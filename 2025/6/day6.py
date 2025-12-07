# make sure to save the input without stripping trailing newlines!
from functools import reduce
from itertools import groupby
from sys import stdin
from operator import add, mul


def transpose(rows):
    return list(zip(*rows))


def split(xs, sep):
    return (g for k, g in groupby(xs, lambda x: x == sep) if not k)


raw = [line.strip("\n") for line in stdin.readlines()]
opers = [add if op == "+" else mul for op in raw[-1].split()]
lines = raw[:-1]

pt1 = transpose(line.split() for line in lines)  # split by whitspace
print("pt1:", sum(reduce(op, map(int, nums)) for op, nums in zip(opers, pt1)))

chars = transpose(list(line) for line in lines)  # split char-by-char
numbers = ("".join(digits).strip() for digits in chars)  # read numbers top-to-bottom
pt2 = split(numbers, "")
print("pt2:", sum(reduce(op, map(int, nums)) for op, nums in zip(opers, pt2)))
