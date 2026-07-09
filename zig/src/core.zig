const std = @import("std");

const Allocator = std.mem.Allocator;

pub const default_base_url = "https://coda.io/apis/v1";

pub const Request = struct {
    operation: []const u8,
    method: std.http.Method,
    url: []u8,
    body: ?[]const u8 = null,
    expected_status: u16,

    pub fn deinit(self: Request, allocator: Allocator) void {
        allocator.free(self.url);
    }
};

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
