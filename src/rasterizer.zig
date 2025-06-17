const std = @import("std");
const math = @import("math.zig");
const ppm = @import("ppm.zig");
const Pixel = @import("types.zig").Pixel;
const Vec2f = @import("types.zig").Vec2f;
const Triangle = @import("types.zig").Triangle;

pub fn render(
    comptime width: usize,
    comptime height: usize,
    framebuffer: *[height][width]Pixel,
    triangles: []const Triangle,
) void {
    clearFramebuffer(width, height, framebuffer);

    for (triangles) |triangle| {
        drawTriangle(width, height, framebuffer, triangle);
    }
}

fn clearFramebuffer(
    comptime width: usize,
    comptime height: usize,
    framebuffer: *[height][width]Pixel,
) void {
    for (0..height) |y| {
        for (0..width) |x| {
            framebuffer[y][x] = Pixel{
                .r = 0,
                .g = 0,
                .b = 0,
            };
        }
    }
}

fn drawTriangle(
    comptime width: usize,
    comptime height: usize,
    framebuffer: *[height][width]Pixel,
    triangle: Triangle,
) void {
    const min_x = @min(triangle.a.x, triangle.b.x, triangle.c.x);
    const min_y = @min(triangle.a.y, triangle.b.y, triangle.c.y);
    const max_x = @max(triangle.a.x, triangle.b.x, triangle.c.x);
    const max_y = @max(triangle.a.y, triangle.b.y, triangle.c.y);

    const bb_start_x: usize = @intFromFloat(@max(0, @min(min_x, width)));
    const bb_start_y: usize = @intFromFloat(@max(0, @min(min_y, height)));
    const bb_end_x: usize = @intFromFloat(@max(0, @min(max_x, width)));
    const bb_end_y: usize = @intFromFloat(@max(0, @min(max_y, height)));

    for (bb_start_y..bb_end_y) |y| {
        for (bb_start_x..bb_end_x) |x| {
            const point: Vec2f = .{ .x = @floatFromInt(x), .y = @floatFromInt(y) };
            if (math.pointInTriangle(triangle, point)) {
                framebuffer[y][x] = triangle.color;
            }
        }
    }
}
