#!/usr/bin/env ruby --yjit

# From https://buttondown.com/hillelwayne/archive/solving-a-math-problem-with-planner-programming/
# With the delete case, finding ==100_001 takes 30s with my optimized planner, and only 4s using
# picat. This bums me out. Originally it took 12 minutes before I optimized.
# I think I'm approaching the limits of what I can do in pure ruby to optimize, and I'm hitting
# constant factors.
# (now takes 10s with ruby 3.4 and the latest yjit)

require_relative '../pathfinding'

State = Data.define(:doc, :clipboard)

res = best_plan(
  starts: State[1,0],
  goal: ->s{ s.doc == 100_001 },
  actions: ->(s, &cb){
    # paste
    cb.(Action[action: 'P', state: State[s.doc+s.clipboard, s.clipboard], cost: 1])
    # select-and-copy
    cb.(Action[action: 'SC', state: State[s.doc, s.doc], cost: 2])
    # delete a char
    cb.(Action[action: 'D', state: State[s.doc-1, s.clipboard], cost: 1]) if s.doc > 0
  },
)

puts "cost: #{res[:cost]}"
puts "steps: #{res[:actions].size}"
puts res[:actions].join(" ")
