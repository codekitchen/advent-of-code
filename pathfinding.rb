require 'pqueue'

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
# @returns Hash<Node,Integer> The minimum cost from start to each given node.
# Note this data may be incomplete if the function exits early due to the +solved+
# argument.
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
# though it will of course run slower.
def pathfind(starts:, neighbors:, solved: nil, heuristic: nil, negatives: false)
  starts = Array(starts)
  # [score+heuristic, score, node]
  q = PQueue.new(starts.map { [0, 0, _1] })
  opt = Hash.new(Float::INFINITY)
  starts.each { opt[_1] = 0 }
  qcounts = Hash.new(0)

  until q.empty?
    _, cost, u = q.shift # shift gives lowest cost, pop gives highest cost
    if negatives
      qc = qcounts[u] += 1
      raise 'negative cycle detected' if qc > opt.size
    end
    neighbors.(u).each do |v,v_cost|
      new_cost = (cost||opt[u]) + v_cost
      if negatives ? new_cost < opt[v] : opt[v] == Float::INFINITY
        opt[v] = new_cost
        return opt if solved&.(v)
        h = heuristic&.(v) || 0
        q << (negatives ? [h+new_cost, nil, v] : [h+new_cost, new_cost, v])
      end
    end
  end
  return opt
end
