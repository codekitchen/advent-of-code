#!/usr/bin/env ruby

require_relative '../grid'
require_relative '../../viz_cairo'

objs = [
  [{ ob: :fill, fr: 0, rf: 1, gf: 1, bf: 1, af: 1, always: true }],
  view = [{ ob: :view, fr: 0, x1: 0, y1: 0, x2: 0, y2: 0, always: true }],
]

ui = [
  [{ ob: :view, fr: 0, x1: 0, y1: 0, x2: 1024, y2: 768, always: true }],
  counter = [{ ob: :box, fr: 0, x1: 5, y1: 5, x2: 90, y2: 30, rf: 0, gf: 0, bf: 0, af: 0.8, rc: 4, fs: 18, tx: "", always: true }],
]

dump = ARGF
step = 0
until dump.eof?
  Marshal.load(dump) => { energized:, grid: }
  frame = step*10
  if step == 0
    view.first[:x2] = grid.width*20
    view.first[:y2] = grid.height*20
    gridobjs = grid.cells.map { |c| [{ ob: :box, fr: 0, x1: c.x*20, y1: c.y*20, x2: c.x*20+20, y2: c.y*20+20, rf: 0.2, gf: 0.2, bf: 0.2, af: 1.0, rc: 2, fs: 18, tx: c.get, always: true }] }
  end
  energized.cells.zip(gridobjs) { |c,o| o << {fr: frame, tx: c.get} if c.get == '#'}
  counter << {fr: frame, tx: "%4d" % [energized.count('#')]}
  step += 1
end

objs += gridobjs
objs += ui

# render_viz(objs)
require 'json'
puts JSON.dump(objs)
