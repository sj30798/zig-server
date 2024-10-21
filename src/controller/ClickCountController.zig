const std = @import("std");
const http = std.http;
const ClickCounter = @import("../models/ClickCounter.zig").ClickCounter;

pub const ClickCountController = struct {
    pub fn incrementCounter(request: *http.Server.Request) !void {
        ClickCounter.IncrementCounter();

        try request.respond("", .{
            .status = http.Status.no_content,
        });
    }

    pub fn decrementCounter(request: *http.Server.Request) !void {
        if (ClickCounter.GetCounter() == 0) {
            try request.respond("Counter is already 0", .{
                .status = http.Status.bad_request,
            });
            return;
        }

        ClickCounter.DecrementCounter();

        try request.respond("", .{
            .status = http.Status.no_content,
        });
    }

    pub fn resetCounter(request: *http.Server.Request) !void {
        ClickCounter.ResetCounter();

        try request.respond("", .{
            .status = http.Status.no_content,
        });
    }
};
