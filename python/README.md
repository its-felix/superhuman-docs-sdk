# superhuman-docs Python SDK

This package is generated from the Smithy model in `../smithy/model`.

## Generate

Run this from the repository root:

```sh
./build.sh
```

The Smithy generator writes deterministic operation metadata and convenience
methods to `src/superhuman_docs/_generated.py`.

## Use

```python
from superhuman_docs import GetDocInput, ListDocsInput, SuperhumanDocsClient

client = SuperhumanDocsClient(token="YOUR_API_TOKEN")
docs = client.docs().list(ListDocsInput(limit=10))
doc = client.docs().read(GetDocInput(doc_id="YOUR_DOC_ID"))
```

The default API base URL is `https://coda.io/apis/v1`, matching the source
OpenAPI document referenced by the Smithy model. Override it with `base_url=...`
if your environment uses a different host.

The generated API exposes service operations directly and resource operations
through resource clients such as `client.docs()` and `client.tables()`. Child
resources can be reached through their parent, for example
`client.tables().rows().list(...)`. Inputs, outputs, unions, and enums are
generated as strict Python model types.

Every operation passes its `PreparedRequest` through `client.send_request()`.
Pass a callable transport or an object implementing `send_request(request,
timeout)` to customize HTTP behavior for tests, tracing, retries, or alternate
network stacks.
