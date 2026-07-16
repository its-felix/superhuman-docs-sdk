package superhumandocs

import (
	"context"
	"io"
	"net/http"
	"reflect"
	"strings"
	"testing"
)

var _ RequestSender = (*http.Client)(nil)

func TestResourceOperationUsesConfiguredRequestSender(t *testing.T) {
	var request *http.Request
	sender := RequestSenderFunc(func(got *http.Request) (*http.Response, error) {
		request = got
		return &http.Response{
			StatusCode: http.StatusOK,
			Status:     "200 OK",
			Header:     make(http.Header),
			Body:       io.NopCloser(strings.NewReader(`{"items":[]}`)),
			Request:    got,
		}, nil
	})

	client := NewClient(
		"test-token",
		WithBaseURL("https://example.test/api/v1/"),
		WithRequestSender(sender),
		WithHeader("X-Test", "present"),
	)
	_, err := client.Tables().Rows().List(context.Background(), &ListRowsInput{
		DocId:         "doc/one",
		TableIdOrName: "grid name",
		Limit:         Int(10),
	})
	if err != nil {
		t.Fatalf("List returned an error: %v", err)
	}
	if request == nil {
		t.Fatal("request sender was not called")
	}
	if request.Method != http.MethodGet {
		t.Fatalf("method = %q, want GET", request.Method)
	}
	if got, want := request.URL.EscapedPath(), "/api/v1/docs/doc%2Fone/tables/grid%20name/rows"; got != want {
		t.Fatalf("escaped path = %q, want %q", got, want)
	}
	if got := request.URL.Query().Get("limit"); got != "10" {
		t.Fatalf("limit = %q, want 10", got)
	}
	if got := request.Header.Get("Authorization"); got != "Bearer test-token" {
		t.Fatalf("Authorization = %q", got)
	}
	if got := request.Header.Get("X-Test"); got != "present" {
		t.Fatalf("X-Test = %q", got)
	}
}

func TestClientOnlyExposesDirectServiceOperations(t *testing.T) {
	clientType := reflect.TypeOf((*Client)(nil))
	if _, ok := clientType.MethodByName("Whoami"); !ok {
		t.Fatal("Client is missing the direct Whoami service operation")
	}
	for _, oldTopLevelOperation := range []string{"ListDocs", "GetTable", "ListRows", "CreatePack"} {
		if _, ok := clientType.MethodByName(oldTopLevelOperation); ok {
			t.Errorf("Client unexpectedly exposes resource operation %s", oldTopLevelOperation)
		}
	}
	for _, childResource := range []string{"Pages", "Columns", "Rows", "PackVersions"} {
		if _, ok := clientType.MethodByName(childResource); ok {
			t.Errorf("Client unexpectedly exposes child resource %s", childResource)
		}
	}
}

func TestGeneratedEnumsAreTypedStringConstants(t *testing.T) {
	var value ColumnFormatType = ColumnFormatTypeDateTime
	if got, want := value.String(), "dateTime"; got != want {
		t.Fatalf("ColumnFormatTypeDateTime.String() = %q, want %q", got, want)
	}
}

func TestNilResponseFromRequestSenderReturnsError(t *testing.T) {
	client := NewClient("", WithRequestSender(RequestSenderFunc(
		func(*http.Request) (*http.Response, error) { return nil, nil },
	)))

	_, err := client.Whoami(context.Background(), nil)
	if err == nil || !strings.Contains(err.Error(), "nil response") {
		t.Fatalf("Whoami error = %v, want nil response error", err)
	}
}
