# Zig Integration with C e-Paper Library

This project now integrates the C e-Paper library into the Zig build system, allowing you to call C functions directly from Zig code.

## What Was Added

### Build Configuration (`build.zig`)

The build script now includes:
- All C source files from `c/lib/` directory
  - Config files (sysfs GPIO implementation for portability)
  - E-Paper display drivers (EPD_2in7, EPD_2in7_V2, EPD_2in7b, EPD_2in7b_V2)
  - GUI/Graphics library (Paint functions)
  - Font files (Font8, 12, 16, 20, 24, and Chinese fonts)
- Include paths for C headers
- Linking with libc and libm (math library)

### Zig Bindings (`src/c_bindings.zig`)

This file provides Zig declarations for the C functions, including:
- Type aliases matching C types (UBYTE, UWORD, UDOUBLE)
- Constants (display dimensions, colors, rotation modes, etc.)
- Function declarations for:
  - Device initialization and configuration
  - Display operations (init, clear, display, sleep)
  - Paint/drawing functions
  - Text rendering
  - Grayscale support

### Example Code (`src/main.zig`)

The main file demonstrates:
- Initializing the e-Paper display
- Creating an image buffer
- Drawing text, shapes, and graphics
- Displaying the image on the screen
- Proper cleanup and shutdown

### Additional Examples (`src/examples.zig`)

Contains various example functions showing:
- Simple display clearing
- Text rendering
- Shape drawing (rectangles, circles, lines)
- Number display
- 4-level grayscale mode

## Usage

### Building the Project

```bash
zig build
```

The executable will be created at `zig-out/bin/e_Paper`.

### Running the Program

```bash
zig build run
```

### Using C Functions in Zig

Import the bindings module in your Zig code:

```zig
const c = @import("c_bindings.zig");
```

Then call C functions directly:

```zig
// Initialize device
const init_result = c.DEV_Module_Init();

// Initialize display
c.EPD_2IN7_Init();

// Create image buffer
const image_size = (c.EPD_2IN7_WIDTH * c.EPD_2IN7_HEIGHT) / 8;
const image_buffer = try allocator.alloc(u8, image_size);

// Setup paint
c.Paint_NewImage(image_buffer.ptr, c.EPD_2IN7_WIDTH, c.EPD_2IN7_HEIGHT, c.ROTATE_0, c.WHITE);
c.Paint_Clear(c.WHITE);

// Draw text
const text = "Hello from Zig!";
c.Paint_DrawString_EN(10, 10, text.ptr, c.getFont16(), c.BLACK, c.WHITE);

// Display
c.EPD_2IN7_Display(image_buffer.ptr);

// Cleanup
c.EPD_2IN7_Sleep();
c.DEV_Module_Exit();
```

## Available Functions

### Device Configuration
- `DEV_Module_Init()` - Initialize the device (returns 0 on failure)
- `DEV_Module_Exit()` - Cleanup and shutdown
- `DEV_Delay_ms(ms)` - Delay for specified milliseconds

### Display Functions (EPD 2.7")
- `EPD_2IN7_Init()` - Initialize the display
- `EPD_2IN7_Clear()` - Clear the display
- `EPD_2IN7_Display(image)` - Display an image buffer
- `EPD_2IN7_Sleep()` - Put display to sleep mode
- `EPD_2IN7_Init_4Gray()` - Initialize 4-level grayscale mode
- `EPD_2IN7_4GrayDisplay(image)` - Display grayscale image

### Paint/Drawing Functions
- `Paint_NewImage(buffer, width, height, rotate, color)` - Initialize image buffer
- `Paint_Clear(color)` - Clear with specified color
- `Paint_DrawPoint(x, y, color, size, style)` - Draw a point
- `Paint_DrawLine(x1, y1, x2, y2, color, width, style)` - Draw a line
- `Paint_DrawRectangle(x1, y1, x2, y2, color, width, fill)` - Draw rectangle
- `Paint_DrawCircle(x, y, radius, color, width, fill)` - Draw circle

### Text Functions
- `Paint_DrawChar(x, y, char, font, fg_color, bg_color)` - Draw a character
- `Paint_DrawString_EN(x, y, string, font, fg_color, bg_color)` - Draw English text
- `Paint_DrawNum(x, y, number, font, fg_color, bg_color)` - Draw integer
- `Paint_DrawNumDecimals(x, y, number, font, digits, fg_color, bg_color)` - Draw decimal number

### Available Fonts
- `getFont8()` - 8pt font
- `getFont12()` - 12pt font
- `getFont16()` - 16pt font
- `getFont20()` - 20pt font
- `getFont24()` - 24pt font
- `getFont12CN()` - 12pt Chinese font
- `getFont24CN()` - 24pt Chinese font

## Constants

### Colors
- `WHITE` - White (0xFF)
- `BLACK` - Black (0x00)
- `GRAY1` - Darkest gray (4-level mode)
- `GRAY2` - Dark gray
- `GRAY3` - Light gray
- `GRAY4` - White (4-level mode)

### Rotation
- `ROTATE_0` - No rotation
- `ROTATE_90` - 90° rotation
- `ROTATE_180` - 180° rotation
- `ROTATE_270` - 270° rotation

### Drawing Options
- `DOT_PIXEL_1X1` through `DOT_PIXEL_8X8` - Point sizes
- `LINE_STYLE_SOLID` - Solid line
- `LINE_STYLE_DOTTED` - Dotted line
- `DRAW_FILL_EMPTY` - Hollow shape
- `DRAW_FILL_FULL` - Filled shape

## Display Specifications

- **EPD_2IN7**: 176x264 pixels, black/white
- **EPD_2IN7_V2**: Updated version of 2.7" display
- **EPD_2IN7B**: 176x264 pixels, black/white/red
- **EPD_2IN7B_V2**: Updated version with color support

## Notes

- The current build uses sysfs GPIO implementation (`JETSON` mode) for maximum portability
- No external library dependencies required (uses kernel sysfs interface)
- For Raspberry Pi with gpiod library, you can modify `build.zig` to use RPI mode
- Image buffers must be allocated with the correct size:
  - B/W mode: `(width * height) / 8` bytes
  - 4-gray mode: `(width * height) / 4` bytes

## Troubleshooting

If you encounter build issues:
1. Ensure you have Zig 0.13+ installed
2. Check that all C source files are present in `c/lib/`
3. Verify include paths in `build.zig`

For runtime issues:
1. Ensure your device has GPIO access permissions
2. Check that `/sys/class/gpio` is accessible
3. Verify pin mappings match your hardware

## Further Reading

- See `src/examples.zig` for more usage examples
- Check `c/examples/` for original C examples
- Refer to Waveshare e-Paper documentation for hardware details
