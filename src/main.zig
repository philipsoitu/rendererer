const std = @import("std");
const ppm = @import("ppm.zig");
const math = @import("math.zig");
const rasterizer = @import("rasterizer.zig");
const Pixel = @import("types.zig").Pixel;
const Triangle = @import("types.zig").Triangle;

const WIDTH: usize = @import("config.zig").WIDTH;
const HEIGHT: usize = @import("config.zig").HEIGHT;
const filename = "hello.ppm";

pub fn main() !void {
    const triangles = [_]Triangle{
        Triangle{
            .a = .{ .x = 100, .y = 100 },
            .b = .{ .x = 100, .y = 200 },
            .c = .{ .x = 200, .y = 200 },
            .color = .{ .r = 0, .g = 255, .b = 255 },
        },
        Triangle{
            .a = .{ .x = 100, .y = 100 },
            .b = .{ .x = 200, .y = 100 },
            .c = .{ .x = 200, .y = 200 },
            .color = .{ .r = 255, .g = 200, .b = 0 },
        },
        Triangle{
            .a = .{ .x = 122, .y = 23 },
            .b = .{ .x = 422, .y = 223 },
            .c = .{ .x = 522, .y = 203 },
            .color = .{ .r = 25, .g = 9, .b = 200 },
        },
    };

    var framebuffer: [HEIGHT][WIDTH]Pixel = undefined;

    rasterizer.render(WIDTH, HEIGHT, &framebuffer, &triangles);

    try ppm.write(filename, WIDTH, HEIGHT, framebuffer);
}
