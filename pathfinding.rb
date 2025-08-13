require_relative 'wheel'

# call-seq:
#   # Bellman-Ford
#   pathfind(negatives: true, starts: node, neighbors: ->p{p.neighbors})
#   # Dijkstra's
#   pathfind(starts: node, neighbors: ->p{p.neighbors}, solved: ->n{n == goal_node})
#   # A*
#   pathfind(starts: node, neighbors: ->p{p.neighbors},
#     solved: ->n{n == goal_node},
#     heuristic: ->n{n.distance_to_target})
#
# Generic pathfinding helper method.
#
# Depending on the arguments passed, this can be equivalent to
# Dijkstra's, A*, or Bellman-Ford.
#
# +neighbors+ proc must return [node,edge_cost] pairs for the given node.
#
#   # Bellman-Ford
#   pathfind(negatives: true, starts: node, neighbors: ->p{p.neighbors})
#
# Bellman-Ford works correctly in the presence of negative weights, but is slower
# than the other options and can't terminate early when the target is first found.
#
#   # Dijkstra's
#   pathfind(starts: node, neighbors: ->p{p.neighbors}, solved: ->n{n == goal_node})
#
# Faster than Bellman-Ford, but can't handle negative weights. The +solved+ proc tells
# the algorithm when to exit early because the goal node has been found. If +solved+ is nil,
# this will exhaustively solve for all nodes.
#
#   # A*
#   pathfind(starts: node, neighbors: ->p{p.neighbors},
#     solved: ->n{n == goal_node},
#     heuristic: ->n{n.distance_to_target})
#
# Can be faster than Dijkstra's with a good heuristic function. In this impl, the
# correct solution will be found even if +heuristic+ isn't admissible --
# unless you early terminate by passing in the solved argument.
#
# @returns :costs Hash<Node,Integer> The minimum cost from start to each given node.
# Note this data may be incomplete if the function exits early due to the +solved+
# argument.
# @returns :prev Hash<Node,Node> A mapping from each node => prev_node for reconstructing
# paths taken. e.g. `unfold(goal) { |node| prev[node] }.to_a.reverse` to get a path
# to goal.
def pathfind(starts:, neighbors:, solved: nil, heuristic: nil, negatives: false, all_routes: false)
  starts = Array(starts)
  q = Wheel.new
  # [node, cost]
  starts.each { q.push(_1, 0) }
  qcounts = Hash.new(0) # only used if negatives == true
  results = {}
  starts.each { results[_1] = History[0, nil, nil] }
  unless neighbors.parameters in [*, [:block, _]]
    nold = neighbors
    neighbors = ->(u,&cb) { nold.(u).each { |n| cb.(n) } }
  end

  loop do
    u = q.pop
    break unless u
    if negatives
      qc = qcounts[u] += 1
      raise "negative cycle detected at #{u}" if qc > results.size
    end
    return results if solved&.(u)
    neighbors.(u) do |v,v_cost,edge|
      new_cost = (results[u].cost) + (v_cost||1)
      previously = results[v]
      next if previously && previously.cost < new_cost
      if !previously || previously.cost > new_cost
        results[v] = all_routes ? History[new_cost, [u], [edge]] : History[new_cost, u, edge]
        h = heuristic&.(v) || 0
        q.push(v, h+new_cost)
      elsif all_routes
        previously.prev << u
        previously.edge << edge
      end
    end
  end
  return results
end

History = Data.define :cost, :prev, :edge

Action = Data.define :state, :action, :cost do
  def to_a
    [state, cost, action]
  end
end

def best_plan(starts:, actions:, goal:)
  neighbors = ->(s, &cb) {
    actions.(s) { cb.(*it) }
  }
  results = pathfind(starts:, neighbors:, solved: goal)
  puts "results #{results.size}"

  final = results.find { |p,_| goal.(p) }&.last
  raise "no solution found" if final.nil?
  cost = final.cost
  history = []
  actions = []
  pos = final
  while pos
    actions.unshift pos.edge
    history.unshift pos
    pos = results[pos.prev]
  end
  # rm null starting action
  actions.shift

  { history:, actions:, cost: }
end
