MIN = 256310
MAX = 732736

def has_run(digits)
    start = 0
    while start < digits.length
        last = start + 1
        last += 1 while digits[last] == digits[start]
        return true if last - start == 2
        start = last
    end
    false
end

possibles = []
MIN.upto(MAX) do |i|
    digits = i.to_s.split("").map(&:to_i)
    # next unless (0..digits.length - 2).any? { |pos| digits[pos] == digits[pos+1] }
    next unless has_run(digits)
    x = 0
    next unless digits.all? { |d| d >= x ? x = d : false }
    possibles << i
end

puts possibles.length