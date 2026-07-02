const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const cwd = std.fs.cwd().realpathAlloc(allocator, ".") catch "?";
    defer allocator.free(cwd);

    var args_list = std.ArrayList(u8).init(allocator);
    defer args_list.deinit();

    const writer = args_list.writer();
    for (std.os.argv[1..], 0..) |arg, i| {
        if (i > 0) try writer.writeAll(", ");
        try writer.print("\"{s}\"", .{std.mem.span(arg)});
    }
    const args = args_list.items;

    const stdout = std.io.getStdOut().writer();
    try stdout.writeAll("\n");
    try stdout.writeAll("  Welcome to use `run.sh` / `run.ps1`\n");
    try stdout.writeAll("\n");
    try stdout.writeAll("  > \"Hello World\"\n");
    try stdout.print("  > cwd  : \"{s}\"\n", .{cwd});
    try stdout.print("  > args : {s}\n", .{args});
    try stdout.writeAll("\n");
}
