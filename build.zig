const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const shared = b.option(
        bool,
        "shared",
        "Build wd4c as a shared library",
    ) orelse false;

    const lib = if (shared)
        b.addSharedLibrary(.{
            .name = "md4c",
            .target = target,
            .optimize = optimize,
            .version = .{ .major = 0, .minor = 4, .patch = 9 },
        })
    else
        b.addStaticLibrary(.{
            .name = "md4c",
            .target = target,
            .optimize = optimize,
        });

    lib.defineCMacro("MD4C_USE_UTF8", "");
    lib.addCSourceFiles(.{
        .files = &md4c_sources,
        .flags = &md4c_flags,
    });
    lib.linkLibC();
    lib.installHeader("src/md4c.h", "md4c.h");

    b.installArtifact(lib);
}

const md4c_flags = [_][]const u8{
    "-Wall",
};

const md4c_sources = [_][]const u8{
    "src/md4c.c",
};
