# Superhuman Docs Go SDK

This package is generated from the Smithy model in `../smithy/model`.

```go
client := superhumandocs.NewClient("api-token")
docs, err := client.ListDocs(ctx, &superhumandocs.ListDocsInput{Limit: superhumandocs.Int(10)})
```

Regenerate after Smithy model changes:

```sh
cd go
GOFMT=/path/to/gofmt python3 scripts/generate.py
go test ./...
```
