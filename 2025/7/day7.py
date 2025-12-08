from sys import stdin
from collections import defaultdict

input = stdin.readlines()
splits = 0
cols = {input[0].index("S")}
for row in input[1:]:
    cols2 = set()
    for col in cols:
        if row[col] == "^":
            splits += 1
            cols2 |= {col - 1, col + 1}
        else:
            cols2.add(col)
    cols = cols2

print("pt1:", splits)

cols = defaultdict(int, {input[0].index("S"): 1})
for row in input[1:]:
    cols2 = defaultdict(int)
    for col, n in cols.items():
        if row[col] == "^":
            cols2[col - 1] += n
            cols2[col + 1] += n
        else:
            cols2[col] += n
    cols = cols2

print("pt2:", sum(cols.values()))
