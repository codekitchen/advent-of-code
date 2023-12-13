require 'pathname'

script = Pathname.new($0)
day = script.basename(".rb")

inputs = (script.dirname.glob("*.txt"))
def inputs_for(inputs, partname)
  inputs.filter_map do |f|
    name = f.basename('.txt').to_s
    if f.empty?
      warn "skipping empty input file #{f.basename}"
      next
    end
    if (name !~ /part/ || name =~ /#{partname}/)
      [name.gsub(/#{partname}_?/, ''), f]
    end
  end
end

END {
  private_methods.grep(/part\d+/).sort.each do |part|
    files = inputs_for(inputs, part)
    if files.empty?
      warn "no files found for #{part}"
      next
    end
    files.each do |name, file|
      puts "#{part} #{name}", send(part, file).inspect
    end
  end
}
