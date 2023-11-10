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

  def each(&b)
    self[0..,0..].each(&b)
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

  class Rect < Struct.new(:grid, :xrange, :yrange)
    include Enumerable
    def each
      yrange.each { |y| xrange.each { |x| yield grid.at(x, y) } }
    end

    def to_s
      lasty = nil
      map { |c|
        nl=lasty&&lasty!=c.y&&"\n"
        lasty = c.y
        "#{nl||''}#{c.get}"
      }.join
    end
  end

  class Cell < Struct.new(:grid, :x, :y, :pos)
    def get
      grid.data[pos]
    end

    def set(val)
      grid.data[pos] = val
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
