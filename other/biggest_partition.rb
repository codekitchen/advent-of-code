require 'z3'
require_relative '../pathfinding'

NUMS = [32, 122, 77, 86, 59, 47, 154, 141, 172, 49, 5, 62, 99, 109, 17, 30, 977]

def solve(nums)
  s = Z3::Solver.new
  x = nums.each_with_index.map { Z3.Int "#{_2}:#{_1}" }
  x.each { s.assert((it == 0) | (it == 1)) }
  s.assert(nums.sum == 2 * nums.zip(x).map { |n,c| n*c }.sum)
  s.satisfiable? && s.model
end

res = best_plan(
  starts: [NUMS],
  goal: ->s { solve(s) },
  actions: ->(s, &cb) {
    s.each_with_index do |n, i|
      s2 = s.dup
      s2.delete_at i
      cb.(Action[state: s2, action: n, cost: n])
    end
  },
)
res => history:, actions:, cost:
puts "Removed: #{actions} (Cost: #{cost})"
final = history.last
puts "Final: #{final}"
model = solve(final)
left = model.filter_map { |n,v| v.to_i == 0 && n.to_s.split(':').last.to_i }
right = model.filter_map { |n,v| v.to_i == 1 && n.to_s.split(':').last.to_i }
puts left.join('+')+" = #{left.sum}"
puts right.join('+')+" = #{right.sum}"
