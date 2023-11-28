input = ARGF.each_line.map(&:chomp).map(&:to_i)
p input.each_cons(2).count { |a,b| b > a }

windows = input.each_cons(3).map { _1.sum }
p windows.each_cons(2).count { |a,b| b > a }
