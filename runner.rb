require 'pathname'

script = Pathname.new($0)
day = script.basename(".rb")

INPUTS = script.dirname.glob("*.txt").to_h { [_1.basename('.txt').to_s,_1] }

def inputs_for(partname)
  INPUTS.filter_map do |name,f|
    if f.empty?
      warn "skipping empty input file #{f.basename}"
      next
    end
    if (name !~ /part/ || name =~ /#{partname}/)
      [name.gsub(/#{partname}_?/, ''), f]
    end
  end
end

at_exit do
  next if $! # skip runs if an exception was thrown before here
  private_methods.grep(/part\d+/).sort.each do |part|
    files = inputs_for(part)
    if files.empty?
      warn "no files found for #{part}"
      next
    end
    files.each do |name, file|
      puts "#{part} #{name}", send(part, file).inspect
    end
  end
end
