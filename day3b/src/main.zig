const std = @import("std");
const print = std.debug.print;
const parseInt = std.fmt.parseInt;
const text = @embedFile("input.txt");
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const alloc = gpa.allocator();

const Number = struct {
    line: usize,
    column: usize,
    value: []const u8,
    found: bool,

    pub fn init(line: usize, column: usize, value: []const u8) Number {
        return Number{
            .line = line,
            .column = column,
            .value = value,
            .found = false,
        };
    }
};

const Symbol = struct {
    line: usize,
    column: usize,
    pub fn init(line: usize, column: usize) Symbol {
        return Symbol{
            .line = line,
            .column = column,
        };
    }
};
var symbols = std.ArrayList(Symbol).init(alloc);
var numbers = std.ArrayList(Number).init(alloc);

pub fn main() !void {
    var text_it = std.mem.tokenizeAny(u8, text, "\n");

    var sum: usize = 0;
    var line_count: usize = 0;
    while (text_it.next()) |line| : (line_count += 1) {
        var num_temp = std.ArrayList(u8).init(alloc);
        for (0..line.len) |i| {
            if (line[i] > 47 and line[i] < 58) {
                try num_temp.append(line[i]);
            } else if (line[i] == '.') {
                if (num_temp.items.len > 0) {
                    const temp = try alloc.alloc(u8, num_temp.items.len);
                    @memcpy(temp, num_temp.items);
                    var numbah = Number.init(line_count, i - temp.len, temp);
                    try numbers.append(numbah);
                    while (num_temp.getLastOrNull() != null) {
                        _ = num_temp.pop();
                    }
                }
            } else if (line[i] == '*') {
                const symbol = Symbol.init(line_count, i);
                try symbols.append(symbol);
                if (num_temp.items.len > 0) {
                    const temp = try alloc.alloc(u8, num_temp.items.len);
                    @memcpy(temp, num_temp.items);
                    var numbah = Number.init(line_count, i - temp.len, temp);
                    try numbers.append(numbah);
                    while (num_temp.getLastOrNull() != null) {
                        _ = num_temp.pop();
                    }
                }
            }
            if (i == line.len and num_temp.items.len > 0) {
                print("{s}\n", .{num_temp.items});
                const temp = try alloc.alloc(u8, num_temp.items.len);
                @memcpy(temp, num_temp.items);
                var numbah = Number.init(line_count, i - temp.len, temp);
                try numbers.append(numbah);
                while (num_temp.getLastOrNull() != null) {
                    _ = num_temp.pop();
                }
            }
        }
        if (num_temp.items.len > 0) {
            const temp = try alloc.alloc(u8, num_temp.items.len);
            @memcpy(temp, num_temp.items);
            var numbah = Number.init(line_count, line.len - temp.len, temp);
            try numbers.append(numbah);
            while (num_temp.getLastOrNull() != null) {
                _ = num_temp.pop();
            }
        }
        num_temp.deinit();
    }

    for (symbols.items) |sym| {
        var nums = std.ArrayList(usize).init(alloc);
        num_loop: for (numbers.items, 0..numbers.items.len) |num, i| {
            if (!num.found and (num.line + 1 >= sym.line and num.line <= sym.line + 1)) {
                if (num.column == sym.column or num.column + 1 == sym.column or num.column == sym.column + 1) {
                    const temp = parseInt(usize, num.value, 10) catch 0;
                    numbers.items[i].found = true;
                    try nums.append(temp);
                    continue :num_loop;
                }
                if (num.column < sym.column and num.column + num.value.len >= sym.column) {
                    const temp = parseInt(usize, num.value, 10) catch 0;
                    numbers.items[i].found = true;
                    try nums.append(temp);
                    continue :num_loop;
                }
            }
        }
        if (nums.items.len == 2) {
            sum += nums.items[0] * nums.items[1];
        }
        while (nums.getLastOrNull() != null) {
            _ = nums.pop();
        }
    }

    print("{d}\n", .{sum});
}
