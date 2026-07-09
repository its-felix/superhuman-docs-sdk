# Superhuman Docs Zig SDK

Zig package for the Superhuman Docs API v1 Smithy model in `../smithy/model`.

The generated SDK currently provides:

- named input structs for every Smithy service operation
- deterministic request builders with Smithy `@httpLabel`, `@httpQuery`, and `@httpPayload` support
- a minimal `std.http` client that sends requests with bearer authentication
- raw response bodies so callers can decode only the JSON shapes they use

## Usage

Add the SDK from the repository root:

```sh
zig fetch --save git+https://github.com/its-felix/superhuman-docs-sdk.git
```

Then wire the package module into your `build.zig`:

```zig
const docs_dep = b.dependency("superhuman_docs", .{
    .target = target,
    .optimize = optimize,
});

exe.root_module.addImport("superhuman-docs", docs_dep.module("superhuman-docs"));
```

Import it from application code:

```zig
const std = @import("std");
const docs = @import("superhuman-docs");

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    var client = try docs.Client.init(allocator, "api-token");
    defer client.deinit();

    const request = try docs.operations.buildGetDoc(
        allocator,
        client.base_url,
        .{ .docId = "doc-id" },
    );
    defer request.deinit(allocator);

    const response = try client.sendExpect(request);
    defer response.deinit(allocator);

    std.debug.print("{s}\n", .{response.body});
}
```

Request payloads are caller-owned JSON byte slices:

```zig
const request = try docs.operations.buildCreateDoc(
    allocator,
    client.base_url,
    .{ .payload = "{\"title\":\"Roadmap\"}" },
);
```

## Regeneration

Run this from the repository root after changing `smithy/model`:

```sh
./build.sh
```
