# Superhuman Docs Smithy model

This directory contains the shared Smithy model for the Superhuman Docs API v1.

The operation and data-shape baseline is generated from the public OpenAPI
document exposed by the Superhuman Docs API reference:

- Documentation: https://docs.superhuman.com/developers/apis/v1
- OpenAPI source: https://docs.superhuman.com/apis/v1/openapi.json

The published OpenAPI document still identifies the API as `Coda API` version `1.5.0` and lists `https://coda.io/apis/v1` as the server URL. The Smithy namespace uses `com.superhuman.docs.v1` so generated SDKs can move forward under the Superhuman Docs naming.

## Layout

- `model/main.smithy` defines the service, version metadata, bearer
  authentication scheme, direct RPC-style operations, and top-level resources.
- `model/resources.smithy` defines the resource hierarchy, identifiers,
  properties, lifecycle operations, resource operations, and child resources.
- `model/docs.smithy` defines docs, folders, publishing, permissions, custom domains, workspace, account, automation, Go Links, and miscellaneous operations.
- `model/pages.smithy` defines page operations.
- `model/tables.smithy` defines table, column, formula, and control operations.
- `model/rows.smithy` defines row operations.
- `model/packs.smithy` defines Pack operations.
- `model/analytics.smithy` defines analytics operations.
- `model/common.smithy` defines reusable data, union, enum, list, and map shapes shared by multiple domains.
- `model/errors.smithy` defines modeled client error shapes.
- `scripts/openapi_to_smithy.py` regenerates operation and data shapes from the
  OpenAPI JSON source while preserving the hand-maintained resource overlay.
- `generator` contains the Maven project for the Smithy-Build SDK generator plugins.

## Regeneration

```sh
curl -sL https://docs.superhuman.com/apis/v1/openapi.json --output /tmp/superhuman-openapi.json
python3 smithy/scripts/openapi_to_smithy.py /tmp/superhuman-openapi.json smithy
```

The OpenAPI description does not encode Smithy's resource hierarchy or
lifecycle semantics. Consequently, `model/resources.smithy` is intentionally
preserved during regeneration, and the service closure in `model/main.smithy`
continues to reference that resource model. New API operations should be added
to the appropriate resource in the overlay after regenerating.

## Validation

From the repository root:

```sh
./build.sh
```

The `smithy-build.json` file invokes local target plugins for Markdown, Python,
Go, Rust, and Zig. The root build script installs the Maven generator, runs
Smithy build, and copies generated artifacts from Smithy's build output into
`docs/` and the Go, Python, Rust, and Zig package directories. Pass a target
name to run only one target plugin:

```sh
./build.sh markdown
./build.sh python
./build.sh go
./build.sh rust
./build.sh zig
```
