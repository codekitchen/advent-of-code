require 'set'

rules = DATA.each_line.map do |line|
    outer, rest = line.split(" contain ")
    def bagname(s) = s.match(/(\d+)? ?([\w ]+) bags?\.?/)[1..2]
    outer = bagname(outer)[1]
    rest = rest.split(", ").map { |r| bagname(r) }
    [outer, rest]
end

outer_to_inner = Hash.new { |h,k| h[k] = [] }
inner_to_outer = Hash.new { |h,k| h[k] = [] }
rules.each do |(outer, inners)|
    inners.each { |(c, inner)|
        inner_to_outer[inner] << outer
        outer_to_inner[outer] << [c.to_i, inner]
    }
end

MYBAG = "shiny gold"
checks = inner_to_outer[MYBAG].dup
found = Set.new
until checks.empty?
    check = checks.pop
    found << check
    inner_to_outer[check].each { |o| checks << o unless found.include?(o) }
end

p found
p found.size

def nest(outer_to_inner, outer)
    outer_to_inner[outer].map { |(c,inner)| c + c * nest(outer_to_inner, inner) }.sum
end
p nest(outer_to_inner, MYBAG)

__END__
vibrant salmon bags contain 1 vibrant gold bag, 2 wavy aqua bags, 1 dotted crimson bag.
dotted plum bags contain 3 wavy cyan bags.
muted salmon bags contain 2 pale purple bags, 3 dull orange bags, 2 dotted lime bags, 3 clear crimson bags.
wavy green bags contain 1 plaid crimson bag.
light salmon bags contain 3 posh lime bags, 1 plaid plum bag, 3 faded yellow bags, 4 clear fuchsia bags.
dim violet bags contain 4 drab tan bags, 4 drab violet bags, 2 faded coral bags, 4 dark white bags.
dim black bags contain 4 posh lime bags.
drab indigo bags contain 4 light aqua bags, 2 light white bags, 4 clear plum bags.
clear purple bags contain 4 drab olive bags, 2 vibrant chartreuse bags.
wavy indigo bags contain 3 clear maroon bags, 4 striped blue bags, 2 wavy gray bags, 2 dim magenta bags.
drab olive bags contain 2 shiny salmon bags, 4 mirrored white bags, 4 mirrored fuchsia bags.
plaid crimson bags contain 2 dull chartreuse bags, 4 striped maroon bags, 4 dull crimson bags, 4 plaid red bags.
pale lavender bags contain 4 dotted tan bags, 5 striped olive bags.
vibrant maroon bags contain 2 faded plum bags, 4 wavy aqua bags, 5 drab lavender bags, 4 light lavender bags.
wavy coral bags contain 5 drab purple bags.
drab salmon bags contain 4 shiny tan bags, 2 shiny white bags.
light green bags contain 5 dim turquoise bags, 4 striped crimson bags, 5 dim salmon bags, 3 clear gray bags.
dark indigo bags contain 5 shiny crimson bags.
dark blue bags contain 3 drab indigo bags, 2 shiny beige bags, 2 shiny coral bags.
shiny cyan bags contain 2 striped aqua bags, 2 drab turquoise bags, 5 light purple bags.
pale cyan bags contain 2 muted violet bags, 2 clear beige bags, 1 clear indigo bag, 5 striped turquoise bags.
muted lime bags contain 5 drab silver bags.
shiny brown bags contain 4 clear purple bags, 5 striped chartreuse bags, 5 pale lavender bags.
muted purple bags contain 4 dark purple bags, 2 dull crimson bags.
plaid turquoise bags contain 2 clear gray bags, 4 clear magenta bags, 4 dull bronze bags.
clear cyan bags contain 3 dotted plum bags, 3 shiny coral bags.
shiny violet bags contain 3 drab chartreuse bags, 1 pale aqua bag, 3 bright aqua bags.
wavy tan bags contain 5 dark magenta bags, 4 dull beige bags, 1 wavy cyan bag.
mirrored lime bags contain 2 clear plum bags, 3 dark bronze bags, 5 faded turquoise bags, 5 plaid crimson bags.
wavy purple bags contain 3 dark bronze bags, 2 bright bronze bags.
plaid plum bags contain 5 muted tan bags, 1 drab teal bag, 2 dark purple bags, 1 dotted blue bag.
dotted cyan bags contain 4 vibrant fuchsia bags, 3 muted plum bags.
striped white bags contain 3 faded salmon bags, 4 plaid cyan bags, 5 wavy gray bags.
posh black bags contain 2 dotted blue bags, 3 muted crimson bags.
dotted bronze bags contain 2 posh tan bags.
muted gray bags contain 2 posh green bags.
plaid violet bags contain 4 muted orange bags.
muted green bags contain 3 drab silver bags, 2 mirrored maroon bags, 3 dark teal bags.
dotted tan bags contain 3 pale black bags.
dim beige bags contain 4 light plum bags, 4 posh blue bags, 4 dotted purple bags.
posh magenta bags contain 2 clear purple bags, 4 posh aqua bags.
bright coral bags contain 5 light bronze bags, 2 vibrant crimson bags, 4 dark gold bags.
pale bronze bags contain 1 striped orange bag.
dim lime bags contain 3 dim green bags.
plaid green bags contain 2 faded brown bags, 3 faded bronze bags, 3 pale green bags, 5 plaid magenta bags.
vibrant cyan bags contain 5 pale black bags, 5 vibrant violet bags, 1 mirrored red bag.
dotted fuchsia bags contain 3 dull crimson bags, 2 wavy silver bags, 4 muted purple bags.
dim red bags contain 2 clear indigo bags, 5 dotted yellow bags.
faded black bags contain 4 bright fuchsia bags.
faded chartreuse bags contain 4 striped orange bags.
plaid blue bags contain 5 dim gray bags, 2 pale salmon bags, 2 muted orange bags.
plaid teal bags contain 5 bright lavender bags.
drab magenta bags contain 2 dim crimson bags, 1 bright fuchsia bag.
clear violet bags contain 3 mirrored white bags, 5 faded lime bags, 2 light olive bags, 1 dotted turquoise bag.
posh tan bags contain 3 posh orange bags, 1 vibrant purple bag, 4 posh gray bags, 2 mirrored fuchsia bags.
posh red bags contain 5 mirrored red bags.
striped lavender bags contain 5 dotted crimson bags, 1 dotted purple bag.
dull salmon bags contain 1 wavy black bag, 2 dull lime bags, 3 bright plum bags, 2 dark gray bags.
light tan bags contain 3 wavy violet bags, 1 shiny olive bag, 5 bright brown bags.
pale orange bags contain 5 vibrant orange bags, 3 wavy black bags.
mirrored green bags contain 1 dark tan bag.
plaid gray bags contain 4 muted magenta bags.
dim maroon bags contain 3 light magenta bags, 4 dull red bags.
dull cyan bags contain 1 wavy blue bag, 1 dark chartreuse bag.
mirrored blue bags contain 4 dark cyan bags, 4 muted magenta bags, 2 striped olive bags, 1 posh gold bag.
plaid purple bags contain 1 shiny orange bag, 5 plaid coral bags, 4 dim red bags, 5 faded aqua bags.
vibrant magenta bags contain 5 posh aqua bags, 5 shiny chartreuse bags, 4 dark teal bags.
bright indigo bags contain 1 dark bronze bag.
bright yellow bags contain 4 muted lime bags, 1 drab maroon bag.
clear gold bags contain 2 striped blue bags, 3 clear green bags, 4 drab indigo bags.
wavy red bags contain 5 faded fuchsia bags, 5 mirrored indigo bags.
dark coral bags contain 3 drab aqua bags, 5 bright fuchsia bags.
striped teal bags contain 1 clear red bag, 3 drab magenta bags, 4 dim green bags, 2 dark fuchsia bags.
pale salmon bags contain 1 muted gray bag, 4 dotted lavender bags, 3 dark maroon bags, 4 plaid plum bags.
dull plum bags contain 3 dim black bags, 5 shiny aqua bags, 3 pale teal bags, 4 clear purple bags.
plaid indigo bags contain 4 drab maroon bags, 2 shiny chartreuse bags, 4 shiny yellow bags, 1 pale violet bag.
shiny orange bags contain 5 bright silver bags, 2 light olive bags, 5 light beige bags.
dotted salmon bags contain 4 posh chartreuse bags, 4 light crimson bags, 5 muted yellow bags.
vibrant aqua bags contain 2 dull brown bags.
shiny bronze bags contain 1 mirrored teal bag, 2 drab tomato bags.
dark black bags contain 5 muted red bags, 5 mirrored crimson bags.
muted bronze bags contain 3 clear tomato bags, 1 vibrant purple bag.
faded beige bags contain 1 shiny blue bag, 5 plaid lime bags.
pale green bags contain 2 pale crimson bags, 4 muted cyan bags.
vibrant bronze bags contain 1 bright lavender bag.
posh salmon bags contain 1 clear green bag, 2 plaid yellow bags, 3 bright orange bags.
dull yellow bags contain 1 clear plum bag, 2 dim bronze bags.
mirrored indigo bags contain 5 dark tomato bags, 5 pale coral bags, 5 light magenta bags, 5 striped turquoise bags.
muted chartreuse bags contain 3 dark tan bags, 4 dotted teal bags.
drab bronze bags contain 3 pale lavender bags, 1 bright salmon bag, 4 plaid red bags.
dim cyan bags contain 1 bright plum bag.
drab purple bags contain 1 dim fuchsia bag, 4 mirrored turquoise bags, 5 striped blue bags.
pale violet bags contain 5 posh brown bags, 5 striped plum bags, 1 dotted indigo bag.
wavy maroon bags contain 3 shiny blue bags, 3 wavy cyan bags, 1 faded purple bag, 4 posh lime bags.
vibrant coral bags contain 3 shiny turquoise bags, 4 mirrored maroon bags.
vibrant lavender bags contain 2 drab turquoise bags, 2 clear red bags.
striped fuchsia bags contain 4 dotted tan bags, 4 posh silver bags, 4 clear maroon bags, 5 wavy fuchsia bags.
muted lavender bags contain 2 pale aqua bags, 2 bright green bags, 5 posh beige bags.
posh tomato bags contain 2 vibrant bronze bags, 3 light brown bags, 5 posh indigo bags.
dull lavender bags contain 2 wavy olive bags.
mirrored violet bags contain 5 wavy violet bags, 2 posh cyan bags, 2 dull olive bags, 3 drab yellow bags.
mirrored chartreuse bags contain 2 shiny salmon bags, 5 dark purple bags, 2 posh lime bags.
dim brown bags contain 4 clear red bags, 1 drab blue bag, 1 pale silver bag, 5 dark gray bags.
striped magenta bags contain 1 light orange bag, 4 muted beige bags.
light red bags contain 3 shiny yellow bags, 3 faded tan bags, 3 vibrant lime bags, 3 muted coral bags.
muted olive bags contain 4 drab coral bags, 5 light salmon bags, 1 vibrant violet bag.
clear silver bags contain 1 posh aqua bag, 1 drab teal bag, 4 dark orange bags.
faded orange bags contain 4 vibrant purple bags, 4 wavy cyan bags, 1 drab brown bag.
mirrored crimson bags contain 5 light aqua bags, 1 wavy olive bag, 2 vibrant lime bags.
shiny plum bags contain 2 shiny maroon bags, 3 dark red bags.
faded green bags contain 3 striped turquoise bags.
bright orange bags contain 1 dull crimson bag, 1 pale lavender bag, 5 shiny aqua bags.
dim gray bags contain 2 drab indigo bags, 5 dim turquoise bags.
mirrored plum bags contain 1 vibrant red bag, 4 dotted purple bags.
posh gold bags contain 4 bright red bags.
posh silver bags contain 3 drab coral bags, 1 faded tan bag, 1 bright silver bag, 1 shiny blue bag.
dull lime bags contain 5 muted tan bags, 4 mirrored cyan bags.
faded turquoise bags contain 2 pale teal bags, 2 bright green bags.
bright salmon bags contain 1 dim white bag, 2 clear tomato bags, 1 bright aqua bag.
dim gold bags contain 3 mirrored turquoise bags, 5 wavy tomato bags.
dull fuchsia bags contain 2 pale beige bags, 1 dotted yellow bag.
dark beige bags contain 2 pale magenta bags.
dotted maroon bags contain 2 dark tomato bags, 2 light gray bags, 3 faded teal bags, 1 clear gray bag.
muted white bags contain 3 dull turquoise bags, 5 dark bronze bags, 1 light olive bag, 3 clear bronze bags.
faded blue bags contain 1 dark chartreuse bag, 3 pale aqua bags, 5 faded crimson bags.
clear aqua bags contain 3 vibrant olive bags, 5 clear crimson bags.
faded cyan bags contain 1 vibrant blue bag, 1 light magenta bag.
shiny aqua bags contain 1 clear green bag.
bright gray bags contain 2 dim fuchsia bags, 1 striped chartreuse bag, 2 clear aqua bags, 2 dull olive bags.
bright white bags contain 2 light purple bags, 5 bright aqua bags.
bright lime bags contain 1 pale orange bag, 5 plaid magenta bags, 4 mirrored maroon bags.
dark lavender bags contain 5 mirrored bronze bags, 4 dotted aqua bags.
striped chartreuse bags contain 3 striped indigo bags, 2 faded plum bags, 4 clear gray bags.
muted magenta bags contain 3 clear red bags, 3 dull crimson bags, 1 clear aqua bag, 4 faded tomato bags.
clear magenta bags contain 2 striped cyan bags, 5 vibrant lime bags, 4 striped salmon bags.
pale yellow bags contain 3 faded fuchsia bags, 2 dotted lime bags, 5 pale gold bags, 1 plaid tomato bag.
dull teal bags contain 4 dim green bags, 1 drab maroon bag, 2 dim crimson bags.
pale brown bags contain 5 drab orange bags, 2 dotted purple bags, 3 plaid olive bags, 3 pale black bags.
posh blue bags contain 4 faded purple bags, 4 drab turquoise bags.
pale olive bags contain 5 muted silver bags, 3 mirrored plum bags, 4 vibrant lime bags, 5 striped olive bags.
plaid black bags contain 3 posh yellow bags.
striped tomato bags contain 4 faded blue bags, 2 shiny magenta bags.
wavy tomato bags contain 1 pale gold bag, 2 dim magenta bags.
faded plum bags contain 3 light violet bags, 3 posh beige bags, 3 striped aqua bags, 4 dim magenta bags.
vibrant turquoise bags contain 3 muted silver bags, 5 dotted black bags.
dull white bags contain 5 dim gray bags, 1 faded crimson bag.
faded purple bags contain 1 vibrant orange bag, 4 pale crimson bags, 5 shiny blue bags, 1 light gold bag.
clear white bags contain 1 striped orange bag, 3 pale coral bags, 5 plaid chartreuse bags.
striped maroon bags contain 2 wavy olive bags.
light tomato bags contain 2 pale crimson bags, 3 bright fuchsia bags, 2 pale salmon bags, 3 pale olive bags.
drab tomato bags contain 1 pale olive bag.
dark aqua bags contain 1 shiny magenta bag, 4 faded lime bags, 4 faded gold bags.
plaid bronze bags contain 2 pale purple bags.
dark plum bags contain 3 wavy brown bags, 1 bright salmon bag.
dark purple bags contain 4 dotted red bags.
light teal bags contain 1 vibrant indigo bag, 5 wavy olive bags, 4 clear maroon bags, 1 light silver bag.
drab fuchsia bags contain 3 faded turquoise bags, 5 dim yellow bags.
light turquoise bags contain 1 dotted blue bag, 4 mirrored tomato bags.
clear maroon bags contain 4 mirrored green bags.
posh maroon bags contain 3 dim black bags, 3 bright gold bags, 3 mirrored white bags, 1 clear lavender bag.
dotted blue bags contain 2 wavy maroon bags.
bright tan bags contain 4 faded turquoise bags, 5 drab coral bags, 5 dull red bags, 2 dim gray bags.
dark salmon bags contain 4 clear fuchsia bags, 5 mirrored red bags.
mirrored fuchsia bags contain 4 bright tomato bags, 3 vibrant orange bags.
vibrant green bags contain 1 clear lavender bag.
dim white bags contain 5 dull red bags.
light white bags contain 3 dark purple bags, 1 mirrored fuchsia bag, 1 plaid gold bag, 1 posh lime bag.
dark turquoise bags contain 3 striped green bags, 1 dull gold bag, 2 pale gray bags.
light purple bags contain 5 muted brown bags, 5 muted purple bags, 4 dull yellow bags, 5 vibrant gold bags.
posh lavender bags contain 5 posh yellow bags, 4 plaid plum bags, 1 dark fuchsia bag, 1 bright maroon bag.
posh crimson bags contain 1 vibrant gold bag, 5 clear green bags, 2 posh chartreuse bags.
wavy lime bags contain 5 mirrored beige bags.
wavy black bags contain 1 plaid orange bag, 4 shiny green bags, 3 shiny blue bags, 4 muted red bags.
muted red bags contain 4 vibrant lime bags, 2 drab black bags, 4 vibrant red bags, 5 faded beige bags.
vibrant gold bags contain 2 bright silver bags, 4 faded teal bags, 2 vibrant orange bags, 3 striped salmon bags.
shiny crimson bags contain 2 bright yellow bags.
muted turquoise bags contain 5 bright plum bags.
posh orange bags contain 4 vibrant yellow bags, 5 clear crimson bags.
wavy aqua bags contain 5 shiny green bags, 5 bright fuchsia bags, 4 muted fuchsia bags.
clear green bags contain 4 dotted plum bags, 2 vibrant olive bags, 5 pale beige bags.
pale aqua bags contain 3 dark tomato bags, 5 posh lime bags.
drab maroon bags contain 5 bright magenta bags, 2 bright plum bags, 5 clear green bags, 3 faded tomato bags.
vibrant plum bags contain 3 light crimson bags, 5 dotted silver bags, 5 mirrored red bags, 1 dotted turquoise bag.
posh yellow bags contain 5 plaid lavender bags, 5 dim tomato bags.
faded brown bags contain 1 striped orange bag, 5 wavy green bags.
drab cyan bags contain 4 faded teal bags, 3 vibrant aqua bags, 2 light chartreuse bags, 3 dark orange bags.
dark lime bags contain 4 vibrant blue bags.
faded coral bags contain 4 wavy green bags, 4 mirrored gold bags, 3 striped fuchsia bags, 1 pale fuchsia bag.
dark orange bags contain 1 dotted red bag, 2 vibrant red bags.
wavy magenta bags contain 3 dull chartreuse bags, 2 dim maroon bags, 2 clear maroon bags.
plaid coral bags contain 4 drab tan bags, 1 pale tan bag.
mirrored salmon bags contain 1 muted bronze bag, 5 muted purple bags.
dim tomato bags contain 2 drab silver bags, 4 mirrored purple bags, 1 dull olive bag, 5 dotted purple bags.
wavy gold bags contain 3 dark crimson bags, 1 dim white bag.
light fuchsia bags contain 3 mirrored green bags, 2 wavy fuchsia bags.
pale tomato bags contain 4 clear purple bags, 5 faded brown bags, 4 light coral bags.
faded yellow bags contain 5 wavy olive bags, 2 pale lavender bags, 4 bright plum bags.
light violet bags contain 1 dotted red bag, 4 dim aqua bags.
posh lime bags contain 2 pale crimson bags, 1 pale gold bag, 1 shiny blue bag, 4 muted gray bags.
mirrored silver bags contain 4 striped bronze bags, 3 faded salmon bags, 3 drab green bags, 4 striped green bags.
dark green bags contain 5 striped maroon bags, 3 dim olive bags, 4 vibrant chartreuse bags, 5 dim white bags.
mirrored olive bags contain 2 dotted red bags, 5 dim white bags.
dark teal bags contain 3 wavy olive bags, 3 pale crimson bags.
pale tan bags contain 2 dark orange bags, 5 bright plum bags, 4 pale crimson bags.
wavy plum bags contain 3 dull lime bags.
light indigo bags contain 5 dark magenta bags.
drab lime bags contain 1 bright fuchsia bag, 4 wavy brown bags.
drab tan bags contain 3 bright tomato bags, 1 muted green bag.
vibrant indigo bags contain 5 dull chartreuse bags, 5 clear aqua bags.
dark bronze bags contain 3 dull red bags, 3 mirrored maroon bags, 1 muted green bag.
shiny red bags contain 2 dark bronze bags, 4 faded magenta bags, 5 dull teal bags.
shiny black bags contain 3 vibrant olive bags, 2 plaid lime bags, 5 shiny gold bags, 2 dotted plum bags.
light gold bags contain 5 vibrant olive bags.
light plum bags contain 5 clear gray bags, 5 dotted chartreuse bags, 4 plaid red bags, 1 plaid lime bag.
bright violet bags contain 4 bright maroon bags, 5 posh red bags, 2 faded olive bags, 4 dim gray bags.
faded red bags contain 4 drab maroon bags, 4 vibrant violet bags, 1 faded purple bag, 2 dotted black bags.
muted orange bags contain 4 plaid chartreuse bags, 5 muted lavender bags, 2 faded purple bags.
clear coral bags contain 2 drab teal bags, 5 bright turquoise bags.
wavy orange bags contain 4 muted cyan bags, 3 light indigo bags, 5 bright black bags, 5 light salmon bags.
faded fuchsia bags contain 3 pale gold bags, 3 faded salmon bags, 4 pale red bags.
light brown bags contain 4 pale silver bags, 4 clear tan bags.
shiny gray bags contain 3 muted teal bags, 1 bright purple bag, 2 bright olive bags, 4 mirrored green bags.
bright brown bags contain 2 dark teal bags, 5 light plum bags, 2 plaid olive bags, 5 dark chartreuse bags.
mirrored white bags contain 1 wavy gray bag, 3 bright tomato bags, 1 muted silver bag, 4 striped olive bags.
pale magenta bags contain 1 clear gray bag, 1 muted gray bag, 1 wavy cyan bag, 4 dull brown bags.
bright magenta bags contain 2 muted tan bags, 1 pale gold bag, 2 wavy cyan bags, 4 vibrant orange bags.
clear teal bags contain 1 dark teal bag, 2 vibrant lime bags.
light orange bags contain 3 light gold bags, 4 clear plum bags, 4 dotted indigo bags.
plaid cyan bags contain 1 pale magenta bag.
wavy chartreuse bags contain 2 posh green bags, 5 dotted purple bags, 2 dark tomato bags, 3 muted gray bags.
light coral bags contain 5 clear gray bags, 2 posh purple bags, 2 mirrored violet bags.
dull violet bags contain 3 dotted blue bags, 5 mirrored tomato bags, 1 dull chartreuse bag, 2 posh beige bags.
bright tomato bags contain 3 vibrant red bags, 3 muted gray bags.
mirrored magenta bags contain 4 wavy brown bags.
muted indigo bags contain 4 wavy chartreuse bags, 3 vibrant indigo bags, 2 posh magenta bags, 1 plaid crimson bag.
bright maroon bags contain 2 dull violet bags, 2 faded tan bags, 3 striped gray bags, 5 pale magenta bags.
dark tomato bags contain no other bags.
pale fuchsia bags contain 3 drab silver bags, 4 faded purple bags, 2 mirrored cyan bags, 5 dark bronze bags.
dull black bags contain 1 dull indigo bag, 1 wavy brown bag, 5 striped gray bags.
pale white bags contain 3 light gray bags, 2 plaid lavender bags, 1 wavy maroon bag.
shiny turquoise bags contain 4 pale red bags.
drab brown bags contain 5 mirrored plum bags, 4 dotted red bags.
bright green bags contain 1 dull lime bag, 2 clear lavender bags.
wavy blue bags contain 4 dotted purple bags.
muted aqua bags contain 5 faded plum bags, 3 plaid plum bags, 4 dotted tan bags, 1 clear gray bag.
clear yellow bags contain 4 dotted indigo bags, 3 vibrant aqua bags, 4 vibrant orange bags.
mirrored gray bags contain 4 shiny crimson bags, 2 mirrored coral bags, 1 dotted tan bag, 4 posh cyan bags.
dark maroon bags contain 1 dark salmon bag, 3 muted coral bags.
posh plum bags contain 1 mirrored bronze bag, 4 plaid purple bags, 3 vibrant white bags.
bright teal bags contain 2 pale aqua bags, 1 mirrored black bag.
wavy teal bags contain 5 plaid tan bags, 3 dull black bags, 1 bright teal bag, 3 clear teal bags.
dotted magenta bags contain 1 plaid plum bag, 5 plaid salmon bags, 3 light gold bags.
faded tomato bags contain 1 dark bronze bag, 2 faded purple bags, 4 vibrant red bags, 4 pale lavender bags.
dull blue bags contain 3 dotted bronze bags, 2 shiny olive bags, 3 muted gold bags.
posh aqua bags contain 5 vibrant orange bags, 1 vibrant olive bag.
mirrored black bags contain 3 dark teal bags, 4 plaid chartreuse bags, 2 light salmon bags, 2 vibrant white bags.
wavy violet bags contain 5 vibrant indigo bags.
vibrant blue bags contain 4 shiny olive bags, 4 light olive bags, 2 muted green bags.
dotted green bags contain 3 shiny violet bags, 3 posh black bags, 3 dark lime bags.
wavy cyan bags contain 2 muted gray bags, 3 vibrant olive bags, 4 striped olive bags, 4 drab silver bags.
faded maroon bags contain 5 bright yellow bags, 2 bright tomato bags, 5 mirrored magenta bags.
dull olive bags contain 1 bright plum bag, 2 pale crimson bags.
clear lime bags contain 5 striped blue bags, 5 wavy blue bags, 3 drab tan bags, 1 shiny olive bag.
striped yellow bags contain 1 mirrored red bag.
plaid magenta bags contain 2 clear yellow bags, 1 pale coral bag, 3 muted bronze bags.
light lime bags contain 1 dim turquoise bag.
striped brown bags contain 3 mirrored brown bags, 4 clear cyan bags, 5 bright white bags, 1 muted maroon bag.
dotted indigo bags contain 3 light olive bags, 1 dull chartreuse bag.
shiny tan bags contain 2 dull lime bags, 5 shiny black bags, 5 dull teal bags.
clear olive bags contain 5 drab coral bags, 4 striped aqua bags, 4 dotted lavender bags.
plaid chartreuse bags contain 1 plaid red bag, 4 faded tomato bags.
dotted olive bags contain 2 dull yellow bags.
faded lime bags contain 5 dotted aqua bags, 4 shiny silver bags, 4 muted white bags.
vibrant silver bags contain 4 dotted teal bags, 3 posh olive bags.
striped beige bags contain 2 vibrant white bags, 3 dark gold bags, 4 posh violet bags, 4 bright chartreuse bags.
dim plum bags contain 2 striped indigo bags, 2 vibrant gold bags.
clear crimson bags contain 5 vibrant red bags.
plaid maroon bags contain 4 clear crimson bags.
drab coral bags contain 2 plaid plum bags.
dull bronze bags contain 4 pale black bags, 1 dull tan bag, 5 dull cyan bags, 4 pale lavender bags.
wavy bronze bags contain 4 posh coral bags, 2 bright silver bags.
dull aqua bags contain 3 dotted orange bags, 3 pale teal bags.
muted plum bags contain 1 light blue bag, 2 muted maroon bags, 4 dull olive bags.
vibrant tan bags contain 4 drab teal bags.
dull tomato bags contain 5 dull white bags.
muted yellow bags contain 3 dark yellow bags, 5 faded beige bags.
shiny white bags contain 4 bright silver bags.
muted crimson bags contain 1 clear maroon bag.
muted violet bags contain 3 dotted yellow bags, 1 light indigo bag, 4 mirrored black bags, 5 drab lime bags.
posh white bags contain 3 faded brown bags, 2 dull yellow bags.
wavy crimson bags contain 3 shiny black bags, 2 dotted blue bags, 4 dark maroon bags.
clear salmon bags contain 1 mirrored magenta bag, 4 bright chartreuse bags, 5 vibrant black bags, 2 vibrant chartreuse bags.
pale teal bags contain 5 mirrored white bags, 2 plaid orange bags, 4 muted lime bags.
light aqua bags contain 2 shiny salmon bags, 3 dark tomato bags, 1 mirrored purple bag.
clear beige bags contain 1 muted crimson bag.
vibrant olive bags contain 5 dark tomato bags, 1 pale gold bag, 4 muted tan bags.
plaid brown bags contain 3 mirrored lavender bags, 1 muted crimson bag, 3 muted green bags, 1 bright lavender bag.
dim magenta bags contain 4 pale fuchsia bags, 3 drab black bags, 4 plaid orange bags.
bright purple bags contain 3 muted gray bags, 3 pale coral bags.
posh indigo bags contain 2 bright beige bags, 2 dim tomato bags.
drab lavender bags contain 2 dotted chartreuse bags, 1 posh green bag, 3 light silver bags, 1 dotted black bag.
pale crimson bags contain no other bags.
posh gray bags contain 1 muted green bag.
shiny lime bags contain 3 mirrored maroon bags, 1 posh crimson bag, 4 mirrored orange bags, 2 posh olive bags.
muted beige bags contain 1 posh tan bag, 3 posh olive bags, 1 faded white bag, 2 posh green bags.
light black bags contain 3 striped green bags, 2 pale salmon bags, 3 muted crimson bags.
dark gold bags contain 5 striped maroon bags, 2 pale fuchsia bags, 3 light gold bags.
light bronze bags contain 2 clear purple bags, 4 dim crimson bags.
muted blue bags contain 1 faded gray bag, 4 muted salmon bags, 5 dull bronze bags.
vibrant orange bags contain no other bags.
dim lavender bags contain 1 vibrant indigo bag.
posh fuchsia bags contain 3 clear fuchsia bags, 2 shiny green bags, 3 plaid plum bags.
dim tan bags contain 5 pale plum bags, 3 posh gray bags, 1 clear yellow bag.
pale lime bags contain no other bags.
striped blue bags contain 5 pale black bags.
shiny tomato bags contain 1 dim fuchsia bag, 5 faded blue bags, 3 muted brown bags, 3 mirrored salmon bags.
dotted orange bags contain 4 bright tomato bags, 1 light silver bag.
muted tan bags contain no other bags.
pale black bags contain 2 dull brown bags, 4 mirrored chartreuse bags, 2 dim aqua bags.
shiny purple bags contain 3 dotted indigo bags, 5 vibrant gold bags, 2 light chartreuse bags, 4 clear magenta bags.
dull brown bags contain 2 bright beige bags, 4 vibrant orange bags, 2 bright tomato bags, 4 clear lavender bags.
plaid aqua bags contain 3 plaid indigo bags.
dark olive bags contain 1 pale plum bag, 4 dim maroon bags.
dark silver bags contain 3 shiny blue bags, 2 muted gray bags, 4 drab coral bags.
clear turquoise bags contain 5 light violet bags, 3 drab yellow bags.
wavy brown bags contain 3 shiny coral bags, 3 shiny salmon bags, 1 drab magenta bag.
dim indigo bags contain 5 bright green bags.
mirrored gold bags contain 1 plaid magenta bag, 2 plaid gold bags, 4 light turquoise bags.
drab red bags contain 3 mirrored bronze bags.
faded bronze bags contain 1 vibrant aqua bag, 2 clear tomato bags, 2 dull tan bags.
bright lavender bags contain 4 drab coral bags, 1 bright green bag.
wavy lavender bags contain 2 wavy green bags, 4 drab silver bags, 5 light turquoise bags.
wavy salmon bags contain 2 dotted gray bags, 4 bright chartreuse bags, 4 striped gray bags.
dotted yellow bags contain 4 dark salmon bags, 1 posh tan bag, 4 drab tomato bags, 4 vibrant chartreuse bags.
dull turquoise bags contain 5 drab silver bags, 1 dark orange bag.
pale gray bags contain 4 dull aqua bags, 4 faded gold bags, 2 mirrored orange bags, 2 dim magenta bags.
dark red bags contain 2 bright gray bags, 4 bright black bags.
dim fuchsia bags contain 3 bright magenta bags, 5 pale crimson bags.
vibrant lime bags contain 2 wavy maroon bags, 2 pale magenta bags, 4 pale crimson bags, 3 drab orange bags.
bright bronze bags contain 4 vibrant black bags, 3 drab fuchsia bags, 3 striped cyan bags, 3 dotted blue bags.
muted coral bags contain 3 wavy white bags, 1 plaid tan bag.
wavy white bags contain 2 drab maroon bags.
pale coral bags contain 3 dotted bronze bags, 1 dull gold bag.
drab white bags contain 3 drab silver bags, 3 bright tomato bags, 1 bright silver bag.
light olive bags contain 3 muted tan bags, 2 mirrored tomato bags.
mirrored tomato bags contain 2 dark tomato bags, 3 shiny gold bags.
light crimson bags contain 4 clear magenta bags, 2 plaid coral bags, 5 dull chartreuse bags, 5 dark teal bags.
bright cyan bags contain 1 clear chartreuse bag, 1 striped brown bag, 5 light tomato bags, 4 dark coral bags.
vibrant fuchsia bags contain 3 dull white bags, 1 dim purple bag, 5 shiny yellow bags.
drab gold bags contain 5 wavy chartreuse bags.
plaid yellow bags contain 4 faded plum bags, 1 faded indigo bag, 2 drab purple bags, 1 light purple bag.
bright black bags contain 2 clear yellow bags, 1 dotted red bag, 4 dim white bags.
pale maroon bags contain 2 vibrant tomato bags, 3 mirrored tomato bags.
wavy gray bags contain 2 wavy cyan bags, 2 dark tomato bags, 4 vibrant orange bags, 5 pale silver bags.
faded salmon bags contain 4 bright plum bags.
shiny teal bags contain 4 dark magenta bags.
dim bronze bags contain 5 striped olive bags, 5 dotted plum bags, 4 dark purple bags.
dotted lavender bags contain 4 striped indigo bags, 2 mirrored red bags, 2 bright chartreuse bags, 4 bright teal bags.
plaid beige bags contain 4 vibrant green bags, 3 striped violet bags, 5 vibrant blue bags.
dull purple bags contain 1 dark beige bag, 1 drab silver bag, 4 faded fuchsia bags, 2 vibrant olive bags.
bright olive bags contain 3 faded salmon bags, 1 wavy magenta bag, 5 dim yellow bags.
mirrored maroon bags contain 3 bright magenta bags, 5 pale lime bags, 3 striped olive bags.
clear brown bags contain 2 mirrored orange bags, 5 bright cyan bags.
drab teal bags contain 3 dull olive bags.
clear red bags contain 1 bright maroon bag.
vibrant black bags contain 4 pale fuchsia bags, 3 clear lavender bags, 2 shiny blue bags, 3 dotted blue bags.
faded white bags contain 3 wavy coral bags, 4 faded yellow bags, 5 shiny olive bags, 1 plaid orange bag.
dotted aqua bags contain 1 wavy white bag, 3 dotted blue bags, 5 pale lavender bags, 4 clear aqua bags.
pale blue bags contain 3 dim salmon bags, 3 muted cyan bags, 5 pale fuchsia bags.
dim turquoise bags contain 4 vibrant chartreuse bags, 2 dark silver bags, 3 pale gold bags.
dull magenta bags contain 3 muted salmon bags, 4 dotted gray bags, 3 light salmon bags.
dotted coral bags contain 2 mirrored tomato bags, 1 vibrant teal bag, 3 dull crimson bags.
dull beige bags contain 2 faded fuchsia bags.
shiny gold bags contain 4 bright beige bags, 3 dull crimson bags, 4 mirrored maroon bags, 3 bright tomato bags.
pale indigo bags contain 2 dotted teal bags, 3 faded teal bags, 4 wavy indigo bags.
shiny magenta bags contain 5 bright tomato bags, 5 dull lime bags, 5 mirrored bronze bags, 2 dim black bags.
muted cyan bags contain 2 dark bronze bags, 5 drab silver bags, 4 dotted chartreuse bags.
plaid orange bags contain 4 light plum bags, 5 shiny salmon bags, 5 posh beige bags.
shiny green bags contain 5 dotted tan bags, 5 mirrored olive bags, 1 dark teal bag.
dull maroon bags contain 1 striped black bag, 4 clear green bags.
drab aqua bags contain 1 striped indigo bag, 3 vibrant white bags.
bright gold bags contain 4 mirrored beige bags, 4 mirrored yellow bags.
plaid tan bags contain 5 shiny aqua bags.
striped plum bags contain 4 clear magenta bags, 2 dark gold bags.
vibrant teal bags contain 1 dim aqua bag, 4 vibrant violet bags, 3 plaid olive bags, 1 mirrored olive bag.
posh bronze bags contain 5 dark tomato bags, 5 shiny silver bags.
dim orange bags contain 4 dull salmon bags.
striped indigo bags contain 4 drab magenta bags.
vibrant yellow bags contain 4 drab olive bags, 4 wavy olive bags, 2 dark teal bags, 2 faded purple bags.
striped purple bags contain 5 pale red bags.
dim coral bags contain 1 plaid maroon bag, 2 pale magenta bags, 1 pale indigo bag, 2 dotted turquoise bags.
muted silver bags contain 4 mirrored turquoise bags.
posh cyan bags contain 3 dotted purple bags.
plaid lavender bags contain 3 muted gray bags, 1 light plum bag.
faded tan bags contain 1 mirrored cyan bag, 2 plaid crimson bags, 5 mirrored maroon bags.
clear lavender bags contain 4 pale gold bags, 1 posh lime bag, 4 pale crimson bags.
dull gray bags contain 5 shiny crimson bags, 5 wavy cyan bags, 3 posh lavender bags.
dull green bags contain 1 faded bronze bag, 3 vibrant indigo bags, 2 muted fuchsia bags, 4 dotted silver bags.
dark magenta bags contain 3 wavy white bags, 3 plaid plum bags, 4 wavy lavender bags, 3 drab magenta bags.
plaid red bags contain 1 bright turquoise bag.
dull coral bags contain 4 clear tomato bags.
posh turquoise bags contain 5 dull gold bags, 4 mirrored chartreuse bags.
drab crimson bags contain 2 dull tomato bags, 5 posh orange bags, 5 shiny violet bags.
clear tan bags contain 1 pale fuchsia bag, 4 light aqua bags, 3 shiny blue bags, 3 bright turquoise bags.
dotted brown bags contain 4 drab magenta bags, 5 plaid crimson bags, 2 posh beige bags.
light silver bags contain 3 mirrored green bags, 5 mirrored maroon bags, 5 shiny blue bags.
dotted gold bags contain 2 dim magenta bags.
drab yellow bags contain 5 pale purple bags.
faded lavender bags contain 5 muted cyan bags.
vibrant beige bags contain 4 clear turquoise bags, 2 dark fuchsia bags, 1 pale gray bag, 5 dim beige bags.
clear fuchsia bags contain 1 pale fuchsia bag, 1 wavy turquoise bag, 5 faded gray bags.
shiny chartreuse bags contain 4 vibrant green bags, 1 dotted teal bag.
dim purple bags contain 1 bright turquoise bag.
clear indigo bags contain 4 light white bags, 3 vibrant orange bags.
wavy turquoise bags contain 5 bright magenta bags.
vibrant chartreuse bags contain 4 mirrored chartreuse bags, 2 muted tan bags, 2 plaid lime bags, 3 striped olive bags.
dark chartreuse bags contain 5 shiny blue bags.
clear plum bags contain 3 pale lime bags.
dotted tomato bags contain 5 bright red bags, 2 bright olive bags, 5 drab silver bags, 4 clear magenta bags.
mirrored beige bags contain 4 light violet bags, 5 mirrored salmon bags, 4 dim yellow bags, 5 bright yellow bags.
posh teal bags contain 2 plaid turquoise bags, 3 pale salmon bags, 1 striped plum bag.
dull chartreuse bags contain 5 pale lavender bags, 1 bright turquoise bag, 3 pale beige bags.
mirrored lavender bags contain 4 vibrant tomato bags, 2 plaid tan bags, 5 bright magenta bags.
dark gray bags contain 5 wavy turquoise bags, 4 wavy gray bags, 4 dark bronze bags, 4 pale aqua bags.
dark white bags contain 4 clear maroon bags, 2 vibrant olive bags, 1 dull lime bag, 1 faded lime bag.
dull indigo bags contain 4 clear fuchsia bags, 3 dotted tan bags, 1 plaid cyan bag.
striped tan bags contain 3 pale brown bags.
dull gold bags contain 2 dark yellow bags, 3 dull olive bags.
light lavender bags contain 2 plaid red bags, 5 dotted purple bags, 1 bright beige bag, 3 pale beige bags.
faded teal bags contain 4 mirrored olive bags.
plaid salmon bags contain 1 dark bronze bag, 5 pale yellow bags, 1 striped cyan bag, 2 muted cyan bags.
dotted purple bags contain 1 bright turquoise bag, 1 posh green bag.
dull silver bags contain 3 striped salmon bags, 4 posh violet bags, 4 striped orange bags.
drab chartreuse bags contain 4 pale lavender bags.
striped coral bags contain 5 bright gray bags, 4 dark teal bags, 5 dotted purple bags.
wavy olive bags contain no other bags.
plaid olive bags contain 1 pale black bag, 3 clear plum bags.
drab black bags contain 3 striped olive bags, 2 mirrored chartreuse bags, 5 pale silver bags.
striped lime bags contain 3 dark chartreuse bags, 5 pale silver bags, 2 plaid crimson bags, 4 clear fuchsia bags.
drab beige bags contain 4 dim black bags, 4 striped black bags, 4 dull crimson bags, 5 dark gray bags.
muted tomato bags contain 3 light bronze bags, 3 pale salmon bags, 2 vibrant chartreuse bags.
bright fuchsia bags contain 5 drab orange bags, 3 pale black bags, 3 mirrored white bags, 5 faded tomato bags.
vibrant gray bags contain 4 posh lime bags, 2 dark purple bags, 4 clear aqua bags.
shiny yellow bags contain 5 bright beige bags, 2 vibrant red bags, 5 dim yellow bags, 2 vibrant yellow bags.
posh coral bags contain 5 drab indigo bags.
muted fuchsia bags contain 5 shiny silver bags, 2 dotted salmon bags, 1 muted tan bag.
muted brown bags contain 4 clear maroon bags, 5 dim purple bags, 4 wavy maroon bags, 2 muted red bags.
posh chartreuse bags contain 5 muted tan bags, 3 drab teal bags.
vibrant brown bags contain 1 wavy bronze bag, 5 bright red bags, 4 muted fuchsia bags, 4 clear fuchsia bags.
posh purple bags contain 2 drab turquoise bags, 5 striped blue bags, 1 muted cyan bag.
plaid lime bags contain 3 muted gray bags, 5 vibrant red bags, 1 wavy gray bag, 1 pale silver bag.
posh violet bags contain 2 faded crimson bags, 1 shiny olive bag, 3 bright magenta bags, 1 drab silver bag.
striped gold bags contain 5 faded salmon bags, 2 drab bronze bags, 2 dark plum bags.
striped gray bags contain 2 mirrored crimson bags, 5 faded beige bags, 1 dull red bag.
dim blue bags contain 2 dark coral bags, 3 dim yellow bags, 1 dull salmon bag.
bright silver bags contain 2 mirrored tomato bags, 3 bright plum bags, 4 pale lavender bags, 1 clear tomato bag.
striped red bags contain 4 light yellow bags, 5 mirrored white bags, 5 plaid gold bags.
shiny maroon bags contain 3 wavy cyan bags, 1 mirrored tomato bag, 1 mirrored coral bag.
mirrored brown bags contain 2 mirrored olive bags, 3 mirrored green bags, 1 dim tomato bag.
striped olive bags contain no other bags.
striped violet bags contain 5 bright tomato bags.
mirrored aqua bags contain 4 dark gray bags, 5 shiny blue bags, 2 pale silver bags.
plaid white bags contain 3 dim maroon bags, 2 dim tan bags.
drab orange bags contain 5 striped olive bags.
dark brown bags contain 2 mirrored bronze bags, 5 clear maroon bags, 2 dull lime bags.
dotted silver bags contain 1 dark gold bag, 1 drab black bag, 3 pale aqua bags.
pale plum bags contain 5 striped maroon bags, 5 dotted purple bags, 4 shiny magenta bags.
faded indigo bags contain 1 posh cyan bag, 5 bright green bags.
mirrored teal bags contain 3 muted indigo bags, 4 clear fuchsia bags, 4 vibrant teal bags, 5 drab violet bags.
shiny lavender bags contain 5 striped beige bags, 2 dull magenta bags, 4 clear tan bags.
pale beige bags contain 5 mirrored maroon bags.
striped bronze bags contain 1 pale orange bag, 5 shiny cyan bags, 5 plaid purple bags, 1 vibrant chartreuse bag.
faded gold bags contain 3 pale brown bags, 2 dull violet bags, 2 clear maroon bags, 4 dull lime bags.
clear tomato bags contain 4 vibrant orange bags, 3 bright tomato bags, 3 wavy chartreuse bags, 5 wavy olive bags.
pale red bags contain 5 wavy blue bags, 5 dark purple bags, 1 bright tomato bag, 4 dark tan bags.
vibrant red bags contain 5 wavy gray bags, 5 dark tomato bags.
dim salmon bags contain 2 faded crimson bags.
shiny blue bags contain 4 muted tan bags, 2 vibrant orange bags.
vibrant white bags contain 3 mirrored cyan bags.
dark violet bags contain 5 vibrant blue bags, 3 wavy tomato bags.
pale gold bags contain no other bags.
dim silver bags contain 4 drab tan bags, 4 pale silver bags, 5 clear bronze bags, 4 drab maroon bags.
drab blue bags contain 5 vibrant indigo bags, 3 muted turquoise bags.
drab plum bags contain 2 dim turquoise bags, 2 drab violet bags, 1 light gray bag, 3 clear tan bags.
bright plum bags contain 3 wavy olive bags.
dark fuchsia bags contain 4 dotted indigo bags, 3 dark brown bags, 1 clear white bag.
bright turquoise bags contain 1 posh lime bag, 2 wavy olive bags, 1 pale crimson bag.
dotted turquoise bags contain 3 faded plum bags, 1 bright tomato bag.
shiny indigo bags contain 1 wavy chartreuse bag.
dark yellow bags contain 2 light gold bags.
posh olive bags contain 2 shiny indigo bags.
light chartreuse bags contain 5 drab turquoise bags, 2 faded purple bags, 3 faded gray bags.
vibrant tomato bags contain 3 light olive bags, 4 shiny purple bags.
posh brown bags contain 4 shiny green bags, 1 pale purple bag.
bright chartreuse bags contain 3 light gold bags.
dotted lime bags contain 5 wavy cyan bags.
drab violet bags contain 4 dark beige bags, 1 plaid gold bag, 3 faded beige bags.
drab green bags contain 4 dotted bronze bags, 5 clear silver bags, 4 faded salmon bags.
wavy beige bags contain 2 clear cyan bags, 2 dim tomato bags.
wavy yellow bags contain 4 pale green bags, 3 mirrored green bags, 5 faded brown bags, 1 clear orange bag.
plaid tomato bags contain 3 dull yellow bags, 2 faded blue bags, 1 dull teal bag.
dull red bags contain 4 posh green bags, 1 shiny salmon bag, 2 bright tomato bags, 4 vibrant red bags.
striped salmon bags contain 4 dim bronze bags, 4 light gold bags, 3 posh beige bags.
dim crimson bags contain 1 dull crimson bag, 4 drab silver bags.
plaid silver bags contain 3 dull black bags, 5 shiny silver bags, 4 dark beige bags, 2 clear aqua bags.
clear bronze bags contain 1 drab coral bag, 2 vibrant red bags.
dotted gray bags contain 1 plaid plum bag, 2 dotted purple bags, 5 striped violet bags, 3 bright tomato bags.
striped silver bags contain 2 plaid coral bags, 5 bright orange bags, 1 pale brown bag.
shiny beige bags contain 4 dim turquoise bags.
posh green bags contain no other bags.
plaid gold bags contain 3 pale fuchsia bags, 5 dull lime bags, 5 wavy chartreuse bags, 5 dim tomato bags.
dim teal bags contain 5 pale beige bags, 2 faded blue bags, 5 dotted tan bags, 5 vibrant tomato bags.
bright red bags contain 4 drab lavender bags, 1 dark purple bag, 2 wavy violet bags.
dotted teal bags contain 5 dull crimson bags.
faded gray bags contain 4 mirrored red bags.
pale purple bags contain 3 faded gray bags, 1 clear gold bag, 4 clear cyan bags.
striped crimson bags contain 4 dim aqua bags, 3 pale magenta bags, 1 drab white bag, 1 vibrant purple bag.
mirrored purple bags contain 3 muted gray bags.
muted maroon bags contain 3 plaid crimson bags, 4 posh aqua bags.
muted gold bags contain 3 pale fuchsia bags, 2 dotted teal bags, 3 dotted chartreuse bags, 4 vibrant lime bags.
wavy silver bags contain 2 plaid beige bags, 3 dull aqua bags, 2 pale lavender bags.
dim aqua bags contain 5 bright beige bags.
dark tan bags contain 4 pale gold bags.
light yellow bags contain 4 dotted gray bags, 5 pale teal bags.
bright blue bags contain 3 shiny coral bags, 4 striped salmon bags.
striped cyan bags contain 5 light turquoise bags.
light gray bags contain 4 vibrant teal bags, 1 shiny turquoise bag, 1 wavy olive bag, 5 dim white bags.
light cyan bags contain 3 dark gray bags, 5 clear lavender bags, 4 dark beige bags.
light blue bags contain 5 dim black bags, 4 drab tomato bags, 2 dim turquoise bags.
dull crimson bags contain 3 pale silver bags, 2 faded beige bags.
dotted beige bags contain 2 dotted aqua bags.
shiny olive bags contain 4 bright plum bags, 4 clear plum bags, 2 wavy green bags, 5 faded tomato bags.
striped turquoise bags contain 1 drab black bag.
pale chartreuse bags contain 5 dotted brown bags.
mirrored turquoise bags contain 4 shiny gold bags, 3 dark chartreuse bags.
posh beige bags contain 3 dotted tan bags.
drab gray bags contain 3 vibrant aqua bags.
shiny silver bags contain 4 plaid gold bags, 5 shiny green bags.
bright crimson bags contain 5 faded yellow bags, 4 bright plum bags, 4 mirrored gold bags.
dim yellow bags contain 2 plaid lime bags, 5 bright salmon bags, 4 mirrored bronze bags.
dark crimson bags contain 4 dull blue bags, 2 light olive bags, 4 mirrored green bags.
faded aqua bags contain 1 dotted chartreuse bag, 1 muted orange bag.
pale turquoise bags contain 4 dull silver bags.
clear orange bags contain 1 pale gray bag, 5 striped bronze bags, 5 dim aqua bags.
mirrored red bags contain 1 muted purple bag.
drab silver bags contain no other bags.
faded silver bags contain 5 mirrored turquoise bags, 4 striped purple bags.
wavy fuchsia bags contain 2 faded purple bags, 1 wavy cyan bag, 2 muted cyan bags.
clear black bags contain 4 drab turquoise bags, 1 plaid lime bag.
dim olive bags contain 5 bright chartreuse bags, 3 striped silver bags.
mirrored tan bags contain 2 striped indigo bags, 3 wavy gray bags, 3 clear tan bags.
mirrored yellow bags contain 2 plaid plum bags, 3 striped salmon bags, 4 dim maroon bags.
shiny salmon bags contain 5 dotted plum bags, 5 pale crimson bags.
dotted crimson bags contain 3 dull yellow bags.
shiny fuchsia bags contain 5 plaid lime bags.
drab turquoise bags contain 2 dull crimson bags.
mirrored cyan bags contain 3 posh green bags, 5 striped olive bags, 5 vibrant red bags.
faded crimson bags contain 3 muted silver bags, 4 shiny olive bags.
light magenta bags contain 3 posh crimson bags, 5 pale purple bags.
faded violet bags contain 3 vibrant lime bags, 1 dim magenta bag, 1 dull lime bag.
dotted black bags contain 2 light gold bags, 2 dim bronze bags, 4 wavy turquoise bags.
bright beige bags contain 4 vibrant orange bags, 4 dark chartreuse bags, 1 muted gray bag, 2 bright tomato bags.
striped green bags contain 3 pale beige bags, 1 pale brown bag, 2 posh brown bags, 5 striped olive bags.
dotted red bags contain 4 vibrant orange bags, 2 pale gold bags.
plaid fuchsia bags contain 5 pale teal bags, 5 pale fuchsia bags, 4 faded gray bags.
light beige bags contain 1 muted red bag, 5 dotted purple bags, 3 striped salmon bags.
dim chartreuse bags contain 5 muted maroon bags, 4 wavy maroon bags.
clear chartreuse bags contain 3 striped lavender bags, 2 clear blue bags.
pale silver bags contain 2 dark teal bags.
faded olive bags contain 4 dotted turquoise bags, 4 drab indigo bags, 5 drab violet bags, 3 shiny blue bags.
clear blue bags contain 1 muted black bag.
dull tan bags contain 5 clear crimson bags, 3 dim tomato bags.
dark cyan bags contain 4 wavy magenta bags, 5 vibrant olive bags, 2 posh gray bags, 5 dull magenta bags.
dotted white bags contain 1 bright magenta bag, 3 pale red bags.
muted teal bags contain 5 posh fuchsia bags, 4 drab turquoise bags, 4 posh red bags.
mirrored coral bags contain 1 faded purple bag, 2 bright magenta bags, 5 dark yellow bags, 3 light plum bags.
dull orange bags contain 4 dotted blue bags, 5 clear gray bags, 3 vibrant red bags.
bright aqua bags contain 4 muted lime bags, 2 wavy plum bags, 1 shiny olive bag.
light maroon bags contain 1 shiny gold bag, 4 light beige bags, 1 drab black bag.
dim green bags contain 4 dull brown bags.
striped black bags contain 4 dotted crimson bags.
mirrored bronze bags contain 4 mirrored chartreuse bags, 3 dull lime bags, 3 wavy turquoise bags.
striped aqua bags contain 4 dark gray bags, 5 faded beige bags, 2 dull lime bags.
shiny coral bags contain 5 mirrored white bags, 5 shiny blue bags.
striped orange bags contain 4 pale silver bags, 4 pale olive bags, 4 shiny olive bags, 2 bright chartreuse bags.
vibrant crimson bags contain 5 shiny olive bags, 5 striped violet bags, 2 posh beige bags.
dotted chartreuse bags contain 5 bright turquoise bags, 5 bright magenta bags.
vibrant purple bags contain 4 posh violet bags.
vibrant violet bags contain 5 posh aqua bags, 4 mirrored white bags, 4 dotted tan bags, 4 mirrored purple bags.
dotted violet bags contain 3 bright brown bags, 3 pale yellow bags, 4 light gray bags, 5 dark green bags.
muted black bags contain 2 light violet bags, 5 muted bronze bags.
mirrored orange bags contain 1 plaid magenta bag, 5 muted red bags, 3 pale lime bags.
faded magenta bags contain 3 striped cyan bags, 4 muted silver bags.
clear gray bags contain 4 muted gray bags, 2 wavy turquoise bags, 3 dotted plum bags.
