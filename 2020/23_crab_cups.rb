EXAMPLE = "389125467"
REAL = "418976235"
PT2 = true

input = REAL
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

    # print "cups: "
    # pc = 1
    # loop do
    #     print(pc == cur ? "(#{pc}) " : "#{pc} ")
    #     pc = cups[pc]
    #     break if pc == 1
    # end
    # puts
    # puts "cups: #{cups.map { |c| cur == c ? "(#{c})" : c }.join(' ')}"
    pick = [cups[cur], cups[cups[cur]], cups[cups[cups[cur]]]]
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
    a = cups[1]
    b = cups[a]
    puts "#{a} * #{b} = #{a*b}"
else
    p1 = cups[1]
    loop do
        print p1
        p1 = cups[p1]
        break if p1 == 1
    end
    puts
end
