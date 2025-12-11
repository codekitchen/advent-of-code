from dataclasses import dataclass
from sys import stdin
from itertools import combinations


@dataclass
class Rect:
    x: int
    y: int
    x2: int
    y2: int
    w: int
    h: int
    area: int

    def __init__(self, a, b):
        self.x = min(a[0], b[0])
        self.y = min(a[1], b[1])
        self.w = max(a[0], b[0]) - self.x + 1
        self.h = max(a[1], b[1]) - self.y + 1
        self.x2 = self.x + self.w - 1
        self.y2 = self.y + self.h - 1
        self.area = self.w * self.h

    def intersect(self, line):
        tl = (self.x + 1, self.y + 1)
        tr = (self.x2 - 1, self.y + 1)
        bl = (self.x + 1, self.y2 - 1)
        br = (self.x2 - 1, self.y2 - 1)
        l1, l2 = line
        return (
            line_line(*tl, *bl, *l1, *l2)
            or line_line(*tl, *tr, *l1, *l2)
            or line_line(*tr, *br, *l1, *l2)
            or line_line(*bl, *br, *l1, *l2)
            or (tl[0] <= l1[0] <= tr[0] and tl[1] <= l1[1] <= bl[1])
            or (tl[0] <= l2[0] <= tr[0] and tl[1] <= l2[1] <= bl[1])
        )


def line_line(x1, y1, x2, y2, x3, y3, x4, y4):
    try:
        uA = ((x4 - x3) * (y1 - y3) - (y4 - y3) * (x1 - x3)) / (
            (y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1)
        )
        uB = ((x2 - x1) * (y1 - y3) - (y2 - y1) * (x1 - x3)) / (
            (y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1)
        )
        return uA >= 0 and uA <= 1 and uB >= 0 and uB <= 1
    except ZeroDivisionError:
        return False


tiles = [tuple(int(n) for n in line.split(",")) for line in stdin.readlines()]
rects = [Rect(a, b) for a, b in combinations(tiles, 2)]
lines = [(t1, t2) for t1, t2 in zip(tiles, tiles[1:] + tiles[:1])]
print("pt1:", max(rects, key=lambda rect: rect.area))

valid = [rect for rect in rects if not any(rect.intersect(line) for line in lines)]
print("pt2:", max(valid, key=lambda rect: rect.area))
