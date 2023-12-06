#!/usr/bin/env ruby --yjit
###
# impl
###

def part1(input)
  races = input.lines.map { _1.split[1..].map(&:to_i) }.transpose
  races
    .map { |t,rec| (0..t).count { |hold| hold * (t - hold) > rec } }
    .reduce(:*)
end

def part2(input)
  time, rec = input.lines.map { _1.split(":").last.gsub(/\s+/, '').to_i }
  (0..time).count { |hold| hold * (time - hold) > rec }
end

###
# data and runner
###

SHORT = %{Time:      7  15   30
Distance:  9  40  200}
FULL = DATA.read

puts "part1 short", (part1 SHORT).inspect
puts "part1 full", (part1 FULL).inspect
puts "part2 short", (part2 SHORT).inspect
puts "part2 full", (part2 FULL).inspect

__END__
Time:        58     81     96     76
Distance:   434   1041   2219   1218
