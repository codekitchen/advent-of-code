input = "0,6,1,7,2,19,20".split(",").map(&:to_i)
memory = {}
step = 1
say = ->(lastnum) {
    # puts "#{step}: #{lastnum}"
    nextnum = memory.key?(lastnum) ? step - memory[lastnum] : 0
    memory[lastnum] = step
    step += 1
    nextnum
}

n = input.map { |n| say.(n) }.last
while true
    n = say.(n)
    if step >= 30000000
        puts n
        break
    end
end
