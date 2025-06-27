const Vec2f = @import("types.zig").Vec2f;
const Vec3f = @import("types.zig").Vec3f;
const RenderOptions = @import("types.zig").RenderOptions;

const Basis = struct {
    i: Vec3f,
    j: Vec3f,
    k: Vec3f,
};

pub fn vec3fToVec2f(
    vec3f: Vec3f,
    comptime width: usize,
    comptime height: usize,
    render_options: RenderOptions,
) Vec2f {
    const vec3f_world = toWorldPoint(vec3f, render_options);

    const pixels_per_unit: f32 = height / render_options.pixel_height / vec3f_world.z;

    const pixel_offset = Vec2f{
        .x = vec3f_world.x * pixels_per_unit,
        .y = vec3f_world.y * pixels_per_unit,
    };
    return Vec2f{
        .x = pixel_offset.x + width / 2,
        .y = -pixel_offset.y + height / 2,
    };
}

pub fn toWorldPoint(p: Vec3f, render_options: RenderOptions) Vec3f {
    const basis = getBasisVectors(render_options.yaw, render_options.pitch);

    const transformed = transformVector(
        basis.i,
        basis.j,
        basis.k,
        p,
    );

    return Vec3f{
        .x = transformed.x + render_options.position.x,
        .y = transformed.y + render_options.position.y,
        .z = transformed.z + render_options.position.z,
    };
}

/// calculates (i, j, k) basis vectors
fn getBasisVectors(yaw: f32, pitch: f32) Basis {
    const i_hat_yaw = Vec3f{ .x = @cos(yaw), .y = 0, .z = @sin(yaw) };
    const j_hat_yaw = Vec3f{ .x = 0, .y = 1, .z = 0 };
    const k_hat_yaw = Vec3f{ .x = -@sin(yaw), .y = 0, .z = @cos(yaw) };

    const i_hat_pitch = Vec3f{ .x = 1, .y = 0, .z = 1 };
    const j_hat_pitch = Vec3f{ .x = 0, .y = @cos(pitch), .z = -@sin(pitch) };
    const k_hat_pitch = Vec3f{ .x = 0, .y = @sin(pitch), .z = @cos(pitch) };

    return Basis{
        .i = transformVector(i_hat_yaw, j_hat_yaw, k_hat_yaw, i_hat_pitch),
        .j = transformVector(i_hat_yaw, j_hat_yaw, k_hat_yaw, j_hat_pitch),
        .k = transformVector(i_hat_yaw, j_hat_yaw, k_hat_yaw, k_hat_pitch),
    };
}

fn transformVector(
    i_hat: Vec3f,
    j_hat: Vec3f,
    k_hat: Vec3f,
    v: Vec3f,
) Vec3f {
    const x_move = Vec3f{
        .x = v.x * i_hat.x,
        .y = v.x * i_hat.y,
        .z = v.x * i_hat.z,
    };
    const y_move = Vec3f{
        .x = v.y * j_hat.x,
        .y = v.y * j_hat.y,
        .z = v.y * j_hat.z,
    };
    const z_move = Vec3f{
        .x = v.z * k_hat.x,
        .y = v.z * k_hat.y,
        .z = v.z * k_hat.z,
    };

    return Vec3f{
        .x = x_move.x + y_move.x + z_move.x,
        .y = x_move.y + y_move.y + z_move.y,
        .z = x_move.z + y_move.z + z_move.z,
    };
}
