const std = @import("std");
const net = std.net;
const http = std.http;
const HtmlElements = @import("HtmlElements//Elements.zig");
const MyElements = @import("ClickCounter//MyElements.zig");
const StringUtils = @import("Utils/StringUtils.zig").StringUtils;
const Routes = @import("./ServerComponents/Routes.zig");
const RouteHandler = Routes.RouteHandler;
const Server = @import("./ServerComponents/Server.zig");

const HomeController = @import("controller/HomeController.zig").HomeController;
const ClickCountController = @import("controller/ClickCountController.zig").ClickCountController;

pub fn main() !void {
    try start_server();
}

fn init_routes() !RouteHandler {
    var handler = RouteHandler{};

    try handler.addRoute(.{ .method = http.Method.GET, .path = "/", .handler = HomeController.LoadHome });
    try handler.addRoute(.{ .method = http.Method.POST, .path = "/counter/increment", .handler = ClickCountController.incrementCounter });
    try handler.addRoute(.{ .method = http.Method.POST, .path = "/counter/decrement", .handler = ClickCountController.decrementCounter });
    try handler.addRoute(.{ .method = http.Method.POST, .path = "/counter/reset", .handler = ClickCountController.resetCounter });

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
