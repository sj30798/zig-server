const std = @import("std");
const http = std.http;
const MyElements = @import("../ClickCounter/MyElements.zig");
const HtmlElements = @import("../HtmlElements/Elements.zig");

pub const HomeController = struct {
    pub fn LoadHome(request: *http.Server.Request) !void {
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
};
