const std = @import("std");

pub const core = @import("core.zig");
pub const operations = @import("generated/operations.zig");

pub const Request = core.Request;
pub const Response = core.Response;
pub const default_base_url = core.default_base_url;

const Allocator = std.mem.Allocator;

pub const ClientOptions = struct {
    api_token: []const u8,
    base_url: []const u8 = default_base_url,
    io: ?std.Io = null,
};

pub const Client = struct {
    allocator: Allocator,
    base_url: []const u8,
    authorization: []u8,
    http_client: std.http.Client,

    pub fn init(allocator: Allocator, api_token: []const u8) !Client {
        return initWithOptions(allocator, .{ .api_token = api_token });
    }

    pub fn initWithOptions(allocator: Allocator, options: ClientOptions) !Client {
        const authorization = try std.fmt.allocPrint(allocator, "Bearer {s}", .{options.api_token});
        errdefer allocator.free(authorization);

        return .{
            .allocator = allocator,
            .base_url = options.base_url,
            .authorization = authorization,
            .http_client = .{
                .allocator = allocator,
                .io = options.io orelse std.Io.Threaded.global_single_threaded.io(),
            },
        };
    }

    pub fn deinit(self: *Client) void {
        self.http_client.deinit();
        self.allocator.free(self.authorization);
        self.* = undefined;
    }

    pub fn send(self: *Client, request: Request) !Response {
        var response_body: std.Io.Writer.Allocating = .init(self.allocator);
        errdefer response_body.deinit();

        const headers_without_body = [_]std.http.Header{
            .{ .name = "Authorization", .value = self.authorization },
            .{ .name = "Accept", .value = "application/json" },
        };
        const headers_with_body = [_]std.http.Header{
            .{ .name = "Authorization", .value = self.authorization },
            .{ .name = "Accept", .value = "application/json" },
            .{ .name = "Content-Type", .value = "application/json" },
        };
        const headers = if (request.body == null) headers_without_body[0..] else headers_with_body[0..];

        const result = try self.http_client.fetch(.{
            .location = .{ .url = request.url },
            .method = request.method,
            .payload = request.body,
            .response_writer = &response_body.writer,
            .extra_headers = headers,
        });

        return .{
            .status = result.status,
            .body = try response_body.toOwnedSlice(),
        };
    }

    pub fn sendExpect(self: *Client, request: Request) !Response {
        const response = try self.send(request);
        errdefer response.deinit(self.allocator);
        if (@intFromEnum(response.status) != request.expected_status) return error.UnexpectedStatus;
        return response;
    }
};

test {
    _ = core;
    _ = operations;
}

test "generated builders expose a Smithy operation request" {
    const allocator = std.testing.allocator;
    const request = try operations.buildGetDoc(allocator, default_base_url, .{ .docId = "doc 1" });
    defer request.deinit(allocator);

    try std.testing.expectEqual(std.http.Method.GET, request.method);
    try std.testing.expectEqual(@as(u16, 200), request.expected_status);
    try std.testing.expectEqualStrings("GetDoc", request.operation);
    try std.testing.expectEqualStrings("https://coda.io/apis/v1/docs/doc%201", request.url);
}
