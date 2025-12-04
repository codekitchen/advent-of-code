import sys


input = open(sys.argv[1]).read()
ranges = input.split(",")
total = 0
for r in ranges:
    lower, upper = map(int, r.split("-"))
    for n in range(lower, upper + 1):
        numstr = str(n)
        if len(numstr) % 2 == 0:
            mid = len(numstr) // 2
            left, right = numstr[:mid], numstr[mid:]
            if left == right:
                total += n

print(total)
