from sys import stdin
from itertools import combinations
from functools import reduce
from math import dist
from operator import mul

boxes = [tuple(int(n) for n in line.split(",")) for line in stdin.readlines()]
pairs = sorted((dist(a, b), a, b) for a, b in combinations(boxes, 2))
firstn = 10 if len(boxes) < 30 else 1000  # example vs full
circuits: list[set] = []


def circuit_for(circuits, box):
    for idx, c in enumerate(circuits):
        if box in c:
            return idx


def add(circuits, a, b):
    circuita = circuit_for(circuits, a)
    circuitb = circuit_for(circuits, b)
    if circuita is not None and circuitb is not None:
        if circuita != circuitb:
            circuits[circuita] |= circuits[circuitb]
            circuits.pop(circuitb)
    elif circuita is not None:
        circuits[circuita].add(b)
    elif circuitb is not None:
        circuits[circuitb].add(a)
    else:
        circuits.append({a, b})


for _, a, b in pairs[0:firstn]:
    add(circuits, a, b)

sizes = sorted((len(c) for c in circuits), reverse=True)
print("pt1:", reduce(mul, sizes[0:3]))

for _, a, b in pairs[firstn:]:
    add(circuits, a, b)
    if len(circuits[0]) == len(boxes):
        print("pt2:", a[0] * b[0])
        break
