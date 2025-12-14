from sys import stdin


def parse():
    stdin.readline()
    shape = [stdin.readline().strip() for _ in range(3)]
    stdin.readline()
    return shape


shapes = [parse() for _ in range(6)]
shape_counts = [sum(line.count("#") for line in shape) for shape in shapes]
print("counts", shape_counts)

fits = []
way_big = []
puzzles = []
impossible = []
while puz := stdin.readline():
    size, counts = puz.strip().split(": ")
    w, h = map(int, size.split("x"))
    counts = list(map(int, counts.split(" ")))
    total_count = sum(counts)
    puzzles.append((w, h, counts))
    total_shape_pieces = sum(a * b for a, b in zip(shape_counts, counts))
    if total_shape_pieces < w * h:
        fits.append((w, h, counts))
    else:
        impossible.append((w, h, counts))
    if total_count * 9 <= w * h:
        way_big.append((w, h, counts))

print("puz:", len(puzzles))
# fits == way_big!! evil
print("fits:", len(fits))
print("way big:", len(way_big))
print("impossible:", len(impossible))

sizes = {tuple(sorted((w, h))) for (w, h, _) in fits}
print("distinct sizes:", len(sizes))
sample = list(sizes)[0]
print(
    "puzzles with",
    sample,
    [(w, h, c) for (w, h, c) in fits if (w, h) == sample or (h, w) == sample],
)
sizes = {(w, h) for (w, h, _) in fits}
print("distinct sizes without sort:", len(sizes))
