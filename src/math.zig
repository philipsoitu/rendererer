const std = @import("std");
const Pixel = @import("types.zig").Pixel;
const Vec2f = @import("types.zig").Vec2f;
const Vec3f = @import("types.zig").Vec3f;
const Triangle = @import("types.zig").Triangle;

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

/// checks if point p is on the right side of a -> b
pub fn pointOnRightSide(a: Vec2f, b: Vec2f, p: Vec2f) bool {
    const ap = Vec2f{
        .x = p.x - a.x,
        .y = p.y - a.y,
    };
    const ab = Vec2f{
        .x = b.x - a.x,
        .y = b.y - a.y,
    };
    const ab_perp = perpendicular(ab);
    return dotProduct(ap, ab_perp) >= 0;
}

// checks if point p is in triangle abc
pub fn pointInTriangle(t: Triangle, p: Vec2f) bool {
    const side_ab = pointOnRightSide(t.a, t.b, p);
    const side_bc = pointOnRightSide(t.b, t.c, p);
    const side_ca = pointOnRightSide(t.c, t.a, p);
    return side_ab == side_bc and side_bc == side_ca;
}

pub fn vec3fToVec2f(vec3f: Vec3f, screen_size: Vec2f) Vec2f {
    const screen_height: f64 = 5.0; // meters ig
    const pixels_per_unit: f64 = screen_size.y / screen_height;

    const pixel_offset = Vec2f{
        .x = vec3f.x * pixels_per_unit,
        .y = vec3f.y * pixels_per_unit,
    };

    return Vec2f{
        .x = pixel_offset.x + screen_size.x / 2,
        .y = pixel_offset.y + screen_size.y / 2,
    };
}
