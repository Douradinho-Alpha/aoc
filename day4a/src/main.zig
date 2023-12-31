const std = @import("std");
const print = std.debug.print;
const file = @embedFile("input.txt");
const pow = std.math.pow;

pub fn main() !void {
    var sum: usize = 0;
    var it = std.mem.tokenizeAny(u8, file, "\n");
    while (it.next()) |line| {
        var dongs = std.mem.tokenizeAny(u8, line, ":");
        const game_id = std.mem.trimLeft(u8, dongs.next().?, "Game ");
        _ = game_id;
        var dings = std.mem.tokenizeAny(u8, dongs.next().?, "|");
        var raffle = std.mem.tokenizeAny(u8, dings.next().?, " ");
        var pool = std.mem.tokenizeAny(u8, dings.next().?, " ");
        var winnings: usize = 0;
        print("{s}\n", .{line});
        print("Found:", .{});
        while (raffle.next()) |tok1| {
            while (pool.next()) |tok2| {
                if (std.mem.eql(u8, tok1, tok2)) {
                    print("[{s},{s}] | ", .{ tok1, tok2 });
                    winnings += 1;
                }
            }
            pool.reset();
        }
        if (winnings > 0) {
            const points: usize = pow(usize, 2, winnings - 1);
            print("\nPoints: {d}\n", .{points});
            sum += points;
        }
    }
    print("{d}\n", .{sum});
}
