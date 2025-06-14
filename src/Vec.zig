pub fn Vec(comptime T: type, comptime N: usize) type {
    return switch (N) {
        2 => struct {
            x: T,
            y: T,

            pub fn length(self: @This()) T {
                return @sqrt(self.x * self.x + self.y * self.y);
            }

            pub fn dot(self: @This(), other: @This()) T {
                return self.x * other.x + self.y * other.y;
            }
        },
        3 => struct {
            x: T,
            y: T,
            z: T,

            pub fn length(self: @This()) T {
                return @sqrt(self.x * self.x + self.y * self.y + self.z * self.z);
            }

            pub fn dot(self: @This(), other: @This()) T {
                return self.x * other.x + self.y * other.y + self.z * other.z;
            }
        },
        4 => struct {
            x: T,
            y: T,
            z: T,
            w: T,

            pub fn length(self: @This()) T {
                return @sqrt(self.x * self.x + self.y * self.y + self.z * self.z + self.w * self.w);
            }

            pub fn dot(self: @This(), other: @This()) T {
                return self.x * other.x + self.y * other.y + self.z * other.z + self.w * other.w;
            }
        },
        else => struct {
            data: [N]T,

            pub fn length(self: @This()) T {
                var sum: T = 0;
                for (self.data) |v| {
                    sum += v * v;
                }
                return @sqrt(sum);
            }

            pub fn dot(self: @This(), other: @This()) T {
                var sum: T = 0;
                for (self.data, other.data) |v1, v2| {
                    sum += v1 * v2;
                }
                return sum;
            }
        },
    };
}
