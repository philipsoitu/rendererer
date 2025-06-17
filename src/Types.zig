pub const Pixel = struct {
    r: u8,
    g: u8,
    b: u8,
};

pub const Vec2f = struct {
    x: f64,
    y: f64,
};

pub const Triangle = struct {
    a: Vec2f,
    b: Vec2f,
    c: Vec2f,
    color: Pixel,
};
