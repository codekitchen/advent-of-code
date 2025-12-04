import sys
import re

RX = re.compile(r"^(\d+)\1+$")

input = open(sys.argv[1]).read()
ranges = input.split(",")
total = 0
for r in ranges:
    lower, upper = map(int, r.split("-"))
    for n in range(lower, upper + 1):
        numstr = str(n)
        if RX.match(numstr):
            total += n

print(total)
