const std = @import("std");
const Pixel = @import("types.zig").Pixel;
const Vec2f = @import("types.zig").Vec2f;
const Vec3f = @import("types.zig").Vec3f;
const Triangle2D = @import("types.zig").Triangle2D;
const config = @import("config.zig");

// that thing we learned in linear algebra
pub fn dotProduct(a: Vec2f, b: Vec2f) f64 {
    return a.x * b.x + a.y * b.y;
}

/// calculates vector 90 degrees clockwise
pub fn perpendicular(vec: Vec2f) Vec2f {
    return Vec2f{
        .x = vec.y,
        .y = -vec.x,
    };
}

// checks if point p is in triangle abc
pub fn pointInTriangle(t: Triangle2D, p: Vec2f, weights: *Vec3f) bool {
    _ = .{ t, p };
    const area_abp = signedTriangleArea(t.a, t.b, p);
    const area_bcp = signedTriangleArea(t.b, t.c, p);
    const area_cap = signedTriangleArea(t.c, t.a, p);
    const in_triangle: bool = area_abp >= 0 and area_bcp >= 0 and area_cap >= 0;

    const inv_area_sum: f32 = 1 / (area_abp + area_bcp + area_cap);
    const weight_a = area_bcp * inv_area_sum;
    const weight_b = area_cap * inv_area_sum;
    const weight_c = area_abp * inv_area_sum;
    weights.* = .{ .x = weight_a, .y = weight_b, .z = weight_c };

    return in_triangle;
}

pub fn signedTriangleArea(a: Vec2f, b: Vec2f, c: Vec2f) f32 {
    const ac: Vec2f = .{
        .x = c.x - a.x,
        .y = c.y - a.y,
    };
    const ab: Vec2f = .{
        .x = b.x - a.x,
        .y = b.y - a.y,
    };
    const ab_perp = perpendicular(ab);

    return dotProduct(ac, ab_perp) / 2;
}
