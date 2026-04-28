const diplin = @import("vect.zig");
const std = @import("std");

pub fn Quaternion(comptime T: type) type {
    return struct {
        w: T,
        v: diplin.Vect3(T),

        const Self = @This();

        pub fn X(self: Self) T {
            return self.v.X();
        }

        pub fn Y(self: Self) T {
            return self.v.Y();
        }

        pub fn Z(self: Self) T {
            return self.v.Z();
        }

        pub inline fn from_axis_angle(axis: diplin.Vect3(T), angle: T) Self {
            const half_angle = angle * @as(T, 0.5);
            const s = @sin(half_angle);
            const c = @cos(half_angle);
            return .{
                .w = c,
                .v = axis.scale(s),
            };
        }

        pub inline fn mul(a: Self, b: Self) Self {
            return .{
                .w = a.w * b.w - a.v.dot(b.v),
                .v = b.v.scale(a.w).add(a.v.scale(b.w)).add(a.v.cross(b.v)),
            };
        }

        pub fn rotate(self: Self, axis: diplin.Vect3(T), angle: T) Self {
            const delta = Self.from_axis_angle(axis, angle);
            return self.mul(delta);
        }
    };
}

test "identity quaternion" {
    const Q = Quaternion(f32);

    const q = Q{
        .w = 1,
        .v = diplin.Vect3(f32).init(0, 0, 0),
    };

    try std.testing.expectApproxEqAbs(q.w, 1, 1e-6);
    try std.testing.expectApproxEqAbs(q.X(), 0, 1e-6);
    try std.testing.expectApproxEqAbs(q.Y(), 0, 1e-6);
    try std.testing.expectApproxEqAbs(q.Z(), 0, 1e-6);
}

test "from_axis_angle X 90 degrees" {
    const Q = Quaternion(f32);
    const axis = diplin.Vect3(f32).init(1, 0, 0);

    const q = Q.from_axis_angle(axis, std.math.pi / 2.0);

    try std.testing.expectApproxEqAbs(q.w, 0.7071, 1e-3);
    try std.testing.expectApproxEqAbs(q.X(), 0.7071, 1e-3);
    try std.testing.expectApproxEqAbs(q.Y(), 0.0, 1e-6);
    try std.testing.expectApproxEqAbs(q.Z(), 0.0, 1e-6);
}
