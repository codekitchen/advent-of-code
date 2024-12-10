require_relative 'pqueue'

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
def pathfind(starts:, neighbors:, solved: nil, heuristic: nil, negatives: false)
  starts = Array(starts)
  # [score+heuristic, score, node]
  q = PQueue.new(starts.map { [0, 0, _1] }) { |a,b| a[0] <=> b[0] }
  costs = Hash.new(Float::INFINITY)
  starts.each { costs[_1] = 0 }
  qcounts = Hash.new(0) # only used if negatives == true
  prev = {}
  edges = {}
  upper_bound = Float::INFINITY

  catch :done do
    loop do
      _, cost, u = q.pop
      break unless u
      if negatives
        qc = qcounts[u] += 1
        raise "negative cycle detected at #{u}" if qc > costs.size
      end
      throw :done if solved&.(u)
      neighbors.(u).each do |v,v_cost,edge|
        new_cost = (cost||costs[u]) + v_cost
        next if new_cost > upper_bound
        if negatives ? new_cost < costs[v] : costs[v] == Float::INFINITY
          costs[v] = new_cost
          prev[v] = u
          edges[v] = edge if edge
          upper_bound = new_cost if solved&.(v) && new_cost < upper_bound
          h = heuristic&.(v) || 0
          q << (negatives ? [h+new_cost, nil, v] : [h+new_cost, new_cost, v])
        end
      end
    end
  end
  return { costs:, prev:, edges: }
end

Action = Data.define :state, :action, :cost

def best_plan(starts:, actions:, goal:)
  neighbors = ->state{
    actions.(state).map { |action| [action.state, action.cost, action.action] }
  }
  pathfind(starts:, neighbors:, solved: goal) => { prev:, costs:, edges: }
  puts "prev #{prev.size} costs #{costs.size} edges #{edges.size}"

  final = costs.keys.find { |p| goal.(p) }
  history = []
  actions = []
  cost = costs[final]
  pos = final
  while pos
    actions.unshift edges[pos]
    history.unshift pos
    pos = prev[pos]
  end
  # rm null starting action
  actions.shift

  { history:, actions:, cost: }
end
