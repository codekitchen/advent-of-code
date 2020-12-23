EXAMPLE = "389125467"
REAL = "418976235"
PT2 = true

input = REAL

class Array
    def link_each(starting=1)
        return to_enum(:link_each, starting) unless block_given?
        cur = starting
        loop do
            cur = self[cur]
            break if cur == starting
            yield cur
        end
    end
end
cups = Array.new(PT2 ? 1_000_001 : input.size+1, nil)

init = input.split(//).map(&:to_i)
cups[init[-1]] = init[0]
1.upto(init.size-1) { |i| cups[init[i-1]] = init[i] }

if PT2
    cups[init[-1]] = init.size+1
    (init.size+1).upto(1_000_000) { |i| cups[i] = i+1 }
    cups[1_000_000] = init[0]
end
cur = init[0]
min = 1
max = cups.size - 1

cycles = PT2 ? 10_000_000 : 100
cycles.times do |i|
    # puts "\n-- move #{i+1} --"

    # puts "cups: #{cups.link_each(cur).to_a.join(' ')}"
    pick = [cups[cur], cups[cups[cur]], cups[cups[cups[cur]]]]
    # pick = cups.link_each(cur).take(3)
    # puts "pick up: #{pick.join(", ")}"

    dest = cur - 1
    dest = max if dest < min
    while pick.include?(dest)
        dest -= 1
        dest = max if dest < min
    end
    # puts "destination: #{dest}"
    # cups.insert(desti+1, *pick)
    # cur = cups[(cups.index(cur) + 1) % cups.size]
    prev = cups[dest]
    cups[dest] = pick[0]
    cups[cur] = cups[pick[-1]]
    cups[pick[-1]] = prev
    cur = cups[cur]
end

if PT2
    a, b = cups.link_each.take(2)
    puts "#{a} * #{b} = #{a*b}"
else
    puts cups.link_each.to_a.join
end
