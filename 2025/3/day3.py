import sys


def max_joltage(line: str, digits: int) -> int:
    def max_idx(subline: str) -> int:
        return max(range(len(subline)), key=lambda i: subline[i])

    indexes = []
    for i in range(digits):
        start = indexes[i - 1] + 1 if indexes else 0
        end = digits - i
        idx = max_idx(line[start : -(end - 1) or len(line)])
        indexes.append(idx + start)
    return int("".join(line[i] for i in indexes))


input = open(sys.argv[1]).read()
print(sum(max_joltage(line, 2) for line in input.splitlines()))
print(sum(max_joltage(line, 12) for line in input.splitlines()))
