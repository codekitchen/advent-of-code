class D
  attr_accessor :name, :entries, :parent
  def initialize(name, parent = nil)
    self.name = name
    self.entries = {}
    self.parent = parent
  end

  def adddir(name)
    self.entries[name] = D.new(name, self)
  end

  def addfile(name, size)
    self.entries[name] = F.new(name, size)
  end

  def to_s(indent_self = '', indent_child = '')
    sz = size.to_s
    just = 30 - (indent_self.length + name.length)
    "#{indent_self}📁 #{self.name} #{sz.rjust(just)}\n" +
      self.entries.values.each_with_index.map { |e,i| lastchild = i == self.entries.length - 1; e.to_s("#{indent_child}#{lastchild ? '└' : '├'} ", "#{indent_child}#{lastchild ? ' ' : '│'} ") }.join("\n")
  end

  def size
    entries.values.sum(&:size)
  end

  def dirs
    self.entries.values.select { |e| D === e }
  end

  def alldirs
    [self] + self.dirs.flat_map(&:alldirs)
  end
end

class F < Struct.new(:name, :size)
  def to_s(indent = '', _ = '')
    sz = size.to_s
    just = 30 - (indent.length + name.length)
    "#{indent}📄 #{name} #{sz.rjust(just)}"
  end
end

toplevel = D.new("/")
cd = toplevel

ARGF.each_line do |line|
  case line.split
  in %w($ ls) | %w($ cd /)
    # nothing
  in %w($ cd ..)
    cd = cd.parent || raise("can't cd ..")
  in ["$", "cd", dirname]
    cd = cd.entries[dirname] || raise("didn't find dir #{dirname}")
  in ["dir", dirname]
    cd.adddir(dirname)
  in [sz, fname]
    cd.addfile(fname, Integer(sz))
  else
    raise "unrecognized: #{line}"
  end
end

puts toplevel
puts

# binding.irb
p toplevel.alldirs.map(&:size).select { |s| s <= 100_000 }.sum

total_space = 70000000
req_space = 30000000
free_space = total_space - toplevel.size
needed = req_space - free_space

found = toplevel.alldirs.sort_by(&:size).find { |d| needed <= d.size }
p found.name, found.size
