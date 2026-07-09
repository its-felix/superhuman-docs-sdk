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
from superhuman_docs import SuperhumanDocsClient

client = SuperhumanDocsClient(token="YOUR_API_TOKEN")
docs = client.list_docs(limit=10)
doc = client.get_doc(doc_id="YOUR_DOC_ID")
```

The default API base URL is `https://coda.io/apis/v1`, matching the source
OpenAPI document referenced by the Smithy model. Override it with `base_url=...`
if your environment uses a different host.

Methods use Pythonic `snake_case` parameter names. Payload members are passed as
plain dictionaries and responses are returned as decoded JSON values.
