# Superhuman Docs Smithy Generator

This Maven project provides Smithy-Build plugins for generating Superhuman Docs
SDK artifacts.

Maven coordinate:
`com.github.its-felix.superhuman-docs-sdk:smithy-generator:0.1.0-SNAPSHOT`.

Java package:
`com.github.its_felix.superhuman_docs_sdk.smithy.codegen`. Hyphens from the
GitHub handle and repository name are represented with underscores because Java
package identifiers cannot contain hyphens.

## Plugins

- `superhuman-docs-markdown-codegen`
- `superhuman-docs-python-codegen`
- `superhuman-docs-go-codegen`
- `superhuman-docs-zig-codegen`
- `superhuman-docs-client-codegen`, a compatibility plugin that runs all targets

Smithy-Build plugin entries are the native way to choose targets. To generate a
single SDK, run a projection that contains only that target plugin.

For example:

```json
{
  "plugins": {
    "superhuman-docs-python-codegen": {
      "service": "com.superhuman.docs.v1#SuperhumanDocsApi"
    }
  }
}
```

The repository helper supports the same target split:

```sh
./build.sh python
./build.sh go
./build.sh zig
./build.sh markdown
```

## Structure

- `TargetCodegenPlugin` adapts a target generator to Smithy's `SmithyBuildPlugin`.
- `MarkdownSdkGenerator`, `PythonSdkGenerator`, `GoSdkGenerator`, and
  `ZigSdkGenerator` each write one target's artifacts.
- `SuperhumanDocsCodegenPlugin` keeps the previous all-target plugin behavior.
- `PythonRenderer`, `GoRenderer`, and `ZigRenderer` contain target-specific
  rendering routines.
- `SdkCodegen` contains shared Smithy model helpers.
- `SmithyBuildCommand` is a fallback for environments without a standalone
  `smithy` CLI.

## Build

The generator is a Java 17 Maven project.

```sh
mvn -f smithy/generator/pom.xml test
```

Install the generator into the local Maven repository before running `smithy
build`, because `smithy/smithy-build.json` references this project as a Maven
dependency:

```sh
mvn -f smithy/generator/pom.xml install
cd smithy
smithy build
```

Generated artifacts are written under `smithy/build/smithy/source/`.

From the repository root, `./build.sh` runs this build and copies the generated
SDK files into their final package directories.
