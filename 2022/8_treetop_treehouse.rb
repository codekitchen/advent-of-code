require './grid'
input = ARGF.readlines.map { |l| l.chomp.chars.map(&:to_i) }
g = Grid.new(input[0].size, input.size, input.flatten)

p g.count { |c|
  l = g[0...c.x, c.y]
  r = g[c.x+1.., c.y]
  u = g[c.x, 0...c.y]
  d = g[c.x, c.y+1..]
  [l, r, u, d].any? { |v| v.all? { |o| o.get < c.get } }
}
