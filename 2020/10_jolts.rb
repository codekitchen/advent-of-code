adapters = [0] + DATA.each_line.map(&:to_i).sort
adapters << adapters[-1] + 3

differences = adapters[..-2].zip(adapters[1..]).map { |a,b| b - a }
tallies = differences.tally
p tallies
p tallies[1] * tallies[3]

groups = []
gaps = [0] + differences.each_with_index.filter { |n,i| n == 3 }.map { |n,i| i } + [adapters.length]
(gaps.length-1).times do |a|
    groups << adapters[gaps[a]..gaps[a+1]]
end

class Integer
    def factorial
        f = 1
        for i in 1..self; f *= i; end
        f
    end
end

p groups
total = groups.map { |g| g.size < 4 ? 0 : (g.size - 2).factorial }.sum
p total

__END__
28
33
18
42
31
14
46
20
48
47
24
23
49
45
19
38
39
11
1
32
25
35
8
17
7
9
4
2
34
10
3
