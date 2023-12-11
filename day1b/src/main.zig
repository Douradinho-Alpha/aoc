const std = @import("std");
const print = std.debug.print;

const Nums = enum(i32) {
    one = 1,
    two,
    three,
    four,
    five,
    six,
    seven,
    eight,
    nine,
};

pub fn main() !void {
    var file = try std.fs.cwd().openFile("src/input", .{});
    defer file.close();
    var file_buffer = std.io.bufferedReader(file.reader());
    var in_stream = file_buffer.reader();
    var sum: i32 = 0;
    var left: i32 = 0;
    var right: i32 = 0;
    var buf: [1024]u8 = undefined;
    var count: i32 = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        count += 1;
        var i: usize = 0;
        left = 0;
        right = 0;
        while (i <= line.len) {
            left = std.fmt.parseInt(i32, line[i .. i + 1], 10) catch 0;

            if (left == 0) {
                find_right: for (3..6) |k| {
                    if ((i + k) <= line.len) {
                        const temp = std.meta.stringToEnum(Nums, line[i .. i + k]) orelse continue :find_right;
                        left = @intFromEnum(temp);
                    }
                }
            }
            if (left > 0) break;
            i += 1;
        }
        i = line.len - 1;
        while (i >= 0) {
            right = std.fmt.parseInt(i32, line[i .. i + 1], 10) catch 0;

            if (right == 0) {
                find_right: for (3..6) |k| {
                    if ((i + k) <= line.len) {
                        const temp = std.meta.stringToEnum(Nums, line[i .. i + k]) orelse continue :find_right;
                        right = @intFromEnum(temp);
                    }
                }
            }
            if (right > 0) break;
            i -= 1;
        }

        sum += (left * 10) + right;
        print("line: {d} | left: {d} | right: {d} | sum: {d}\n", .{ count, left, right, sum });
    }
    print("sum = {d}\n", .{sum});
}
