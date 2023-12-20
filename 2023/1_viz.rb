require_relative '../viz_cairo'
require_relative '../utils'

def obj(type, fr:0, **att)
  { ob:type, fr:, **att }
end
def color(prefix, r, g, b, a=1)
  {"r#{p=prefix}":r,"g#{p}":g,"b#{p}":b,"a#{p}":a}
end
def rect(x1, y1, x2=nil, y2=nil, w:nil, h:nil)
  x2||=x1+w
  y2||=y1+h
  {x1:,y1:,x2:,y2:}
end

VALS=
  %w[zero one two three four five six seven eight nine].each.with_index.to_h{[_1,_2]}
  .merge((0..9).to_h{[_1.to_s,_1]})
def findit(line, it)
  it.each { |i| VALS.each { |k,v| return [i,k,v] if line[i..].start_with?(k) } }
  raise "not found in #{line}"
end

imgw, imgh = 1024,768

bg = [obj(:fill, **color(:f, 1, 1, 1))]
view = [obj(:view, **rect(0, 0, imgw, 40))]
valuelb = [obj(:box,lw:4,rc:20,
  **rect(40,340,w:320,h:40),
  **color(:f,0.9,0.9,0.9),
  **color(:s,0.1,0.1,0.1,0.5),
  **color(:t,0,0,0),
  fs:20,pa:10,xj:0.5,
  tx:("Value %5s"%[0])
)]
totallb = [obj(:box,lw:4,rc:20,
  **rect(40,280,w:320,h:40),
  **color(:f,0.9,0.9,0.9),
  **color(:s,0.1,0.1,0.1,0.5),
  **color(:t,0,0,0),
  fs:20,pa:10,xj:0.5,
  tx:("Total %5s"%[0])
)]

strings=[]
firsts=[]
lasts=[]
total=0
fr=0

CHARW=15
FS=25

input=File.read(File.join(__dir__,'1/full.txt'))
input.each_line.with_index do |l,i|
  l.strip!
  view << {fr:fr+30,y1:40*i,y2:40*i+40}
  string = [obj(:box,
    **rect(400,40*i,w:800,h:40),
    **color(:f,0,0,0,0),
    **color(:t,0,0,0),
    fs:FS,pa:0,xj:0,yj:0.5,tx:l,
  )]
  strings << string
  firsti, firstk, firstv = findit(l,0...l.length)
  first = [
    obj(:box,fr:,rc:5,**rect(400,40*i+4,w:CHARW,h:FS+4),**color(:f,1,0,0,0.3)),
    {fr:fr+30,x1:400+CHARW*firsti,x2:400+CHARW*(firsti+firstk.size)},
  ]
  firsts << first
  lasti, lastk, lastv = findit(l,(0...l.length).reverse_each)
  last = [
    obj(:box,fr:,rc:5,**rect(400+CHARW*(l.size-1),40*i+4,w:CHARW,h:FS+4),**color(:f,0,0,1,0.3)),
    {fr:fr+30,x1:400+CHARW*lasti,x2:400+CHARW*(lasti+lastk.size)},
  ]
  lasts << last
  value=firstv*10+lastv
  valuelb << {fr:fr+15,tx:("Value %5s"%[value])}
  total+=value
  totallb << {fr:fr+15,tx:("Total %5s"%[total])}
  fr+=30
end

objs = [bg, totallb, valuelb, view, *firsts, *lasts, *strings]
fr+=60
objs.each {_1 << {fr:}}

# pp objs
render_viz objs, cuts:[1024..], preview:false
