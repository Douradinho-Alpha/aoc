const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    var file = try std.fs.cwd().openFile("src/input", .{});
    defer file.close();
    var file_buffer = std.io.bufferedReader(file.reader());
    var in_stream = file_buffer.reader();
    var sum: i32 = 0;
    var left: i32 = undefined;
    var right: i32 = undefined;
    var buf: [1024]u8 = undefined;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var line_len = line.len;
        var i: usize = 0;
        var temp: i32 = undefined;

        read_left: while (i < line_len) {
            temp = std.fmt.parseInt(i32, line[i .. i + 1], 10) catch {
                i += 1;
                continue :read_left;
            };
            i += 1;
            left = temp;
            break;
        }

        read_right: while (line_len >= 0) {
            temp = std.fmt.parseInt(i32, line[line_len - 1 .. line_len], 10) catch {
                line_len -= 1;
                continue :read_right;
            };
            line_len -= 1;
            right = temp;
            break;
        }
        sum += (left * 10) + right;
        print("sum = {d}\n", .{sum});
    }
}
