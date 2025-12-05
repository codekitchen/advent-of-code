from sys import stdin

rangelist, idlist = stdin.read().split("\n\n")
ranges = [
    range(int(lower), int(upper) + 1)
    for lower, upper in (line.split("-") for line in rangelist.splitlines())
]

ids = map(int, idlist.splitlines())
print("fresh id count:", sum(1 for id in ids if any(id in r for r in ranges)))

ranges.sort(key=lambda r: r.start)
consolidated = ranges[0:1]
for r in ranges[1:]:
    p = consolidated[-1]
    if r.start <= p.stop:
        consolidated[-1] = range(p.start, max(r.stop, p.stop))
    else:
        consolidated.append(r)

print("fresh range count:", sum(r.stop - r.start for r in consolidated))
