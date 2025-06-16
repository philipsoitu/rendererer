const std = @import("std");
const ppm = @import("ppm.zig");
const math = @import("math.zig");

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

    const a = math.Vec2f{
        .x = 0.2 * width,
        .y = 100,
    };
    const b = math.Vec2f{
        .x = 100,
        .y = 200,
    };
    const c = math.Vec2f{
        .x = 200,
        .y = 200,
    };

    for (0..height) |y| {
        for (0..width) |x| {
            const r_ratio: f64 = @as(f64, @floatFromInt(x)) / @as(f64, @floatFromInt(width - 1));
            const g_ratio: f64 = @as(f64, @floatFromInt(y)) / @as(f64, @floatFromInt(height - 1));
            const b_ratio: f64 = 0.0;

            const red: u8 = @intFromFloat(255.99 * r_ratio);
            const green: u8 = @intFromFloat(255.99 * g_ratio);
            const blue: u8 = @intFromFloat(255.99 * b_ratio);

            var pixel: Pixel = .{
                .r = red,
                .g = green,
                .b = blue,
            };

            if (math.pointInTriangle(a, b, c, math.Vec2f{
                .x = @floatFromInt(x),
                .y = @floatFromInt(y),
            })) {
                pixel = .{
                    .r = 0,
                    .g = 0,
                    .b = 255,
                };
            }

            framebuffer[y][x] = pixel;
        }
    }

    try ppm.write(filename, width, height, framebuffer);
}
