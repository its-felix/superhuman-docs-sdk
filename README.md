# Superhuman Docs SDK

SDKs generated from the Smithy model for the Superhuman Docs API v1.

The source API description is the public OpenAPI document at
`https://docs.superhuman.com/apis/v1/openapi.json`. The published document still
identifies itself as Coda API v1 and lists `https://coda.io/apis/v1` as the
default server, so the generated clients use that base URL by default while the
Smithy namespace is `com.superhuman.docs.v1`.

## SDKs

| Language | Package | Notes |
| --- | --- | --- |
| Go | `github.com/its-felix/superhuman-docs-sdk/go` | The Go module is rooted at this repository so normal `vX.Y.Z` tags work. |
| Python | `superhuman-docs` | Built by the release workflow. |
| Zig | `superhuman-docs` module | Consumed through Zig's package manager from this git repository. |

## Install

Go:

```sh
go get github.com/its-felix/superhuman-docs-sdk/go@v0.1.0
```

Python:

```sh
python -m pip install superhuman-docs
```

Zig:

```sh
zig fetch --save git+https://github.com/its-felix/superhuman-docs-sdk.git
```

Then add the module in your `build.zig`:

```zig
const docs_dep = b.dependency("superhuman_docs", .{
    .target = target,
    .optimize = optimize,
});

exe.root_module.addImport("superhuman-docs", docs_dep.module("superhuman-docs"));
```

## Layout

- `smithy/model`: shared Smithy model
- `smithy/scripts/openapi_to_smithy.py`: OpenAPI-to-Smithy generator
- `go`: generated Go package
- `python`: generated Python package
- `zig`: generated Zig source package
- `.github/workflows/ci.yml`: validation and generated-source freshness checks
- `.github/workflows/release.yml`: tag-driven release publishing

## Regeneration

After changing `smithy/model`, regenerate the SDKs:

```sh
python3 go/scripts/generate.py
python3 python/scripts/generate.py
python3 zig/tools/generate.py
```

Then verify:

```sh
go test ./...
python3 -m unittest discover -s python/tests
zig build test
```

The CI workflow runs the generators and fails if generated files differ from the
committed tree.

## Releases

Push a semver tag like `v1.2.3` to publish:

- Go: the release workflow primes `proxy.golang.org` for
  `github.com/its-felix/superhuman-docs-sdk@v1.2.3`; users import the package at
  `github.com/its-felix/superhuman-docs-sdk/go`.
- Python: the workflow builds the package artifact. The tag version must match
  `python/pyproject.toml`.
- Zig: there is no central Zig package registry to upload to. The workflow
  verifies the tag is buildable and fetchable as a Zig package from the git
  repository. The tag version must match `build.zig.zon`.
