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
            const pixel: Pixel = .{
                .r = 255,
                .g = 200,
                .b = 100,
            };
            framebuffer[y][x] = pixel;
        }
    }

    try ppm.write(filename, width, height, framebuffer);
}
