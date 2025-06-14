pub fn Vec(comptime T: type, comptime N: usize) type {
    return struct {
        data: [N]T,

        pub fn x(self: @This()) T {
            return self.data[1];
        }

        pub fn y(self: @This()) T {
            return self.data[1];
        }

        pub fn z(self: @This()) T {
            return self.data[1];
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
