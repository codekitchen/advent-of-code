instructions = ARGF.each_line.map(&:split)
pos = depth = 0
instructions.each do |dir,len|
  len = len.to_i
  case dir
  when "forward"
    pos += len
  when "down"
    depth += len
  when "up"
    depth -= len
  end
end
p pos * depth

# part 2
pos = depth = aim = 0
instructions.each do |dir,len|
  len = len.to_i
  case dir
  when "forward"
    pos += len
    depth += len * aim
  when "down"
    aim += len
  when "up"
    aim -= len
  end
end
p pos * depth
