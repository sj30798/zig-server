// Zig version 0.14.0
const std = @import("std");
const net = std.net;
const http = std.http;
const HttpElements = @import("HttpElements//Elements.zig");
const MyElements = @import("ClickCounter//MyElements.zig");
const StringUtils = @import("Utils/StringUtils.zig").StringUtils;

pub fn main() !void {
    const addr = net.Address.parseIp4("127.0.0.1", 9091) catch |err| {
        std.debug.print("An error occurred while resolving the IP address: {}\n", .{err});
        return;
    };

    var server = try addr.listen(.{});

    start_server(&server);
}

fn start_server(server: *net.Server) void {
    std.debug.print("Starting server at port: {d}\n", .{server.listen_address.getPort()});
    while (true) {
        var connection = server.accept() catch |err| {
            std.debug.print("Connection to client interrupted: {}\n", .{err});
            continue;
        };
        defer connection.stream.close();

        var read_buffer: [1024]u8 = undefined;
        var http_server = http.Server.init(connection, &read_buffer);

        var request = http_server.receiveHead() catch |err| {
            std.debug.print("Could not read head: {}\n", .{err});
            continue;
        };
        handle_request(&request) catch |err| {
            std.debug.print("Could not handle request: {}", .{err});
            continue;
        };
    }
}

fn loadHome() ![]const u8 {
    var customBody = try MyElements.CustomBodyElement.init();
    var body = [_]HttpElements.DivElement{
        .{
            .content = &customBody.baseHttpElement,
        },
    };

    var httpElement = HttpElements.HttpElement{
        .head = .{
            .title = .{
                .value = "This is title",
            },
        },
        .body = .{
            .content = &body,
        },
    };

    return try std.fmt.allocPrint(std.heap.page_allocator, "{s}\n", .{try httpElement.baseHttpElement.toHttpString()});
}

const PathHandlerError = error{
    PathNotFound,
};

fn pathHandler(request: *http.Server.Request) ![]const u8 {
    if (StringUtils.equal(request.head.target, "/")) {
        return loadHome();
    } else if (StringUtils.equal(request.head.target, "/count") and request.head.method == http.Method.PUT) {
        try MyElements.CustomBodyElement.incrementCounter();
        return "";
    }

    return PathHandlerError.PathNotFound;
}

fn handle_request(request: *http.Server.Request) !void {
    std.debug.print("Handling request for {s}\n", .{request.head.target});

    const responseData = pathHandler(request) catch |err| switch (err) {
        PathHandlerError.PathNotFound => return try request.respond("", .{ .status = http.Status.not_found }),
        else => return try request.respond("", .{ .status = http.Status.bad_request }),
    };

    try request.respond(responseData, .{});
}
