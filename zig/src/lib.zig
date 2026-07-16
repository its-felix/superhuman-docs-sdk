const std = @import("std");

pub const core = @import("core.zig");
pub const operations = @import("generated/operations.zig");

pub const Request = core.Request;
pub const Response = core.Response;
pub const Transport = core.Transport;
pub const ClientOptions = operations.ClientOptions;
pub const Client = operations.Client;
pub const default_base_url = core.default_base_url;

test {
    _ = core;
    _ = operations;
}

test "generated SDK exposes native enums and resource clients" {
    const format: operations.ColumnFormatType = .text;
    try std.testing.expectEqualStrings("text", @tagName(format));

    var client = try Client.init(std.testing.allocator, "token");
    defer client.deinit();
    _ = client.docs();
    _ = client.tables();
    _ = client.docs().pages();
}

test "custom transport receives requests through sendRequest" {
    const State = struct {
        calls: usize = 0,

        fn send(
            context: *anyopaque,
            allocator: std.mem.Allocator,
            authorization: []const u8,
            request: Request,
        ) !Response {
            const self: *@This() = @ptrCast(@alignCast(context));
            self.calls += 1;
            try std.testing.expectEqualStrings("Bearer token", authorization);
            try std.testing.expectEqualStrings("Whoami", request.operation);
            return .{
                .status = .ok,
                .body = try allocator.dupe(u8,
                    \\{"name":"Ada","loginId":"ada","type":"user","scoped":true,"tokenName":"test","href":"/whoami","workspace":{"id":"workspace","type":"workspace","browserLink":"https://example.test"}}
                ),
            };
        }
    };

    var state = State{};
    var client = try Client.initWithOptions(std.testing.allocator, .{
        .api_token = "token",
        .transport = .{ .context = &state, .send_request = State.send },
    });
    defer client.deinit();

    var response = try client.whoami(.{});
    defer response.deinit();
    try std.testing.expectEqualStrings("Ada", response.value.value.name);
    try std.testing.expectEqual(@as(usize, 1), state.calls);
}
