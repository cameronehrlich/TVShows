#!/usr/bin/env ruby

# This file is part of the TVShows source code.
# http://github.com/mattprice/TVShows

# TVShows is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

requires = [
	'open-uri',
	File.join(File.dirname(__FILE__), 'TVShowsScript/TVShowsConstants.rb'),
	File.join(File.dirname(__FILE__), 'TVShowsScript/lib/plist.rb')
]

def die(message)
	time = Time.new
	$stderr.puts "#{time.strftime("%m/%d/%y %H:%M:%S")}\tTVShows Error: #{message}"
	exit(-1)
end
def printError(message)
	time = Time.new
	$stderr.puts "#{time.strftime("%m/%d/%y %H:%M:%S")}\tTVShows Error: #{message}"
end
def printException(exception)
	time = Time.new
	$stderr.puts "#{time.strftime("%m/%d/%y %H:%M:%S")}\tTVShows Error: #{exception.inspect}\n\t#{exception.backtrace.join("\n\t")}"
end

requires.each { |r|
	begin
		die("Could not load #{r}") unless require r
	rescue => e
		printException(e)
	end
}

exit(2) if ( ARGV.length != 2 )

begin

	path = ARGV[0]
	version = ARGV[1]

	shows = {
		"Shows" => [],
		"Version" => version
	}

	data = nil
	3.times { |n|
		begin
  			data = open("http://ezrss.it/shows/?format=plain")
  			break
  		rescue Exception, Timeout::Error => e
  			printError("Failed to download the list, retrying...")
  		end
  	}

  	raise "Data is nil." if data.nil?	

  	data.read.split("\n").each { |show|
  	  show = show.split("|")
  		shows["Shows"] << {
  			"ExactName"		=> CGI::escape(show[1].gsub("%2B", "+")),
  			"HumanName"		=> show[1],
  			"Subscribed"	=> false,
  			"Links"			=> show[0] + "&mode=rss"
  		}
  	}

	# Specials, non-shows, misnamed shows, etc.
	list1 = ["24+Day+7+Preview", "24+Redemption", "36th+Annual+American+Music+Awards", "A+Colbert+Christmas+++The+Greatest+Gift+of+All+%28", "A+Very+British+Gangster", "A+Very+British+Gangster+Extras", "ABC+A+Machine+to+Die+For+The+Quest+for+Free+Energy", "ABC+Dinosaurs+on+Ice", "Afghanistan+Drugs+Guns+And+Money", "Aftermath+Population+Zero", "American+Chopper+Eragon+Bike+Pt1", "American+Gangster+HBO+First+Look", "American+Gladiators", "Americans+in+Paris", "Americas+Deadliest+Prison+Gang", "Americas+Funniest+Home+Videos+S", "Americas+Next+Top+Model+Exposed+Part+2", "Americas+Next+Top+Model+Exposed+Part1", "Anchorwoman", "Ancient+Discoveries+Mega+Machines", "Animal+Planet+Buggin+with+Ruud+Alaskan+Bugs+on+Ice", "Animal+Planet+Buggin+with+Ruud+Bug+Cloud+9", "Antarctica+Dreaming+Wildlife+on+Ice", "Antarctica+Dreaming+Wildlife+on+Ice+Extra+Antarctic+Peninsula+South+Georgia+Island+and+the+Falkland+Island", "Antarctica+Dreaming+Wildlife+on+Ice+Extra+Narration+Removed", "Austin+City+Limits", "Australian+Geographic+Best+of+Australia+Tropical+North+Queensland", "BBC", "BBC+2008+After+Rome+Holy+War+and+Conquest", "BBC+Alfred+Brendel+Man+and+Mask", "BBC+Amazon+With+Bruce+Parry", "BBC+Black+Power+Salute", "BBC+Castrato", "BBC+Charles+Darwin+and+the+Tree+of+Life", "BBC+Charles+Rennie+Mackintosh+The+Modern+Man", "BBC+Coast+And+Beyond+Series+4", "BBC+Dan+Cruickshanks+Adventures+in+Architecture", "BBC+Darwin", "BBC+Darwins+Struggle+The+Evolution+of+the+Origin+of+Species", "BBC+Did+Darwin+Kill+God", "BBC+Earth+++The+Power+Of+The+Planet", "BBC+Earth+Power+of+the+Planet", "BBC+Earth+The+Climate+Wars", "BBC+Electric+Dreams", "BBC+Francescos+Mediterranean+Voyage", "BBC+Future+of+Food", "BBC+Hardcore+Profits", "BBC+Horizon", "BBC+Horizon+How+Mad+Are+You", "BBC+Hotel+California+LA+from+the+Byrds+to+the+Eagles", "BBC+Joanna+Lumley+In+the+Land+of+the+Northern+Lights+DVB+x", "BBC+Johnny+Cash+The+Last+Great+American", "BBC+Law+and+Disorder", "BBC+Life+In+Cold+Blood", "BBC+Lightning+Nature+Strikes+Back", "BBC+Lost+Horizons+The+Big+Bang", "BBC+Lost+Land+of+the+Volcano", "BBC+Medieval+Lives", "BBC+Medieval+Lives+Extra+Gladiators+The+Brutal+Truth", "BBC+Montezuma", "BBC+Natural+World", "BBC+Natures+Great+Events", "BBC+OCEANS", "BBC+Pedigree+Dogs+Exposed", "BBC+Russia+A+Journey+with+Jonathan+Dimbleby", "BBC+Shroud+of+Turin+x", "BBC+South+Pacific", "BBC+Stuart+Sutcliffe+The+Lost+Beatle", "BBC+The+American+Future+A+History+1of4+American+Plenty", "BBC+The+American+Future+A+History+2of4+American+War", "BBC+The+American+Future+A+History+3of4+American+Fervour", "BBC+The+American+Future+A+History+4of4+What+is+an+American", "BBC+The+Atheism+Tapes", "BBC+The+Big+Bang+Machine", "BBC+The+Cell", "BBC+The+Darwin+Debate", "BBC+The+Flapping+Track", "BBC+The+Frankincense+Trail", "BBC+The+Harp", "BBC+The+Incredible+Human+Journey", "BBC+The+Last+Nazis", "BBC+The+Life+And+Death+of+a+Mobile+Phone", "BBC+The+Life+and+Times+of+El+Nino", "BBC+The+Link+Uncovering+Our+Earliest+Ancestor", "BBC+The+Lost+World+of+Tibet", "BBC+The+Love+of+Money", "BBC+The+Machine+that+Made+Us", "BBC+The+Mark+Steel+Lectures+Charles+Darwin", "BBC+The+Podfather", "BBC+The+Pre+Raphaelites", "BBC+The+Private+Life+of+a+Masterpiece+Masterpieces+1800+to+1850", "BBC+The+Private+Life+of+a+Masterpiece+Masterpieces+1851+to+1900", "BBC+The+Private+Life+of+a+Masterpiece+Renaissance+Masterpieces", "BBC+The+Private+Life+of+a+Masterpiece+Seventeenth+Century+Masters", "BBC+The+Secret+Life+Of+Elephants", "BBC+The+Sky+at+Night", "BBC+The+Story+of+India", "BBC+The+Strange+and+The+Dangerous", "BBC+The+Strange+and+The+Dangerous+Extra+The+Weird+World+of+Louis+Theroux", "BBC+The+Voice", "BBC+This+World+Gypsy+Child+Thieves", "BBC+Time", "BBC+Timewatch", "BBC+Upgrade+Me", "BBC+What+Darwin+Didnt+Know", "BBC+What+Happened+Next", "BBC+Who+Killed+The+Honey+Bee", "BBC+Wild+China", "BBC+Yellowstone", "BET+Hip+Hop+Awards", "Baftas", "Barack+Obama+Presidential+Victory+Speech", "Battlestar+Galactica+Razor", "Battlestar+Galactica+Revealed", "Battlestar+Galactica+The+Last+Frakkin+Special", "Battlestar+Galactica+The+Phenomenon", "Battlestar+Galactica+The+Top+10+Things+You+Need+To+Know", "Beijing", "Beijing+Olympic+Games", "Beijing+Olympic+Games+Athletics+Mens", "Beijing+Olympic+Games+Athletics+Mens+Triple+Jump+Final", "Beijing+Olympic+Games+Athletics+Womens", "Beijing+Olympic+Games+Athletics+Womens+High+Jump+Final", "Beijing+Olympic+Games+Diving+Womens+Synchronised+10m+Platform+Final", "Beijing+Olympic+Games+Mens+Marathon", "Beijing+Olympic+Games+Rowing+Mens+Eights+Final", "Beijing+Olympic+Games+Rowing+Mens+Lightweight+Double+Sculls+Final", "Beijing+Olympic+Games+Rowing+Womens+Quadruple+Sculls+Final", "Beijing+Olympic+Games+Swimming+Mens", "Beijing+Olympic+Games+Swimming+Mens+50m+Freestyle+Final", "Beijing+Olympic+Games+Swimming+Womens", "Beijing+Olympic+Games+Swimming+Womens+50m+Freestyle+Final", "Beijing+Olympic+Games+Swimming+Womens+50m+Freestyle+Semifinals", "Beijing+Olympic+Games+Weightlifting+Mens", "Beijing+Olympic+Games+Womens+Marathon", "Beijing+Olympics", "Beijing+Olympics+2008+Day+Eleven+Gymnastics+Highlights", "Beijing+Olympics+2008+Day+Fourteen+Mens+Basketball+Highlights", "Beijing+Olympics+2008+Day+Nine+Highlights", "Beijing+Olympics+2008+Day+Ten+Gymnastics+Highlights", "Beijing+Olympics+2008+Day+Twelve+Basketball+Highlights", "Best+Movies+Ever+Chases", "Best+Of+Top+Gear+Series+11+Part1", "Beyond+the+Yellow+Brick+Road+The+Making+of+Tin+Man", "Big+Brother", "Big+Brothers+Big+Mouth", "Bigger+Stronger+Faster", "Bigger+Stronger+Faster+Extras", "Biography+Channel+Barack+Obama+Inaugural+Edition", "Biography+Channel+Charles+Darwin+Evolutions+Voice", "Biography+Channel+Chuck+Norris", "Biography+Channel+Hollywoods+10+Best+Cat+Fights", "Biography+Channel+Jackson+Pollock", "Biography+Channel+Jon+Stewart", "Bollywood+Hero+Part+I", "Bollywood+Hero+Part+II", "Bollywood+Hero+Part+III", "Booze+A+Young+Persons+Guide", "Born+Survivor+Bear+Grylls", "Breaking+Bad+Uncensored+IFC", "Britain+From+Above", "Britain+From+Above+Extra", "British+Painting", "Brothers+2009", "Buggin+with+Ruud+Island+of+Giant+Bugs", "CBC+Buried+at+Sea", "CH4+Extraordinary+Animals+In+The+Womb", "CW+Fall+Preview", "Cash+Poker", "Ch4+Making+the+Monkees", "Ch+4+Race+and+Intelligence", "Ch4+Sex+Bomb", "Ch4+The+Great+Global+Warming+Swindle", "Ch4+The+Great+Global+Warming+Swindle+EXTRAS", "Charles+Darwin+The+Story+Of", "Checkpoint", "Cheerleader+U", "Christmas+In+Rockefeller+Center", "Claes+Oldenburg", "Clash+of+the+Choirs", "Classic+Albums+Deep+Purple+Machine+Head", "Classic+Albums+Def+Leppard+Hysteria", "Classic+Albums+Jimi+Hendrix+Electric+Ladyland", "Classic+Albums+Pink+Floyd+The+Making+of+The+Dark+Side+of+the+Moon", "Classic+Albums+Queen+The+Making+of+A+Night+At+The+Opera", "Comanche+Moon+E01", "Comanche+Moon+E02", "Comanche+Moon+E03", "Comedy+Central+Last+Laugh", "Comedy+Central+Presents+Dan+Cummins", "Comedy+Central+Presents+Jo+Koy", "Comedy+Central+Presents+Kyle+Grooms", "Comedy+Central+Presents+Sebastian+Maniscalco", "Comedy+Central+Presents+Stephen+Lynch", "Comedy+Inc+CA", "Conan+O+Brian", "Concert+for+Diana+Hour+Five", "Concert+for+Diana+Hour+Four", "Concert+for+Diana+Hour+One", "Concert+for+Diana+Hour+Six", "Concert+for+Diana+Hour+Three", "Concert+for+Diana+Hour+Two", "Constantines+Sword", "Constantines+Sword+Extras", "Countdown+To+The+Emmys", "Crude+Impact", "Crude+Impact+Extras", "Da+Vinci+Seeking+the+Truth", "Dallas+Cowboys+Cheerleaders+Making+The+Team", "Dancing+With+The+Stars+Special+US+Judges+All+Time+Top+10", "Dancing+With+The+Stars+USA", "Deadliest+Catch+Behind+The+Scenes+Special", "Death+Of+A+President", "Defying+Gravity+US", "Democratic+Convention", "Derren+Brown+Something+Wicked+This+Way+Comes", "Desperate+Housewives+Time+To+Come+Clean", "Desperate+Virgins", "Dirty+Jobs+AU", "Dirty+Jobs+Big+Animal+Vet", "Dirty+Jobs+S04+Special+Greenland+Shark+Quest", "Dirty+Jobs+Special", "Discovery+2057", "Discovery+Africas+Super+Seven+x", "Discovery+Ancient+Inventions", "Discovery+Arctic+Exposure+with+Nigel+Marven", "Discovery+Bugging+With+Ruud+Amazon+Kill+or+Cure+x", "Discovery+Bugging+With+Ruud+Hawaii+Moving+Heaven+and+Earth+x", "Discovery+Building+The+Ultimate+Digging+Big", "Discovery+Channel", "Discovery+Channel+American+Chopper+OCC+Roadshow", "Discovery+Channel+American+Chopper+On+The+Road", "Discovery+Channel+Beach+Towns+With+Attitude", "Discovery+Channel+Build+It+Bigger", "Discovery+Channel+Dirty+Jobs+Americans+Worker", "Discovery+Channel+Dirty+Jobs+Roadkill+Cleaners", "Discovery+Channel+Dirty+Jobs+Veterinarian", "Discovery+Channel+Discovering+Ardi+x", "Discovery+Channel+Egypt+Uncovered", "Discovery+Channel+Egypts+Ten+Greatest+Discoveries", "Discovery+Channel+Forensic+Detectives+Trail+Of+Evidence", "Discovery+Channel+Kings+of+Construction+Gotthard+Base+Tunnel+In+Switzerland", "Discovery+Channel+Kings+of+Construction+Tung+Chung+Hong+Kongs+New+Cable+Car", "Discovery+Channel+Most+Evil+Mastermind", "Discovery+Channel+Raising+The+Mammoth+CD1", "Discovery+Channel+Raising+The+Mammoth+CD2", "Discovery+Channel+Scientists+Guinea+Pigs", "Discovery+Channel+Seven+Wonders+of+Ancient+Egypt", "Discovery+Channel+Sleeping+With+Teacher", "Discovery+Channel+Time+Warp", "Discovery+Channel+Why+Ancient+Egypt+Fell", "Discovery+Channel+Worlds+Biggest+Airliner", "Discovery+Channel+Worlds+Toughest+Jobs+Pyrotechnician", "Discovery+Civilisation+Future+Weapons", "Discovery+Civilisation+Unsolved+History+Aztec+Temple+Of+Blood", "Discovery+Edge+of+Existence", "Discovery+Egypts+New+Tomb+Revealed", "Discovery+End+of+Extinction+Cloning+the+Tasmanian+Tiger", "Discovery+Into+the+Unknown+with+Josh+Bernstein+Season+1", "Discovery+Jack+the+Ripper+The+First+Serial+Killer", "Discovery+Mastodon+in+your+Backyard+The+Ultimate+Guide", "Discovery+Mayday+Air+India+Explosive+Evidence+x", "Discovery+Mayday+Bomb+on+Board+x", "Discovery+Megabuilders+Season+3", "Discovery+Naica+Secrets+of+the+Crystal+Cave+x", "Discovery+Nile+River+of+Gods", "Discovery+On+the+Volcanoes+of+the+World", "Discovery+Planet+Luxury+Season+2", "Discovery+Presents+Ted+Koppel+The+Price+of+Freedom", "Discovery+Science+First+Alien+Encounter", "Discovery+Science+Men+Are+Better+Than+Women+Rafting", "Discovery+Science+Men+Are+Better+Than+Women+Sailing", "Discovery+Science+Tornado+Touchdown", "Discovery+Shark+Feeding+Frenzy+x", "Discovery+Skull+Wars+The+Missing+Link", "Discovery+Solar+Empire+On+Jupiter", "Discovery+Stephen+Hawking+and+the+Theory+of+Everything+1of", "Discovery+The+Beauty+of+Snakes+x", "Discovery+The+Body+Machine+x", "Discovery+The+Leopard+Son+x", "Discovery+Traveler+Thailand+1of", "Discovery+Traveler+Thailand+2of", "Discovery+Turbo+Engineering+The+World+Rally+Monte+Carlo+Or+Bust", "Discovery+Turbo+Firepower+Destroyer", "Discovery+Understanding+Bacteria", "Discovery+Understanding+Flight", "Discovery+Understanding+Time", "Discovery+Unwrapped+The+Mysterious+World+of+Mummies", "Discovery+Valley+of+the+T+Rex", "Discovery+Whats+That+About+The+Airport+x", "Discovery+Whats+That+About+The+Scrapyard+x", "Dispatches+Drinking+Yourself+To+Death", "Doctor+Who+At+The+Proms", "Doctor+Who+Confidential", "Doctor+Who+Confidential+S04+Special+The+Eleventh+Doctor", "Doctor+Who+Confidential+S04+Xmas+Special", "Doctor+Who+S04+Christmas+Special+%28", "Doctor+Who+S04+Special+Planet+Of+The+Dead", "Doctor+Who+Special", "Doctor+Who+Xmas+Special", "Doctor+Who+at+The+Proms+Behind+The+Scenes", "Dogface", "Dracula", "Drosera+Documentary+Carnivorous+Plants+FS", "Duet+Impossible", "E+True+Hollywood+Story", "Early+Renaissance+Painting", "Eurovision+Song+Contest", "Evanescence+Live+At+Rock+In+Rio", "Extras+S02+Christmas+Special", "Extras+Xmas+Special", "Faceless", "Fallen+Part+1+The+Beginning", "Fallen+Part+2", "Fallen+Part+3", "Family+Guy+S06+Special", "Fast+And+Furious", "Fearless+Planet+Part1+Hawaii", "Fearless+Planet+Part2+Alaska", "Fearless+Planet+Part3+Saraha", "Fearless+Planet+Part4+Earth+Story", "Fearless+Planet+Part5+Great+Barrier+Reef", "Fearless+Planet+Part6+Grand+Canyon", "Flying+Confessions+of+a+Free+Woman+EXTRA+Interview", "Fonejacker+Christmas+Special", "Forensic+Files+Photo+Finish", "Four+Kings", "Fox+Fall+Preview", "Friday+Nights+Lights", "Fringe+S02+Access+All+Areas", "Future+Focus+Biometrics", "Geologic+Journey", "Get+Lost", "Ghost_Whisperer", "Goya+Crazy+Like+A+Genius", "Grey%5C%5C%5Cs+Anatomy", "HDTV+ABC+Earth", "HDTV+BBC+The+Medici+Makers+of+Modern+Art+DVB+x", "HDTV+Discovery+Destroyer+Forged+In+Steel+x", "HDTV+Discovery+Naked+Science+Asteroid+Alert+x", "HDTV+Discovery+Paul+Merton+In+China", "HDTV+Discovery+The+Last+Maneater+Killer+Tigers+of+India+x", "HDTV+Discovery+The+True+Legend+of+the+Eiffel+Tower+x", "HDTV+Discovery+Worlds+Biggest+and+Baddest+Bugs+x", "Hacking+Democracy", "Halfway+Home", "Harpers+Island+Solved", "Harpers+Island+Unsolved", "Harry+Potter+And+The+Order+Of+The+Pheonix+Behind+The+Magic", "Harry+Potter+and+the+Order+of+the+Phoenix+HBO+First+Look", "Hawthrone", "Heroes+Unmasked", "High+Stakes+Poker", "His+Dark+Materials+Book+1+Northern+Lights", "His+Dark+Materials+Book+2+The+Subtle+Knife", "His+Dark+Materials+Book+3+The+Amber+Spyglass", "History+Channel+Ancient+Aliens", "History+Channel+Ape+to+Man", "History+Channel+Conspiracy+The+Robert+Kennedy+Assassination", "History+Channel+Dead+Mens+Secrets+Plotting+To+Kill+Hitler", "History+Channel+Decoding+the+Past+The+Real+Sorcerers+Stone+x", "History+Channel+Digging+For+The+Truth+WS", "History+Channel+Dinosaur+Secrets+Revealed", "History+Channel+Disasters+of+the+Century+Second+Narro", "History+Channel+Great+Spy+Stories+Hitlers+Spies", "History+Channel+Journey+to+10", "History+Channel+Life+After+People", "History+Channel+Modern+Marvels+Machu+Picchu", "History+Channel+Modern+Marvels+The+Hoover+Dam", "History+Channel+Star+Wars+The+Legacy+Revealed", "History+Channel+Sun+Tzus+The+Art+Of+War", "History+Channel+Test+Lab", "History+Channel+The+Universe+Season+1", "History+Channel+The+Universe+Season+2", "History+Channel+The+Universe+Season+3", "Hitlers+War+On+America", "House+S06+An+Insiders+Guide", "How+I+Met+Your+Mother+%28", "Hunt+the+Kaisers+Cruisers", "IMAX+Bugs%21+A+Rainforest+Adventure+x", "IMAX+Volcanoes+Of+The+Deep+Sea", "ITV+South+Bank+Show+Cildo+Mereilles", "ITV+The+Secret+Caribbean", "Imagine+Peter+Pan+A+Hard+Act+To+Follow", "Imagine+The+Beatles+In+Love", "Important+Things+with+Demetri+Martin+REPACK", "Impressionist+Painting", "In+Debt+We+Trust+America+Before+the+Bubble+Bursts", "In+Pot+We+Trust", "Inferno+999", "Inside+The+Actors+Studio", "Inside+The+Actors+Studio+Al+Pacino", "Italian+Renaissance+Painting", "Its+Always+Sunny+In+Philidelphia", "J+K+Rowling+A+Year+In+the+Life+Of", "JASPER+JOHNS+Ideas+In+Paint", "James+May+At+The+Edge+Of+Space", "James+May+On+The+Moon+Part+1+DOCU", "James+Mays+Big+Ideas", "Jericho+S01+Special+Return+to+Jericho", "Jimmy+Kimmel", "John+Adams+Part+7", "John+Adams+Part1", "John+Adams+Part2", "John+Adams+Part3", "John+Adams+Part4", "John+Adams+Part5", "John+Adams+Part6", "John+Oliver+Terrifying+Times", "John+Safrans+Race+Relations", "John+Virtue+London+Paintings", "John+from+Cincinnati", "Joy+Division", "Katt+Williams+The+Pimp+Chronicles+Part+1", "Kitchen+Nightmares+US", "Knight+Rider", "Larry+King+Live", "Law+And+Order%3A+SVU", "Little+Britain+Xmas+Special+Part1", "Little+Britain+Xmas+Special+Part2", "Live+Earth+London+Black+Eyed+Peas", "Live+Earth+London+Duran+Duran", "Live+Earth+London+Foo+Fighters", "Live+Earth+London+Madonna", "Live+Earth+London+Metallica", "Live+Earth+London+Red+Hot+Chili+Peppers", "Live+Earth+London+Spinal+Tap", "Live+Earth+Sydney+Jack+Johnson", "Live+Earth+Sydney+Wolfmother", "Live+Earth+Tokyo+Rihanna", "Lost+Missing+Pieces+E10+Jack+Meet+Ethan", "Lost+S03+The+Answers", "Lost+S05+A+Journey+In+Time+Recap+Special", "Lost+Survival+Guide", "Lost+Treasures+of+the+Ancient+World", "Lost+Uncovered", "Louis+Armstrong", "Louis+C+K+Shameless", "Lucy+The+Daughter+of+the+Devil", "MTV+Making+The+Movie+Borat", "MTV+Movie+Awards", "MTV+Video+Music+Awards", "Madonna+The+Confessions+Tour+Live+From+London", "Making+The+Movie+Iron+Man", "Man+On+Wire", "Man+Vs+Wild+S03+Special+Bears+Mission+Everest", "Man+vs+Wild+S05+Will+Ferrell+Special", "Manda+Bala+Send+A+Bullet", "Manda+Bala+Send+A+Bullet+Extras", "Mandela+Son+Of+Africa+Father+Of+A+Nation", "Melrose+Place+2009", "Merlin+Secrets+And+Magic", "Micheal+Jackson", "Midsomer+Murders", "Miss+Universe+Pageant", "Mission+Man+Band", "Modern+Marvels+Cities+Of+The+Underworld", "Modern+Marvels+Commercial+Fishing", "Modern+Marvels+Corn", "Modern+Marvels+Distilleries+2", "Modern+Marvels+Engineering+Disasters+20", "Modern+Marvels+Failed+Inventions", "Modern+Marvels+Hi+Tech+Hitler", "Modern+Marvels+Ink", "Modern+Marvels+Jet+Engines", "Modern+Marvels+Renewable+Energy", "Modern+Marvels+Snow", "Modern+Marvels+Star+Trek+Tech", "Modern+Marvels+Water", "Modern+Marvels+Wiring+America", "Monster+Quest", "Mtv+Making+The+Movie+The+Dark+Knight", "MythBusters+Supersized+Myths+Special", "Mythbusters+Mythbusters+Revealed", "Mythbusters+Pirates+Special", "Mythbusters+S06+Shark+Week+Special", "NEF+And+The+Pursuit+of+Happiness+x", "NFL+Football", "NFL+Super+Bowl+XLII", "NFL+Super+Bowl+XLIII", "NGC+Air+Crash+Investigation+Mid+Air+Collision", "NHK+Satoyama+II+Japans+Secret+Watergarden", "NOVA+AstroSpies", "NOVA+Judgement+Day+Intelligent+Design+on+Trial", "NOVA+Master+of+the+Killer+Ants", "NOVA+Secrets+of+the+Parthenon", "NOVA+Sputnik+Declassified", "NOVA+scienceNOW", "NatGeo+Incredible+Human+Machine", "National+Geographic+42+Ways+to+Kill+Hitler", "National+Geographic+9+11+Science+and+Conspiracy+x", "National+Geographic+Africa+Desert+Odyssey", "National+Geographic+American+Skinheads", "National+Geographic+Ancient+Graves+Voices+of+the+Dead", "National+Geographic+Ape+Genius", "National+Geographic+Ape+Man+Search+for+the+First+Human", "National+Geographic+Australias+Animal+Mysteries", "National+Geographic+Battle+at+Kruger", "National+Geographic+Breaking+Up+The+Biggest+Historic+Bridge", "National+Geographic+Conjoined+Twins", "National+Geographic+Crash+Scene+Investigation+Runaway+Train", "National+Geographic+Crystal+Skull+Legend", "National+Geographic+Darwins+Secret+Notebooks", "National+Geographic+Death+Of+The+Universe", "National+Geographic+Dinosaur+Hunters", "National+Geographic+Dwarfism", "National+Geographic+Egyptian+Secrets+of+the+Afterlife", "National+Geographic+Evolutions", "National+Geographic+Expeditions+To+The+Edge+Mount+Hood+Climb+And+Helo+Crash", "National+Geographic+Hardest+Fighter", "National+Geographic+Hitler+and+the+Occult", "National+Geographic+Hubbles+Final+Frontier", "National+Geographic+Inside+The+Emperors+Treasure", "National+Geographic+Journey+To+The+Edge+Of+The+Universe", "National+Geographic+Kingdom+of+the+Blue+Whale", "National+Geographic+Lost+Tribe+of+Palau", "National+Geographic+Martian+Robots", "National+Geographic+Megastructures+World+Island+Wonder", "National+Geographic+Monster+of+the+Milky+Way", "National+Geographic+Moon+Mysteries+Investigated", "National+Geographic+My+Brilliant+Brain", "National+Geographic+Naked+Science+Big+Freeze", "National+Geographic+Naked+Science+Birth+of+America", "National+Geographic+Naked+Science+Deadliest+Planets", "National+Geographic+Naked+Science+Evolution+was+Darwin+Wrong", "National+Geographic+Naked+Science+First+Mariners", "National+Geographic+Naked+Science+Grand+Canyon", "National+Geographic+Naked+Science+Hubble+Trouble", "National+Geographic+Naked+Science+Prehistoric+Americans+x", "National+Geographic+Naked+Science+Solar+Force", "National+Geographic+Naked+Science+Triumph+of+the+Tank", "National+Geographic+Octopus+Volcano", "National+Geographic+Prison+Nation", "National+Geographic+Riddles+of+the+Dead+Diagnosing+Darwin", "National+Geographic+Science+of+Gigantism", "National+Geographic+Science+of+Speed+Eating", "National+Geographic+Seed+Hunter", "National+Geographic+Silkair", "National+Geographic+Six+Degrees+Could+Change+The+World", "National+Geographic+Smarter+Than+an+Ape", "National+Geographic+Spartacus+Gladiator+War", "National+Geographic+Special+Herods+Lost+Tomb", "National+Geographic+Special+Lost+Treasures+of+Afghanistan", "National+Geographic+Special+Unlocking+The+Great+Pyramid", "National+Geographic+Stonehenge+Decoded", "National+Geographic+Super+Pride", "National+Geographic+The+Living+Edens", "National+Geographic+The+Lost+Film+of+Dian+Fossey", "National+Geographic+The+Scorpion+King", "National+Geographic+Valley+Of+The+Kings", "National+Geographic+Wild+Sex", "National+Geographic+Worlds+Deadliest+Animals+Amazon", "National+Geographic+Worlds+Deadliest+Animals+Asia+Pacific", "National+Geographic+Worlds+Deadliest+Animals+Australia", "National+Geographic+Worlds+Deadliest+Animals+Costa+Rica", "NatureTech", "Nepenthes+Documentary+Carnivorous+Plants+FS", "Newport+Harbor+The+Real+Orange+County", "Next+Best+Thing+Who+Is+the+Greatest+Celebrity+Impersonator", "Night+Of+Too+Many+Stars", "Nip+Tuck+S", "No+Maps+For+These+Territories", "Oliver+Twist+2007", "Olympic+Games+Opening+Ceremony+Beijing", "Olympics+2008+Day+13+Highlights", "Olympics+2008+The+Games+Today", "Olympics+2008+The+Games+Today+Highlights", "One+Vs+100", "PBS+NOVA+Americas+Stone+Age+Explorers+X", "PBS+Nature+Parrots+Look+Whos+Talking", "PBS+Nova+Hitlers+Sunken+Secret", "PBS+Unforgivable+Blackness", "PDC+Darts+World+Matchplay+Quarter+Final+Adrian+Lewis+vs+Phil+Taylor", "PRIDE+FC+Bushido+Survival", "Panorama", "Paula+Rego+Telling+Tales", "Perfect+10+Model+Boxing", "Perfect+Parents", "Period+Piece", "Phoenix+Mars+Mission+Ashes+to+Ice", "Plagues+and+Pleasures+on+the+Salton+Sea", "Plagues+and+Pleasures+on+the+Salton+Sea+Extras", "Planet+Earth", "Police+Camera+Action+Search+And+Rescue", "Pretty+Handsome", "Pride+FC+33+The+Second+Coming", "Prison+Break+S02+Special+The+Road+To+Freedom", "Prison+Break+S03+Special+Access+All+Areas", "Prison+Break+The+Final+Break", "Prison_Break", "Punkd+S08+Special+1st+Annual+Punkd+Awards", "QI+%28Quite+Interesting%29", "Quarterlife", "Ralphie+May+Prime+Cut", "Raphael+From+Urbino+to+Rome", "Real+Time+With+Bill+Maher%3A", "Red+And+White+Gone+With+The+West", "Red+Dwarf+S9+Special+%28", "Reunion", "Rich+and+Reckless", "Rise+of+the+Video+Game", "Road+to+the+Oscars", "Robot+Chicken+REPACK", "Robot+Chicken+S03+Christmas+Special", "Robot+Chicken+Star+Wars+Episode+II", "Robot+Chicken+Star+Wars+Special", "STAG+outrageous+Moments", "Sanctuary+Webisode", "Saturday+Night+Live+Best+of", "Saturday+Night+Live+Sports+Extra", "Saturday+Night+Live+Weekend+Update+E02", "Saturday+Night+Live+in+the+90s+Pop+Culture+Nation", "Science+Channel+Its+All+Geek+to+Me+Laptops", "Seconds+From+Disaster+Everglades+Plane+Crash", "Secret+Talents+of+the+Stars", "Sex+Sin+and+Censorship+in+Pre+Code+Hollywood", "Sharkwater+Beneath+the+Surface+extra", "Sharkwater+The+Making+of+Sharkwater+extra", "Shrek+The+Halls", "Shut+Up+And+Sing", "Side+Order+of+Life", "Sky+Special+The+Simpsons+Movie", "South+Park+Pilot+The+Spirit+Of+Christmas+Jesus+VS+Santa", "Stand+Up+To+Cancer", "Standard+Operating+Procedure", "Standard+Operating+Procedure+Extras", "Stargate%3A+SG-1", "Stargate+SG+1+Inside+The", "Stargate+SG+1+The+Ark+Of+Truth", "Steve+Irwin+A+Tribute+To+The+Crocodile+Hunter", "Sukhavati", "Super+Bowl+Halftime+Show", "Super+Snakes", "Survivor+S13+Reunion", "Survivor+S14+The+Vote", "Survivor+S18+Reunion", "Survivor+US", "Survivors+2008", "Tats+Cru+The+Murals+Kings", "Terminator+TSCC+Behind+The+Scenes", "Terry+Pratchetts+HogFather+Part+1", "Terry+Pratchetts+HogFather+Part+2", "Terry+Pratchetts+The+Colour+Of+Magic+Part1", "Terry+Pratchetts+The+Colour+Of+Magic+Part2", "The+33rd+Annual+Peoples+Choice+Awards", "The+39+Steps", "The+49th+Annual+Grammy+Awards+CD1", "The+49th+Annual+Grammy+Awards+CD2", "The+50th+Annual+Grammy+Awards", "The+51st+Annual+Grammy+Awards", "The+56th+Annual+Miss+Universe+Pageant", "The+59th+Annual+Primetime+Emmy+Awards", "The+60th+Annual+Primetime+Emmy+Awards", "The+61st+Annual+Primetime+Emmy+Awards", "The+79th+Annual+Academy+Awards", "The+80th+Annual+Academy+Awards", "The+81st+Annual+Academy+Awards", "The+Andromeda+Strain", "The+Apprentice+UK+S03+The+Final", "The+Apprentice+UK+S04+Special+The+Worst+Decisions+Ever", "The+Apprentice+UK+S04+Special+Why+I+Fired+Them", "The+Art+of+Barbara+Hepworth", "The+Art+of+Eric+Gill", "The+Art+of+Francis+Bacon", "The+Art+of+Helen+Chadwick", "The+Art+of+Henry+Moore", "The+Bachelor+S12+Special+Where+Are+They+Now", "The+Best+Of+Top+Gear+Series+9+Special", "The+Big+Drugs+Debate", "The+Catherine+Tate+Christmas+Show", "The+Chopping+Block", "The+Chopping+Block+US", "The+Colbert+Report+08+Aug+07+%28", "The+Colbert+Report+08+Jan+08+%28", "The+Colbert+Report+16+May+07+%28", "The+Colbert+Report+4+Mar+08+%28", "The+CollegeHumor+Show", "The+Da+Vinci+Detective", "The+Daily+Show+04+Jun+07+%28", "The+Daily+Show+08+Jan+08+%28", "The+Daily+Show+11+Oct+07+%28", "The+Daily+Show+3+Mar+08+%28", "The+Daily+Show+4+Mar+08+%28", "The+Daily+Show+and+The+Colbert+Report+Mid+Term+Midtacular", "The+Devil+Came+On+Horseback", "The+Devils+Whore+Part1", "The+Devils+Whore+Part2", "The+Devils+Whore+Part3", "The+Devils+Whore+Part4", "The+Dudesons", "The+Genius+of+Charles+Darwin", "The+Genius+of+Charles+Darwin+EXTRAS", "The+God+Who+Wasnt+There+Extra+Extended+Intervie", "The+Great+Global+Warming+Swindle", "The+Heros+Journey", "The+Hills+Presents+Speidis+Wedding+Unveiled", "The+Hills+S04+The+Lost+Scenes", "The+Howlin+Wolf+Story", "The+Inspector+Lynley+Mysteries", "The+Journalist+and+The+Jihandi+The+Murder+of+Daniel+Pearl", "The+King+Of+Kong", "The+King+Of+Kong+Extras", "The+Last+Continent", "The+Last+Enemy", "The+Last+Templar+Part1", "The+Last+Templar+Part2", "The+Last+Templar+Pt+2", "The+Last+Templar+Pt+I", "The+Last+Templar+Pt+II+PROPER", "The+Lost+Room+Part+1+%28", "The+Lost+Room+Part+2+%28", "The+Lost+Room+Part+3+%28", "The+Money+Programme+Britains+Brilliant+Ideas+Boom", "The+Money+Programme+Virtual+World", "The+Most+Annoying+People+Of", "The+Museum+of+Modern+Art+In+Our+Time", "The+Mystery+of+the+Disorderly+Warriors", "The+Nazi+Officers+Wife", "The+Next+Best+Thing+Who+Is+The+Greatest+Celebrity+Impersonator", "The+Penguins+Of+Madagascar", "The+Planets+Funniest+Animals", "The+Post+Impressionists+Edvard+Munch", "The+Post+Impressionists+Henri+Rousseau", "The+Post+Impressionists+Paul+Gauguin", "The+Power+Of+Myth", "The+Price+Is+Right+S35+SPECIAL+Bobs+Last+Show", "The+Saatchi", "The+Sarah+Connor+Chronicles", "The+Secret+Life+of+the+American+Teenage", "The+Secret+Life+of+the+American+Teenager+REPACK+READNFO", "The+Sopranos+A+Sitdown", "The+Storm", "The+Tonight+Show+With+Jay+Leno", "The+Trap+Part1", "The+Trap+Part2", "The+Trap+Part3", "The+Venture+Bros", "The+Vicar+Of+Dibley+Xmas+Special", "The+Victorias+Secret+Fashion+Show", "The+Wire+S05+Special+The+Last+Word", "TheEYE+Gavin+Turk", "TheEYE+Gillian+Ayres", "TheEYE+Grayson+Perry", "TheEYE+Howard+Hodgkins", "TheEYE+Malcolm+Morley", "TheEYE+Martin+Creed", "TheEYE+Michael+Craig+Martin", "TheEYE+Sandra+Blow", "TheEYE+Stuart+Brisley", "Thin", "This+Film+Is+Not+Yet+Rated+LIMITED", "Tin+Man+Part+1", "Tin+Man+Part+2", "Tin+Man+Part+3", "Tin+Man+Part1", "Titanic+Answers+From+The+Abyss", "To+The+Manor+Born+S03+Christmas+Special", "Top+10+Casinos", "Top+Gear+Ground+Force+Sports+Relief", "Top+Gear+Of+The+Pops+Comic+Relief+Special", "Top+Gear+Polar+Special", "Top+Gear+S10+Special+The+Best+Of+Top+Gear+1", "Top+Gear+S10+Special+The+Best+Of+Top+Gear+2", "Top+Gear+The+Best+Of+Top+Gear+S10+Special+3", "Top+Gear+The+Best+Of+Top+Gear+S12+Part1", "Top+Gear+The+Best+Of+Top+Gear+S12+Part2", "Top+Gear+The+Best+Of+Top+Gear+S12+Part3", "Touch+Me+Im+Karen+Taylor", "Toughest+Seaside+Resorts+In+Britain+2", "Toughest+Sheriff+In+America", "Trailer+Park+Boys+Say+Goodnight+To+The+Bad+Guys", "Trailer+Park+Boys+The+Movie+Behind+The+Scenes", "Transformers+HBO+First+Look", "Trust+Me", "Two+Pints+Of+Lager+And+A+Packet+Of+Crisps", "Two+and+a+Half+Men+HDTV", "Two_Twisted", "UFC+64+Unstoppable", "UFC+65+Bad+Intensions", "UFC+68+The+Uprising", "UFC+87+Seek+And+Destroy", "UFC+88+Liddell+vs+Evans", "UFC+89+Bisping+vs+Leben", "UFC+90+Silva+vs+Cote", "UFC+91+Couture+vs+Lesnar", "UFC+92+The+Ultimate", "UFC+Fight+Night", "UFC+Ortiz+vs+Shamrock+3+Final+Chapter", "UFC+Ultimate+Fighter+4+Finale+LIVE", "Underbelly+A+Tale+of+Two+Cities", "Union+Jackass", "Us+Now", "VH1s+Al+TV+Straight+Out+Of+Lynwood", "Vegas+Confessions", "Venture+brothers", "Victorias+Secret+Fashion+Show", "Virtuality+Pilot", "WWE+SummerSlam", "Wallace+And+Gromit+A+Matter+Of+Loaf+And+Death", "When+We+Left+Earth+Bonus+DVD", "WipeOut", "Wire+in+the+Blood+S5+Special+%28", "Without+a+Trace+%28", "Worlds+Most+Dangerous+Animals", "Worlds+Worst+Drivers+Caught+on+Tape", "theEYE+Karl+Weschke", "theEYE+Lisa+Milroy", "BBC+Iran+and+the+West", "PBS+The+National+Parks+Americas+Best+Idea",  "PBS+The+National+Parks+Americas+Best+Idea+The+Scripture+of+Nature+Extra", "BBC+The+Art+on+Your+Wall", "BBC+The+Sky+at+Night+Special", "BBC+This+World+Can+Obama+Save+the+Planet", "BBC+What+is+Beauty", "Discovery+Health+The+Body+Invaders+Cold+and+Flu+x", "House+Cats%3A+The+Ultimate+Guide+x", "Level", "The+Body+Invaders%3A+Cold+and+Flu", "Ch+4+Bleach+Nip+Tuck+The+White+Beauty+Myth", "Family+Guy+Presents+Seth+and+Alexs+Almost+Live+Comedy+Show", "PBS+The+National+Parks+Americas+Best+Idea+Going+Home+Extra", "PBS+The+National+Parks+Americas+Best+Idea+The+Empire+of+Grandeur+Extra","PBS+The+National+Parks+Americas+Best+Idea+The+Morning+of+Creation+Extra", "PBS+The+National+Parks+Americas+Best+Idea+Great+Nature+Extra", "National+Geographic+The+Human+Family+Tree", "National+Geographic+Wild+Russia", "Discovery+Crown+of+Thorns+Starfish+Monster+from+the+Shallows+x", "Discovery+Discover+Magazine+Invisible+Enemies", "Discovery+Rogue+Nature", "Discover+Magazine+Invisible+Enemies+x", "Doctor+Who+Confidential+S04+Special+Is+There+Life+On+Mars", "Discovery+Understanding+Viruses", "Discovery+Understanding+Viruses+x", "BBC+Last+Chance+To+See", "BBC+Mars+A+Horizon+Guide", "Doctor+Who+Dreamland+%28"]

	# Ended, not updated, miniseries, etc.
	list2 = ["10+Items+or+Less", "3+Lbs", "30+Days", "7th+Heaven", "Alive", "All+of+Us", "American+Hot+Rod", "American+Inventor", "Andy+Barker+P+I", "Andy+Barker+PI", "Angelas+Eyes", "Australias+Funniest+Home+Videos", "Babylon+Fields", "Badger+Or+Bust", "Beyond+the+Break", "Big+Brother+Allstars", "Big+Day", "Bionic+Woman", "Blade+The+Series", "Blood+Ties", "Boy+Meets+Girl+2009", "Brainiac+Science+Abuse", "Brotherhood", "Bullrun", "Cane", "Caprica", "Catastrophe", "Cavemen", "Celebrity+Duets", "Clone", "Close+To+Home", "Comedy+Lab", "Crash+UK", "Creature+Comforts+US", "Criss+Angel+Mindfreak", "Crooked+House", "Crossing+Jordan", "Cupid+2009", "Dancelife", "Dancing+With+The+Stars", "Day+Break", "Demons+UK", "Dirty+Sexy+Money", "Doctor+Who+%282005%29", "Dont+Forget+The+Lyrics", "Drawn+Together", "Drive", "Driving+Force", "E+Ring", "Easy+Money", "Echo+Beach", "Eleventh+Hour", "Eleventh+Hour+US", "Eli+Stone", "Everybody+Hates+Chris", "Extras", "Extreme+Makeover+Home+Edition", "Fear+Factor", "Feasting+On+Waves", "Fight+Girls", "Flash+Gordon+2007", "Flavor+Of+Love", "Fonejacker", "Frank+TV", "FutureWeapons", "Gene+Simmons+Family+Jewels", "George+Lopez", "Gilmore+Girls", "Grease+Is+The+Word", "Grease+Youre+the+One+That+I+Want", "Happy+Hour", "Harley+Street", "Harpers+Island", "Hells+Kitchen", "Help+Me+Help+You", "Hidden+Palms", "Hole+in+the+Wall+US", "Honest", "House+Of+Saddam", "How+Stuff+Works", "How+To+Look+Good+Naked", "Hows+Your+News", "Human+Weapon", "Hyperdrive", "I+Pity+The+Fool", "Impact", "In+Case+of+Emergency", "In+Harms+Way", "Inked", "Intelligence", "Into+Alaska+with+Jeff+Corwin", "Islands+of+Scotland", "Jekyll", "Jericho", "Journeyman", "Jurassic+Fight+Club", "Just+Legal", "Justice", "K+Ville", "Kath+and+Kim+US", "Kenny+vs+Spenny", "Kid+Nation", "Kidnapped", "Kings", "Knight+Rider+2008", "Lab+Rats", "Laguna+Beach", "Las+Vegas", "Last+Comic+Standing", "Law+And+Order+UK", "Lewis+Blacks+Root+Of+All+Evil", "Life", "Life+Is+Wild", "Life+On+Mars", "Life+on+Mars+US", "Lipstick+Jungle", "Little+Britain+USA", "Lost+Worlds", "Mark+Loves+Sharon", "Masters+Of+Horror", "Masters+of+Science+Fiction", "Maui+Fever", "Meadowlands", "Men+In+Trees", "Mental", "Merlin+2008", "Miami+Ink", "Midnight+Man", "Million+Dollar+Listing+Hollywood", "Mind+of+Mencia", "Miss+Guided", "Mistresses", "Modern+Marvels", "Monkey+Life", "Moonlight", "My+Fair+Brady", "My+Name+Is+Earl", "My+Own+Worst+Enemy", "New+Amsterdam", "No+Heroics", "Notes+From+the+Underbelly", "October+Road", "On+The+Lot", "Painkiller+Jane", "Paris+Hiltons+British+Best+Friend", "Peep+Show", "Phenomenon", "Pimp+My+Ride", "Pirate+Master", "Poker+Superstars", "Prime+Suspect", "Professional+Poker+Tour", "Prototype+This", "Punkd", "Pushing+Daisies", "Raines", "Reaper", "Reba", "Red+Dwarf", "Regenesis", "Respectable", "Rob+and+Amber+Against+the+Odds", "Robin+Hood", "Rock+Star+Supernova", "Rome", "Roommates", "Rush+2008", "Samantha+Who", "Samurai+Girl", "Sanctuary", "Saving+Planet+Earth", "Saxondale", "Scott+Baio+is+46+and+Pregnant", "Secret+Diary+Of+A+Call+Girl", "Shaqs+Big+Challenge", "Shark", "Sit+Down+Shut+Up", "Six+Degrees", "Sleeper+Cell", "Smith", "Snapped", "Snoop+Doggs+Father+Hood", "Somebodies", "South+Of+Nowhere", "Spooks+Code+9", "Standoff", "Star+Trek+Beyond+the+Final+Frontier", "Stargate+Continuum", "Stargate+SG+1", "Street+Customs", "Studio+60+on+the+Sunset+Strip", "Stunt+Junkies", "Surviving+Suburbia", "Swingtown", "Talk+Show+With+Spike+Feresten", "Talk+To+Me+UK", "Tell+Me+You+Love+Me", "Terminator+The+Sarah+Connor+Chronicles", "Thank+God+Youre+Here+AU", "Thank+God+Youre+Here+US", "The+4400", "The+Andromeda+Strain", "The+Beautiful+Life", "The+Black+Donnellys", "The+Chasers+War+on+Everything", "The+Class", "The+Cleaner", "The+Collector", "The+Company", "The+Contender", "The+Dead+Zone", "The+Dresden+Files", "The+Ex+List", "The+Girls+Next+Door", "The+Goode+Family", "The+Hills+After+Show", "The+Holy+Hottie", "The+Invisibles", "The+Kill+Point", "The+King+Of+Queens", "The+Knights+of+Prosperity", "The+L+Word", "The+Life+and+Times+of+Tim", "The+Loop", "The+Middleman", "The+Mole", "The+Mole+US", "The+Nine", "The+OC", "The+Office+US", "The+Palace", "The+Paper", "The+Pickup+Artist", "The+Poker+Star", "The+Price+is+Right", "The+Real+Wedding+Crashers", "The+Real+World", "The+Return+of+Jezebel+James", "The+Riches", "The+Rock+Life", "The+Ruby+in+The+Smoke", "The+Sarah+Silverman+Program", "The+Sci+Fi+Guys", "The+Shadow+In+The+North", "The+Shield", "The+Simple+Life", "The+Singing+Bee", "The+Sopranos", "The+Unit", "The+Unusuals", "The+Venture+Brothers", "The+War+at+Home", "The+Wedding+Bells", "The+Wehrmacht", "The+Winner", "The+Wire", "The+X+Factor+Uk", "Things+We+Love+To+Hate", "Three+Moons+Over+Milford", "Top+Gear+Australia", "Trailer+Park+Boys", "Traveler", "Trial+and+Retribution", "Tripping+Over", "Twenty+Good+Years", "Two+A+Days", "Two+Twisted", "Ultimate+Poker+Challenge", "Underbelly", "Unhitched", "Valentine", "Vanished", "Veronica+Mars", "Viva+Laughlin", "Wallander", "Welcome+to+The+Captain", "What+About+Brian", "When+We+Left+Earth", "Where+Did+It+Come+From", "Whistler", "White+Boyz+In+The+Hood", "Wildfire", "Wire+In+The+Blood", "Wired+Science", "Womens+Murder+Club", "Work+Out", "World+Poker+Tour", "Worst+Week", "jPod", "A+Raisin+In+The+Sun", "American+Gladiators+2008", "Apparitions", "Archer", "Back+to+You", "Battleplan", "The+Beast", "Big+Shots", "Bonekickers", "Boston+Legal", "Canterburys+Law", "Carl+Sagans+Cosmos", "Carpoolers", "Cashmere+Mafia", "The+Chasers+War+On+Everything", "Crusoe", "Dead+Set", "Deep+Wreck+Mysteries", "Defying+Gravity", "Demons", "Dirt", "Do+Not+Disturb", "ER", "Fairytales", "Fear+Itself", "Flash+Gordon", "Flying+Confessions+of+a+Free+Woman", "Generation+Kill", "Glamour+Girls", "The+History+Channel+Evolve", "Life+2009", "Moving+Wallpaper", "Occupation", "Prison+Break", "Privileged", "Ruby+and+The+Rockits", "Runaway", "Stargate+Atlantis", "Without+a+Trace", "Trust+Me+US"]

	blockedShows = list1 + list2

	# Merge
	if (File.exists?(path)) then
		begin
			knownShows = Plist::parse_xml(path)
		rescue => e
			printException(e)
			exit(1)
		end
		
		if !knownShows.nil? then
			showsToAdd = []
			shows["Shows"].each { |show|
				if (!knownShows["Shows"].find{|ks| ks["ExactName"] == show["ExactName"]}) then
					showsToAdd << show
				end
			}
		
			knownShows["Shows"] += showsToAdd
			knownShows["Version"] = version
			
			shows = knownShows
    	
		end
	end
	
	blockedShows.each_index { |x|
		shows["Shows"].delete_if {|s| s["ExactName"] == blockedShows[x]}
	}

	shows["Shows"] = shows["Shows"].sort_by{ |x| x["HumanName"].sub(/^(the)\s/i, '').downcase }
	shows.save_plist(path)

rescue Exception, Timeout::Error => e
	printException(e) 
	exit(1)
end

exit(0)