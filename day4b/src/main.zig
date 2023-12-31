const std = @import("std");
const print = std.debug.print;
const file_path = "input.txt";
const file = @embedFile(file_path);
const pow = std.math.pow;
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const alloc = gpa.allocator();

pub fn main() !void {
    var timer = try std.time.Timer.start();
    var start = timer.read();
    var table = [_]usize{0} ** 196;
    var extras = [_]usize{1} ** 196;
    var sum: usize = 0;
    var it = std.mem.tokenizeAny(u8, file, "\n");
    var scratchies: usize = 0;
    var game_counter: usize = 0;

    while (it.next()) |line| : (game_counter += 1) {
        var dongs = std.mem.tokenizeAny(u8, line, ":");
        _ = std.mem.trimLeft(u8, dongs.next().?, "Game ");
        var dings = std.mem.tokenizeAny(u8, dongs.next().?, "|");
        var raffle = std.mem.tokenizeAny(u8, dings.next().?, " ");
        var pool = std.mem.tokenizeAny(u8, dings.next().?, " ");
        var winnings: usize = 0;
        while (raffle.next()) |tok1| {
            while (pool.next()) |tok2| {
                if (std.mem.eql(u8, tok1, tok2)) {
                    winnings += 1;
                }
            }
            pool.reset();
        }
        if (winnings > 0) {
            table[game_counter] = winnings;
        }
        for (0..winnings) |i| {
            extras[game_counter + 1 + i] += extras[game_counter];
        }
    }
    for (extras) |ding| scratchies += ding;

    print("{d}\n", .{table});
    print("{d}\n", .{extras});
    var elapsed_s = @as(f64, @floatFromInt(timer.read() - start)) / std.time.ns_per_s;
    print("{d} | {d} TIME:{d}\n", .{ scratchies, sum, elapsed_s });
}
