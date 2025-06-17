const std = @import("std");
const Pixel = @import("types.zig").Pixel;

pub fn write(
    filename: []const u8,
    comptime width: usize,
    comptime height: usize,
    framebuffer: [height][width]Pixel,
) !void {
    const file = try std.fs.cwd().createFile(filename, .{});
    defer file.close();

    try file.writer().print("P6\n{} {}\n255\n", .{ width, height });
    try file.writeAll(std.mem.sliceAsBytes(&framebuffer));
}
