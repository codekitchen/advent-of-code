from sys import stdin

for i, line in enumerate(stdin.readlines()):
    parts = line.split(" ")
    lights = parts.pop(0)[1:-1]
    print(f"% [{lights}]")
    print(f"line({i},light(0..{len(lights)})).")
    for j, light in enumerate(lights):
        print(f":- part(1),{'not ' if light == '#' else ''}line({i},lit({j})).")
    joltages = parts.pop(-1)[1:-2].split(",")
    for b, bstr in enumerate(parts):
        print(f"line({i},button({b},({';'.join(bstr[1:-1].split(','))}))).")
    print(f"% {'{' + ','.join(joltages) + '}'}")
    print(f"line({i},jolt(0..{len(joltages)})).")
    for j, jolt in enumerate(joltages):
        print(f":- part(2),line({i},jolt({j},N)),N!={jolt}.")
    print()
