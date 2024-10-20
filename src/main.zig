const std = @import("std");
const net = std.net;
const http = std.http;
const HtmlElements = @import("HtmlElements//Elements.zig");
const MyElements = @import("ClickCounter//MyElements.zig");
const StringUtils = @import("Utils/StringUtils.zig").StringUtils;
const Routes = @import("Routes.zig");
const RouteHandler = Routes.RouteHandler;
const Server = @import("Server.zig");

pub fn main() !void {
    try start_server();
}

fn init_routes() !RouteHandler {
    var handler = RouteHandler{};

    try handler.addRoute(.{ .method = http.Method.GET, .path = "/", .handler = loadHome });
    try handler.addRoute(.{ .method = http.Method.POST, .path = "/incrementCounter", .handler = counterHandler });

    return handler;
}

fn start_server() !void {
    std.debug.print("Initializing routes\n", .{});

    const routeHandler = init_routes() catch |err| switch (err) {
        else => {
            std.debug.panic("Failed to initialize routes! Error: {}", .{err});
            return;
        },
    };

    const serverConfig = Server.ServerConfig{
        .hostname = "127.0.0.1",
        .port = 9091,
        .routeHandler = routeHandler,
    };

    var server = Server.Server{
        .config = serverConfig,
    };

    std.debug.print("Starting server\n", .{});
    try server.startServer();
}

fn loadHome(request: *http.Server.Request) !void {
    var customBody = try MyElements.CustomBodyElement.init();
    var body = [_]HtmlElements.DivElement{
        .{
            .content = &customBody.baseHttpElement,
        },
    };

    var httpElement = HtmlElements.HttpElement{
        .head = .{
            .title = .{
                .value = "This is title",
            },
        },
        .body = .{
            .content = &body,
        },
    };

    const response = try std.fmt.allocPrint(std.heap.page_allocator, "{s}\n", .{try httpElement.baseHttpElement.toHttpString()});

    try request.respond(response, .{});
}

fn counterHandler(request: *http.Server.Request) !void {
    try MyElements.CustomBodyElement.incrementCounter();

    try request.respond("", .{
        .status = http.Status.no_content,
    });
}
