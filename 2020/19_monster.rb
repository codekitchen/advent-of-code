FNAME = "19_full.txt"

rules_s, messages = File.read(FNAME).split("\n\n")

rules = {}
rules_s.split("\n").each do |r|
    idx, s = r.split(": ")
    rules[idx.to_i] = s.split(" | ").map { |p| p[0] == '"' ? [p[1]] : p.split(' ').map(&:to_i) }
end

# rules[8] = [[42], [42, 8]]
# rules[11] = [[42, 31], [42, 11, 31]]

def to_rx(rules, idx=0)
    return "(#{to_rx(rules, 42)})+" if idx == 8
    return "(?<r11>(#{to_rx(rules, 42)})\\g<r11>*(#{to_rx(rules, 31)}))" if idx == 11
    r = rules[idx]
    rxified = r.map { |option| option.map { |p| p.is_a?(String) ? p : to_rx(rules, p) }.join }
    if r.length == 1
        rxified[0]
    else
        "(#{rxified.join("|")})"
    end
end
rx = Regexp.new("\\A#{to_rx(rules)}\\z")
p rx

valids = messages.split("\n").filter { |m| rx.match?(m) }
p valids
p valids.size
