const std = @import("std");

pub const Vec2f = struct {
    x: f64,
    y: f64,
};

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
pub fn pointInTriangle(a: Vec2f, b: Vec2f, c: Vec2f, p: Vec2f) bool {
    const side_ab = pointOnRightSide(a, b, p);
    const side_bc = pointOnRightSide(b, c, p);
    const side_ca = pointOnRightSide(c, a, p);
    return side_ab == side_bc and side_bc == side_ca;
}
