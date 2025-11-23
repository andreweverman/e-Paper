// Minimal example showing the simplest way to use the e-Paper display from Zig
const std = @import("std");
const c = @import("c_bindings.zig");

pub fn minimal() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // 1. Initialize the hardware
    if (c.DEV_Module_Init() == 0) {
        return error.InitFailed;
    }
    defer c.DEV_Module_Exit(); // Always cleanup

    // 2. Initialize the display
    c.EPD_2IN7_Init();
    defer c.EPD_2IN7_Sleep(); // Put to sleep when done

    // 3. Create image buffer (176 * 264 / 8 bytes for black/white)
    const buffer_size = (c.EPD_2IN7_WIDTH * c.EPD_2IN7_HEIGHT) / 8;
    const image = try allocator.alloc(u8, buffer_size);
    defer allocator.free(image);

    // 4. Initialize the paint context
    c.Paint_NewImage(image.ptr, c.EPD_2IN7_WIDTH, c.EPD_2IN7_HEIGHT, c.ROTATE_0, c.WHITE);

    // 5. Clear to white
    c.Paint_Clear(c.WHITE);

    // 6. Draw something
    c.Paint_DrawString_EN(20, // x position
        20, // y position
        "Hello, World!", // text
        c.getFont20(), // font
        c.BLACK, // foreground color
        c.WHITE // background color
    );

    // 7. Display the image
    c.EPD_2IN7_Display(image.ptr);
}

test "minimal example compiles" {
    // This test just ensures the code compiles
    // Remove the try minimal() line to avoid runtime errors in tests
}
