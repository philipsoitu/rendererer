const std = @import("std");
const ppm = @import("ppm.zig");
const obj = @import("obj.zig");
const math = @import("math.zig");
const rasterizer = @import("rasterizer.zig");
const Pixel = @import("types.zig").Pixel;
const Triangle2D = @import("types.zig").Triangle2D;
const RenderOptions = @import("types.zig").RenderOptions;

const WIDTH: usize = @import("config.zig").WIDTH;
const HEIGHT: usize = @import("config.zig").HEIGHT;

pub fn main() !void {
    var render_options: RenderOptions = .{
        .yaw = 0.0,
        .pitch = 0.0,
        .pixel_height = 10.0,
    };

    const obj_model = try obj.parseFile("models/cow.obj");
    defer obj_model.deinit();

    const triangles = try obj.modelToTriangles(obj_model);
    defer triangles.deinit();

    var framebuffer: [HEIGHT][WIDTH]Pixel = undefined;

    var filename_buffer: [23]u8 = undefined;

    for (0..100) |frame| {
        render_options.yaw = @as(f32, @floatFromInt(frame)) / 100 * std.math.pi;
        std.debug.print("frame {}\n", .{frame});
        rasterizer.render(
            WIDTH,
            HEIGHT,
            &framebuffer,
            &triangles.items,
            render_options,
        );

        const filename = try std.fmt.bufPrint(&filename_buffer, "output/frames/f{0:0>4}.ppm", .{frame + 1});
        try ppm.write(filename, WIDTH, HEIGHT, framebuffer);
    }
}
