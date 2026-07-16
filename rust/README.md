# superhuman-docs Rust SDK

This crate is generated from the Smithy model in `../smithy/model`. It exposes
strict Rust structures, unions, and enums for the full API model, together with
typed service and resource clients.

## Use

Create one service client and call lifecycle operations through the resource
that owns them:

```rust,no_run
use superhuman_docs::{operations, Client, ClientOptions, Error, Request, Response};

let transport = |request: Request| -> Result<Response, Error> {
    // Adapt `request.method`, `request.url`, and the optional JSON `request.body`
    // to reqwest, ureq, hyper, or the HTTP stack used by your application.
    // Add the bearer token in this adapter, then return status and response bytes.
    todo!()
};

let client = Client::new(ClientOptions::new(transport))?;

let deleted = client.docs().delete(operations::DeleteDocInput {
    doc_id: "doc-1".to_string(),
})?;

let rows = client.tables().rows().list(operations::ListRowsInput {
    doc_id: "doc-1".to_string(),
    table_id_or_name: "grid-1".to_string(),
    query: None,
    sort_by: None,
    use_column_names: None,
    value_format: None,
    visible_only: None,
    limit: Some(100),
    page_token: None,
    sync_token: None,
})?;
# Ok::<(), Error>(())
```

Smithy lifecycle operations have stable resource method names such as
`create`, `read`, `update`, `delete`, and `list`. Non-lifecycle operations keep
their Smithy operation name in Rust snake case. Direct service operations are
methods on `Client`, for example `client.whoami(operations::WhoamiInput {})`.

Generated enums are native Rust enums and preserve their wire values through
Serde. For example, `operations::ColumnFormatType::DateTime.as_str()` returns
`"dateTime"`.

## Transport

Every generated operation builds a `Request` and dispatches it through
`Client::send_request`. Implement `Transport`, or provide a thread-safe closure,
to integrate any synchronous HTTP client. `ClientOptions::with_base_url` can be
used for testing or alternate endpoints, and `with_shared_transport` accepts an
`Arc<dyn Transport>` when the transport is already shared.

Rust's standard library does not include an HTTP client, so the crate does not
choose a networking dependency on behalf of applications. `ClientOptions::default()`
uses the production base URL but deliberately installs a placeholder transport;
operations return `Error::MissingTransport` until a transport is configured.
Authentication, retries, timeouts, and connection pooling belong in that
transport adapter.

## Regeneration

Run this from the repository root after changing `smithy/model`:

```sh
./build.sh rust
```
