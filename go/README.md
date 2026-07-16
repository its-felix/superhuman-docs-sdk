# Superhuman Docs Go SDK

This package is generated from the Smithy model in `../smithy/model`.
The Go module is rooted at the repository root so releases use normal
`vX.Y.Z` tags while this package remains importable as:

```go
import superhumandocs "github.com/its-felix/superhuman-docs-sdk/go"
```

```go
client := superhumandocs.NewClient("api-token")
docs, err := client.Docs().List(ctx, &superhumandocs.ListDocsInput{
    Limit: superhumandocs.Int(10),
})
```

Smithy lifecycle operations use concise names on resource clients, while
resource-specific operations keep their modeled names:

```go
page, err := client.Docs().Pages().Read(ctx, &superhumandocs.GetPageInput{
    DocId:        "doc-id",
    PageIdOrName: "page-id",
})
rows, err := client.Tables().Rows().List(ctx, &superhumandocs.ListRowsInput{
    DocId:         "doc-id",
    TableIdOrName: "table-id",
})
```

All operations dispatch through `Client.SendRequest`. `RequestSender` uses the
same `Do(*http.Request) (*http.Response, error)` contract as `http.Client`, so a
standard-library client can be supplied directly:

```go
client := superhumandocs.NewClient("api-token",
	superhumandocs.WithRequestSender(&http.Client{Timeout: 10 * time.Second}),
)
```

Use `RequestSenderFunc` for a custom transport, retry layer, tracer, or fixture:

```go
client := superhumandocs.NewClient("api-token",
    superhumandocs.WithRequestSender(superhumandocs.RequestSenderFunc(
        func(request *http.Request) (*http.Response, error) {
            return transport.Do(request)
        },
    )),
)
```

Run this from the repository root after Smithy model changes:

```sh
./build.sh
```
