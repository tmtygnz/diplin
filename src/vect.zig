const std = @import("std");

pub fn Vect3(comptime T: type) type {
    return struct {
        data: @Vector(3, T),

        const Self = @This();

        pub inline fn X(self: Self) T {
            return self.data[0];
        }

        pub inline fn Y(self: Self) T {
            return self.data[1];
        }

        pub inline fn Z(self: Self) T {
            return self.data[2];
        }

        pub inline fn init(x: T, y: T, z: T) Self {
            return .{ .data = .{ x, y, z } };
        }

        pub inline fn add(self: Self, toadd: Self) Self {
            return .{ .data = self.data + toadd.data };
        }

        pub inline fn subtract(self: Self, tosub: Self) Self {
            return .{ .data = self.data - tosub.data };
        }

        pub inline fn scale(self: Self, s: T) Self {
            return .{ .data = .{ self.X() * s, self.Y() * s, self.Z() * s } };
        }

        pub inline fn neg(self: Self) Self {
            return .{ .data = -self.data };
        }

        pub inline fn dot(self: Self, d: Self) T {
            return self.X() * d.X() + self.Y() * d.Y() + self.Z() * d.Z();
        }

        pub inline fn lsquared(self: Self) T {
            return self.dot(self);
        }

        pub inline fn length(self: Self) T {
            return std.math.sqrt(self.lsquared());
        }
    };
}
