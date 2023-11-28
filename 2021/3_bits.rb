nums = ARGF.each_line.map(&:chomp)
def most_common(nums, col)
  digits = nums.map { _1[col] }
  digits.count("0") > digits.count("1") ? 0 : 1 # digits.tally.max_by{_2}.first.to_i
end
commons = nums[0].size.times.map { |i| most_common(nums, i) }
gamma = commons.join.to_i(2)
epsilon = commons.map { 1 - _1 }.join.to_i(2)
p gamma * epsilon
