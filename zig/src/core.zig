const std = @import("std");

const Allocator = std.mem.Allocator;

pub const default_base_url = "https://coda.io/apis/v1";

pub const Request = struct {
    operation: []const u8,
    method: std.http.Method,
    url: []u8,
    body: ?[]u8 = null,
    expected_status: u16,

    pub fn deinit(self: Request, allocator: Allocator) void {
        allocator.free(self.url);
        if (self.body) |body| allocator.free(body);
    }
};

/// A caller-supplied transport. The callback owns neither the request nor the
/// returned response; generated client methods release both after use.
pub const Transport = struct {
    context: *anyopaque,
    send_request: *const fn (
        context: *anyopaque,
        allocator: Allocator,
        authorization: []const u8,
        request: Request,
    ) anyerror!Response,

    pub fn sendRequest(
        self: Transport,
        allocator: Allocator,
        authorization: []const u8,
        request: Request,
    ) !Response {
        return self.send_request(self.context, allocator, authorization, request);
    }
};

pub const ClientOptions = struct {
    api_token: []const u8,
    base_url: []const u8 = default_base_url,
    io: ?std.Io = null,
    transport: ?Transport = null,
};

/// Runtime state shared by the generated global and resource clients.
pub const ClientCore = struct {
    allocator: Allocator,
    base_url: []const u8,
    authorization: []u8,
    transport: ?Transport,
    http_client: std.http.Client,

    pub fn init(allocator: Allocator, api_token: []const u8) !ClientCore {
        return initWithOptions(allocator, .{ .api_token = api_token });
    }

    pub fn initWithOptions(allocator: Allocator, options: ClientOptions) !ClientCore {
        const authorization = try std.fmt.allocPrint(allocator, "Bearer {s}", .{options.api_token});
        errdefer allocator.free(authorization);

        return .{
            .allocator = allocator,
            .base_url = options.base_url,
            .authorization = authorization,
            .transport = options.transport,
            .http_client = .{
                .allocator = allocator,
                .io = options.io orelse std.Io.Threaded.global_single_threaded.io(),
            },
        };
    }

    pub fn deinit(self: *ClientCore) void {
        self.http_client.deinit();
        self.allocator.free(self.authorization);
        self.* = undefined;
    }

    /// The single transport seam used by every generated operation.
    pub fn sendRequest(self: *ClientCore, request: Request) !Response {
        if (self.transport) |transport| {
            return transport.sendRequest(self.allocator, self.authorization, request);
        }
        return self.sendStdHttpRequest(request);
    }

    fn sendStdHttpRequest(self: *ClientCore, request: Request) !Response {
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
};

pub fn TypedResponse(comptime T: type) type {
    return struct {
        status: std.http.Status,
        value: std.json.Parsed(T),

        pub fn deinit(self: *@This()) void {
            self.value.deinit();
            self.* = undefined;
        }
    };
}

pub fn decodeResponse(comptime T: type, allocator: Allocator, response: Response) !TypedResponse(T) {
    defer response.deinit(allocator);
    const parsed = try std.json.parseFromSlice(T, allocator, response.body, .{
        .allocate = .alloc_always,
        .ignore_unknown_fields = true,
    });
    return .{ .status = response.status, .value = parsed };
}

pub fn jsonEncode(allocator: Allocator, value: anytype) ![]u8 {
    var body: std.Io.Writer.Allocating = .init(allocator);
    errdefer body.deinit();
    var stringify: std.json.Stringify = .{
        .writer = &body.writer,
        .options = .{ .emit_null_optional_fields = false },
    };
    try stringify.write(value);
    return body.toOwnedSlice();
}

pub const Response = struct {
    status: std.http.Status,
    body: []u8,

    pub fn deinit(self: Response, allocator: Allocator) void {
        allocator.free(self.body);
    }
};

pub const UrlBuilder = struct {
    allocator: Allocator,
    writer: std.Io.Writer.Allocating,
    wrote_query: bool = false,

    pub fn init(allocator: Allocator) UrlBuilder {
        return .{
            .allocator = allocator,
            .writer = .init(allocator),
        };
    }

    pub fn deinit(self: *UrlBuilder) void {
        self.writer.deinit();
    }

    pub fn base(self: *UrlBuilder, value: []const u8) !void {
        const trimmed = std.mem.trimEnd(u8, value, "/");
        try self.writer.writer.writeAll(trimmed);
    }

    pub fn finish(self: *UrlBuilder) ![]u8 {
        return self.writer.toOwnedSlice();
    }

    pub fn pathLiteral(self: *UrlBuilder, value: []const u8) !void {
        try self.writer.writer.writeAll(value);
    }

    pub fn pathString(self: *UrlBuilder, value: []const u8) !void {
        try percentEncode(&self.writer.writer, value);
    }

    pub fn pathInt(self: *UrlBuilder, value: i64) !void {
        try self.writer.writer.print("{d}", .{value});
    }

    pub fn pathFloat(self: *UrlBuilder, value: f64) !void {
        try self.writer.writer.print("{d}", .{value});
    }

    pub fn pathBool(self: *UrlBuilder, value: bool) !void {
        try self.writer.writer.writeAll(if (value) "true" else "false");
    }

    pub fn queryString(self: *UrlBuilder, name: []const u8, value: []const u8) !void {
        try self.queryStart(name);
        try percentEncode(&self.writer.writer, value);
    }

    pub fn queryOptionalString(self: *UrlBuilder, name: []const u8, value: ?[]const u8) !void {
        if (value) |actual| try self.queryString(name, actual);
    }

    pub fn queryInt(self: *UrlBuilder, name: []const u8, value: i64) !void {
        try self.queryStart(name);
        try self.writer.writer.print("{d}", .{value});
    }

    pub fn queryOptionalInt(self: *UrlBuilder, name: []const u8, value: ?i64) !void {
        if (value) |actual| try self.queryInt(name, actual);
    }

    pub fn queryFloat(self: *UrlBuilder, name: []const u8, value: f64) !void {
        try self.queryStart(name);
        try self.writer.writer.print("{d}", .{value});
    }

    pub fn queryOptionalFloat(self: *UrlBuilder, name: []const u8, value: ?f64) !void {
        if (value) |actual| try self.queryFloat(name, actual);
    }

    pub fn queryBool(self: *UrlBuilder, name: []const u8, value: bool) !void {
        try self.queryStart(name);
        try self.writer.writer.writeAll(if (value) "true" else "false");
    }

    pub fn queryOptionalBool(self: *UrlBuilder, name: []const u8, value: ?bool) !void {
        if (value) |actual| try self.queryBool(name, actual);
    }

    pub fn queryStringList(self: *UrlBuilder, name: []const u8, values: []const []const u8) !void {
        for (values) |value| try self.queryString(name, value);
    }

    pub fn queryOptionalStringList(self: *UrlBuilder, name: []const u8, values: ?[]const []const u8) !void {
        if (values) |actual| try self.queryStringList(name, actual);
    }

    pub fn queryIntList(self: *UrlBuilder, name: []const u8, values: []const i64) !void {
        for (values) |value| try self.queryInt(name, value);
    }

    pub fn queryOptionalIntList(self: *UrlBuilder, name: []const u8, values: ?[]const i64) !void {
        if (values) |actual| try self.queryIntList(name, actual);
    }

    pub fn queryFloatList(self: *UrlBuilder, name: []const u8, values: []const f64) !void {
        for (values) |value| try self.queryFloat(name, value);
    }

    pub fn queryOptionalFloatList(self: *UrlBuilder, name: []const u8, values: ?[]const f64) !void {
        if (values) |actual| try self.queryFloatList(name, actual);
    }

    pub fn queryBoolList(self: *UrlBuilder, name: []const u8, values: []const bool) !void {
        for (values) |value| try self.queryBool(name, value);
    }

    pub fn queryOptionalBoolList(self: *UrlBuilder, name: []const u8, values: ?[]const bool) !void {
        if (values) |actual| try self.queryBoolList(name, actual);
    }

    fn queryStart(self: *UrlBuilder, name: []const u8) !void {
        try self.writer.writer.writeByte(if (self.wrote_query) '&' else '?');
        self.wrote_query = true;
        try percentEncode(&self.writer.writer, name);
        try self.writer.writer.writeByte('=');
    }
};

fn percentEncode(writer: *std.Io.Writer, value: []const u8) !void {
    const hex = "0123456789ABCDEF";
    for (value) |c| {
        switch (c) {
            'A'...'Z', 'a'...'z', '0'...'9', '-', '.', '_', '~' => try writer.writeByte(c),
            else => {
                try writer.writeByte('%');
                try writer.writeByte(hex[c >> 4]);
                try writer.writeByte(hex[c & 0x0f]);
            },
        }
    }
}

test "UrlBuilder percent-encodes path labels and query values" {
    const allocator = std.testing.allocator;
    var url = UrlBuilder.init(allocator);
    errdefer url.deinit();
    try url.base("https://example.test/");
    try url.pathLiteral("/docs/");
    try url.pathString("doc 1/2");
    try url.queryString("q", "a+b c");
    try url.queryOptionalBool("visibleOnly", true);
    const built = try url.finish();
    defer allocator.free(built);

    try std.testing.expectEqualStrings("https://example.test/docs/doc%201%2F2?q=a%2Bb%20c&visibleOnly=true", built);
}
