require 'ruby2d'
require 'cairo'

def render_viz(objs,cuts:[],preview:true)
  width, height = 1024, 768
  surface = Cairo::ImageSurface.new(width, height)
  ctx = Cairo::Context.new(surface)
  ctx.select_font_face("Menlo")
  objs = objs.map { |o| o.group_by { _1[:fr] }.map { |_,g| g.inject(:merge) } }
  objs = objs.sort_by.with_index { [_1.first[:fr], _2] }
  frames = objs.map { _1.last[:fr] }.max
  puts "total frames #{frames}"
  activeidx = 0
  active = []
  frame = 0
  anim_step = lambda do
    while cuts.any?{|c|c.include?(frame)}
      frame+=1
      return if frame >= frames
    end
    while activeidx < objs.length && objs[activeidx].first[:fr] <= frame
      active << objs[activeidx]
      activeidx += 1
    end
    active = active.select { |it| it.last[:always] || frame <= it.last[:fr] }.sort_by.with_index { [_1.first.fetch(:zo, 0), _2] }
    active.each do |obj|
      obj[0].merge!(obj.delete_at 1) while obj.size > 1 && obj[1][:fr] <= frame
      props = obj.first.dup
      if obj.size > 1
        lerp = (frame - props[:fr]).to_f / (obj[1][:fr] - props[:fr])
        lerp = 6.0 * lerp ** 5 - 15.0 * lerp ** 4 + 10.0 * lerp ** 3
        obj[1].each { |k,v| raise k.to_s if !props[k]; props[k] = (1-lerp)*props[k]+lerp*v if Numeric === v }
      end
      case props[:ob]
      when :fill
        ctx.identity_matrix
        ctx.set_source_rgba(*props.values_at(:rf, :gf, :bf, :af))
        ctx.paint
      when :view
        props => { x1:, y1:, x2:, y2: }
        ctx.identity_matrix
        ctx.translate width/2, height/2
        sc = [width / (x2-x1).abs, height / (y2-y1).abs].min
        ctx.scale sc,sc
        ctx.translate (x1+x2)*-0.5, (y1+y2)*-0.5
      when :box
        ctx.new_path
        props = {rc:0}.merge(props)
        props => { x1:, y1:, x2:, y2:, rc:, rf:, gf:, bf:, af: }
        ctx.arc x2-rc, y2-rc, rc, 0.0, 1.5707963268
        ctx.arc x1+rc, y2-rc, rc, 1.5707963268, 3.14159265359
        ctx.arc x1+rc, y1+rc, rc, 3.14159265359, 4.71238898039
        ctx.arc x2-rc, y1+rc, rc, 4.71238898039, 0.0
        ctx.close_path
        ctx.set_source_rgba rf, gf, bf, af
        ctx.fill_preserve
        if props[:lw]
          props => {lw:,rs:,gs:,bs:,as:}
          ctx.set_line_width lw
          ctx.set_source_rgba rs,gs,bs,as
          ctx.stroke
        end
        if props[:tx]
          props = {pa:0,xj:0,yj:0}.merge(props)
          props => { tx:, fs:, rt:, gt:, bt:, at:, pa:, xj:, yj: }
          ctx.set_font_size fs
          fnext = ctx.font_extents
          txext = ctx.text_extents tx
          ctx.move_to x1+pa+(x2-x1-2*pa-txext.x_advance)*xj, y1+pa+fnext.ascent+(y2-y1-2*pa-fnext.ascent-fnext.descent)*yj
          ctx.set_source_rgba rt, gt, bt, at
          ctx.show_text tx
        end
      else
        raise "unknown object type #{obj.inspect}"
      end
    end
    fname="viz/frame-%04d.png" % [frame]
    print "\r#{fname}"
    surface.write_to_png(fname)
    frame += 1
    fname
  end

  if preview
    set(width:, height:)
    img = nil
    update do
      fname = anim_step.()
      if !fname
        close
        return
      end
      img&.remove
      img = Image.new(fname, width:, height:)
      sleep 1.0 / 60
    end
    show
  else
    loop do
      fname = anim_step.()
      break if !fname
    end
  end
end
