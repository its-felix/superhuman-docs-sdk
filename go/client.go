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
	BaseURL    string
	Token      string
	HTTPClient *http.Client
	UserAgent  string
	Headers    http.Header
}

type Option func(*Client)

func NewClient(token string, opts ...Option) *Client {
	c := &Client{
		BaseURL:    DefaultBaseURL,
		Token:      token,
		HTTPClient: http.DefaultClient,
		UserAgent:  "superhuman-docs-go/0.1.0",
		Headers:    make(http.Header),
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

func WithHTTPClient(httpClient *http.Client) Option {
	return func(c *Client) {
		if httpClient != nil {
			c.HTTPClient = httpClient
		}
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
	if c.HTTPClient == nil {
		c.HTTPClient = http.DefaultClient
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

	resp, err := c.HTTPClient.Do(req)
	if err != nil {
		return err
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

func (c *Client) endpoint(path string) (*url.URL, error) {
	base := DefaultBaseURL
	if c.BaseURL != "" {
		base = c.BaseURL
	}
	u, err := url.Parse(strings.TrimRight(base, "/"))
	if err != nil {
		return nil, err
	}
	u.Path = strings.TrimRight(u.Path, "/") + "/" + strings.TrimLeft(path, "/")
	return u, nil
}

func addQueryValue(values url.Values, name string, value any) {
	if value == nil {
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
