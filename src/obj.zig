const std = @import("std");
const math = @import("math.zig");
const Vec2f = @import("types.zig").Vec2f;
const Vec3f = @import("types.zig").Vec3f;
const Triangle = @import("types.zig").Triangle;

const WIDTH = @import("config.zig").WIDTH;
const HEIGHT = @import("config.zig").HEIGHT;

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

pub fn modelToTriangles(obj_model: ObjModel) !std.ArrayList(Triangle) {
    const allocator = std.heap.page_allocator;
    var triangles = try std.ArrayList(Triangle).initCapacity(allocator, 100);

    const screen = Vec2f{ .x = WIDTH, .y = HEIGHT };

    for (obj_model.faces.items) |face| {
        const a = math.vec3fToVec2f(obj_model.vertices.items[face.a - 1], screen);
        const b = math.vec3fToVec2f(obj_model.vertices.items[face.b - 1], screen);
        const c = math.vec3fToVec2f(obj_model.vertices.items[face.c - 1], screen);

        const triangle = Triangle{
            .a = a,
            .b = b,
            .c = c,
            .color = .{ .r = 255, .g = 0, .b = 0 },
        };

        try triangles.append(triangle);
    }

    return triangles;
}
