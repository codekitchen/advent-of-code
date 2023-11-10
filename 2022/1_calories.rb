elves = ARGF.slice_after("\n")
cals = elves.map{_1.sum(&:to_i)}.max(3)
p cals[0]
p cals.sum
