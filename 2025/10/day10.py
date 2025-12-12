from sys import stdin
from z3 import Optimize, Ints, sat
from functools import reduce

pt1 = 0
pt2 = 0
for i, line in enumerate(stdin.readlines()):
    opt1, opt2 = Optimize(), Optimize()
    parts = line.split(" ")
    lights = parts.pop(0)[1:-1]  # ".#.#"
    joltages = map(int, parts.pop(-1)[1:-2].split(","))  # {1,3,2,...}
    goals = [1 if light == "#" else 0 for light in lights]

    # a, b, c, ...
    buttons = Ints(" ".join(f"b{i}" for i in range(len(parts))))
    for b in buttons:
        opt1.add(b >= 0)
        opt2.add(b >= 0)
    # a+c+e
    eqs1 = [0] * len(lights)
    eqs2 = [0] * len(lights)
    for b, bstr in enumerate(parts):
        targets = map(int, bstr[1:-1].split(","))
        for t in targets:
            eqs1[t] += buttons[b]
            eqs2[t] += buttons[b]

    for eq, goal, j in zip(eqs1, goals, joltages):
        c = eq % 2 == goal
        opt1.add(c)
        opt2.add(eq == j)

    total = reduce(lambda a, b: a + b, buttons)
    opt1.add(total >= 0)
    opt2.add(total >= 0)
    h = opt1.minimize(total)
    if opt1.check() == sat:
        model = opt1.model()
        val = sum(model[b].py_value() for b in buttons)
        pt1 += val
    else:
        raise "failed"
    h = opt2.minimize(total)
    if opt2.check() == sat:
        model = opt2.model()
        val = sum(model[b].py_value() for b in buttons)
        pt2 += val
    else:
        raise "failed"

print(f"Part 1: {pt1}")
print(f"Part 2: {pt2}")
