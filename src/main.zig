const std = @import("std");
const ppm = @import("ppm.zig");

pub const Pixel = struct {
    r: u8,
    g: u8,
    b: u8,
};

pub fn main() !void {
    const filename = "hello.ppm";
    const width: usize = 640;
    const height: usize = 480;

    var framebuffer: [height][width]Pixel = std.mem.zeroes([height][width]Pixel);

    for (0..height) |y| {
        for (0..width) |x| {
            const r_ratio: f64 = @as(f64, @floatFromInt(x)) / @as(f64, @floatFromInt(width - 1));
            const g_ratio: f64 = @as(f64, @floatFromInt(y)) / @as(f64, @floatFromInt(height - 1));
            const b_ratio: f64 = 0.0;

            const r: u8 = @intFromFloat(255.99 * r_ratio);
            const g: u8 = @intFromFloat(255.99 * g_ratio);
            const b: u8 = @intFromFloat(255.99 * b_ratio);

            const pixel: Pixel = .{
                .r = r,
                .g = g,
                .b = b,
            };

            framebuffer[y][x] = pixel;
        }
    }

    try ppm.write(filename, width, height, framebuffer);
}
