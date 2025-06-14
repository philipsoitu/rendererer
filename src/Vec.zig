pub fn Vec(comptime T: type, comptime N: usize) type {
    return struct {
        data: [N]T,

        pub fn x(self: @This()) T {
            comptime if (N >= 1) {
                return self.data[0];
            } else {
                @compileError("Vec.x is not available for N < 1");
            };
        }

        pub fn y(self: @This()) T {
            comptime if (N >= 2) {
                return self.data[1];
            } else {
                @compileError("Vec.y is not available for N < 2");
            };
        }

        pub fn z(self: @This()) T {
            comptime if (N >= 3) {
                return self.data[2];
            } else {
                @compileError("Vec.z is not available for N < 3");
            };
        }

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
    };
}
