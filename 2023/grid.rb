class Grid
  include Enumerable

  attr_reader :cols, :rows, :data

  def initialize(cols, rows, data=nil)
    @cols = cols
    @rows = rows
    n = rows*cols
    raise("bad input length: #{data.length}") if data && data.length != n
    @data = data || Array.new(n)
  end

  def self.from_input(input)
    input = input.lines.map(&:chomp)
    new(input.first.size, input.size, input.join)
  end

  def each(&)
    self[0..,0..].each(&)
  end

  def[](x,y)
    if Range === x
      x = Range.new(0, x.end, x.exclude_end?) if x.begin.nil?
      x = (x.begin...@cols) if x.end.nil?
      y = (y..y) if Integer === y
    end
    if Range === y
      y = Range.new(0, y.end, y.exclude_end?) if y.begin.nil?
      y = (y.begin...@rows) if y.end.nil?
      x = (x..x) if Integer === x
    end
    if Integer === x
      at(x,y)&.get
    else
      Rect.new(self, x, y)
    end
  end

  def at(x,y)
    return nil if x < 0 || y < 0 || x >= cols || y >= rows
    Cell.new(self, x, y, x+y*@cols)
  end

  def inspect
    "#<Grid #{cols}x#{rows}>"
  end

  def to_s
    self[0..,0..].to_s
  end

  Rect = Data.define(:grid, :xrange, :yrange) do
    include Enumerable
    def each
      yrange.each { |y| xrange.each { |x| yield grid.at(x, y) } }
    end

    def to_s
      lasty = nil
      map { |c|
        nl=lasty&&lasty!=c.y&&"\n"
        lasty = c.y
        "#{nl||''}#{c.get || ' '}"
      }.join
    end
  end

  Cell = Data.define(:grid, :x, :y, :pos) do
    def get
      grid.data[pos]
    end

    def set(val)
      grid.data[pos] = val
      self
    end

    def r
      n = grid.at(x+1, y)
      n && self.get =~ /[-FL]/ && n.get =~ /[-7J]/ && n
    end
    def l
      n = grid.at(x-1, y)
      n && self.get =~ /[-7J]/ && n.get =~ /[-FL]/ && n
    end
    def u
      n = grid.at(x, y-1)
      n && self.get =~ /[\|LJ]/ && n.get =~ /[\|F7]/ && n
    end
    def d
      n = grid.at(x, y+1)
      n && self.get =~ /[\|F7]/ && n.get =~ /[\|LJ]/ && n
    end

    def connected
      [l, r, u, d].compact
    end

    def inside_corner
      case get
      when 'F' then grid.at(x+1, y+1)
      when '7' then grid.at(x-1, y+1)
      when 'J' then grid.at(x-1, y-1)
      when 'L' then grid.at(x+1, y-1)
      end
    end

    def neighbors
      [
        grid.at(x-1, y),
        grid.at(x+1, y),
        grid.at(x, y-1),
        grid.at(x, y+1),
      ].compact
    end
  end
end
