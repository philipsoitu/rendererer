const std = @import("std");
const Vec3f = @import("types.zig").Vec3f;
const Triangle = @import("types.zig").Triangle;

const ObjModel = struct {
    vertices: std.ArrayList(Vec3f),
    faces: std.ArrayList(Face),

    pub fn deinit(self: @This()) void {
        self.vertices.deinit();
        self.faces.deinit();
    }
};

const Face = struct {
    a: usize,
    b: usize,
    c: usize,
};

const LineResult = union(enum) {
    vec: Vec3f,
    face: Face,
};

pub fn parseFile(filename: []const u8) !ObjModel {
    const allocator = std.heap.page_allocator;

    var vertices = try std.ArrayList(Vec3f).initCapacity(allocator, 100);
    var faces = try std.ArrayList(Face).initCapacity(allocator, 100);

    const file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();

    const stat = try file.stat();
    const file_size = stat.size;

    const buffer = try allocator.alloc(u8, file_size);
    defer allocator.free(buffer);

    _ = try file.readAll(buffer);

    var lines = std.mem.splitScalar(u8, buffer, '\n');

    while (lines.next()) |line| {
        // clean up line
        const trimmed = std.mem.trim(u8, line, " \r\n");

        if (std.mem.startsWith(u8, trimmed, "v ")) {
            // is vertice
            var iter = std.mem.tokenizeScalar(u8, trimmed[2..], ' ');
            const x = try std.fmt.parseFloat(f64, iter.next().?);
            const y = try std.fmt.parseFloat(f64, iter.next().?);
            const z = try std.fmt.parseFloat(f64, iter.next().?);
            try vertices.append(Vec3f{ .x = x, .y = y, .z = z });
        } else if (std.mem.startsWith(u8, line, "f ")) {
            // is face
            var iter = std.mem.tokenizeScalar(u8, line[2..], ' ');
            const a = try std.fmt.parseInt(usize, iter.next().?, 10);
            const b = try std.fmt.parseInt(usize, iter.next().?, 10);
            const c = try std.fmt.parseInt(usize, iter.next().?, 10);
            try faces.append(.{ .a = a, .b = b, .c = c });
        }
    }
    return ObjModel{
        .vertices = vertices,
        .faces = faces,
    };
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
