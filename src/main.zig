const std = @import("std");
const ppm = @import("ppm.zig");
const obj = @import("obj.zig");
const math = @import("math.zig");
const rasterizer = @import("rasterizer.zig");
const Pixel = @import("types.zig").Pixel;
const Triangle2D = @import("types.zig").Triangle2D;
const CameraOptions = @import("types.zig").CameraOptions;

const WIDTH: usize = @import("config.zig").WIDTH;
const HEIGHT: usize = @import("config.zig").HEIGHT;

pub fn main() !void {
    var camera_options: CameraOptions = .{
        .yaw = 0.0,
    };

    const obj_model = try obj.parseFile("models/cow.obj");
    defer obj_model.deinit();

    const triangles = try obj.modelToTriangles(obj_model);
    defer triangles.deinit();

    var framebuffer: [HEIGHT][WIDTH]Pixel = undefined;

    var filename_buffer: [23]u8 = undefined;

    for (0..1000) |frame| {
        camera_options.yaw = @as(f32, @floatFromInt(frame)) / 100;
        std.debug.print("{}\n", .{camera_options.yaw});
        rasterizer.render(WIDTH, HEIGHT, &framebuffer, &triangles.items, camera_options);

        const filename = try std.fmt.bufPrint(&filename_buffer, "output/frames/f{0:0>4}.ppm", .{frame + 1});
        try ppm.write(filename, WIDTH, HEIGHT, framebuffer);
    }
}
