#!/usr/bin/env ruby --yjit

###
# impl
###
require_relative './../utils'

def unfold(row, nums, n=5) = [([row]*n).join('?'), nums.cycle(n).to_a]
assert_eq unfold('.#', [1], 5), ['.#?.#?.#?.#?.#', [1,1,1,1,1]]

def parse_count(str, nums, memo={})
  n = nums[0] || 0
  memo[[str, nums]] ||= case str
  when nil, ''
    nums.empty? ? 1 : 0
  when /^[.]/
    # blank, just skip
    parse_count(str[1..], nums, memo)
  when /^[?][#?]{#{n-1}}(?![#])/
    # leading ?, so go both ways
    # take this parse
    parse_count(str[n+1..], nums[1..], memo) +
    # skip this parse
    parse_count(str[1..], nums, memo)
  when /^[#][#?]{#{n-1}}(?![#])/
    # leading #, take this parse
    parse_count(str[n+1..], nums[1..], memo)
  when /^[#]/
    # leading # but no parse, no solution
    0
  else # leading ? but no parse
    # skip this parse
    parse_count(str[1..], nums, memo)
  end
end

def parse(line)
  field, nums = line.split(' ')
  nums = nums.split(',').map(&:to_i)
  [field, nums]
end

def part1(input)
  input.lines.sum { |l| parse_count(*parse(l)) }
end

def part2(input)
  input.lines.sum { |l| parse_count(*unfold(*parse(l))) }
end

###
# data and runner
###

SHORT = %{???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1}
FULL = DATA.read

puts "part1 short", (part1 SHORT).inspect
puts "part1 full", (part1 FULL).inspect
puts "part2 short", (part2 SHORT).inspect
puts "part2 full", (part2 FULL).inspect

__END__
.???##?????????#?.?? 1,12
#####??.?????? 7,1
#.???#???.#? 1,2,1,1
?#???#?..???# 2,1,1,1
?#..???.#?.?.. 1,2,2,1
?#?????#?#??#?????# 2,1,8,1,1
?#???????? 1,4,1
#???#??#?##.???? 1,1,7,1,1
?#?.#???#?###??? 2,3,8
.??#????#. 3,1
??#.??#??#?? 1,1,2,1
?#??#?#??.?.#.#?? 8,1,1,3
????###??#.???#..?? 7,3,1
.##????.?? 3,2,1
#.#???#?##??.????.? 1,2,7,1,2
.#?.??#?????.??.?? 2,8,1
#???..?.?. 3,1
????#?#???..??? 1,6
?????#???.??.???? 6,1,1,1,2
?..?.#????#?###?#? 1,1,1,10
.#??#?????#. 4,5
.?????????. 1,4
.??.?.#?#??. 1,4
??##???.#???#??.? 5,3,2,1
?#????#??.? 1,4,1
#??#.??###???. 4,5,1
?#?.#??.???# 3,2,3
?#??.???#??? 1,1,5
???.#????.? 2,4,1
???#?.#??#???#?.?# 1,1,1,1,3,1
???.#???.?#???? 1,1,3,2,1
.#??##????. 5,2
?????#???????.??? 3,4,1,1,3
?...???####????#? 1,13
.?##?#????????#???. 6,6
???.?#???? 2,3,1
.????????#???? 5,3,1
..?#??..??.?? 4,1,1
.?#???.?#? 2,1,1
#??..???????#? 2,1,5
??#????..??.???. 3,1,1,1
..#??.????? 3,3
.#?????#?..?.#?? 2,1,3,1,1
##???..????? 4,2
???????????#.? 1,5
.#?#???????#???? 3,1,5,1,1
?????#?????. 2,2,1
?.?????###?? 2,4
???????#???#?????? 1,1,7,1,1
?#????##?????????? 9,1,1,1
???????.??#????#? 6,2,1,1
?#???..??????? 4,3,1
.#?????#?# 4,4
???????.???????. 2,3,2,3
????#?#????????.??# 12,1,1,1
.##..?.?##?#?.?.# 2,4,1,1
#?##??#??.# 8,1
?????.??#????? 1,1,6
??.?..?#?.??. 1,2,2
????#??..????? 2,1
?.#???##???.? 1,1,2,1
????????#?? 1,1,4
?#???.??###????.? 4,5,1
??.?.??#?#.???#???? 1,1,1,3,6,1
.???#????????? 1,7
?###????#?????.?#. 4,8,2
?#?????????? 8,1
?.#?#???###?.???? 1,8,1
????#?.#???????.?? 1,8
#????????.?#??# 2,1,1,2,1
?.??.??#..?#.??? 1,1,2,2,2
?????.#??.?? 1,3
##??.?###????? 4,7
?.?#?###??? 1,2,3
.?????.???#? 2,4
.??#.?##???#?? 1,5,1
?##.??#????#???????# 3,5,1,1,1,2
#??#???#.???###???? 1,1,2,5,1,1
??.??.?????##?.?? 1,1,5,2
.#??.??#???##?#.?#? 1,1,2,2,1,2
??????####??##..?? 14,1
????.??#?????#??... 1,1,6,1,1
??#?.??.#.. 3,1
.#?#????????.. 5,4
???#?????#??#? 2,7
????#?????#?#??#.? 8,1,1,1,1
?#?????##.?????????? 9,1,1,1
?#????.??#?#.??.# 1,1,5,1,1
?????#?..? 1,3
?.???#?#????##? 8,3
???..?..??#?.#??##?. 2,1,4,6
?###??.?#?#?????? 5,4,2
?..##???????????? 4,5
.??#.????????#..???? 1,6
?###??????.????? 10,3
?.#.??.?????#..??. 1,2,2,1,1,1
??#???????#.# 8,1,1
??.#?...?#????? 1,1,2,4
.??????#????? 8,2
?#?#??..??.??# 3,1,3
.?????.????. 1,2
?????..??????? 1,2,3,1
..#?.??#.##??#??? 1,1,1,6
????.?.?..? 2,1,1
.#???.??.??? 1,1,1,1
?.???#..??????? 1,3,6
.?#.??..?? 1,1,1
????????.#? 3,1
???#?????? 1,2,2
???#####???#?.?#.??. 12,1
????..??.? 2,1
.???????.???? 3,1,2,1
??#?#???#??#??.???. 8,1,1,3
?????###.???? 8,2
.??..?.?#?? 2,3
#?.????..? 1,2,1
??????????##.#?#. 1,8,1,1
.#????##??.?.#?? 1,1,4,1,2
?###???.??.???.? 3,1,1,1,1
.#?.?#???????? 2,1,2,3
#???#?##???#?#??. 8,5
.?#???????????.#?#? 4,2,3
?##.??..??? 2,1
?..???????????? 1,2,2,1,1
.#?.??#??? 2,2
???.???.???..#????? 2,2,1,1,3,1
?#??????#. 3,4
?.????#?#?????# 7,5
??#????.?#??.. 2,2,3
.#?????#??#??#??.?? 1,4,1,2,1,2
???..?#???? 3,1,1
#??#??????...?? 1,1,3,1,1
?#??.?..#??????# 4,3,4
??.??.??????.? 2,3,1
..#?..?#???. 1,2
.?????#?.? 3,1
?#??#??#?#?#.??? 1,9
##???.????.?#??.??? 4,1,1,3,1
.?.?.?.????????? 1,1,4,1
??.#????#.???##???.? 1,3,1,1,5,1
#.??#?.?.?..? 1,2,1,1
???.#?.???. 1,2,2
?..#?.?#??????? 1,2,6
#?.?##?#?? 1,3,1
#?#.???#?#???.? 3,5,2,1
##..?.????##?#?#???? 2,1,1,9,1
.?#????.???? 2,4
???..###?#??# 2,5,2
#???.????#??? 4,2,1,1
..?#??????..? 2,4
??...????#.?? 1,3,1,1
?.??##?#???.??????? 6,7
???#?.?????#? 1,1,1,1
??#?????????.??#?.?? 1,1,2,4,3
?????#?#??#??????? 1,4,1,6,1
?#???#.?#??? 2,1,1,3
?##.??#?????.???. 2,3,3
??#????.??? 1,5,1
??##?????????????? 3,3,1,5
???.?##????? 1,5,1
?#??#.???#?????## 1,1,6,3
.?.??#?.???#?? 2,4
???##???.??????#???? 7,1,1,5
??????#????.?..? 3,1,3,1,1
?#??##???.???#.????# 7,1,1,1,1,1
???????#.??? 1,6,2
.#.?#?.?#? 1,1,1
?#???#????#?.#?????? 10,1,2,1
.?#?####??#???????. 6,9
#?..?#.?#?#????#? 1,2,8
.??#?##?.????#??#. 2,2,8
????#..???????? 1,1,2,2
??#???#..?##????? 1,2,1,8
.????????##???. 6,4
????#?...??.?.?#.# 5,1,1,1,1
??.?????..#?? 1,1,1,3
?????.???? 3,1
.????????.??.???? 1,4,2,1,1
?#??#???.????????? 7,2,2
???#????.#.??##??? 4,1,4
#??##..#?????. 1,2,2,1
???????#???.?.?#?. 4,2,1,3
??.???#.?.???. 2,3,3
???.???#???.??##? 1,7,4
????##.?#??##..?? 6,1,2,1
.??.???#????#.?.? 2,1,3,2,1
????????#?#?#? 2,5,4
.???????.?#?#?. 5,5
?.###???.???????##?? 5,1,1,6
??????#??#??#???.#? 1,1,9,1
?#???#.?????# 6,2,2
???.#??????. 2,3,1
.????##?????.? 9,1
????#..#.??? 1,1,1,1
?##?..???????????#.? 4,9
?#?????.?? 3,2,2
#??????#??????.? 8,1,2,1
?#.?#?????#..#??? 2,4,2,1,1
#????????????.#?? 1,6,2,3
???#???.#.? 4,1
?#??#?#.???#??????. 6,4,2
??##???????#????.?# 1,8,1,2,2
?#????#?#.???.?# 2,4,1,1
?##????#?# 3,5
?.?..??#.#?. 1,1,1,1
?#.???????.?? 2,3
?#???#????.? 8,1
?#?.??????#. 1,6
#?#.???.?? 3,3,1
?.#?????????????#? 10,1
???????#??.?#?? 2,4,2
?#???##??##??#???#?? 8,2,1,3,1
?#???#???##? 2,6
??.???##?. 2,3
?????????.???..?#?? 7,1,1,3
.?#??..??#?? 4,3
???.???#????.???? 1,5,2,1
?#.???##???#.. 2,6
?#?.???.??#??#.??.. 2,3,3,1,1
?#???????##???.??#? 14,1
#?.#????..?.? 1,1,2
??..???????#?.??. 1,7,1
?#??#??????#.????? 2,1,1,3,1,1
?..??.??#?.?? 1,1,3,1
????.??##?#?#??. 2,8
??????##?#?? 1,1,7
???##?.#?#??????#??? 3,13
??#????#????.??. 3,1,2,1,1
???.??????..?.? 2,1,1,1,1
#???###???????. 1,6,2
??#?#.##???.????##? 3,1,4,1,4
?.????##????????##?? 4,7
?.###?#.?#??#.??#??. 1,5,3,1,4
.?.?#????? 1,1,3
...??.???. 2,2
.?????#??? 2,2
??????##?#..?????#.? 4,4,1,1,2,1
??##?#??.?.?? 6,1
.???##????..??#???#? 5,7
#???#????? 5,1,1
????????#?. 3,5
?.??#???##?.??? 1,1,1,5,2
???????#?.?. 1,1,2,1
?.##?#.??#?#?.. 4,6
?##??????#.?????? 7,1,2,1,1
?.??????..???.?..? 2,1
?..?????#??? 2,2,1
??#..????? 1,1,1
???????#?.?? 9,1
????#??.??. 6,1
#.?....??????#?? 1,8
?###?#?????##??? 13,1
???.??.???##? 1,5
##.?.?.?##??#?##???? 2,1,10,2
?#??.?.?.? 2,1
???#??#??????.?? 1,1,3,4,1
#?##???#?#.???##? 8,1,4
????.###.????## 1,3,1,1,2
????????.????##?#?? 1,2,1,1,2,6
?.???#?????. 4,1
????#?.??.##?? 1,1,2,3
#??????.??# 3,3,2
..####.#?#.?????##?. 4,1,1,6
??????????#?????? 1,3,2,2,3
?.??#???#?#??????#. 3,10
?#?.#???????#??# 2,4,1,1,1
??????????? 7,1
..??..#?#??#???#??## 2,14
?#?#.????? 1,1,2
#??#??#??#.#?.?.#.?. 7,1,1,1,1,1
??????#?.??.#.????? 1,4,2,1,5
?#????#??? 1,1,3
#?#??#??..??.#???? 8,1,4
??#??#?#?#???#????? 2,1,11
?##??#?#.?????.?? 7,2
#????##?..?. 1,5
????#?#???????#??? 8,1,1,2
???.????.?##????# 1,1,2,4,3
??????##?###?? 1,1,9
???#?.??#?#.?.????# 1,3,1,3,1,1
.#???????##?#?. 10,1
????#???.?????#??? 2,3,2,2
##?.????#?#?? 2,2,5
.?????#???#??#?.#? 1,1,6,2,2
?.??#??.??#?#?#?#?? 1,1,2,11
.?#???#?..? 2,3
.??.??#.?? 2,1
?????#?..?? 1,2,1
.##???#????.#.??? 2,5,1,1
??.??##?????. 2,4,2
..##.??#????????#.?? 2,1,10,1
???###?#??#. 1,8
??..??##??.? 1,4,1
?.?#?#..???#?.#??. 1,3,5,1
??????#?????? 1,1,1,4
??.#???????????#? 1,10,1
???.?????.????????.. 1,5
???####.????? 6,2
#?##?.?????????? 4,2,3
???.?#????.??.?#.? 3,1,3,1,2,1
????????.?.?. 7,1
?.?##?#??.??#?#?#?? 1,6,5,2
.??#???..?#??...??# 2,4,1
#.???????# 1,6
?#.??##.??.????? 1,2,1,2,1
?.?..???#?????? 6,3
?.??#?#?#?? 1,7
???#???#.?#?.???#.# 1,5,1,1,1,1
??.?????#??????.?.? 1,1,4,1,1,1
.?.?????.??# 1,2,1,2
???..#?#?# 1,3,1
?..#?#???????#? 1,4,1,1,1
??#?.???#???#?? 3,4,1,1
????#???????#??????. 1,13,2
?.???#????..?. 1,8,1
??.?#?.?.???##?.?# 1,2,1,6,1
???..???#???###?#??? 2,13
...##??#?.??. 5,1
???.?#?#?? 1,4
?#??????.#? 2,1,1
##?#????#? 4,4
???.#?##????#??????. 1,5,4,1,1
#.??????#. 1,1,1
??????.?..#????#? 4,2,1
??????????##???. 2,1,7
?#?????????? 2,5,1
?.?.????#??? 1,5,1
????.#??##?..?.? 2,6,1
????????#???? 1,1,1,5
.?.????##???#?.??? 1,10,1,1
?.?????#?? 2,2
.????.#??.??#?? 2,2,4
#??.#????#?#????.. 1,12
?##?.??##????? 2,6
?.??.#?#??#####?.# 1,10,1
.??#.?????? 2,4
?????#???.?.##? 1,4,2
??..???..?.??#??. 1,2,3
???##?##?#?#??????.. 1,13
????.?.??.#?#?##???# 1,1,1,10
??#.?????##???????.? 3,11
.?.?..??#??#??? 1,7
??#?#.???.?##??? 1,1,1,1,4
???????#??? 2,4
.?#??##??#?????? 1,5,1,1
?#?#???#?#?.#?#?# 5,3,5
.?..??#?#???#???. 1,10
????#?#?#??.?? 1,4,2,1
?????.#??#??#??? 2,8
??.?#?????????#???.# 1,13,1
?????#????#?? 1,1,5
?????#???.??#?? 5,2,3
?.?.????#.. 1,4
??.???????#????.#?? 2,1,1,1,2,2
???.#???????#. 1,1,5
????#?#.?#??.???.?? 1,5,1,1,1,1
.??.#???.#??#??.?# 1,1,1,4,1,1
????.?????##?? 2,1,4
??..??????.??? 1,3,2,2
????.?????. 4,2
????..??????##??? 4,1,1,4,1
??..??#?##??.#?? 6,3
#?.?##?#?..??#? 1,6,2
?#???????#.# 2,2,2,1
???..?.??. 1,1,1
.???????.? 1,1,1
?#????????##? 1,2,3
??????#???.?.?##?#. 1,7,3,1
#??????#??? 1,6
?..???#??????? 5,1
??.???.??#??# 2,1,3,2
#?.?#?????#?##???.?. 1,2,8
.#??#???.???.? 1,2,3
#????????#??? 5,3,1
??????#???###. 7,5
????##?????###? 1,4,1,4
?????.????#?#??.? 3,1,1,5,1
??#?#??????#?.?. 2,1,1,1,2
#??????#?.?#? 1,4,2,1
?#???#...???? 2,1,3
???.??##???#.??? 3,1
??.?#?.???#?#?##??# 1,3,1,1,1,5
?..????.?? 2,2
???.?????? 1,1,1
??#??????.????. 7,3
??.????????..??.?#?? 1,1,1,2,2,3
??#.???.?? 1,1,1
?????????#????.?##?? 1,1,7,1,3,1
??????#??##?## 2,1,1,6
#?????.?#???.? 6,4
.?#??#.?#????. 2,1,3
??#?.??#?? 3,3
??#??##??#. 4,3,1
???#????.?.?????.?? 1,3,1,2,1,1
?#?.???????#. 2,8
??.#?????????????#?? 3,3,6
?.??###??#. 5,1
????.?#??? 4,3
?.?.????#???#.# 1,1,1,3,1
.##???#.????. 4,1,1,1
??#?##??????#?? 1,6,1,1
?#??##?..??#?. 5,3
#?#????#.#??#? 3,2,1,4
??#???#?.? 1,2
??##?#?.#?#???? 1,4,3,1,1
?#??.???###??. 3,5
??.?.?????#????.? 2,4
#???.??#?#???.???? 3,6
?#?#????#.?#???##??? 4,1,10
??.#????????#??.? 1,1,1,6,1
??#??#.????.??. 3,2,1,2
?#.?#?????.#? 1,3,1,1
????.??.?????.?? 2,2,3,1
?#.????..???.# 2,2,1,1
?.??##??#??????. 3,1,2,2
?????#.?##????#.? 2,1,6,1,1
.?###??????.?#? 8,1
.??..##???#?#?? 2,9
.??#?####???.?.? 8,1,1,1
??.?.?.#.? 2,1,1
??????.??#??? 4,1,3
??.?????????..??? 1,2,1,3,1
?.???#??..??##??..? 1,1,1,1,6,1
###???#???????#...#? 13,1,2
#?###?????#?????##? 1,6,4,1,2
.?...?.#??.??##?.? 1,2
??.?.??#.??.? 3,1
??????.?#?##??.? 3,1,6,1
??????#?#.??#?#.. 2,1,2,1,5
?#??#.?.??###???##?? 2,1,1,4,6
#?...?#?#. 1,4
#??#????#?.??.???. 1,7,2,3
??????????#??.?. 1,8,1
????????#??.?.??#.?? 7,2
??#??#?.??#??#???#? 4,10
#?#.?#????? 3,2,2
??#.?????.???? 2,1,1,2
.?#???.#????#?? 2,6
???.?.##??.???? 1,2,1,1,1
???????###.#..#?. 2,2,3,1,2
??#?#??...?#.. 4,1
??..???????.?. 1,1
????#?#??? 3,3,1
????##???? 2,3,2
??.#??.?????#?#? 1,1,1,3,1
.?.??.???. 1,2
??.??#?????? 2,2,1
.?????#.?##??#?#??# 2,1,2,4,1
???#???#???#.??.#?#? 2,7,1,3
?##.?.?.#??#.?#?? 2,1,1,2,2
????.?##.??. 3,2,2
.?#?#?????????##??. 7,1,5
??????###?#??? 3,8
?????#??#.???.?#?.?. 9,1,3
..??##..###?#??? 3,5,1
.##?.#.???.? 2,1,1
..##??#?.???#???. 5,6
???????????#????# 1,5,2,2,2
??##???#????????#?? 1,6,1,1,1
.#????????#. 3,1,1
?#???????.????# 2,1,1,2,1
??.?#????##? 2,4
#?#?????????##?##.? 1,1,1,1,8,1
??.#???#??.#?. 1,4,1
?.?.????#..?? 1,4
????..#??????##??.?. 1,1,11
?#????.?.? 4,1,1
#?????#????#??.???.? 1,1,7,1,1
.??.#?.#????#.#???? 1,2,6,1,1
??#???#??? 5,1
??????#.?????? 6,1
?#??????#?#.?.. 1,4
.?????.??..???#???? 3,1,6
?#?.??#?#?#??#.??. 1,1,8,1
???.#.??.???#??? 3,1,1,6
??#?#????.?? 6,1
?????##????#?#?#??. 4,8
.?#???????#.?#.??#?? 7,1,1,1,1,1
?##?#??#.??# 5,1,3
?.#?????#???????##?? 1,2,11
??#???#??. 1,3
.?.???#???#.#?..? 1,4,1,2
#??.#??????. 1,2,1,1
.??#?###????#? 1,4,3
??.???.?.????.? 1,2
?.?#??.??#.?? 3,1,1,1
?#.????#????. 1,4,1,1
.?##??.?.?#.?# 5,1,2,1
????#???????.?##?. 10,2
???.?#???.????###?# 1,1,2,1,8
?..?#?.##?? 2,3
???????????.#??#?# 2,1,1,1,4,1
???..???.????#? 1,3
.#???#?#?# 1,5
???.#?.#??#??##.?.? 1,1,8
????????#????.?#???? 7,5,4
???.????#?#?? 1,3,4
?..?#?????.##?? 6,3
?????????.???????? 1,1,4,1,2
????#??#?.??#.? 3,1,3
??#..????? 3,3
??#.??#???.#??. 3,3,1,1
??#?.???#?????? 1,1,7,1
????#??#?.????.??#?? 7,1,1,1,1
.??#???#??#?????#?? 2,11
.?#?#?#??? 3,3
????#???##. 3,2
.?#??#???????? 4,6
.??.???###?. 2,5
??.?.?????#?#??? 1,8
???..???#?#?..?#?? 3,1,1,2,2,1
????.?#???##?##? 1,1,1,1,5
?????????????????# 1,1,3,1,5,1
#??#.?#.?. 1,1,1
????.#??#??.??.? 2,4,1
??#?#.?????. 1,3,4
#?#???#?????#.?? 1,7,1,1
?#??????#?? 2,1,1
?????????.###.???? 1,5,3,1,1
??????##??.?#.?? 1,7,2,1
?.??.??????.???? 1,2,2,3
.??????##???..??##? 8,4
.???.?.#??????#???# 2,1,4,7
?#.#????#???? 1,4,5
?..#??##??#?.?#?#??? 1,1,2,2,4,1
??..??????.?? 1,5
???.????#.??#?#????? 2,1,1,10
???????...?# 2,1,2
#.?#??#?#?#?#?.??? 1,4,1,3,1
.??#??.#?# 4,1,1
??????????.????.? 1,4,1,1,1
?????.????#??? 3,2,2
???#??????#????#??? 11,1,2
.?.#?#?#.?. 1,3
??.????##??..# 1,1,4,1
?????#??##??.?#? 1,10,2
..#??#?????? 4,2
.?#??.???#?? 3,5
.?????.??? 1,1,2
?????????. 1,1,2
???.???.?#?.??? 3,1,2,1
???#??.?#?.#.? 2,1,2,1
.#????#???#????? 3,2,3,3
??????#?#.??? 1,4
?.????#??##. 1,2,5
?.??#?#.?? 3,1
????#?#????.#???#?.? 3,4,1,6
????#?#?#?#?#??#??. 9,8
?..?#..### 1,1,3
.????????#?? 7,1,1
?.?#??#??.?????? 3,1,1,1,1
?#??.#?#???#??? 3,1,1,3
?#?.????#?#???.? 2,6,1
??.???.?????? 1,2,2,1
?#??..??????#?# 2,1,2,2,1
??#?????#???#???#?#? 12,2,1
??#???.?#??? 1,4,2
???...#..?#??? 3,1,3
##?.#?#?##????##??? 2,6,3,1
.#?#?.?.???#?#?## 4,8
##??.??????#. 3,6
?#???..#.#.??##?? 1,1,1,1,5
??#??#?#?.#?.#??#?? 1,7,2,1,1,1
.?.???????##??.?? 1,2,3,2
??#????#????.??. 8,1,1
???#?.?#???? 2,2
???#?#?#????? 7,2
????.????? 3,1
###?#?#????? 3,4,2
??#?#??#.?.#?#?##?. 5,2,7
.??.???#..???#??.? 1,1,1,5,1
?#?..???.? 1,3
..?##?.??..#?#?##?#? 3,1,9
?.??.?##??. 1,3
????#???###??.?# 1,1,4,2
#??#...???? 1,1,3
?????..#?# 4,1,1
??#?#?.??.. 4,1
..?#.??#?? 2,2
???.?????#??#?? 1,6,2,1
???.#?##???#??? 2,11
???#????#?#????#??? 2,9,5
??.???.??????? 1,2
??##?...????#?? 4,4
??#??#????? 5,1
?##.??.?.#.?.? 2,2,1,1
.?#.??#???.#?#?..?? 2,5,3,1
?#???##?????#? 9,2
??#??.#?#?.??# 4,1,1,2
#.?#?????? 1,1,1
????#???????.??.? 11,1
??.?#?#???#??#? 2,10
?#??#??#??#??#??#? 8,1,5
?#?#?#?????????#.??# 1,7,1,1,2
.??.???#?. 2,1,1
??...??#?#. 1,4
.??.#????.?.? 1,2,1,1
??#?#.?#???###?#? 3,7,1
?????#???###?.??? 2,1,6,2
?#?#???#.???#?.?.# 8,1,1,1
?.??#?#?#??###??# 1,14
#.??#????????.. 1,5,1
##?#???????#???##??? 9,4,2
.??..???#?? 1,3
##????.?????. 2,1,3
.???.??????.#???## 1,3,1,1,4
#.?##??#??##? 1,7,2
?#??#????? 2,4
.?#???#??#??#?#. 7,4,1
????#?.#??#.. 1,2,1,1
??.?##.?#??#?? 3,1,3
?.????.??#?#????.??? 3,5,1,3
?????#..?###?.???.?# 2,3,5,1,1,2
#?.?.#?.?#?? 1,1,1,1
?#?.???.##.?.?.? 2,2,1,1
#?#???.?#.?????? 4,1,2
?.??????.??? 1,2
.#????#??#?##?.? 2,1,5,1
???#?#???.#. 1,1,1,1
?##??##??????.???? 7,1,2,1,2
#????##?#?..#?#??. 9,1,1
??#??.??#??#????# 1,2,1,1,4
.????#???#???? 5,1,1
???#?.?..???????# 3,4,2
????#?#??#??.????.. 7,2
#?#????#.???..#? 5,1,2,2
?#?#?#??.??????.. 5,1,2
??#??????? 1,5
..??##??.?#??..??? 3,2,1
#????.??????#? 1,1,4,1
?#.#??????#? 1,1,1,3
??.??.???#???. 1,2,1,4
??#?#?????? 4,3
?????.?.??#? 1,1,1,1
??##??#???#?? 6,1
?.????###??#??? 3,1
??????????#??.#? 3,1,1,2,1
????#?.???##?? 1,1,6
?.?#?.??#?????? 2,2,2
#.??##?#?????#?????? 1,10,2,1,1
?.??#???..???? 1,1,2
.##????.??? 4,1
#???..???#??#???#??? 1,1,1,1,9
#.#??#???????#.#?#?. 1,7,2,1,2
??#??#?????#?###??? 5,3,7
?#?#?.??.??? 1,1,1,1
..#????????# 1,2,3,1
?.??#.?#??? 2,2
.#?????.?##???#?? 6,8
?.???#????..??????? 4,1,3,2
????.???#???..? 1,1,2,1,1
#???#??????????? 1,2,1,6
?.??.???#? 1,4
??#????#.??? 4,1,1
????.??.?#??.??? 1,1
#.?.?#??????.?#?.? 1,2,3,3
?##??##??.?..? 2,4,1
???.??#?????###?#?# 1,13,1
????????.?????????#? 2,1,1,9
?#?#??#?????#????? 2,2,1,1,3,3
??..#??.???.???## 3,2,3
?.?#?#???#? 4,1
.?#??#???#??????#.? 10,4
???????????##???.? 1,1,1,1,3,1
..?#??.#???????#?? 1,1,7,1
?????#?#?????? 1,3,2
.??????????.#?????? 2,4
??.#?#?.?.???? 4,2
???#????.?#???# 1,1,3,3,1
??.??????.???.?? 1,3,2
?#.#?????#???###? 2,1,11
????.#?.#????##???.# 2,1,2,5,1
??.##????##?... 3,4
..?#??.??.?##??#??.? 4,6
?#?????????#?. 6,3,2
??.##????????####??# 1,15,1
???.?.????? 1,3
???#?#.?##?? 5,3
.??#?..##? 4,3
?????#??#????.##? 6,2,2,2
??.#??#???##.#. 1,3,2,1
?#.?.????.?. 1,2,1
??.?????????. 2,3,2,1
????#???.? 1,2,1
??????.#???. 1,1,3
#..?.??#?? 1,3
..#.?????????. 1,4,2
?.??????#?????.? 7,2,1
?#??.?.#?###??? 1,1,1,5
.??.?#.??.?.???...?. 2,1
???#?.#?#?.??..?#.? 1,3,4,2,2,1
..??..?#??. 1,4
.??#?????.??????? 6,3
?..??????..???.? 1,2,3
#?????.?#?????#????. 1,1,1,12
?????????.?#??????? 1,5,7
???.?#.???.??? 2,2,2,3
??.?.?.??#.???? 1,3,2
??.????##????# 1,6,1
?.???????.?#. 1,2,1,1
..??#.????.?????? 3,1
??#?#?.###?#??#?#.?? 4,5,2,1,1
??#?..???? 3,2
?#?##.???.#.??##???# 5,1,1,1,4,2
.#.?#?.??# 1,2,3
#?.##??..#???.???#?? 1,2,1,4,3
??#??????????????? 3,1,1,2,1,1
.??.#?.?#??# 1,1,3,1
?.?#??#???????#????? 1,5,3,4,1
???#????#??? 4,3,1
.??#???.??#? 2,4
##?.??.#??#??? 2,1,6
#??#..##..?#. 1,1,2,1
?#?.#?#??#??##.???#? 2,3,2,2,4
..????????.?.??.?#? 1,1,3,1,1,3
#??.??????# 2,5
?.###???????? 3,1,2
.?#??#?#???..????? 2,7,3
?#?##?#??.##?..?#?? 7,2,3
??#?.??..?#?#.# 1,1,4,1
??#????????#.? 9,1
##?#?##????????????? 8,1,1,2,3
#????#?????#???? 9,1,1
?#..???#?.#???#?##?# 1,1,1,10
?.?????##.?#?? 1,4,2
?.????????? 5,2
?#?#?????.??#?##?? 4,2,8
???.#??#.?#??#?.??? 2,1,1,5,2
?#??.?????????#. 4,2,4
.##?????.#.?. 2,3,1
.##..????.? 2,3
?#?#???.????.???? 4,2
##?.???.????? 2,1,5
?#??.?#??? 1,1,5
?.????#??..#?..? 2,1,2
#??????#.. 1,2,1
???#??..?#??? 1,1,3,1
??#???.#??? 6,1,1
???#?????????????? 3,2,6,2
#??????.?????? 4,1,1,1
?????#?#?? 2,6
?##?#???????.???? 2,2,1,1,4
?..?????#?.? 1,3
##..#?.??. 2,2,2
..#??????? 1,2,1
..?????##.. 2,3
??#???????#? 1,3,2,1
#??.#???????????? 3,3,1,4
#??.??#.???? 2,1,2
?????#?.????? 1,2,1,1
????#?##???##??#? 6,8
?.??#?.?????.. 2,4
??.?????#??#? 1,1,5
??????#.#???.?#??? 2,1,1,4,1,1
?#??.???#???..?# 1,1,2,1,2
##???.???###? 2,1,1,4
##?????????????##?#. 5,1,1,7
??..???#???????????? 1,4,1,1,3,1
?..??#??.?##?? 1,1,1,3
.?.??.???#.?.?? 2,1
??????????? 1,4
????#.???? 3,1
??#??????#??.? 2,8,1
.????#?#??????. 6,3
??#?###?.?.???#????? 8,1,1,4,1
????.?#???. 1,5
?.????#????. 1,7
????.????? 3,1
?.#..##??#????? 1,1,9
#?#?#??????##?????? 1,1,10,1,1
??.???.#?? 2,1
.?#????#.???.?.# 4,2,2,1,1
.????#.??? 1,3,1
???????????#???? 1,6,3,1
???.#?.????. 2,2
??#?????#??? 8,1
???????????. 1,1,2,3
???#.????.#?.??# 3,3,1,1,1
????#??..?.#?. 3,1
.##?????#?????.?.?#? 9,2,1,1
????.???????#?? 2,1,6
..??.?#??? 1,2,1
#?.???#.????##. 1,1,1,1,2
?.???#????# 1,1,6
?.????????? 1,6
???#?##???#????.?.? 9,2,1
?.#?#.?????#???###? 1,1,1,1,1,8
???#.?.??.#? 4,1,2,1
???..?..?# 2,2
?????????? 1,2,1
..???#?????#... 1,7
??.????.#????? 1,3,1,3
.?#???#??? 2,1
?????????.??????? 2,1,3,1,5
???.??????#???? 2,6
??##???#?#? 3,1,2
?...?#?.???... 3,2
???#?..?##?? 2,3
#?#??????#???#??#?? 4,13
?????#????. 1,1,1
.?.#?#????#?????.??? 1,6,1,2
????#??????.?? 8,1
.?#???#???.#?# 2,1,1,3
????#.????? 5,1,1
.?#???.?###?.??# 3,5,1
?#???#??????#??.#. 8,4,1
??????#.#???.?? 1,5,2,1,1
#???##.?##?? 1,3,4
#.?.?.???????? 1,1,4,1
?#????#??#?? 2,3,3
#??#???????.#?? 1,1,1,2,1
.????????? 1,1,1
???#?????..??. 9,1
..?#??#?.??..???. 6,2
?.?#????????.?...?? 4,4,1,2
#?.????.??# 1,4,2
.?#?.??.#?????? 1,1,1,4
..#?????.??#???.## 2,1,1,1,1,2
.#???????.?#??. 6,1,3
.#??#?.#?????#??.??? 1,1,1,7,1
?#???.?.?#??? 1,2,1,4
#?.???????????????? 1,2,6,1
???#.??..?? 4,1
#???.#????.? 2,1,2,1
.#??????.#??.? 2,2,2
?.?????#??#.??#?.? 2,4,4
.#???????##. 1,1,2
?#??????.#.##? 2,4,1,3
?#????.???#? 5,3
?.??#?#??##.#? 1,4,2,1
???#?#?##??????? 1,6,1,1,1
?..#?.#?#? 1,1,2
????.??.#?? 1,2,1
?#?.?.#?...?? 2,1,2,2
?????????#???. 1,1,1,5
.?#????.???#?? 6,1,2
??.?#????.???#. 1,4,1,1
.???#??.?????### 4,8
??##?????#??? 8,3
?#???????##.? 3,4
??.#???#??#?. 5,1
?#.????#????#.???. 1,1,6,2
???????#???#?? 3,6
??#.?#.???? 2,1,2
????????.?#??????.?? 1,1,1,1,6,1
.?.??????????#?? 5,4
?#?..???#??#??#??? 2,11
??#???.???#??#??? 2,2,6
##?#??##??#?????..?. 9,2,1,1,1
#??????.?.#??#? 1,2,1,1,1
.???.??#?.#?? 1,1,2,1
.???#.?#??#?#??# 4,1,4,2
?.?#???????????.? 2,2
?.????#??????.?? 4,1
?#????????#?.?.# 6,2,1,1,1
..????#?????#. 5,1,1
????#.#???????????? 1,1,1,1,8,1
?...?#?#??? 1,3
?#?????#..?.?? 7,1
??#??????.#?#?#?.?? 4,2,6,1
???#???.??. 4,1,1
???#???#?#?#?#??#??? 2,1,3,9
??.????.???##?# 2,6
???.#????#?#??#??.# 1,1,1,10,1
??????????.??#?#?? 2,5,4
??#????????#?# 1,5,3
????.?..#??? 2,3
.?#??#??.???..?# 1,2,1,2,1
#????????????###?#?? 3,14
???????..?????##?? 2,2,9
?##?#?.???.????.??# 5,1,1,2,1
???#.????###?###.??. 1,1,1,8,1
?#??????#??#? 2,1,6
?..?..??#. 1,1,1
#???????????.?? 1,6,1
.???.?????? 1,3,1
?.????#????##??.? 1,8,1
??#?.?.???.?..? 2,1
?????#????????? 1,1,1,2,1
???????????.?.?# 1,5,1,1,1
??#??.??#??#?????? 3,1,4,2
.????##???# 4,1
???#.?#??.???????# 2,3,5,1
?????#.#?.?.#???. 6,2,4
?.??#????.#??#???# 4,8
#???.?#.#??#.??##?? 1,1,1,4,2,1
?#?.##..#?##.?# 2,2,4,2
???.??????.??????#?# 1,1,1,1,1,9
?.?#??#?#.#? 1,1,3,2
?#????.?#???? 4,3
??#?#?#?.????? 7,1,1
##?#??#??.? 8,1
??#.?###?#?.? 2,6
#?##????????#. 7,1,1,1
??..#???##???.?#???? 1,3,2,2,5
??#?#?.????#?# 3,1,2,4
??????##??.#???? 3,3,3
?#???#.?????#?? 4,1,5
??.??#???????.?#. 1,6,1,2
..??????????#?## 8,1,2
.#???.##??.?#??#?? 3,2,1,1,2
?#???##?.. 1,1,2
.????#?.?##??#..??? 6,6,1
??#???##.?.###??#? 7,4,1
?????????#?#???? 9,1
?#?##?#???#?.. 7,2
.#?.?.????? 1,1,2
?#.?#????#.?? 1,3,1,2
.????#??.??#..??? 4,3,2
???????.?#??###??. 6,7
.???##???#?? 1,4,1
????#?###???#? 1,1,1,7
#?.?.?.?#? 1,1,1
?.##?#?.?#??.#. 4,2,1
??.???.??#?##?.???# 2,2,6,1,1
.???.#..#???.?? 2,1,1,1,1
?#????.?.?# 2,1,2
??#????#?#?.??. 3,1,1,2,2
???.????#.????? 1,4,2
.??##????#?.???. 5,4,1
?##??#????#??# 2,2,1,4
?#????.#?#???#?? 2,2,7,1
????#..?#? 4,3
#.?.#?????#? 1,1,2,3
??#??????#?.??? 5,1,1,1,1
??????#.#? 1,2,2
??#.??????#? 3,4,2
#?????#??.?.##????? 1,1,4,1,5,1
??.??.???#???##????. 1,6,4
.?#?.?..?#? 2,3
?#??????.?#?.# 5,1,2,1
??#????#??.#?#? 7,3
??#??#?.????#? 1,2,5
???.???..??????? 2,3,3
???#???#??? 1,7
#???.???#??? 1,2,1,3
?????.?.#??.??# 2,2,1,2,2
??.?#?????????#??##? 1,16
??.???????????? 2,6,3
?????#?????##?..??# 1,1,2,7,1,1
.#?.??????##??.?.?? 1,2,5,1,1,1
?#???.????.? 1,1,4,1
????????#?#????? 1,1,11
????###.?#??.#? 1,3,2,1
#??.???#??????? 3,4,3
?#?????..? 2,1,1
????##????#???????## 3,3,8,2
?????.??###????? 2,4,1
.?#??#???.?? 2,1,1,1
????#??.?????. 5,1,1
?#?????.??.????# 5,1,1,1,3
?##.??????# 3,5
??##???#????.?#.?? 7,3,1,1
?..#.??##???.?? 1,7,1
?#?##?????#??.?# 1,10,1
??.?#?#.????#??. 4,1
.?????#?##.??. 1,7
???#.???.?#????? 1,5
#?.???????.??? 1,1,5,1
?##??#???## 7,2
#?##??????.. 7,1
#...????????##?##?? 1,3,7
???#?????#?????#? 3,8
?#???#??#.????.??# 1,1,4,1,1,1
??#??#?????????? 4,1,1,1
?.?????##????##????? 1,1,8,2,1,1
?????#???? 5,1
?.??.###?##??#? 1,1,3,2,2
????.??..?? 4,1,2
??.????#.?# 5,2
#.#??.?????? 1,1,1,2
..#??#??.??????#??? 6,6
.#?.??##???.#?#. 2,3,1,3
?????.??.?????????.? 3,7
.##?#????# 4,1
?#???#??#??.#.?# 2,1,3,1,1
??????#???. 1,1,4
.#??###?????#?? 1,11
.????#?????#?##.??.. 10,2,1
??.##?.???#????.# 1,2,8,1
.??#?????????.? 1,1,4,1,1
?#?##?.???? 4,1
.??????#?.?#? 5,2
?.???###.????.?.? 1,6,3,1,1
##??##????????##?#? 7,1,6,1
??#??????????###?? 2,1,1,6
?.??.#.??#????. 1,1,1,1,2
????????.??#? 8,1,1
?.??????.##??#.#?.# 1,1,2,5,1,1
..?#?#???.??.??.?? 6,1
.????#.##?#?##.#??? 1,1,1,7,1,2
??#???#??#?#??? 12,1
#???????????#?#????? 1,2,1,1,6,1
???#..?????#??. 1,1,7
??##???###??.?#?#?.? 12,4,1
??????#.?##.?#???#? 1,2,2,3,1
??.??.?##???????#. 2,1,11
.??#????##??? 3,4
.??#???#????#??.? 14,1
?#????..#??????.. 2,1,7