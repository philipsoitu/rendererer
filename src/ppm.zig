const std = @import("std");
const Pixel = @import("main.zig").Pixel;

pub fn write(filename: []const u8, width: usize, height: usize, framebuffer: anytype) !void {
    const file = try std.fs.cwd().createFile(filename, .{});
    defer file.close();

    try file.writer().print("P6\n{} {}\n255\n", .{ width, height });
    try file.writeAll(std.mem.sliceAsBytes(&framebuffer));
}
