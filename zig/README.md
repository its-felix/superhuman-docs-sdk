# Superhuman Docs Zig SDK

Zig package for the Superhuman Docs API v1 Smithy model in `../smithy/model`.

The generated SDK provides:

- native Zig structs, tagged unions, lists, maps, aliases, and enums for the full Smithy namespace
- typed operation inputs and parsed, typed operation outputs
- a global client for service operations and resource clients for lifecycle and resource operations
- deterministic internal request construction from Smithy `@httpLabel`, `@httpQuery`, and `@httpPayload` bindings
- a `std.http` default transport and an optional `Transport.send_request` callback

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

    var response = try client.docs().read(.{ .docId = "doc-id" });
    defer response.deinit();

    std.debug.print("{s}\n", .{response.value.value.name});
}
```

Request payloads are strict generated model values and are JSON-encoded by the SDK:

```zig
var response = try client.docs().create(.{
    .payload = .{ .title = "Roadmap" },
});
defer response.deinit();
```

Set `ClientOptions.transport` to route every operation through a custom transport. The callback receives the allocator, bearer authorization value, and fully constructed `Request`; omitting it uses `std.http`.

## Regeneration

Run this from the repository root after changing `smithy/model`:

```sh
./build.sh
```
