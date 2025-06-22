const Vec2f = @import("types.zig").Vec2f;
const Vec3f = @import("types.zig").Vec3f;
const CameraOptions = @import("types.zig").CameraOptions;

const Basis = struct {
    i: Vec3f,
    j: Vec3f,
    k: Vec3f,
};

pub fn vec3fToVec2f(
    vec3f: Vec3f,
    comptime width: usize,
    comptime height: usize,
    camera_options: CameraOptions,
) Vec2f {
    const vec3f_world = toWorldPoint(vec3f, camera_options);

    const screen_height: f32 = 20.0;
    const pixels_per_unit: f32 = height / screen_height;

    const pixel_offset = Vec2f{
        .x = vec3f_world.x * pixels_per_unit,
        .y = vec3f_world.y * pixels_per_unit,
    };
    return Vec2f{
        .x = pixel_offset.x + width / 2,
        .y = -pixel_offset.y + height / 2,
    };
}

pub fn toWorldPoint(p: Vec3f, camera_options: CameraOptions) Vec3f {
    const basis = getBasisVectors(camera_options.yaw);
    return transformVector(
        basis.i,
        basis.j,
        basis.k,
        p,
    );
}

/// calculates (i, j, k) basis vectors
fn getBasisVectors(yaw: f32) Basis {
    const i_hat = Vec3f{ .x = @cos(yaw), .y = 0, .z = @sin(yaw) };
    const j_hat = Vec3f{ .x = 0, .y = 1, .z = 0 };
    const k_hat = Vec3f{ .x = -@sin(yaw), .y = 0, .z = @cos(yaw) };

    return Basis{
        .i = i_hat,
        .j = j_hat,
        .k = k_hat,
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
