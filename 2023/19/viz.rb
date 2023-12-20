#!/usr/bin/env ruby

$skip_runner = true
require_relative '19'
require_relative '../../viz_cairo'
require_relative '../../utils'

objs = [
  [{ ob: :fill, fr: 0, rf: 1, gf: 1, bf: 1, af: 1, always: true }],
  view = [{ ob: :view, fr: 0, x1: 0, y1: 0, x2: 0, y2: 0, always: true }],
]

dump = ARGF
step = 0
workflows, parts = Marshal.load(dump)
x2 = 0
WF_X = 5
WF_Y = 5
WF_W = 10
WF_H = 10
WF_DY = 15
workflows.each.with_index do |(name,wf),i|
  objs << [{ob: :box, fr: 0, always: true, x1: WF_X, y1: WF_Y+i*WF_DY, x2: WF_X+WF_W, y2: WF_Y+i*WF_DY+WF_H, rf: 0, gf: 0.5, bf: 0, af: 1, rc: 4 }]
  wf.tests.each.with_index do |t,j|
    x2 = [x2,i].max
    objs << [{ob: :box, fr: 0, always: true, x1: WF_X+WF_W*(1+j), y1: WF_Y+i*WF_DY, x2: WF_W+WF_X+WF_W*(1+j), y2: WF_Y+i*WF_DY+WF_H, rf: 0.5, gf: 0, bf: 0, af: 1, rc: 4, fs: 10, tx: t.op||'|' }]
  end
end

objs << acc = [{ob: :box, fr: 0, always: true, x1: WF_W*x2, x2: 40+WF_W*x2+80, y1: 5, y2: 50, rf: 0, gf: 0, bf: 0, af: 0.2, rc: 2, fs: 12, tx: 'Accepted'}]
acc_midx = acc[0][:x1] + (acc[0][:x2] - acc[0][:x1]) / 2
objs << rej = [{ob: :box, fr: 0, always: true, x1: WF_W*x2, x2: 40+WF_W*x2+80, y1: 60, y2: 105, rf: 0.5, gf: 0, bf: 0, af: 0.2, rc: 2, fs: 12, tx: 'Rejected'}]

view.first[:x2] = acc[0][:x2]+10#30+WF_W*x2
view.first[:y2] = 30+WF_DY*workflows.size

paths = []
paths << Marshal.load(dump) until dump.eof?

paths.zip(parts).each do |path,part|
  fr = step*20
  best_attr = part.to_h.then { |part| part.key(part.values.max) }
  o = [{ob: :box, fr:, rf: 0, gf: 0, bf: 0.5, af: 0.8, rc: 6, fs: 8, tx: best_attr.to_s }]
  prev_y = nil
  path.each.with_index do |(p,step),i|
    break if %w[A R].include?(p)
    y = workflows.find_index { |n,| n == p }
    fr += 10*(y-prev_y).abs if i > 0
    (0..step).each { |z| o << {fr:, x1:WF_X+WF_W*z, x2:WF_X+WF_W*z+10, y1:WF_Y+y*WF_DY, y2:WF_Y+y*WF_DY+10}; fr += 10 }
    prev_y = y
  end
  o << {fr:fr+10, x1:acc_midx, x2:acc_midx+10, y1: 5, y2:15} if path.last.first == 'A'
  o << {fr:fr+10, x1:0, x2:10, y1: 35, y2:45} if path.last.first == 'R'
  o << {fr:fr+50}
  objs << o
  step += 1
end

# objs += ui
# pp objs
render_viz(objs)
# require 'json'
# puts JSON.dump(objs)
