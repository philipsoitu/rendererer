const std = @import("std");

// comptime is cool!
pub fn Vec(comptime T: type, N: usize) type {
    return switch (N) {
        2 => struct {
            x: T,
            y: T,
        },
        3 => struct {
            x: T,
            y: T,
            z: T,
        },
        else => struct {
            data: [N]T,
        },
    };
}
