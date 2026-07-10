# superhuman-docs Rust SDK

This crate is generated from the Smithy model in `../smithy/model`.

## Use

```rust
use superhuman_docs::{operations, DEFAULT_BASE_URL};

let request = operations::build_get_doc(
    DEFAULT_BASE_URL,
    operations::GetDocInput {
        doc_id: "doc 1".to_string(),
    },
)?;

assert_eq!(request.operation, "GetDoc");
```

The crate currently builds typed request metadata and encoded URLs using only the
Rust standard library. Bring your own HTTP transport and send the generated
`Request`.

## Regeneration

Run this from the repository root after changing `smithy/model`:

```sh
./build.sh rust
```
