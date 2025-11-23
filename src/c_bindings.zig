// C bindings for e-Paper display library
// This file provides Zig declarations for the C functions

// Type aliases matching the C code
pub const UBYTE = u8;
pub const UWORD = u16;
pub const UDOUBLE = u32;

// EPD 2in7 Display Constants
pub const EPD_2IN7_WIDTH: u16 = 176;
pub const EPD_2IN7_HEIGHT: u16 = 264;

// Paint/GUI Constants
pub const WHITE: u16 = 0xFF;
pub const BLACK: u16 = 0x00;
pub const RED: u16 = BLACK;

// Gray levels
pub const GRAY1: u8 = 0x03; // Blackest
pub const GRAY2: u8 = 0x02;
pub const GRAY3: u8 = 0x01; // Gray
pub const GRAY4: u8 = 0x00; // White

// Rotation constants
pub const ROTATE_0: u16 = 0;
pub const ROTATE_90: u16 = 90;
pub const ROTATE_180: u16 = 180;
pub const ROTATE_270: u16 = 270;

// Mirror modes
pub const MIRROR_NONE: u8 = 0x00;
pub const MIRROR_HORIZONTAL: u8 = 0x01;
pub const MIRROR_VERTICAL: u8 = 0x02;
pub const MIRROR_ORIGIN: u8 = 0x03;

// Dot pixel sizes
pub const DOT_PIXEL_1X1: u8 = 1;
pub const DOT_PIXEL_2X2: u8 = 2;
pub const DOT_PIXEL_3X3: u8 = 3;
pub const DOT_PIXEL_4X4: u8 = 4;
pub const DOT_PIXEL_5X5: u8 = 5;
pub const DOT_PIXEL_6X6: u8 = 6;
pub const DOT_PIXEL_7X7: u8 = 7;
pub const DOT_PIXEL_8X8: u8 = 8;

// Draw fill modes
pub const DRAW_FILL_EMPTY: u8 = 0;
pub const DRAW_FILL_FULL: u8 = 1;

// Line styles
pub const LINE_STYLE_SOLID: u8 = 0;
pub const LINE_STYLE_DOTTED: u8 = 1;

// Font structure (opaque pointer for now)
pub const sFONT = opaque {};
pub const cFONT = opaque {};

// External font declarations (these are defined in the C font files)
extern const Font8: sFONT;
extern const Font12: sFONT;
extern const Font16: sFONT;
extern const Font20: sFONT;
extern const Font24: sFONT;
extern const Font12CN: cFONT;
extern const Font24CN: cFONT;

// Device Configuration Functions
pub extern fn DEV_Module_Init() UBYTE;
pub extern fn DEV_Module_Exit() void;
pub extern fn DEV_Delay_ms(xms: UDOUBLE) void;

// EPD 2in7 Display Functions
pub extern fn EPD_2IN7_Init() void;
pub extern fn EPD_2IN7_Clear() void;
pub extern fn EPD_2IN7_Display(Image: [*c]const UBYTE) void;
pub extern fn EPD_2IN7_Sleep() void;
pub extern fn EPD_2IN7_Init_4Gray() void;
pub extern fn EPD_2IN7_4GrayDisplay(Image: [*c]const UBYTE) void;

// EPD 2in7 V2 Display Functions
pub extern fn EPD_2IN7_V2_Init() void;
pub extern fn EPD_2IN7_V2_Clear() void;
pub extern fn EPD_2IN7_V2_Display(Image: [*c]const UBYTE) void;
pub extern fn EPD_2IN7_V2_Sleep() void;

// EPD 2in7b (B/W/Red) Display Functions
pub extern fn EPD_2IN7B_Init() void;
pub extern fn EPD_2IN7B_Clear() void;
pub extern fn EPD_2IN7B_Display(ImageBlack: [*c]const UBYTE, ImageRed: [*c]const UBYTE) void;
pub extern fn EPD_2IN7B_Sleep() void;

// EPD 2in7b V2 Display Functions
pub extern fn EPD_2IN7B_V2_Init() void;
pub extern fn EPD_2IN7B_V2_Clear() void;
pub extern fn EPD_2IN7B_V2_Display(ImageBlack: [*c]const UBYTE, ImageRed: [*c]const UBYTE) void;
pub extern fn EPD_2IN7B_V2_Sleep() void;

// Paint/GUI Functions
pub extern fn Paint_NewImage(image: [*c]UBYTE, Width: UWORD, Height: UWORD, Rotate: UWORD, Color: UWORD) void;
pub extern fn Paint_SelectImage(image: [*c]UBYTE) void;
pub extern fn Paint_SetRotate(Rotate: UWORD) void;
pub extern fn Paint_SetMirroring(mirror: UBYTE) void;
pub extern fn Paint_SetPixel(Xpoint: UWORD, Ypoint: UWORD, Color: UWORD) void;
pub extern fn Paint_SetScale(scale: UBYTE) void;
pub extern fn Paint_Clear(Color: UWORD) void;
pub extern fn Paint_ClearWindows(Xstart: UWORD, Ystart: UWORD, Xend: UWORD, Yend: UWORD, Color: UWORD) void;

// Drawing Functions
pub extern fn Paint_DrawPoint(Xpoint: UWORD, Ypoint: UWORD, Color: UWORD, Dot_Pixel: UBYTE, Dot_FillWay: UBYTE) void;
pub extern fn Paint_DrawLine(Xstart: UWORD, Ystart: UWORD, Xend: UWORD, Yend: UWORD, Color: UWORD, Line_width: UBYTE, Line_Style: UBYTE) void;
pub extern fn Paint_DrawRectangle(Xstart: UWORD, Ystart: UWORD, Xend: UWORD, Yend: UWORD, Color: UWORD, Line_width: UBYTE, Draw_Fill: UBYTE) void;
pub extern fn Paint_DrawCircle(X_Center: UWORD, Y_Center: UWORD, Radius: UWORD, Color: UWORD, Line_width: UBYTE, Draw_Fill: UBYTE) void;

// Text Drawing Functions
pub extern fn Paint_DrawChar(Xstart: UWORD, Ystart: UWORD, Acsii_Char: u8, Font: *const sFONT, Color_Foreground: UWORD, Color_Background: UWORD) void;
pub extern fn Paint_DrawString_EN(Xstart: UWORD, Ystart: UWORD, pString: [*c]const u8, Font: *const sFONT, Color_Foreground: UWORD, Color_Background: UWORD) void;
pub extern fn Paint_DrawString_CN(Xstart: UWORD, Ystart: UWORD, pString: [*c]const u8, font: *const cFONT, Color_Foreground: UWORD, Color_Background: UWORD) void;
pub extern fn Paint_DrawNum(Xpoint: UWORD, Ypoint: UWORD, Nummber: i32, Font: *const sFONT, Color_Foreground: UWORD, Color_Background: UWORD) void;
pub extern fn Paint_DrawNumDecimals(Xpoint: UWORD, Ypoint: UWORD, Nummber: f64, Font: *const sFONT, Digit: UWORD, Color_Foreground: UWORD, Color_Background: UWORD) void;

// Helper function to get pointers to fonts
pub fn getFont8() *const sFONT {
    return &Font8;
}

pub fn getFont12() *const sFONT {
    return &Font12;
}

pub fn getFont16() *const sFONT {
    return &Font16;
}

pub fn getFont20() *const sFONT {
    return &Font20;
}

pub fn getFont24() *const sFONT {
    return &Font24;
}

pub fn getFont12CN() *const cFONT {
    return &Font12CN;
}

pub fn getFont24CN() *const cFONT {
    return &Font24CN;
}
