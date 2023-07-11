const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // zigstr library
    const zigstr = b.addModule("zigstr", .{
        .source_file = .{ .path = "./lib/zigstr/lib/str.zig" },
    });

    // hasm executable
    const elf = b.addExecutable(.{
        .name = "hasm",
        .root_source_file = .{ .path = "./src/hasm.zig" },
        .target = target,
        .optimize = optimize,
    });

    elf.addModule("zigstr", zigstr);

    // install
    b.installArtifact(elf);

    const run_cmd = b.addRunArtifact(elf);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    // run command
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
