# easier way to write simple regexp captures
# based on behavior of the nushell parse command
# parse("{loc} = ({l}, {r})") returns a regexp to capture those groups
# parse("{id}: {vals*}") will split vals to an array
class Parse
  def initialize(spec, repeat: nil, hash: false)
    @matchers = {}
    @repeat = repeat
    @hash = hash
    s = Regexp.escape(spec).gsub(/\\\{[^}]+\\\}/) do |m|
      info = {}
      m = m.tr("\\","")
      m = m[1...-1] # remove surrounds "{}"
      if m[-1] == '*'
        m = m[...-1] # remove "\*"
        info[:multi] = true
      elsif m[-1] == '?'
        m = m[...-1]
        opt = '?'
      end
      m, allowed = m.split(":")
      allowed = allowed ? "[#{Regexp.escape allowed}]" : '.'
      @matchers[m.to_sym] = info
      "(?<#{m}>#{allowed}+)#{opt}"
    end
    @rx = Regexp.new(s)
  end

  def parse(line)
    if @repeat
      line.split(@repeat).map { parse_one(_1) }
    else
      parse_one(line)
    end
  end

  def parse_one(line)
    md = @rx.match line
    raise "parse failed on #{line}" unless md
    md = md.deconstruct_keys nil
    # might need more control over splitting eventually
    @matchers.each { |k,info| md[k] = md[k]&.split(%r{,\s*|\s+}) if info[:multi] }
    md.keys.each { |k| md[k] = convert_numbers(md[k]) }
    # a little suspect, but just return the value if the parse string only has one
    return md.values.first if md.size <= 1
    @hash ? md : md.values
  end
  alias call parse

  def lines(input)
    input.each_line.map { self.(_1) }
  end

  def convert_numbers(val)
    case val
    when Array
      val.map { convert_numbers(_1) }
    when %r{^-?[0-9]+$}
      val.to_i
    when %r{^-?[.0-9]+$}
      val.to_f
    else
      val
    end
  end
end

if __FILE__ == $0
  def assert_eq(a,b)
    return if a == b
    raise "#{a.inspect} != #{b.inspect}"
  end
  assert_eq Parse.new('Card {id}: {wins*} | {nums*}', hash: true).('Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53'), { id: 1, wins: [41, 48, 83, 86, 17], nums: [83, 86, 6, 31, 17, 9, 48, 53] }
  assert_eq Parse.new('Card {id}: {wins*} | {nums*}').('Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53'), [1, [41, 48, 83, 86, 17], [83, 86, 6, 31, 17, 9, 48, 53]]
  assert_eq Parse.new('{ints*}').('0 3 6 9 12 15'), [0, 3, 6, 9, 12, 15]
  assert_eq Parse.new('{str} {nums*}', hash: true).('????.#...#... 4,1,1'), { str: '????.#...#...', nums: [4,1,1]}
  assert_eq Parse.new('{str} {nums*}').('????.#...#... 4,1,1'), ['????.#...#...', [4,1,1]]
  assert_eq Parse.new('{name}={age}', repeat:',', hash: true).('sally=45,joe=41'), [{name:'sally',age:45},{name:'joe',age:41}]
  assert_eq Parse.new('{label}{op:-=}{lens?}').('cm-'), ['cm', '-', nil]
  assert_eq Parse.new('{label}{op:-=}{lens?}',repeat:',').('rn=1,cm-,qp=3'), [ ['rn','=',1], ['cm','-',nil], ['qp','=',3], ]
end
