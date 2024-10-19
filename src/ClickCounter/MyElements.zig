const std = @import("std");
const BaseElements = @import("../HttpElements//Elements.zig");
const BaseHttpElement = BaseElements.BaseHttpElement;

pub const CustomBodyElement = struct {
    clickButton: BaseElements.ButtonElement,
    buttonCounter: BaseElements.Paragraph,

    baseHttpElement: BaseHttpElement = .{
        .toHttpStringFn = toHttpString,
    },

    var buttonClickCount: i32 = 0;

    pub fn init() !CustomBodyElement {
        const buttonCounterText = try std.fmt.allocPrint(std.heap.page_allocator, "Button has been clicked {d} times!", .{CustomBodyElement.buttonClickCount});

        return .{
            .clickButton = .{
                .text = "Click me!",
            },
            .buttonCounter = .{
                .content = buttonCounterText,
            },
        };
    }

    pub fn incrementCounter() !void {
        CustomBodyElement.buttonClickCount += 1;
    }

    fn toHttpString(iBaseHttpElement: *BaseHttpElement) anyerror![]const u8 {
        const self = @as(*CustomBodyElement, @fieldParentPtr("baseHttpElement", iBaseHttpElement));

        return try std.fmt.allocPrint(std.heap.page_allocator, "{s}<br>{s}", .{ try self.clickButton.baseHttpElement.toHttpString(), try self.buttonCounter.baseHttpElement.toHttpString() });
    }
};
