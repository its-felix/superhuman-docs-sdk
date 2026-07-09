# Superhuman Docs Smithy model

This directory contains the shared Smithy model for the Superhuman Docs API v1.

The initial model is generated from the public OpenAPI document exposed by the Superhuman Docs API reference:

- Documentation: https://docs.superhuman.com/developers/apis/v1
- OpenAPI source: https://docs.superhuman.com/apis/v1/openapi.json

The published OpenAPI document still identifies the API as `Coda API` version `1.5.0` and lists `https://coda.io/apis/v1` as the server URL. The Smithy namespace uses `com.superhuman.docs.v1` so generated SDKs can move forward under the Superhuman Docs naming.

## Layout

- `model/main.smithy` defines the service, version metadata, and bearer authentication scheme.
- `model/docs.smithy` defines docs, folders, publishing, permissions, custom domains, workspace, account, automation, Go Links, and miscellaneous operations.
- `model/pages.smithy` defines page operations.
- `model/tables.smithy` defines table, column, formula, and control operations.
- `model/rows.smithy` defines row operations.
- `model/packs.smithy` defines Pack operations.
- `model/analytics.smithy` defines analytics operations.
- `model/common.smithy` defines reusable data, union, enum, list, and map shapes shared by multiple domains.
- `model/errors.smithy` defines modeled client error shapes.
- `scripts/openapi_to_smithy.py` regenerates the Smithy model from the OpenAPI JSON source.
- `generator` contains the Maven project for the Smithy-Build SDK generator plugins.

## Regeneration

```sh
curl -sL https://docs.superhuman.com/apis/v1/openapi.json --output /tmp/superhuman-openapi.json
python3 smithy/scripts/openapi_to_smithy.py /tmp/superhuman-openapi.json smithy
```

## Validation

From the repository root:

```sh
./build.sh
```

The `smithy-build.json` file invokes local target plugins for Markdown, Python,
Go, and Zig. The root build script installs the Maven generator, runs Smithy
build, and copies generated SDK artifacts from Smithy's build output into the
Go, Python, and Zig package directories. Pass a target name to run only one
target plugin:

```sh
./build.sh markdown
./build.sh python
./build.sh go
./build.sh zig
```
