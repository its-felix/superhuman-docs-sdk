package superhumandocs

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"strconv"
	"strings"
)

const DefaultBaseURL = "https://coda.io/apis/v1"

type Client struct {
	BaseURL   string
	Token     string
	Sender    RequestSender
	UserAgent string
	Headers   http.Header
}

// RequestSender is the transport hook used by Client.SendRequest.
// Implementations can add tracing, retries, fixtures, or a non-standard transport.
type RequestSender interface {
	Do(*http.Request) (*http.Response, error)
}

type RequestSenderFunc func(*http.Request) (*http.Response, error)

func (f RequestSenderFunc) Do(request *http.Request) (*http.Response, error) {
	return f(request)
}

type Option func(*Client)

func NewClient(token string, opts ...Option) *Client {
	c := &Client{
		BaseURL:   DefaultBaseURL,
		Token:     token,
		Sender:    http.DefaultClient,
		UserAgent: "superhuman-docs-go/0.2.0",
		Headers:   make(http.Header),
	}
	for _, opt := range opts {
		opt(c)
	}
	return c
}

func WithBaseURL(baseURL string) Option {
	return func(c *Client) {
		c.BaseURL = strings.TrimRight(baseURL, "/")
	}
}

func WithRequestSender(sender RequestSender) Option {
	return func(c *Client) {
		c.Sender = sender
	}
}

func WithUserAgent(userAgent string) Option {
	return func(c *Client) {
		c.UserAgent = userAgent
	}
}

func WithHeader(key, value string) Option {
	return func(c *Client) {
		c.Headers.Set(key, value)
	}
}

type APIError struct {
	StatusCode int
	Status     string
	Message    string
	Body       []byte
}

func (e *APIError) Error() string {
	if e.Message != "" {
		return fmt.Sprintf("superhuman docs: %s: %s", e.Status, e.Message)
	}
	return fmt.Sprintf("superhuman docs: %s", e.Status)
}

func (c *Client) do(ctx context.Context, method, path string, query url.Values, payload any, out any) error {
	if c == nil {
		return errors.New("superhuman docs: nil client")
	}
	endpoint, err := c.endpoint(path)
	if err != nil {
		return err
	}
	if len(query) > 0 {
		endpoint.RawQuery = query.Encode()
	}

	var body io.Reader
	if payload != nil {
		buf := new(bytes.Buffer)
		if err := json.NewEncoder(buf).Encode(payload); err != nil {
			return fmt.Errorf("superhuman docs: encode request: %w", err)
		}
		body = buf
	}

	req, err := http.NewRequestWithContext(ctx, method, endpoint.String(), body)
	if err != nil {
		return err
	}
	if payload != nil {
		req.Header.Set("Content-Type", "application/json")
	}
	req.Header.Set("Accept", "application/json")
	if c.UserAgent != "" {
		req.Header.Set("User-Agent", c.UserAgent)
	}
	if c.Token != "" {
		req.Header.Set("Authorization", "Bearer "+c.Token)
	}
	for key, values := range c.Headers {
		for _, value := range values {
			req.Header.Add(key, value)
		}
	}

	resp, err := c.SendRequest(req)
	if err != nil {
		return err
	}
	if resp == nil {
		return errors.New("superhuman docs: request sender returned a nil response")
	}
	if resp.Body == nil {
		resp.Body = http.NoBody
	}
	defer resp.Body.Close()

	if resp.StatusCode < 200 || resp.StatusCode >= 300 {
		data, readErr := io.ReadAll(resp.Body)
		if readErr != nil {
			return readErr
		}
		apiErr := &APIError{
			StatusCode: resp.StatusCode,
			Status:     resp.Status,
			Body:       data,
		}
		var decoded struct {
			Message       string `json:"message"`
			StatusMessage string `json:"statusMessage"`
		}
		if json.Unmarshal(data, &decoded) == nil {
			if decoded.Message != "" {
				apiErr.Message = decoded.Message
			} else {
				apiErr.Message = decoded.StatusMessage
			}
		}
		return apiErr
	}

	if out == nil {
		io.Copy(io.Discard, resp.Body)
		return nil
	}
	dec := json.NewDecoder(resp.Body)
	if err := dec.Decode(out); err != nil && !errors.Is(err, io.EOF) {
		return err
	}
	return nil
}

// SendRequest is the single transport boundary used by all generated operations.
// It uses the configured RequestSender, falling back to the standard HTTP client.
func (c *Client) SendRequest(request *http.Request) (*http.Response, error) {
	if c == nil {
		return nil, errors.New("superhuman docs: nil client")
	}
	sender := c.Sender
	if sender == nil {
		sender = http.DefaultClient
	}
	return sender.Do(request)
}

func (c *Client) endpoint(path string) (*url.URL, error) {
	base := DefaultBaseURL
	if c.BaseURL != "" {
		base = c.BaseURL
	}
	u, err := url.Parse(strings.TrimRight(base, "/"))
	if err != nil {
		return nil, err
	}
	// The generated path already escapes label values. Keep that escaped path in
	// RawPath so URL.String does not turn `%2F` into `%252F`.
	escapedPath := strings.TrimRight(u.EscapedPath(), "/") + "/" + strings.TrimLeft(path, "/")
	decodedPath, err := url.PathUnescape(escapedPath)
	if err != nil {
		return nil, err
	}
	u.Path = decodedPath
	u.RawPath = escapedPath
	return u, nil
}

func addQueryValue(values url.Values, name string, value any) {
	if isNilValue(value) {
		return
	}
	switch v := value.(type) {
	case string:
		if v != "" {
			values.Add(name, v)
		}
	case *string:
		if v != nil {
			values.Add(name, *v)
		}
	case bool:
		values.Add(name, strconv.FormatBool(v))
	case *bool:
		if v != nil {
			values.Add(name, strconv.FormatBool(*v))
		}
	case int:
		values.Add(name, strconv.Itoa(v))
	case *int:
		if v != nil {
			values.Add(name, strconv.Itoa(*v))
		}
	case int64:
		values.Add(name, strconv.FormatInt(v, 10))
	case *int64:
		if v != nil {
			values.Add(name, strconv.FormatInt(*v, 10))
		}
	case float64:
		values.Add(name, strconv.FormatFloat(v, 'f', -1, 64))
	case *float64:
		if v != nil {
			values.Add(name, strconv.FormatFloat(*v, 'f', -1, 64))
		}
	case fmt.Stringer:
		values.Add(name, v.String())
	case []string:
		for _, item := range v {
			values.Add(name, item)
		}
	case []int:
		for _, item := range v {
			values.Add(name, strconv.Itoa(item))
		}
	case []int64:
		for _, item := range v {
			values.Add(name, strconv.FormatInt(item, 10))
		}
	case []float64:
		for _, item := range v {
			values.Add(name, strconv.FormatFloat(item, 'f', -1, 64))
		}
	default:
		addQueryReflect(values, name, value)
	}
}

func pathEscape(value any) string {
	switch v := value.(type) {
	case string:
		return url.PathEscape(v)
	case fmt.Stringer:
		return url.PathEscape(v.String())
	case int:
		return strconv.Itoa(v)
	case int64:
		return strconv.FormatInt(v, 10)
	case float64:
		return strconv.FormatFloat(v, 'f', -1, 64)
	case bool:
		return strconv.FormatBool(v)
	default:
		return url.PathEscape(fmt.Sprint(v))
	}
}
