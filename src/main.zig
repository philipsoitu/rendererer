const std = @import("std");
const ppm = @import("ppm.zig");
const obj = @import("obj.zig");
const math = @import("math.zig");
const rasterizer = @import("rasterizer.zig");
const Pixel = @import("types.zig").Pixel;
const Triangle2D = @import("types.zig").Triangle2D;

const WIDTH: usize = @import("config.zig").WIDTH;
const HEIGHT: usize = @import("config.zig").HEIGHT;
const filename = "hello.ppm";

pub fn main() !void {
    const obj_model = try obj.parseFile("models/cow.obj");
    defer obj_model.deinit();

    const triangles = try obj.modelToTriangles(obj_model);
    defer triangles.deinit();

    var framebuffer: [HEIGHT][WIDTH]Pixel = undefined;
    rasterizer.render(WIDTH, HEIGHT, &framebuffer, &triangles.items);

    try ppm.write(filename, WIDTH, HEIGHT, framebuffer);
}
