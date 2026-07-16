#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
smithy_artifact_dir="$repo_root/smithy/build/smithy/source"

usage() {
  cat >&2 <<'USAGE'
usage: ./build.sh [all|markdown|python|go|rust|zig ...]

No target argument is equivalent to "all". Multiple targets can be provided.
USAGE
}

targets=("$@")
if [ "${#targets[@]}" -eq 0 ]; then
  targets=(all)
fi

expanded_targets=()
for target in "${targets[@]}"; do
  case "$target" in
    all)
      expanded_targets=(markdown python go rust zig)
      ;;
    markdown|python|go|rust|zig)
      expanded_targets+=("$target")
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      usage
      exit 2
      ;;
  esac
done

has_target() {
  local needle="$1"
  local target
  for target in "${expanded_targets[@]}"; do
    if [ "$target" = "$needle" ]; then
      return 0
    fi
  done
  return 1
}

plugin_for_target() {
  case "$1" in
    markdown) echo "superhuman-docs-markdown-codegen" ;;
    python) echo "superhuman-docs-python-codegen" ;;
    go) echo "superhuman-docs-go-codegen" ;;
    rust) echo "superhuman-docs-rust-codegen" ;;
    zig) echo "superhuman-docs-zig-codegen" ;;
  esac
}

plugins=()
for target in "${expanded_targets[@]}"; do
  plugins+=("$(plugin_for_target "$target")")
done

cd "$repo_root"

rm -rf "$smithy_artifact_dir"

mvn -f smithy/generator/pom.xml clean install

if command -v smithy >/dev/null 2>&1 && [ "${#plugins[@]}" -eq 5 ]; then
  (cd smithy && smithy build)
else
  mvn -f smithy/generator/pom.xml \
    -DskipTests \
    exec:java \
    -Dexec.mainClass=com.github.its_felix.superhuman_docs_sdk.smithy.codegen.SmithyBuildCommand \
    -Dexec.args="$repo_root/smithy ${plugins[*]}"
fi

if has_target markdown; then
  mkdir -p "$repo_root/docs"
  cp "$smithy_artifact_dir/superhuman-docs-markdown-codegen/sdk/markdown/service.md" \
    "$repo_root/docs/service.md"
fi

if has_target python; then
  cp "$smithy_artifact_dir/superhuman-docs-python-codegen/sdk/python/src/superhuman_docs/_generated.py" \
    "$repo_root/python/src/superhuman_docs/_generated.py"
  cp "$smithy_artifact_dir/superhuman-docs-python-codegen/sdk/python/src/superhuman_docs/_models.py" \
    "$repo_root/python/src/superhuman_docs/_models.py"
fi

if has_target go; then
  cp "$smithy_artifact_dir/superhuman-docs-go-codegen/sdk/go/types_gen.go" "$repo_root/go/types_gen.go"
  cp "$smithy_artifact_dir/superhuman-docs-go-codegen/sdk/go/operations_gen.go" "$repo_root/go/operations_gen.go"
  if command -v gofmt >/dev/null 2>&1; then
    gofmt -w "$repo_root/go/types_gen.go" "$repo_root/go/operations_gen.go"
  fi
fi

if has_target rust; then
  cp "$smithy_artifact_dir/superhuman-docs-rust-codegen/sdk/rust/src/generated/operations.rs" \
    "$repo_root/rust/src/generated/operations.rs"
  if command -v rustfmt >/dev/null 2>&1; then
    rustfmt "$repo_root/rust/src/generated/operations.rs"
  fi
fi

if has_target zig; then
  cp "$smithy_artifact_dir/superhuman-docs-zig-codegen/sdk/zig/src/generated/operations.zig" \
    "$repo_root/zig/src/generated/operations.zig"
fi

if has_target go; then
  if command -v go >/dev/null 2>&1; then
    go test ./go
  else
    echo "Skipping Go tests: go not found on PATH" >&2
  fi
fi

if has_target python; then
  if command -v python3 >/dev/null 2>&1; then
    (cd python && python3 -m unittest discover -s tests)
  else
    echo "Skipping Python tests: python3 not found on PATH" >&2
  fi
fi

if has_target rust; then
  if command -v cargo >/dev/null 2>&1; then
    cargo test --manifest-path rust/Cargo.toml
  else
    echo "Skipping Rust tests: cargo not found on PATH" >&2
  fi
fi

if has_target zig; then
  if command -v zig >/dev/null 2>&1; then
    zig build test
  else
    echo "Skipping Zig tests: zig not found on PATH" >&2
  fi
fi
