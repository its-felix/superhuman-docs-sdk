# Superhuman Docs Go SDK

This package is generated from the Smithy model in `../smithy/model`.
The Go module is rooted at the repository root so releases use normal
`vX.Y.Z` tags while this package remains importable as:

```go
import superhumandocs "github.com/its-felix/superhuman-docs-sdk/go"
```

```go
client := superhumandocs.NewClient("api-token")
docs, err := client.ListDocs(ctx, &superhumandocs.ListDocsInput{Limit: superhumandocs.Int(10)})
```

Run this from the repository root after Smithy model changes:

```sh
./build.sh
```
