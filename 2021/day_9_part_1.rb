# frozen_string_literal: true

map = []

DATA.each_line do |line|
  map << line.strip.split("").map(&:to_i)
end

minimums = []

map.each_with_index do |row, y|
  row.each_with_index do |cell, x|
    next if x > 0 && map[y][x - 1] <= cell
    next if x + 1 < row.length && map[y][x + 1] <= cell
    next if y > 0 && map[y - 1][x] <= cell
    next if y + 1 < map.length && map[y + 1][x] <= cell

    minimums << cell
  end
end

puts minimums.map { |i| i + 1 }.sum

__END__
2127897678998676894313987643134789876543434987678932345965421298989998743210145989653456789543212456
1056789569876545679524598854545689765432123996567891959895310197678998654359239879542345699765401347
2245893458989434788965699967876789897643439875469999797689923998587899765498998765431234569543212398
9499912967898323567976989878987895999654545997348998654567899876456789876997439876510123478954394989
8978909898987456978989876989998954989897656797657897543489910975345699989875421987321235589765989978
7567899789876567899998965399969893976998767998798976701567999863245988998996410198934356678978978767
4348998678988998967897894219856789984589989999899654323488987652129876987989321239765477889989869945
5457897567899659456986789998745696943467896899998765454599986543098765435678932349876567993497657834
6667895456789542399765498899534785892356795789019876565679397653129876566789649498987899212987545125
7778943345895421989873347678921234789467893578923989879799298854234987879898798987898934929976321016
9899321256789592976432134569432345678989922459894596989998989976349999989999987546769899898765432135
2999432347899989876541015678943457989993210998789954599987676897498987696789998423856789769898543234
1397954459999875987763237789655698999875399766567895798976545789987996515569879212345678954987654659
2986896598999964399854346898767789432976987654356789997995434997676789403498765423476899123599965767
9995789987989543298765657899898994321099798765467898886789759887545693212979998534589921034598796878
8854699876578954369987867998979498752197679876878997675789898765434579439865987657678932126798689999
7653986543457965456998978997654349543986565987989876554679959876312389998654598768799874235987578924
8762399874668996789899989898763298765799434598999877323488949943101249876543329899998765399795456899
9821298765978989899789498799821019879998945689798765434567998654323347997721012987989876987654345678
5432349876789667987689234679932923998767976797669876545679239967457656985432323495479989998973234599
7653656987896549876510134569899894987656988989545998766789999896569869876554536589356999869765345678
8995767998997432989432249789789789998967899879439899987999888789689978989865787679277897659887897799
9989898999987643987543698997675678919878988768998789998997675689893989998976788792125789545998998989
7878999997898954599654567898544578909989677657896579999986524599932199867987899891014898956799449678
6567899876789867698767898987623567898796543546976467899875312679549989756798910954323457897892323579
5456789865798988789878919876544899944598652125894356799964303578998775635669892985454768998921012357
6578998974567899894989323989875678932987654034689167899875213467899654423456789876579899659434223456
7989987896698999923899569997987899321298543125679878901987824569999763214878996987897999549645394567
8999876797899889212688998976498976490129654346789989899999434598899874323989324998956798998656989678
9459865989987678923567977897319987989998776658991296798898945976789985434789909869867987899868978999
1297654578976567894599756999423498976899989769210145987757899864567897565699897654989876978979867899
2984553568997458965987649899564999985689790989921236986546789653678998987789789943299865867899756989
9873212779998569876799534768979899976797652499892959877435678954789769198993567894989764556798979878
9762102389987679987998423459998789989898743988789898764323489769899854399212456789876553545787898765
8743212387898789199987515767997657892997659975698789875212599878998765988924567898765432134456789954
7656326456899893245697623499987545943698998754894678987101278989999899876799779999874321012367899893
8766546567899994357986434989897657954569879643253459998234567899878999865678999998765432133456789762
9898757878948789469897899878798998968698765432101268999455678998767998764569898919987543245777899843
9999868999234679598798989765689209979999876954216999498677989893456789343698787934598654356889967955
8799978920134797699679976774978999989887989875425889599789598754678993201799656895679975677992459896
7678989321295989989569865443769989998765492995434678989893489866899994319987545789899896789991298789
8589995439989878976498778332356678999974321297567889476942678977945986998999334499999797998989397679
5468997698875767895359643201234589987543210198679991345894567988932199876789212357895679876578976568
6679659797664656789298756312345678998659421239989982496789978999993249765678923789964598765467895457
7892345986542547994359895423456989999798934346799976587899899999989497534679895689012349865376799345
8901239875430239965467997934767899897987945456789987698998799987878989423567789792123497654245678956
9212498765321349896778987545889987786456899569898899789987689986656679212345678989434569775678989767
4323989876732399789899987676790296654365678998987789891296569875434598993457999878945979996799799878
6539876986543987678976599789891985733234567897665678990987679986321456789569875467959899987896541989
7898775499859876547895459893999864210123789986424569989998894987432358897698764347898789999965430196
8999664369767998756789349901299754321245699875313457979869923976544789989799875456789578998965321245
9998543249878999767893298919989865452376789654201378965456894987685678979899989767895456467999432467
6987654567999999988999987998979878763589895975613456954346799898776789569978999898954314345678954578
5498975698999989999998976656867989874678934986894579893236789759887992398867899999654301236899965689
2349298789898678901987545343455699989789423987965698789345678945998931987656567898764212345679876796
1492109898796546699876532101234789999897912398876988678957899234569540198744457999865324567899989895
0989912999689134589987543212345678978986899469989976567898910123578951987632379899976545989989993934
9879899998578995679987698654896789569875678989998965458999321239699892398540256789988657997678932123
8765698766456789790198789765787893398764567899987654347698954398998789987641234997699898964567893254
9854597654345999891999999876898921296543235798999864234567895987586679998932656896569979753477894347
8966987643234899999892102987999510989792199987789542123458999878494567899843767943457965432356989456
7698998732123799999789212998984329878989987545678931015867987654343498998654588932369874321245678977
4569998754345678987678929899965498768779876534458942123989999843212989329776689643456985210124899098
3499789965456789976587898767896599654567989214347895435679899954101978910987899865677894342246789199
4987679876667998765456789656789987663412498501256896546798788943229869891298910987788999943358998989
9876578987979899754345692345678996532101987432345789657987676794398756789989439698999998896479877578
9865456899898789656236794556789987643419876567899898768976545895999545678968998549545997689589765458
7654345798765678942134895877890198984523987678998969878998436789895434799657897667939876579998642367
9743234679854567893245986798931299876634698789987656989876545998754323899546799788998655468895431345
8754123498765678965757897989949989987745789898798767999998689899895435678935688999896544356799430123
9873236789976989879998999878898679998876996955679879898549896689986547899923567899765433245678921234
4986545697698995990139998767689568999987894544578998767533934568998658997894578979854321014789932356
3497956989559024921239876553569459998998943423599569654321023456789769876789678967965762123599893467
2989899879432129892356997432488968996999862013489459785632436567899978965456999656987653234789794578
9875768968993298789997989551567899989899973124578979876545557678999989654345878943299754356997679989
9764454557989987696789876532898939879789989235689989997786878789788996543234567892129898456789567891
7653212345978999545678987656789549765678998945792398798897989897657987632123457893239876567892456910
6542103459956789223899998868899998654569467967899989549998995938545899821034578954345987678901688922
7654713998745679019998999979999869732479338998998978932389654320134789752156689766787898799213899993
8765629897634467998787889989198754321569123789987569893479765434545689843278793997898949894345789789
9886798654524346789656678993239865587678935689876458799568986755678999654689891989969435965986896698
1998987543210289899544569654345976799789545679854347678979987999799298767896989878954319876898954597
2989698954322779998623678967478989899899956898743234569989199878989129979975678969543201987989543986
9876559766433568999654567899567997974969898987642145689994299769878949989654989656994312998979691975
9965449898965878998795678978979876463456789999853234567896987654567898797643895448789429899768989987
8654323999878989319989989869899964321567899989964345678999998943478997699432689235668998798657878999
9798414598989698909978998756789876432878978879875899789898999854679876578993590123456789698743467890
9997523997694567898767899845699987643589665367996789898766898765698764356789689234577896549832579932
9899639889543458999658999434989998789696554245697893999954779977789893298999894395989965439943567893
8798998765612345987649898912978999898789432134598954989763567898899954989456976989999876598997678964
7697989954201234598732767999868899929897993249679999868322345909999899878967989878901989967989789875
6545679876345348999821656789756789101956789398999987543210458912398795967978999767892399857679991989
5434589987466467987510345897647998932345999987989998667321567893987654356799329878993998643567890995
7623491299567679875431256998734567894569878436767999779542678949876543267899410989679875432375789876
3212989998978989985432345987523458987698765425458989987654789530998764588998921393598964321234578997
4329879876899799876543467895434679398789896202345678999767897921239965799987899932987543210123456789
5498765345789654987656798976546793239999954314569789129898956892456986789676598893987654324545567895
6987653235678943298787899987897892127689965435678995398989347793678997896563456789598766436656698934
8998732123459942109898946498989921013579876566799876987673234689999498965452346995469887645787789312
9439851012567893235999532349765432123489989679899987899432124567892359764321245789312998789899896434
