require 'set'

SMALL = "
mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
trh fvjkl sbzzf mxmxvkd (contains dairy)
sqjhc fvjkl (contains soy)
sqjhc mxmxvkd sbzzf (contains fish)
".strip

input = SMALL
input = DATA.read

Food = Struct.new(:ingredients, :allergens)
foods = input.split("\n").map { |line| md = %r{([\w ]+) \(contains ([\w ,]+)\)}.match(line); Food.new(md[1].split(' '), md[2].split(', ')) }
allergen_words = {}
foods.each do |food|
    food.allergens.each do |a|
        if allergen_words.key?(a)
            allergen_words[a] = allergen_words[a] & food.ingredients.to_set
        else
            allergen_words[a] = food.ingredients.to_set
        end
    end
end

all_possible_allergens = allergen_words.values.reduce(:|)

count = 0
foods.each do |food|
    food.ingredients.each { |i| count += 1 if !all_possible_allergens.include?(i) }
end
p count

allergens = {}
loop do
    ones = allergen_words.select { |k,v| v.length == 1 }
    break if ones.empty?
    ones.each do |a,i|
        i = i.first
        allergens[i] = a
        allergen_words.values.each { |s| s.delete(i) }
    end
end
p allergens
puts allergens.to_a.sort_by { |a| a[1] }.map { |a| a[0] }.join(',')

__END__
vzkbf lxrsn mnj bjqfl brqg kcddk nkjc bgblpf xxhp cfb pzqgtb cggl cjhv vplz dlhfnjb jtfmtpd ccmvjbn jgrrd dvjxl tdrxvd vlqz pfbz txvctk kqvhbt qcmgxlj kgf znvmcx ldkt lshjmc nrlf rjf mcvc tzkfgq fpgmtjg srvfk nhhbtd mdtrqk hqxp bgxpfm ncx sckjj vqn npxrdnd xvsxb bcvlvk tflkk sjdmzj zmkx jpvvt vvlbp fqpt lmcqt khmm gfgbq plgvrz klnrvd xmcdn hrrt (contains dairy)
dvjxl sjpkc xdqx cfb jnmsr jzvjxf czcfdv zmvpzp srvfk tsch qqq qdhk pxf ttlvf jtfmtpd ndqk mrqgvd fqpt ctbvdq bgxpfm znvmcx sgczbl jpvvt zkjh kskbk mjzpgzs jxvc qvkdgn tdrxvd fzdltb csxkh mnj vbvbbh ldkt bcxxjq fpgmtjg nvxk hcrgt mqvf kqvhbt hnpd tmckpp lmcqt pzqgtb npxrdnd fdhfpn nbhhmfx dntsjl zbfqrn cmtvkq xmcdn xjsgl hrhzg zfrkt bxgzl zkfsg xzn zmmrgdf fkpjn dhz (contains shellfish, fish, nuts)
rxjq qdhk hlzkpt tsch xl tcff vmhhjm xjsgl pfbz xhxkf ftqpg ctnb zhvhng zmvpzp djmbx dptsqvq fkpjn pzqgtb lg kcddk ngrcb tflkk fsbll svvjknm khmm mjzpgzs jpvvt lkvdg mcvc gmsnc lmcqt npxrdnd xtnsbgc xkzsk vlqz cfgc dvzz qtpvndc qlrrrgb zkfsg mzlzxcc ltrhm mk zmmrgdf pfhsdp hqtzllj ldkt dqntj mqvf vtrchx slkjz hrhzg tmckpp lbdlb mdqdgf pnpg dscxjl sgczbl gscxfbd nfkzd mnj cjhv zmkx rrtkdz njjvq rjf xxhp bcxxjq lfvdf sqg dvjxl fqpt vjpnd gkkcjs flrjj bnfhd mmlq tsrqc nbhhmfx bgblpf ctbvdq xbrtdm srvfk cfb (contains nuts, peanuts)
kskbk qdhk cxbkg xpmx xskgz dvzz xdqx tsdcm pgcxql fkpjn rxjq bcxxjq mdh ngrcb sqg zmkx mdtrqk nfqkt tzkfgq dntsjl jzvjxf dmtcj dscxjl plgvrz npxrdnd jgrrd ftqpg hrrt zkjh dgbndg lmcqt fqpt kqvhbt hrhzg cfb qvkdgn flrjj tsch mcvc xvsxb blnsd pxf zhvhng ldkt jtfmtpd sckjj zmmrgdf xkgpch vzkbf cmtvkq mzlzxcc sfmbms mk (contains soy, shellfish)
xvsbr cbdl lmcqt kqvhbt pxf ldkt kskbk zhvhng jzvjxf nfkzd mk fsjcf srvfk bqrsxn lkvdg cshq npxrdnd zfrkt vmhhjm znvmcx zpzzt slkjz ndqk fqpt qvkdgn ftqpg jnmsr cfb tsch lshjmc mnj xlqp hrrt mqqzg sqg kcddk mqvf xzn hqxp cmtvkq (contains peanuts, nuts)
lkvdg xhxkf fpgmtjg szfxqq lshjmc cggl jxvc xmcdn tdrxvd jgrrd vvlbp hrhzg lxrsn xtnsbgc mzlzxcc ftqpg kcddk jmvt dgbndg cvd tsch pgcxql fqpt plgvrz tmckpp mmlq jpvvt xxhp dntsjl bxgzl mmhmx cfb svvjknm fsjcf rzc jtfmtpd xzn pzqgtb vjpnd hndcnf xskgz qdhk mdqdgf npxrdnd flrjj zkfsg mqvf lmcqt ctbvdq znvmcx khmm nhhbtd zpzzt hrrt tzkfgq slkjz xl mk pgct mrqgvd njjvq zhvhng kskbk blnsd gxmk vtrchx hjkqqr qtpvndc klnrvd xqbtls bgxpfm (contains fish, dairy)
lmcqt vrl hmnln rjf ttlvf cfb cggl rxjq qpdd plgvrz mdh pfhsdp xpmx zhvhng dscxjl mrqgvd bxgzl mk lxrsn nrlf vvlbp fpgmtjg tsrqc dhz ccmvjbn npxrdnd ltrhm xvsxb sjpkc hcrgt cshq hlzkpt jpvvt xdqx xjsgl pzqgtb xhxkf tdrxvd hjkqqr fqpt tfnsz bcxxjq hclf ctbvdq mzlzxcc kgf gfgbq sckjj tflkk bgxpfm zkfsg vmhhjm qlrrrgb jnmsr qcmgxlj bcvlvk srvfk hrhzg jtfmtpd ngrcb jbmxr flrjj szfxqq csqrvk bggz ldkt mdtrqk sqg zfrkt slkjz tsch (contains sesame, soy)
cxbkg fsjcf vqn xzn sjdmzj qcmgxlj cfb mrqgvd bcvlvk bggz hrrt npxrdnd dntsjl lfvdf tsch cmtvkq xjsgl pxf kcddk vdqtgt dgbndg ldkt xhxkf dptsqvq gscxfbd tmckpp bxgzl znvmcx mmlq flrjj xpmx kgf mmhmx tdrxvd dvjxl fqpt plgvrz zmvpzp zmkx xskgz ltrhm lmcqt csxkh (contains eggs, soy)
srvfk tsch szfxqq lmcqt xjsgl mqvf mrqgvd dhz kcddk mmhmx fqpt vvlbp gscxfbd jfl cjhv zbfqrn cfb vplz pgct jxvc mdtrqk sgczbl pbkr nfkzd lxrsn gmsnc blnsd fpgmtjg mjzpgzs fsbll rzc xvsxb mnj lkvdg kqvhbt hjkqqr njjvq klnrvd bgxpfm kskbk nsdk tsdcm bnfhd lfvdf hndcnf fkpjn jzvjxf bqrsxn txvctk xmcdn ldkt tsrqc zkjh slkjz dptsqvq lbdlb jtfmtpd jnmsr bjqfl zpqh csqrvk dscxjl cbdl dqntj sqg rbkr mzlzxcc bvzs nvxk hrrt vlqz fdhfpn pfbz mxfgnv pzqgtb hqtzllj (contains shellfish, sesame, dairy)
xl hjkqqr fsbll mmhmx kcddk xkzsk kqvhbt jtfmtpd xlqp bgxpfm zmkx fpgmtjg fdhfpn zhvhng gxmk mjzpgzs tcff szfxqq mxfgnv rzc zmvpzp svvjknm sqg bcvlvk dqntj lfvdf jbmxr lmcqt pgt xjsgl tsdcm hnpd mnj vbvbbh plgvrz rxjq mdh mdtrqk tsch ldkt fqpt qpdd mqqzg vdqtgt jvxqc ccmvjbn hclf cfb ttlvf cxbkg vjpnd dmtcj vtrchx qqq nbh jmvt xskgz (contains sesame, peanuts)
fqpt pfhsdp fkpjn tsch dscxjl tdrxvd klnrvd mnj czcfdv kqvhbt mzlzxcc mxfgnv dvjxl rrtkdz cggl nfkzd pgct bnfhd bxgzl djmbx lkvdg bjqfl xlqp xhxkf nkjc csxkh sjpkc lmcqt vbvbbh cshq npxrdnd mk plgvrz ldkt rzc qqq dlhfnjb hrrt xqbtls mjzpgzs cfb bqrsxn jvxqc fpgmtjg dptsqvq rbkr mcvc lshjmc cxbkg bcxxjq nrlf pnpg zpqh vzkbf zkfsg mmlq ndqk nbhhmfx zkjh kcddk vmhhjm fzdltb ccmvjbn bvzs (contains dairy)
zmmrgdf zpzzt cmtvkq sgczbl jtfmtpd xskgz znvmcx hjkqqr vqn jpvvt mmlq hclf svvjknm pnpg lxrsn dmtcj vtrchx tmckpp lmcqt hmnln xdqx nhhbtd xqbtls gmsnc npxrdnd fqpt zkfsg brqg cxbkg mjzpgzs rbkr pfbz dptsqvq mnj vdqtgt kgf ldkt jxvc ftqpg zkjh hrhzg ttlvf kcddk jmvt cfb vbvbbh khmm xmcdn tcff mdtrqk fdhfpn srvfk (contains sesame)
qpdd vrl sgczbl qdhk cfb cxbkg bgblpf kcddk tsch hnpd bxgzl jzvjxf svvjknm rbkr xzn lshjmc zkjh xjsgl ftqpg fdhfpn hqtzllj sjdmzj ldkt cggl xskgz jxvc bcxxjq tflkk vqn jvxqc blnsd xdqx lg tsdcm ngrcb vzkbf jmvt jtfmtpd gfgbq xl fqpt csqrvk zmkx nsdk xlqp rjf mnj mzlzxcc plgvrz cvd jbmxr sqg cfgc bqrsxn mqqzg cjhv zpzzt vdqtgt jfl mmlq vlqz pgt xtnsbgc vjpnd gxmk dscxjl lmcqt lxrsn (contains dairy)
pnpg lmcqt nbh zpzzt dptsqvq tdrxvd mdqdgf ncx gmsnc sckjj klnrvd dscxjl znvmcx dvjxl bgxpfm vdqtgt hmnln jvxqc gxmk tsch ngrcb csxkh slkjz jmvt xkzsk prnjsm hqtzllj jtfmtpd fdhfpn cshq xjsgl jzvjxf kcddk jbmxr xdqx jpvvt cmtvkq fqpt cfb npxrdnd (contains nuts, sesame, soy)
flrjj zhvhng tsdcm xkzsk jtfmtpd mqqzg dntsjl npxrdnd tdrxvd znvmcx mzlzxcc vbvbbh gfgbq lbdlb mxfgnv khmm bcvlvk bjqfl zkfsg jzvjxf xvsbr hrhzg xkgpch czcfdv tsch pxf nhhbtd lmcqt rxjq njjvq kqvhbt cfb bgblpf tfnsz bggz csxkh kcddk fsbll gxmk zfrkt xxhp slkjz mmlq vtrchx ldkt dlhfnjb ftqpg (contains peanuts, fish, nuts)
tsrqc lmcqt czcfdv pfhsdp xl zpqh qdhk jtfmtpd vtrchx csqrvk xmcdn nfkzd tfnsz blnsd fsjcf bgxpfm klnrvd srvfk mnj jbmxr sckjj xjsgl mqvf mxfgnv mdtrqk nbh gkkcjs bjqfl mjzpgzs zfrkt svvjknm lg pnpg pzqgtb kcddk mdh gscxfbd xvsxb nhhbtd qcmgxlj tsch mzlzxcc cjhv xqbtls spkl cmtvkq qpdd xkgpch rzc xpmx bgblpf vvlbp gfgbq dscxjl tmckpp fqpt vplz vlqz cfb vmhhjm npxrdnd fpgmtjg vbvbbh gmsnc zkjh cxbkg cfgc ctnb znvmcx mcvc pgt txvctk (contains nuts, shellfish)
mrqgvd xvsbr cggl zmvpzp xxhp xbrtdm qqq bgxpfm cfb cfgc tsrqc kcddk mdqdgf bqrsxn bcvlvk bxgzl ldkt pgt lfvdf qlrrrgb jtfmtpd nvxk fqpt jxvc mmlq sjdmzj ngrcb zmmrgdf jbmxr pgct lg hnpd dscxjl npxrdnd jpvvt ndqk gkkcjs zfrkt bggz ncx bnfhd xskgz mnj dptsqvq hcrgt zkfsg sjpkc bjqfl pxf tflkk dvzz srvfk xmcdn fdhfpn mmhmx dlhfnjb ctnb vplz rzc nsdk xqbtls cvd jgrrd cbdl mdtrqk czcfdv mcvc bgblpf vqn pbkr lmcqt xhxkf (contains fish)
vzkbf dvjxl nrlf cbdl xskgz sfmbms mdqdgf cjhv szfxqq ldkt mmhmx mzlzxcc qvkdgn fqpt gmsnc mmlq kskbk tzkfgq djmbx pgcxql kgf sjdmzj xkzsk vjpnd slkjz pgct kcddk pnpg nfqkt sckjj xlqp xvsxb qlrrrgb vtrchx bjqfl tsch cmtvkq dgbndg spkl cfb vvlbp lmcqt bgxpfm dntsjl jpvvt ctbvdq nbhhmfx mxfgnv xqbtls xjsgl bqrsxn prnjsm cxbkg fsjcf jtfmtpd ccmvjbn xtnsbgc (contains sesame)
khmm xxhp prnjsm vvlbp tdrxvd mdh jvxqc jgrrd jnmsr bnfhd bqrsxn ldkt xpmx cfb jbmxr vlqz zpzzt npxrdnd mnj pgct tfnsz dqntj hjkqqr hrrt nsdk gfgbq dlhfnjb qlrrrgb jpvvt tsch mrqgvd kskbk rrtkdz qdhk fzdltb nfqkt hndcnf dptsqvq xvsbr fqpt xl lfvdf lmcqt jtfmtpd (contains shellfish, soy, dairy)
qpdd ldkt jfl vtrchx pbkr srvfk hmnln gkkcjs jtfmtpd djmbx fqpt cfb dhz vdqtgt hlzkpt zmvpzp tsch lg blnsd pgct qtpvndc ctbvdq mqvf flrjj vqn jzvjxf gxmk ccmvjbn jnmsr mdqdgf hclf cbdl vlqz hndcnf mxfgnv fsbll csxkh mmlq sqg dvjxl fzdltb gscxfbd npxrdnd lshjmc sckjj klnrvd nfqkt mqqzg dptsqvq nkjc xskgz tsdcm nvxk mjzpgzs lmcqt pxf dlhfnjb qvkdgn vplz szfxqq cshq kgf jbmxr mzlzxcc tmckpp zpqh (contains soy)
zhvhng xmcdn gscxfbd xxhp jnmsr svvjknm ctbvdq dptsqvq ldkt hcrgt rzc cggl hnpd djmbx lmcqt xl nfkzd jpvvt kcddk dntsjl xlqp fqpt mzlzxcc qcmgxlj pzqgtb sgczbl vmhhjm nvxk tsdcm dmtcj vqn zkjh srvfk xtnsbgc jgrrd pxf vjpnd tsch sckjj ncx fkpjn cfgc lfvdf plgvrz kskbk cfb pfbz cshq ndqk bcvlvk khmm brqg sjpkc ccmvjbn cbdl lbdlb vplz nhhbtd jtfmtpd sqg (contains soy)
hrhzg xvsbr rjf pfhsdp dvzz fsjcf klnrvd slkjz mxfgnv tsch rrtkdz rzc cfb srvfk pxf vvlbp pnpg mdqdgf lbdlb tcff hqtzllj jtfmtpd brqg mmhmx fqpt sfmbms xkzsk dptsqvq nrlf ldkt pgcxql vzkbf vjpnd znvmcx pbkr npxrdnd nkjc ltrhm cxbkg vplz lmcqt jvxqc prnjsm tmckpp pzqgtb jnmsr bgblpf vtrchx mqqzg pgct zfrkt svvjknm nvxk cbdl dgbndg ctbvdq rxjq mdtrqk nsdk hclf szfxqq nbh xlqp fkpjn dhz gxmk hjkqqr hndcnf tfnsz xkgpch mnj zmvpzp sqg zhvhng (contains soy)
fkpjn ttlvf vlqz dscxjl dvzz vjpnd sqg srvfk qdhk gscxfbd xzn njjvq ldkt vmhhjm xskgz svvjknm xkgpch brqg hjkqqr mdtrqk sgczbl gfgbq pfbz nbh qqq xvsxb hclf lmcqt kqvhbt npxrdnd zbfqrn fqpt dqntj qcmgxlj pgct zmkx fdhfpn szfxqq ltrhm lg hqtzllj vdqtgt jvxqc hcrgt sckjj jtfmtpd zpqh kcddk fsbll zpzzt djmbx vplz cfb pnpg (contains nuts)
hqxp lshjmc rrtkdz nvxk pfhsdp tcff jmvt mqqzg qdhk vdqtgt bqrsxn bxgzl mqvf kskbk qcmgxlj jvxqc nfqkt gmsnc hjkqqr qpdd ttlvf mdtrqk mmhmx ctbvdq vvlbp bggz hmnln xpmx lmcqt npxrdnd cggl prnjsm fqpt nkjc pgcxql qvkdgn xhxkf ftqpg gkkcjs mmlq sqg rjf cxbkg dqntj cvd zmvpzp slkjz pxf dscxjl tsch xtnsbgc jtfmtpd cbdl kqvhbt zfrkt fzdltb klnrvd bvzs sjpkc kcddk ldkt hcrgt zpqh sjdmzj nbh qlrrrgb dvzz vmhhjm txvctk tdrxvd vbvbbh vzkbf zhvhng zpzzt vqn fsjcf svvjknm xvsbr qtpvndc xl lkvdg nfkzd bgxpfm bcxxjq znvmcx (contains sesame)
jtfmtpd blnsd mmlq fkpjn pgt ldkt xzn tsch mcvc jzvjxf jfl cxbkg tzkfgq vqn klnrvd nhhbtd xdqx fqpt jvxqc sckjj vrl bggz xvsbr hlzkpt vlqz jbmxr bgblpf bcvlvk rbkr jgrrd bjqfl jnmsr ctnb nvxk vvlbp lmcqt cfb djmbx lkvdg zmkx sqg qcmgxlj mqvf svvjknm xqbtls hmnln nrlf lxrsn dhz zhvhng pfbz rrtkdz npxrdnd znvmcx qpdd txvctk jmvt gfgbq tsrqc bgxpfm bqrsxn ftqpg ccmvjbn gscxfbd dptsqvq xkgpch pbkr cvd xtnsbgc xlqp (contains shellfish, soy, peanuts)
mcvc dgbndg vzkbf dptsqvq gscxfbd jzvjxf vtrchx lfvdf vplz ltrhm pbkr jtfmtpd sgczbl spkl khmm dntsjl mxfgnv njjvq lkvdg cshq qcmgxlj ldkt vjpnd qlrrrgb jmvt dscxjl bnfhd tsch sjdmzj csxkh hndcnf nbh ccmvjbn kcddk djmbx nfqkt bgxpfm mqvf cfb mjzpgzs txvctk dlhfnjb mdtrqk cxbkg lmcqt mk bggz hqtzllj fqpt dqntj qvkdgn nfkzd cmtvkq hjkqqr mmlq rxjq (contains sesame, peanuts)
lg pxf jpvvt ndqk pzqgtb mmlq zmmrgdf sqg xlqp xvsbr lbdlb qcmgxlj gmsnc xpmx mqvf jtfmtpd pgt dvzz vvlbp sgczbl spkl lshjmc hrrt zkfsg szfxqq hclf qdhk bvzs npxrdnd dqntj bjqfl fqpt tcff ttlvf lmcqt hqtzllj xdqx nsdk ldkt ccmvjbn tsch ftqpg tzkfgq kcddk hrhzg rbkr (contains soy, eggs, dairy)
tfnsz bcvlvk mjzpgzs prnjsm tsch xkzsk vzkbf lmcqt mqvf dvzz cxbkg zhvhng npxrdnd vqn fsbll ttlvf hclf vmhhjm bcxxjq fpgmtjg tcff mmlq plgvrz hrrt qcmgxlj kcddk vplz ctnb pgct mk mxfgnv pxf qpdd nrlf jnmsr rbkr dptsqvq rrtkdz jtfmtpd ldkt srvfk xpmx lfvdf bxgzl ctbvdq xjsgl gfgbq slkjz xskgz mqqzg cmtvkq nhhbtd nsdk mdtrqk cfb sfmbms hjkqqr jzvjxf pgt qlrrrgb xlqp ftqpg tdrxvd hqtzllj (contains dairy, shellfish)
mrqgvd rxjq cmtvkq xzn fqpt mjzpgzs mqqzg xdqx kqvhbt pfbz tdrxvd lmcqt mcvc ftqpg mdh szfxqq tsch nrlf npxrdnd ndqk slkjz jtfmtpd cfb hlzkpt prnjsm cjhv vtrchx lbdlb sckjj sjdmzj gxmk nbhhmfx dgbndg gkkcjs lxrsn dscxjl dntsjl bnfhd zpqh ldkt pgt cbdl (contains fish)
jvxqc nbhhmfx jbmxr hclf nfqkt ctbvdq gxmk ctnb brqg fzdltb bnfhd dscxjl blnsd jtfmtpd flrjj bcxxjq bgblpf csxkh gfgbq fpgmtjg fdhfpn mcvc rjf zpzzt nbh vjpnd ldkt fqpt rbkr mnj pbkr vvlbp tmckpp xzn zkfsg cfb tsrqc lmcqt kcddk xvsbr ndqk sckjj djmbx vlqz lfvdf lxrsn tsch (contains dairy, soy)
jfl qvkdgn nkjc mcvc ltrhm nhhbtd cjhv nfqkt znvmcx zmvpzp fdhfpn dlhfnjb hndcnf dvjxl pxf bnfhd vbvbbh mjzpgzs xbrtdm cfb lbdlb plgvrz hclf lfvdf pgt hrhzg hjkqqr dscxjl jxvc tcff lmcqt mzlzxcc slkjz rxjq dntsjl bggz fzdltb svvjknm xtnsbgc vqn szfxqq pzqgtb rjf zmkx xlqp khmm tsch ngrcb nbhhmfx zkjh mmhmx blnsd lxrsn jtfmtpd kcddk zkfsg tzkfgq sfmbms mdqdgf ldkt czcfdv kqvhbt nvxk fsbll pnpg hqxp fqpt rbkr vlqz (contains nuts, dairy)
tfnsz mjzpgzs zbfqrn mxfgnv nrlf ncx ccmvjbn qqq rbkr prnjsm xskgz jtfmtpd kqvhbt fqpt zhvhng zpqh pgct lmcqt ltrhm hrrt pgcxql hcrgt nfkzd qdhk ndqk mrqgvd xvsbr xjsgl ldkt tmckpp fkpjn npxrdnd xxhp cggl jzvjxf qvkdgn cvd vjpnd qtpvndc xdqx mdtrqk kcddk dptsqvq fsjcf cfb gxmk xbrtdm flrjj dntsjl (contains fish, shellfish, nuts)
sfmbms mjzpgzs mcvc hcrgt xxhp kcddk zmkx ldkt mdh npxrdnd cfb tdrxvd tzkfgq nbhhmfx vvlbp vtrchx jfl xzn rrtkdz zkjh dntsjl hmnln fsjcf rbkr tmckpp qlrrrgb xjsgl mdqdgf lfvdf jgrrd mmhmx hrhzg gkkcjs jxvc pzqgtb vjpnd lg dlhfnjb fkpjn pgcxql mrqgvd tsch vbvbbh bcvlvk tsrqc vmhhjm lmcqt jtfmtpd flrjj sckjj kgf zfrkt nhhbtd kqvhbt (contains eggs)
zhvhng xskgz vlqz qcmgxlj npxrdnd cxbkg xvsbr bcvlvk xkzsk jmvt ftqpg jfl nrlf fkpjn sqg cshq lxrsn dptsqvq rrtkdz lg bjqfl mnj dqntj xzn jtfmtpd bvzs gmsnc cvd svvjknm fdhfpn cbdl bggz ndqk lshjmc dntsjl nhhbtd sjdmzj pfhsdp tsch xmcdn zmkx cfb xkgpch mrqgvd szfxqq lmcqt fqpt kgf qdhk kcddk jpvvt pnpg jgrrd dscxjl jvxqc nkjc vtrchx pzqgtb fzdltb jzvjxf (contains soy, dairy, sesame)
bjqfl jmvt vrl blnsd jxvc bgxpfm sjpkc tflkk mjzpgzs fsbll vjpnd czcfdv lfvdf ncx mmhmx ctbvdq vdqtgt jpvvt hjkqqr txvctk lg ccmvjbn rzc mk dvzz xbrtdm tzkfgq vvlbp flrjj nfqkt ldkt jnmsr kcddk zpzzt lkvdg xl mqvf hrhzg vtrchx cfgc pgt xlqp xskgz dvjxl nkjc mxfgnv mcvc hqxp xpmx tmckpp pxf nfkzd cggl kqvhbt kgf fdhfpn plgvrz zhvhng jbmxr qcmgxlj fqpt bcxxjq jtfmtpd lmcqt csqrvk fsjcf tsch brqg mdqdgf fkpjn nbh srvfk hndcnf cfb mnj lbdlb mzlzxcc xmcdn qpdd hnpd hclf xzn svvjknm dptsqvq (contains soy, nuts, peanuts)
nrlf zfrkt pfbz dhz bcxxjq bxgzl dgbndg vplz jtfmtpd cggl spkl ftqpg ncx cjhv npxrdnd hrrt khmm sqg djmbx sjdmzj cshq lmcqt lshjmc fzdltb hjkqqr njjvq lbdlb nbhhmfx ttlvf zpqh tfnsz fqpt qqq kcddk gxmk qlrrrgb prnjsm xmcdn tzkfgq dmtcj txvctk mdh rzc pgct ldkt ctbvdq kskbk hnpd zbfqrn vlqz tdrxvd cfb (contains peanuts, eggs)
sjdmzj dgbndg cfb tdrxvd hnpd dntsjl xskgz pfbz fpgmtjg mmhmx tzkfgq lmcqt ngrcb xvsxb npxrdnd khmm mdtrqk sgczbl hcrgt tsrqc sfmbms fdhfpn xjsgl kcddk nbhhmfx ccmvjbn hjkqqr xmcdn pbkr szfxqq mnj hqxp rzc zpqh hrrt xqbtls jtfmtpd gscxfbd fkpjn mzlzxcc dqntj ldkt mk fqpt pzqgtb gfgbq xkgpch qvkdgn rjf nfqkt bvzs hclf dhz dptsqvq (contains eggs, fish, peanuts)
xmcdn kcddk lg zbfqrn tzkfgq pxf qtpvndc ldkt rxjq fqpt flrjj jfl sjdmzj rzc nvxk lxrsn vvlbp zmvpzp tsch zhvhng ngrcb cfb blnsd bqrsxn djmbx jnmsr cfgc hqxp mmhmx mk mxfgnv njjvq jxvc xkgpch ncx tsdcm fsjcf fpgmtjg cvd klnrvd jpvvt nkjc xvsxb tmckpp pfbz dvjxl ctnb nhhbtd rrtkdz mdtrqk prnjsm zmkx nbh tcff czcfdv tdrxvd xxhp lmcqt vtrchx cxbkg zfrkt slkjz xl mjzpgzs dvzz cmtvkq jtfmtpd xpmx xdqx vzkbf (contains shellfish, soy, nuts)
hrrt dlhfnjb dntsjl xjsgl hclf rzc rxjq djmbx mzlzxcc jnmsr mjzpgzs xvsbr xvsxb ttlvf zbfqrn mmhmx fdhfpn lmcqt tflkk rbkr npxrdnd jgrrd fpgmtjg mdtrqk vplz sfmbms hmnln bgblpf qvkdgn lbdlb bqrsxn cfb lfvdf cxbkg hcrgt hnpd ngrcb cggl ndqk kcddk xkgpch jbmxr dgbndg fkpjn nbhhmfx tmckpp bcvlvk hndcnf qdhk cjhv slkjz tsch zhvhng qtpvndc blnsd ccmvjbn xskgz nrlf hlzkpt dqntj fqpt ldkt bnfhd vrl sjpkc pbkr (contains sesame, peanuts, dairy)
