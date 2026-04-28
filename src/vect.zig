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

        pub inline fn div(self: Self, divr: Self) Self {
            return .{
                .data = self.data / divr.data,
            };
        }

        pub fn cross(self: Self, other: Self) Self {
            return .{
                .data = .{
                    self.Y() * other.Z() - self.Z() * other.Y(),
                    self.Z() * other.X() - self.X() * other.Z(),
                    self.X() * other.Y() - self.Y() * other.X(),
                },
            };
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

        pub fn normalize(self: Self) Self {
            const l = self.length();
            if (l == 0) return self;
            const inv_l = @as(T, 1.0) / l;
            return self.scale(inv_l);
        }

        pub fn distanceSq(self: Self, other: Self) T {
            return self.subtract(other).lsquared();
        }

        pub fn distance(self: Self, other: Self) T {
            return std.math.sqrt(self.distanceSq(other));
        }
    };
}
