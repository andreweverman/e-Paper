const std = @import("std");
const e_Paper = @import("e_Paper");
const c = @import("c_bindings.zig");
const builtin = @import("builtin");
const zigimg = @import("zigimg");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const is_mac = builtin.os.tag == .macos;
    
    if (is_mac) std.debug.print("Running from mac, nothing going to display...", .{});
    std.debug.print("OS: {}\n", .{builtin.os.tag});

    std.debug.print("E-Paper Display Example\n", .{});

    // Example of calling C functions from Zig
    // Initialize the device
    const init_result = c.DEV_Module_Init();
    if (init_result == 0 or is_mac) {
        std.debug.print("Device initialized successfully\n", .{});

        std.Thread.sleep(10 * std.time.ns_per_s);
        // Initialize the display
        c.EPD_2IN7_Init();
        std.debug.print("Display initialized\n", .{});

        // Clear the display
        c.EPD_2IN7_Clear();
        std.debug.print("Display cleared\n", .{});

        const result = c.GUI_ReadBmp("images/flipclock.bmp", 0, 0);
        if (result != 0) {
            std.debug.print("Failed to read BMP\n", .{});
        }

        // Create an image buffer
        const image_size = (c.EPD_2IN7_WIDTH * c.EPD_2IN7_HEIGHT) / 8;
        const image_buffer = try allocator.alloc(u8, image_size);
        defer allocator.free(image_buffer);

        // Initialize the paint buffer
        c.Paint_NewImage(image_buffer.ptr, c.EPD_2IN7_WIDTH, c.EPD_2IN7_HEIGHT, c.ROTATE_0, c.WHITE);
        c.Paint_Clear(c.WHITE);

        // Draw some text
        const text = "Hello from Zig!";
        c.Paint_DrawString_EN(10, 10, text.ptr, c.getFont16(), c.BLACK, c.WHITE);

        std.Thread.sleep(3 * std.time.ns_per_s);

        // Draw a rectangle
        c.Paint_DrawRectangle(10, 50, 100, 100, c.BLACK, c.DOT_PIXEL_2X2, c.DRAW_FILL_EMPTY);

        // Draw a filled circle
        c.Paint_DrawCircle(130, 75, 20, c.BLACK, c.DOT_PIXEL_1X1, c.DRAW_FILL_FULL);

        // Display the image
        c.EPD_2IN7_Display(image_buffer.ptr);
        std.debug.print("Image displayed\n", .{});

        // Put display to sleep
        c.EPD_2IN7_Sleep();

        // Exit
        c.DEV_Module_Exit();
        std.debug.print("Device shutdown complete\n", .{});
    } else {
        std.debug.print("Failed to initialize device\n", .{});
        return error.DeviceInitFailed;
    }

    try e_Paper.bufferedPrint();
}

test "simple test" {
    const gpa = std.testing.allocator;
    var list: std.ArrayList(i32) = .empty;
    defer list.deinit(gpa); // Try commenting this out and see if zig detects the memory leak!
    try list.append(gpa, 42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}

test "fuzz example" {
    const Context = struct {
        fn testOne(context: @This(), input: []const u8) anyerror!void {
            _ = context;
            // Try passing `--fuzz` to `zig build test` and see if it manages to fail this test case!
            try std.testing.expect(!std.mem.eql(u8, "canyoufindme", input));
        }
    };
    try std.testing.fuzz(Context{}, Context.testOne, .{});
}
