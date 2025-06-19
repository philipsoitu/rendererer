const std = @import("std");
const Vec3f = @import("types.zig").Vec3f;
const Triangle = @import("types.zig").Triangle;

const ObjModel = struct {
    vertices: std.ArrayList(Vec3f),
    faces: std.ArrayList(Triangle),

    pub fn deinit(self: @This()) void {
        self.vertices.deinit();
        self.faces.deinit();
    }
};

const Face = struct {
    indexes: [3]usize,
};

const LineResult = union(enum) {
    vec: Vec3f,
    face: Face,
};

pub fn parseFile(filename: []const u8) !ObjModel {
    const allocator = std.heap.page_allocator;

    const file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();

    const stat = try file.stat();
    const file_size = stat.size;

    const buffer = try allocator.alloc(u8, file_size);
    defer allocator.free(buffer);

    _ = try file.readAll(buffer);

    var lines = std.mem.splitScalar(u8, buffer, '\n');

    while (lines.next()) |line| {
        const line_res = try parseLine(line);
        switch (line_res) {
            .vec => |v| {
                std.debug.print("vector: {} {} {}\n", .{ v.x, v.y, v.z });
            },
            .face => |f| {
                std.debug.print("face: {d} {d} {d}\n", .{ f.indexes[0], f.indexes[1], f.indexes[2] });
            },
        }
    }
    return undefined;
}

pub fn parseLine(line: []const u8) !LineResult {
    var tokens = std.mem.splitScalar(u8, line, ' ');
    var i: usize = 0;

    var line_return: LineResult = undefined;

    while (tokens.next()) |token| {
        switch (i) {
            // determine type of line
            0 => {
                if (std.mem.eql(u8, token, "v")) {
                    line_return = .{ .vec = .{
                        .x = 0.0,
                        .y = 0.0,
                        .z = 0.0,
                    } };
                } else if (std.mem.eql(u8, token, "f")) {
                    line_return = .{ .face = .{ .indexes = std.mem.zeroes([3]usize) } };
                }
            },
            // parse first number
            1 => {
                if (line_return == .vec) {
                    line_return.vec.x = try std.fmt.parseFloat(f64, token);
                } else if (line_return == .face) {
                    line_return.face.indexes[0] = try std.fmt.parseInt(usize, token, 10);
                }
            },
            // parse second number
            2 => {
                if (line_return == .vec) {
                    line_return.vec.y = try std.fmt.parseFloat(f64, token);
                } else if (line_return == .face) {
                    line_return.face.indexes[1] = try std.fmt.parseInt(usize, token, 10);
                }
            },
            // parse third number
            3 => {
                if (line_return == .vec) {
                    line_return.vec.z = try std.fmt.parseFloat(f64, token);
                } else if (line_return == .face) {
                    line_return.face.indexes[2] = try std.fmt.parseInt(usize, token, 10);
                }
            },
            // too many numbers
            else => {
                return error.TOO_MANY_ARGS_IN_LINE;
            },
        }
        i += 1;
    }
    return line_return;
}
