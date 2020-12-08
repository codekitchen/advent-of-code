require 'set'

def get_points(paths)
    res = Set.new
    steps = {}
    step = 0
    pos = [0, 0]
    for path in paths
        adv = case path[0]
        when 'R'; [ 1,  0]
        when 'L'; [-1,  0]
        when 'U'; [ 0,  1]
        when 'D'; [ 0, -1]
        end
        path[1..].to_i.times do
            step += 1
            pos[0] += adv[0]
            pos[1] += adv[1]
            if !res.include?(pos)
                res << pos.dup
                steps[pos.dup] = step
            end
        end
    end
    [res, steps]
end

wire1 = get_points(STDIN.gets.split(","))
wire2 = get_points(STDIN.gets.split(","))
common = wire1[0] & wire2[0]
distances = common.map { |(x,y)| x.abs+y.abs }
puts distances.min
steps = common.map { |pos| wire1[1][pos] + wire2[1][pos] }
puts steps.min
