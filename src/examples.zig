// Example functions demonstrating how to use the C e-Paper library from Zig

const std = @import("std");
const c = @import("c_bindings.zig");

/// Initialize the e-Paper device and display
pub fn initDisplay() !void {
    const result = c.DEV_Module_Init();
    if (result == 0) {
        return error.DeviceInitFailed;
    }
}

/// Simple example: Clear the display
pub fn clearDisplay() void {
    c.EPD_2IN7_Init();
    c.EPD_2IN7_Clear();
    c.EPD_2IN7_Sleep();
}

/// Draw text on the display
pub fn drawText(allocator: std.mem.Allocator, text: []const u8) !void {
    const image_size = (c.EPD_2IN7_WIDTH * c.EPD_2IN7_HEIGHT) / 8;
    const image_buffer = try allocator.alloc(u8, image_size);
    defer allocator.free(image_buffer);

    // Initialize display
    c.EPD_2IN7_Init();

    // Setup paint
    c.Paint_NewImage(image_buffer.ptr, c.EPD_2IN7_WIDTH, c.EPD_2IN7_HEIGHT, c.ROTATE_0, c.WHITE);
    c.Paint_Clear(c.WHITE);

    // Draw text
    c.Paint_DrawString_EN(10, 10, text.ptr, c.getFont16(), c.BLACK, c.WHITE);

    // Display
    c.EPD_2IN7_Display(image_buffer.ptr);
    c.EPD_2IN7_Sleep();
}

/// Draw shapes on the display
pub fn drawShapes(allocator: std.mem.Allocator) !void {
    const image_size = (c.EPD_2IN7_WIDTH * c.EPD_2IN7_HEIGHT) / 8;
    const image_buffer = try allocator.alloc(u8, image_size);
    defer allocator.free(image_buffer);

    c.EPD_2IN7_Init();

    c.Paint_NewImage(image_buffer.ptr, c.EPD_2IN7_WIDTH, c.EPD_2IN7_HEIGHT, c.ROTATE_0, c.WHITE);
    c.Paint_Clear(c.WHITE);

    // Draw rectangle
    c.Paint_DrawRectangle(10, 10, 80, 80, c.BLACK, c.DOT_PIXEL_2X2, c.DRAW_FILL_EMPTY);

    // Draw filled rectangle
    c.Paint_DrawRectangle(90, 10, 160, 80, c.BLACK, c.DOT_PIXEL_1X1, c.DRAW_FILL_FULL);

    // Draw circle
    c.Paint_DrawCircle(45, 120, 30, c.BLACK, c.DOT_PIXEL_2X2, c.DRAW_FILL_EMPTY);

    // Draw filled circle
    c.Paint_DrawCircle(125, 120, 30, c.BLACK, c.DOT_PIXEL_1X1, c.DRAW_FILL_FULL);

    // Draw lines
    c.Paint_DrawLine(10, 170, 166, 170, c.BLACK, c.DOT_PIXEL_2X2, c.LINE_STYLE_SOLID);
    c.Paint_DrawLine(10, 180, 166, 180, c.BLACK, c.DOT_PIXEL_2X2, c.LINE_STYLE_DOTTED);

    c.EPD_2IN7_Display(image_buffer.ptr);
    c.EPD_2IN7_Sleep();
}

/// Display numbers
pub fn drawNumbers(allocator: std.mem.Allocator, number: i32) !void {
    const image_size = (c.EPD_2IN7_WIDTH * c.EPD_2IN7_HEIGHT) / 8;
    const image_buffer = try allocator.alloc(u8, image_size);
    defer allocator.free(image_buffer);

    c.EPD_2IN7_Init();

    c.Paint_NewImage(image_buffer.ptr, c.EPD_2IN7_WIDTH, c.EPD_2IN7_HEIGHT, c.ROTATE_0, c.WHITE);
    c.Paint_Clear(c.WHITE);

    // Draw number
    c.Paint_DrawNum(10, 10, number, c.getFont24(), c.BLACK, c.WHITE);

    // Draw decimal number
    c.Paint_DrawNumDecimals(10, 50, 3.14159, c.getFont20(), 3, c.BLACK, c.WHITE);

    c.EPD_2IN7_Display(image_buffer.ptr);
    c.EPD_2IN7_Sleep();
}

/// Example using 4-grayscale mode
pub fn draw4Gray(allocator: std.mem.Allocator) !void {
    const image_size = (c.EPD_2IN7_WIDTH * c.EPD_2IN7_HEIGHT) / 4; // 2 bits per pixel for 4 gray
    const image_buffer = try allocator.alloc(u8, image_size);
    defer allocator.free(image_buffer);

    c.EPD_2IN7_Init_4Gray();

    c.Paint_NewImage(image_buffer.ptr, c.EPD_2IN7_WIDTH, c.EPD_2IN7_HEIGHT, c.ROTATE_0, c.WHITE);
    c.Paint_SetScale(2); // 2-bit grayscale
    c.Paint_Clear(c.GRAY4);

    // Draw with different gray levels
    c.Paint_DrawRectangle(10, 10, 50, 50, c.GRAY1, c.DOT_PIXEL_1X1, c.DRAW_FILL_FULL);
    c.Paint_DrawRectangle(60, 10, 100, 50, c.GRAY2, c.DOT_PIXEL_1X1, c.DRAW_FILL_FULL);
    c.Paint_DrawRectangle(110, 10, 150, 50, c.GRAY3, c.DOT_PIXEL_1X1, c.DRAW_FILL_FULL);

    c.EPD_2IN7_4GrayDisplay(image_buffer.ptr);
    c.EPD_2IN7_Sleep();
}

/// Shutdown the display
pub fn shutdownDisplay() void {
    c.DEV_Module_Exit();
}
