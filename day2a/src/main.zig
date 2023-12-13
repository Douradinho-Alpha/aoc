const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    var file = try std.fs.cwd().openFile("src/input.txt", .{});

    var file_buffer = std.io.bufferedReader(file.reader());
    var in_stream = file_buffer.reader();
    var buf: [1024]u8 = undefined;
    var sum: u32 = 0;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var id: u32 = 0;
        var last_i: u32 = 0;
        for (0..4) |i| {
            var temp = std.fmt.parseInt(u32, line[i + 5 .. i + 6], 10) catch break;
            id = id * 10 + temp;
            last_i = @intCast(i + 6 + 1);
        }
        var blue: u32 = 0;
        var green: u32 = 0;
        var red: u32 = 0;
        var it = std.mem.tokenizeAny(u8, line[last_i..], ";");

        while (it.next()) |pre_token| {
            var it2 = std.mem.tokenizeAny(u8, pre_token, ",");
            while (it2.next()) |token| {
                var it3 = std.mem.tokenizeAny(u8, token, " ");
                const num: u32 = std.fmt.parseInt(u32, it3.next().?, 10) catch break;

                const color = it3.next() orelse break;
                if (std.mem.eql(u8, "blue", color)) {
                    if (num > blue) blue = num;
                }
                if (std.mem.eql(u8, "green", color)) {
                    if (num > green) green = num;
                }
                if (std.mem.eql(u8, "red", color)) {
                    if (num > red) red = num;
                }
            }
        }
        if (red <= 12 and green <= 13 and blue <= 14) {
            sum += id;
        }
    }

    print("{d}\n", .{sum});
}
