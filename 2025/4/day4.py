import itertools
import sys


input = open(sys.argv[1]).read()
lines = input.splitlines()
w, h = len(lines[0]), len(lines)
grid = {
    (x, y) for y, line in enumerate(lines) for x, char in enumerate(line) if char == "@"
}


def get_accessible(grid):
    accessible = set()
    for y in range(h):
        for x in range(w):
            if (x, y) in grid:
                neighbors = 0
                for dx, dy in itertools.product([-1, 0, 1], repeat=2):
                    if dx == 0 and dy == 0:
                        continue
                    if (x + dx, y + dy) in grid:
                        neighbors += 1
                if neighbors < 4:
                    accessible.add((x, y))
    return accessible


accessible = get_accessible(grid)
print("accessible on first pass:", len(accessible))

removed = 0
passes = 0
while accessible:
    passes += 1
    removed += len(accessible)
    grid -= accessible
    accessible = get_accessible(grid)
print("total removed:", removed, "in", passes, "passes")
