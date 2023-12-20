# backtick_javascript: true
require 'opal'
require 'native'
require 'json'
require 'corelib/pattern_matching'

def start_viz(objs)
  objs = JSON.from_object(objs)
  objs = objs.map { |o| o.group_by { |it| it[:fr] }.map { |_,g| g.inject(:merge) } }
  objs = objs.sort_by { |it| it.first[:fr] }
  $frames = objs.map { |it| it.last[:fr] }.max
  # puts "max frame #{$frames}"
  $activeidx = 0
  $active = []
  viz(objs)
end

def rgba(rf, gf, bf, af)
  "rgba(#{rf*255}, #{gf*255}, #{bf*255}, #{af})"
end

def viz(objs)
  start = $start ||= %x{Date.now()}
  ctx = %x{document.getElementById("canvas").getContext("2d")}

  frame = (%x(Date.now() - start) / 1000 * 30).to_i
  return if frame > $frames
  # print "frame #{frame}"
  width, height = 1280, 720
  while $activeidx < objs.length && objs[$activeidx].first[:fr] <= frame
    $active << objs[$activeidx]
    $activeidx += 1
  end
  $active = $active.select { |it| it.last[:always] || frame <= it.last[:fr] }.sort_by.with_index { |it,i| [it.first.fetch(:zo, 0), i] }
  $active.each do |obj|
    obj[0].merge!(obj.delete_at 1) while obj.size > 1 && obj[1][:fr] <= frame
    props = obj.first.dup
    if obj.size > 1
      lerp = (frame - props[:fr]).to_f / (obj[1][:fr] - props[:fr])
      lerp = 6.0 * lerp ** 5 - 15.0 * lerp ** 4 + 10.0 * lerp ** 3
      obj[1].each { |k,v|  props[k] = (1-lerp)*props[k]+lerp*v if Numeric === v }
    end
    case props[:ob]
    when :fill
      ctx.JS.resetTransform
      ctx.JS.fillStyle = rgba(*props.values_at(:rf, :gf, :bf, :af))
      ctx.JS.fillRect(0, 0, 1024, 768)
    when :view
      props => { x1:, y1:, x2:, y2: }
      ctx.JS.resetTransform
      ctx.JS.translate width/2, height/2
      sc = [width / (x2-x1).abs, height / (y2-y1).abs].min
      ctx.JS.scale sc,sc
      ctx.JS.translate (x1+x2)*-0.5, (y1+y2)*-0.5
    when :box
      props => { x1:, y1:, x2:, y2:, rc: }
      ctx.JS.beginPath
      ctx.JS.arc x2-rc, y2-rc, rc, 0.0, 1.5707963268
      ctx.JS.arc x1+rc, y2-rc, rc, 1.5707963268, 3.14159265359
      ctx.JS.arc x1+rc, y1+rc, rc, 3.14159265359, 4.71238898039
      ctx.JS.arc x2-rc, y1+rc, rc, 4.71238898039, 0.0
      ctx.JS.closePath
      ctx.JS.fillStyle = rgba(*props.values_at(:rf, :gf, :bf, :af))
      ctx.JS.fill
      if props[:tx]
        props => { tx:, fs: }
        pa = 3
        xj = yj = 0
        ctx.JS.font = "#{fs}px serif"
        ctx.JS.textAlign = "center"
        # fnext = ctx.font_extents
        # txext = ctx.text_extents tx
        # ctx.JS.moveTo x1+pa+(x2-x1-2*pa-txext.y_advance)*xj, y1+pa+fnext.ascent+(y2-y1-2*pa-fnext.ascent-fnext.descent)*yj
        # x = x1+pa+(x2-x1-2*pa)*0.5
        # y = y1+pa+(y2-y1-2*pa)*0.5
        x = x1+(x2-x1)*0.5
        y = y1+(y2-y1)*0.8
        ctx.JS.fillStyle = rgba(1,1,1,1)
        ctx.JS.fillText(tx, x, y)
      end
    end
  end

  $$.requestAnimationFrame { viz(objs) }
end

$$.fetch('viz/16_part1_example.json').then { |res|
  # wtf
  cb = ->j{start_viz(j)}
  %x{res.json().then(cb)}
}
