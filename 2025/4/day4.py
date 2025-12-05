from sys import stdin
from itertools import product, count

NEIGHBORS = frozenset(product([-1, 0, 1], repeat=2)) - {(0, 0)}
grid = {
    (x, y)
    for y, line in enumerate(stdin.readlines())
    for x, char in enumerate(line)
    if char == "@"
}

print("round\tremoved\ttotal")
round, total = count(1), 0
while accessible := {
    (x, y)
    for (x, y) in grid
    if len(grid & {(dx + x, dy + y) for dx, dy in NEIGHBORS}) < 4
}:
    grid -= accessible
    total += len(accessible)
    print(f"{next(round)}\t{len(accessible)}\t{total}")
