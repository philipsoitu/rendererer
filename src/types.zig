const math = @import("math.zig");
const projection = @import("projection.zig");
const config = @import("config.zig");

pub const Pixel = struct {
    r: u8,
    g: u8,
    b: u8,
};

pub const Vec2f = struct {
    x: f32,
    y: f32,
};

pub const Vec3f = struct {
    x: f32,
    y: f32,
    z: f32,
};

pub const Triangle2D = struct {
    a: Vec2f,
    b: Vec2f,
    c: Vec2f,
    color: Pixel,

    pub fn fromTriangle3D(t3: Triangle3D, render_options: RenderOptions) @This() {
        const t2: Triangle2D = .{
            .a = projection.vec3fToVec2f(t3.a, config.WIDTH, config.HEIGHT, render_options),
            .b = projection.vec3fToVec2f(t3.b, config.WIDTH, config.HEIGHT, render_options),
            .c = projection.vec3fToVec2f(t3.c, config.WIDTH, config.HEIGHT, render_options),
            .color = t3.color,
        };
        return t2;
    }
};

pub const Triangle3D = struct {
    a: Vec3f,
    b: Vec3f,
    c: Vec3f,
    color: Pixel,
};

pub const RenderOptions = struct {
    yaw: f32,
    pitch: f32,
    position: Vec3f,

    pixel_height: f32,
};
