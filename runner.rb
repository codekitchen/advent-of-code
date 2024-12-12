require 'pathname'
require 'optparse'

return if $skip_runner

$viz = false
script = Pathname.new($0)
$day = script.basename(".rb")

INPUTS = script.dirname.glob("*.txt").to_h { [_1.basename('.txt').to_s,_1] }

OptionParser.new do |opts|
  opts.banner = "Usage: #{File.basename $0} [-v|--viz] [input_filename]"
  opts.on("-v", "--viz", "Enable viz") { $viz = _1 }
  opts.on("-pPART", "--part=PART", "Part to run") { $runpart = _1 }
  opts.on("-iINPUT", "--input=INPUT", "Input to run") { ($runinput ||= []) << _1 }
end.parse!

def inputs_for(partname)
  INPUTS.filter_map do |name,f|
    next if $runinput && $runinput.grep(name).empty?
    if f.empty?
      # warn "skipping empty input file #{f.basename}"
      next
    end
    if (name !~ /part/ || name =~ /#{partname}/)
      [name.gsub(/#{partname}_?/, ''), f]
    end
  end.sort_by { |name,f| [name =~ /full/ ? 1 : 0, name] }
end

Result = Struct.new(:name, :called) do
  def method_missing(part, result)
    puts "#{part} #{self.name}", result.inspect
    self.called = true
  end
end

def do_run(part, name, file)
  dumpfile = File.open("viz/#{$day}_#{part}_#{name}.dump", "wb") if $viz

  takes_result = method(part).arity > 1
  if takes_result
    result_obj = Result.new(name, false)
    run = Fiber.new { send(part, file, result_obj) }
  else
    run = Fiber.new { send(part, file) }
  end
  result = loop do
    nxt = run.resume
    if run.alive?
      Marshal.dump(nxt, dumpfile) if $viz
    else
      break nxt
    end
  end
  puts "#{part} #{name}", result.inspect unless takes_result
end

at_exit do
  next if $! # skip runs if an exception was thrown before here
  private_methods.grep(/part\d+/).sort.each do |part|
    next if $runpart && !part.to_s.match($runpart)
    files = inputs_for(part)
    if files.empty?
      warn "no files found for #{part}"
      next
    end
    files.each { |name, file| do_run(part, name, file) }
  end
  private_methods.grep(/^run$/).each do |runner|
    files = inputs_for('all')
    files.each { |name, file| do_run('run', name, file) }
  end
end
