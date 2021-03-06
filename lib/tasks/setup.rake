namespace :setup do

	task :update => :environment do
		game = Game.find(4879)
		hitter = Hitter.where(:name => "Mike Morse", :game_id => nil).first
		game.hitters.where(:name => "Mike Morse").first.update_attributes(:team_id => hitter.team.id, :name => hitter.name, :alias => hitter.alias, :fangraph_id => hitter.fangraph_id, :bathand => hitter.bathand,
									:throwhand => hitter.throwhand, :lineup => hitter.lineup, :starter => true, :SB_L => hitter.SB_L, :wOBA_L => hitter.wOBA_L,
									:OBP_L => hitter.OBP_L, :SLG_L => hitter.SLG_L, :AB_L => hitter.AB_L, :BB_L => hitter.BB_L, :SO_L => hitter.SO_L, :LD_L => hitter.LD_L,
									:wRC_L => hitter.wRC_L, :SB_R => hitter.SB_R, :wOBA_R => hitter.wOBA_R, :OBP_R => hitter.OBP_R, :SLG_R => hitter.SLG_R, :AB_R => hitter.AB_R,
									:BB_R => hitter.BB_R, :SO_R => hitter.SO_R, :LD_R => hitter.LD_R, :wRC_R => hitter.wRC_R, :SB_14 => hitter.SB_14, :wOBA_14 => hitter.wOBA_14,
									:OBP_14 => hitter.OBP_14, :SLG_14 => hitter.SLG_14, :AB_14 => hitter.AB_14, :BB_14 => hitter.BB_14, :SO_14 => hitter.SO_14, :LD_14 => hitter.LD_14,
									:wRC_14 => hitter.wRC_14, :SB_previous_L => hitter.SB_previous_L, :wOBA_previous_L => hitter.wOBA_previous_L, :OBP_previous_L => hitter.OBP_previous_L,
									:SLG_previous_L => hitter.SLG_previous_L, :AB_previous_L => hitter.AB_previous_L, :BB_previous_L => hitter.BB_previous_L, :SO_previous_L => hitter.SO_previous_L,
									:LD_previous_L => hitter.LD_previous_L, :wRC_previous_L => hitter.wRC_previous_L, :SB_previous_R => hitter.SB_previous_R, :wOBA_previous_R => hitter.wOBA_previous_R, 
									:OBP_previous_R => hitter.OBP_previous_R, :SLG_previous_R => hitter.SLG_previous_R, :AB_previous_R => hitter.AB_previous_R, :BB_previous_R => hitter.BB_previous_R,
									:SO_previous_R => hitter.SO_previous_R, :LD_previous_R => hitter.LD_previous_R, :wRC_previous_R => hitter.wRC_previous_R)
	end

	task :delete => :environment do
		hour, day, month, year = findDate(Time.now.tomorrow)
		Game.where(:year => year, :month => month, :day => day).each do |game|
			game.pitchers.destroy_all
			game.hitters.destroy_all
			game.destroy
		end
	end

	def findDate(today)
		year = today.year.to_s
		month = today.month.to_s
		day = today.day.to_s
		hour = today.hour

		if month.size == 1
			month = '0' + month
		end
		if day.size == 1
			day = '0' + day
		end
		return hour, day, month, year
	end

	task :create => [:create_teams, :create_players] do
	end

	task :daily => [:create_players, :fangraphs, :update_players, :update_weather, :bullpen, :boxscores, :innings, :closingline] do
	end

	task :hourly => [:matchups, :ump, :tomorrow] do
	end

	task :create_teams => :environment do

		name = ["Angels", "Astros", "Athletics", "Blue Jays", "Braves", "Brewers", "Cardinals",
			"Cubs", "Diamondbacks", "Dodgers", "Giants", "Indians", "Mariners", "Marlins", "Mets",
			"Nationals", "Orioles", "Padres", "Phillies", "Pirates", "Rangers", "Rays", "Red Sox",
			"Reds", "Rockies", "Royals", "Tigers", "Twins", "White Sox", "Yankees"]

		stadium = ["Angels Stadium", "Minute Maid Park", "Oakland Coliseum", "Rogers Centre", "Turner Field",
			"Miller Park", "Busch Stadium", "Wrigley Field", "Chase Field", "Dodgers Stadium", "AT&T Park",
			"Progressive Field", "Safeco Park", "Marlins Park", "Citi Field", "Nationals Park", "Camden Yards",
			"Petco Park", "Citizens Bank Park", "PNC Park", "Rangers Ballpark", "Tropicana Field", "Fenway Park",
			"Great American Ball Park", "Coors Field", "Kauffman Stadium", "Comerica Park", "Target Field",
			"U.S. Cellular Field", "Yankee Stadium"]

		abbr = ["LAA", "HOU", "OAK", "TOR", "ATL", "MIL", "STL", "CHC", "ARI", "LAD", "SFG", "CLE", "SEA", "MIA", "NYM",
			"WSN", "BAL", "SDP", "PHI", "PIT", "TEX", "TBR", "BOS", "CIN", "COL", "KCR", "DET", "MIN", "CHW", "NYY"]

		game_abbr = ["ANA", "HOU", "OAK", "TOR", "ATL", "MIL", "SLN", "CHN", "ARI", "LAN", "SFN", "CLE", "SEA", "MIA", "NYN",
			"WAS", "BAL", "SDN", "PHI", "PIT", "TEX", "TBA", "BOS", "CIN", "COL", "KCA", "DET", "MIN", "CHA", "NYA"]

		zipcode = ["92806", "77002", "94621", "M5V 1J1", "30315", "53214", "63102", "60613", "85004", "90012", "94107",
			"44115", "98134", "33125", "11368", "20003", "21201", "92101", "19148", "15212", "76011", "33705", "02215", "45202",
			"80205", "64129", "48201", "55403", "60616", "10451"]

		league = ["AL", "AL", "AL", "AL", "NL", "NL", "NL", "NL", "NL", "NL", "NL", "AL", "AL", "NL", "NL", "NL", "AL", "NL",
			"NL", "NL", "AL", "AL", "AL", "NL", "NL", "AL", "AL", "AL", "AL", "AL"]

		fangraph_id = [1, 21, 10, 14, 16, 23, 28, 17, 15, 22, 30, 5, 11, 20, 25, 24, 2, 29, 26, 27, 13, 12, 3, 18, 19, 7, 6, 8, 4, 9]


		(0...name.size).each{|i|
			team = Team.create(:name => name[i], :abbr => abbr[i], :game_abbr => game_abbr[i], :stadium => stadium[i], :zipcode => zipcode[i], :fangraph_id => fangraph_id[i], :league => league[i])
			if team.name == "Angels" || team.name == "Athletics" || team.name == "Diamondbacks" || team.name == "Dodgers" || team.name == "Giants" || team.name == "Mariners" || team.name == "Padres"
				team.update_attributes(:timezone => -3)
			elsif team.name == "Rockies"
				team.update_attributes(:timezone => -2)
			elsif team.name == "Astros" || team.name == "Braves" || team.name == "Brewers" || team.name == "Cardinals" || team.name == "Cubs" || team.name == "Rangers" || team.name == "Royals" || team.name == "Twins" || team.name == "White Sox"
				team.update_attributes(:timezone => -1)
			else
				team.update_attributes(:timezone => 0)
			end
		}
		
	end

	task :create_players => :environment do
		Team.all.each do |team|
			team.create_players
		end
	end

	task :update_players => :environment do
		Team.all.each do |team|
			team.update_players
		end
	end

	task :fangraphs => :environment do
		require 'nokogiri'
		require 'open-uri'

		def getFangraph(stat)
			href = stat.child['href']
			first = href.index('=')+1
			last = href.index('&')
			return href[first...last].to_i
		end

		def updatePlayer(stat, nil_players, nicknames)
			name = stat.child.child.to_s
			fangraph_id = getFangraph(stat)
			if player = nil_players.find_by_name(name)
				player.update_attributes(:fangraph_id => fangraph_id)
			elsif player = nil_players.find_by_name(nicknames[name])
				player.update_attributes(:fangraph_id => fangraph_id)
			else
				puts name + ' not found'
				puts fangraph_id
			end
		end

		nicknames = {
			"Phil Gosselin" => "Philip Gosselin",
			"Thomas Pham" => "Tommy Pham",
			"Zachary Heathcott" => "Slade Heathcott",
			"Daniel Burawa" => "Danny Burawa",
			"Kenneth Roberts" => "Kenny Roberts",
			"Dennis Tepera" => "Ryan Tepera",
			"John Leathersich" => "Jack Leathersich",
			"Hyun-Jin Ryu" => "Hyun-jin Ryu",
			"Tom Layne" => "Tommy Layne",
			"Nathan Karns" => "Nate Karns",
			"Matt Joyce" => "Matthew Joyce",
			"Michael Morse" => "Mike Morse",
			"Jackie Bradley Jr." => "Jackie Bradley",
			"Steven Souza Jr." => "Steven Souza",
			"Reynaldo Navarro" => "Rey Navarro",
			"Jung-ho Kang" => "Jung Ho Kang",
			"Edward Easley" => "Ed Easley",
			"JR Murphy" => "John Ryan Murphy",
			"Deline Deshields Jr." => "Delin DeShields",
			"Steve Tolleson" => "Steven Tolleson",
			"Daniel Dorn" => "Dan Dorn",
			"Nicholas Tropeano" => "Nick Tropeano",
			"Michael Montgomery" => "Mike Montgomery",
			"Matthew Tracy" => "Matt Tracy",
			"Andrew Schugel" => "A.J. Schugel",
			"Matthew Wisler" => "Matt Wisler",
			"Sugar Marimon" => "Sugar Ray Marimon",
			"Nate Adcock" => "Nathan Adcock",
			"Samuel Deduno" => "Sam Deduno",
			"Joshua Ravin" => "Josh Ravin",
			"Michael Strong" => "Mike Strong",
			"Samuel Tuivailala" => "Sam Tuivailala",
			"Joseph Donofrio" => "Joey Donofrio",
			"Mitchell Harris" => "Mitch Harris",
			"Christopher Rearick" => "Chris Rearick",
			"Jeremy Mcbryde" => "Jeremy McBryde",
			"Daniel Robertson" => "Dan Robertson",
			"Jorge de la Rosa" => "Jorge De La Rosa",
			"Rubby de la Rosa" => "Rubby De La Rosa"
		}


		nil_hitters = Hitter.where(:game_id => nil)
		nil_pitchers = Pitcher.where(:game_id => nil)
		(1..30).each do |i|

			url = "http://www.fangraphs.com/depthcharts.aspx?position=ALL&teamid=#{i}"
			doc = Nokogiri::HTML(open(url))

			doc.css(".depth_chart:nth-child(58) td").each_with_index do |stat, index|
				case index%10
				when 0
					name = stat.child.child
					if name != nil
						updatePlayer(stat, nil_hitters, nicknames)
					end
				end
			end

			doc.css(".depth_chart:nth-child(76) td").each_with_index do |stat, index|
				case index%10
				when 0
					name = stat.child.child
					if name != nil
						updatePlayer(stat, nil_hitters, nicknames)
						updatePlayer(stat, nil_pitchers, nicknames)
					end

				end
			end
		end
	end

	task :update_weather => :environment do

		require 'nokogiri'
		require 'open-uri'

		def row(row, text)
			case row
			when 2
				@temperature << text
			when 4
				@humidity << text
			when 6
				@precipitation << text
			when 10
				@wind << text
			end	
		end

		def convertToFahr(celsius)
			symbol = celsius[-1]
			celsius = celsius[0...-1].to_f
			fahr = (celsius * 9.0 / 5.0 + 32.0).round.to_s
			fahr += symbol
			return fahr
		end

		def grabWeather(game, today)
			team = game.home_team
			time = game.time
			amorpm = game.time[-2..-1]
			time = time[0...time.index(":")].to_i
			if amorpm == "PM" && time != 12
				time += 12
			end
			if !today
				time += 24
			end

			url = @url_array[team.id-1]
			puts url
			doc = Nokogiri::HTML(open(url))
			pressure = nil
			doc.css(".second").each_with_index do |weather, index|
				if index == 2
					pressure = weather.text[0..4] + ' in'
					break
				end
			end
			game.update_attributes(:pressure_1 => pressure, :pressure_2 => pressure, :pressure_3 => pressure)


			url = @url_hourly[team.id-1]
			url += "?hour=#{time}"
			puts url
			doc = Nokogiri::HTML(open(url))
			var = row = 0
			@temperature = Array.new
			@humidity = Array.new
			@precipitation = Array.new
			@wind = Array.new
			doc.css("td").each_with_index do |stat, index|
				if stat.children.size == 1
					text = stat.text
				elsif stat.children.size == 2
					text = stat.children[-1].text
				elsif stat.children.size == 3
					text = stat.last_element_child.text
				else
					text = stat.text
				end
				if index == 40 || index == 73
					var = 0
					next
				end
					
				case var%8
				when 0
					row(row, text)
				when 1
					row(row, text)
				when 2
					row(row, text)
					row += 1
				end
				var += 1
			end

			@temperature.each_with_index do |temperature, index|
				if team.id == 4
					temperature = convertToFahr(temperature)
				end
				case index
				when 0
					game.update_attributes(:temperature_1 => temperature)
				when 1
					game.update_attributes(:temperature_2 => temperature)
				when 2
					game.update_attributes(:temperature_3 => temperature)
				end
			end

			@humidity.each_with_index do |humidity, index|
				case index
				when 0
					game.update_attributes(:humidity_1 => humidity)
				when 1
					game.update_attributes(:humidity_2 => humidity)
				when 2
					game.update_attributes(:humidity_3 => humidity)
				end
			end

			@precipitation.each_with_index do |precipitation, index|
				case index
				when 0
					game.update_attributes(:precipitation_1 => precipitation)
				when 1
					game.update_attributes(:precipitation_2 => precipitation)
				when 2
					game.update_attributes(:precipitation_3 => precipitation)
				end
			end

			@wind.each_with_index do |wind, index|
				case index
				when 0
					game.update_attributes(:wind_1 => wind)
				when 1
					game.update_attributes(:wind_2 => wind)
				when 2
					game.update_attributes(:wind_3 => wind)
				end
			end
		end



		@url_array = ["https://weather.yahoo.com/united-states/california/anaheim-2354447/", "https://weather.yahoo.com/united-states/texas/houston-2424766/", "https://weather.yahoo.com/united-states/california/oakland-2463583/",
				"https://weather.yahoo.com/canada/ontario/toronto-4118/", "https://weather.yahoo.com/united-states/georgia/atlanta-2357024/", "https://weather.yahoo.com/united-states/wisconsin/milwaukee-2451822/",
				"https://weather.yahoo.com/united-states/missouri/st.-louis-2486982/", "https://weather.yahoo.com/united-states/illinois/chicago-2379574/", "https://weather.yahoo.com/united-states/arizona/phoenix-2471390/",
				"https://weather.yahoo.com/united-states/california/los-angeles-2442047/", "https://weather.yahoo.com/united-states/california/san-francisco-2487956/", "https://weather.yahoo.com/united-states/ohio/cleveland-2381475/",
				"https://weather.yahoo.com/united-states/washington/seattle-2490383/", "https://weather.yahoo.com/united-states/florida/miami-2450022/", "https://weather.yahoo.com/united-states/new-york/new-york-2459115/",
				"https://weather.yahoo.com/united-states/district-of-columbia/washington-2514815/", "https://weather.yahoo.com/united-states/maryland/baltimore-2358820/", "https://weather.yahoo.com/united-states/california/san-diego-2487889/",
				"https://weather.yahoo.com/united-states/pennsylvania/philadelphia-2471217/", "https://weather.yahoo.com/united-states/pennsylvania/pittsburgh-2473224/", "https://weather.yahoo.com/united-states/texas/arlington-2355944/",
				"https://weather.yahoo.com/united-states/florida/st.-petersburg-2487180/", "https://weather.yahoo.com/united-states/massachusetts/boston-2367105/", "https://weather.yahoo.com/united-states/ohio/cincinnati-2380358/",
				"https://weather.yahoo.com/united-states/colorado/denver-2391279/", "https://weather.yahoo.com/united-states/kansas/kansas-city-2430632/", "https://weather.yahoo.com/united-states/michigan/detroit-2391585/",
				"https://weather.yahoo.com/united-states/minnesota/minneapolis-2452078/", "https://weather.yahoo.com/united-states/illinois/chicago-2379574/", "https://weather.yahoo.com/united-states/new-york/bronx-91801630/"]

		@url_hourly = ["http://www.accuweather.com/en/us/anaheim-ca/92805/hourly-weather-forecast/327150", "http://www.accuweather.com/en/us/houston-tx/77002/hourly-weather-forecast/351197", "http://www.accuweather.com/en/us/oakland-ca/94612/hourly-weather-forecast/347626",
				"http://www.accuweather.com/en/ca/toronto/m5g/hourly-weather-forecast/55488", "http://www.accuweather.com/en/us/atlanta-ga/30303/hourly-weather-forecast/348181", "http://www.accuweather.com/en/us/milwaukee-wi/53202/hourly-weather-forecast/351543",
				"http://www.accuweather.com/en/us/st-louis-mo/63101/hourly-weather-forecast/349084", "http://www.accuweather.com/en/us/chicago-il/60608/hourly-weather-forecast/348308", "http://www.accuweather.com/en/us/phoenix-az/85004/hourly-weather-forecast/346935",
				"http://www.accuweather.com/en/us/los-angeles-ca/90012/hourly-weather-forecast/347625", "http://www.accuweather.com/en/us/san-francisco-ca/94103/hourly-weather-forecast/347629", "http://www.accuweather.com/en/us/cleveland-oh/44113/hourly-weather-forecast/350127",
				"http://www.accuweather.com/en/us/seattle-wa/98104/hourly-weather-forecast/351409", "http://www.accuweather.com/en/us/miami-fl/33128/hourly-weather-forecast/347936", "http://www.accuweather.com/en/us/queens-borough-ny/11414/hourly-weather-forecast/2623321",
				"http://www.accuweather.com/en/us/washington-dc/20006/hourly-weather-forecast/327659", "http://www.accuweather.com/en/us/baltimore-md/21202/hourly-weather-forecast/348707", "http://www.accuweather.com/en/us/san-diego-ca/92101/hourly-weather-forecast/347628",
				"http://www.accuweather.com/en/us/philadelphia-pa/19107/hourly-weather-forecast/350540", "http://www.accuweather.com/en/us/pittsburgh-pa/15219/hourly-weather-forecast/1310", "http://www.accuweather.com/en/us/arlington-tx/76010/hourly-weather-forecast/331134",
				"http://www.accuweather.com/en/us/st-petersburg-fl/33712/hourly-weather-forecast/332287", "http://www.accuweather.com/en/us/boston-ma/02108/hourly-weather-forecast/348735", "http://www.accuweather.com/en/us/cincinnati-oh/45229/hourly-weather-forecast/350126",
				"http://www.accuweather.com/en/us/denver-co/80203/hourly-weather-forecast/347810", "http://www.accuweather.com/en/us/kansas-city-mo/64106/hourly-weather-forecast/329441", "http://www.accuweather.com/en/us/detroit-mi/48226/hourly-weather-forecast/348755",
				"http://www.accuweather.com/en/us/minneapolis-mn/55415/hourly-weather-forecast/348794", "http://www.accuweather.com/en/us/chicago-il/60608/hourly-weather-forecast/348308", "http://www.accuweather.com/en/us/bronx-borough-ny/10461/hourly-weather-forecast/334650"]



		hour, day, month, year = findDate(Time.now)

		Game.where(:year => year, :month => month, :day => day).each do |game|

			grabWeather(game, true)
			
		end

		hour, day, month, year = findDate(Time.now.tomorrow)

		Game.where(:year => year, :month => month, :day => day).each do |game|

			grabWeather(game, false)
			
		end
	end

	task :matchups => :environment do
		require 'nokogiri'
		require 'open-uri'

		def getFangraphID(text)
			index = text.index("player/")
			text = text[index+7..-1]
			index = text.index("/")
			return text[0...index]
		end

		def starters_set_false(pitchers, hitters)
			pitchers.where(:starter => true).each do |pitcher|
				pitcher.update_attributes(:starter => false)
			end
			hitters.where(:starter => true).each do |hitter|
				hitter.update_attributes(:starter => false)
			end
		end

		# Convert's Eastern Time to local time for each team
		def convertTime(game, time)

			if !time.include?(":")
				return ""
			end

			colon = time.index(":")
			original_hour = time[0...colon].to_i
			hour = original_hour + game.home_team.timezone
			suffix = time[colon..-4]


			if original_hour == 12 && hour != 12 || hour < 0
				suffix[suffix.index("P")] = "A"
			end
			if hour < 1
				hour += 12
			end

			return hour.to_s + suffix

		end

		# Find the current date and get all the games playing today
		hour, day, month, year = findDate(Time.now)
		todays_games = Game.where(:year => year, :month => month, :day => day)
		# Get the prototype players from the database
		nil_pitchers = Pitcher.where(:game_id => nil)
		nil_hitters = Hitter.where(:game_id => nil)

		# Today's current lineup from baseballpress
		url = "http://www.baseballpress.com/lineups/#{DateTime.now.to_date}"
		doc = Nokogiri::HTML(open(url))

=begin
	Store the times of each game and the home and away teams in arrays.
	Find the duplicate games of each team, which will allow us to check for double headers.
=end
		home = Array.new
		away = Array.new
		gametime = Array.new
		doc.css(".game-time").each do |time|
			gametime << time.text
		end
		doc.css(".team-name").each_with_index do |stat, index|
			team = Team.find_by_name(stat.text)
			if index%2 == 0
				away << team
			else
				home << team
			end
		end
		teams = home + away
		duplicates = teams.select{ |e| teams.count(e) > 1 }.uniq

		# iterate through each home team and create games that have not been created yet
		(0...gametime.size).each{ |i|

			games = todays_games.where(:home_team_id => home[i].id, :away_team_id => away[i].id)

			# Check for double headers
			if games.size == 1 && duplicates.include?(home[i])
				game = Game.create(:year => year, :month => month, :day => day, :home_team_id => home[i].id, :away_team_id => away[i].id, :num => '2')
			elsif games.size == 0 && duplicates.include?(home[i])
				game = Game.create(:year => year, :month => month, :day => day, :home_team_id => home[i].id, :away_team_id => away[i].id, :num => '1')
			elsif games.size == 0
				game = Game.create(:year => year, :month => month, :day => day, :home_team_id => home[i].id, :away_team_id => away[i].id, :num => '0')
			end

			unless game == nil
				time = convertTime(game, gametime[i])
				game.update_attributes(:time => time)
				puts 'Game ' + game.url + ' created'
			end

		}

		# List all starters as not starting
		starters_set_false(nil_pitchers, nil_hitters)

		# For all players, first search each player by alias, then fangraph id, otherwise name.
		
		# Find starting pitchers and set them to starting
		doc.css(".team-name+ div").each do |player|
			text = player.text
			name = player.child.child.to_s
			href = player.child['data-bref'].to_s
			fangraph_text = player.child['data-razz'].to_s
			fangraph_id = 0
			if fangraph_text != ''
				fangraph_id = getFangraphID(fangraph_text)
			end

			if name == "TBD"
				next
			end

			if href != "" && pitcher = nil_pitchers.find_by_alias(href)
				pitcher.update_attributes(:starter => true)
			elsif fangraph_id != 0 && pitcher = nil_pitchers.find_by_fangraph_id(fangraph_id)
				pitcher.update_attributes(:starter => true)
				puts pitcher.name
			elsif pitcher = nil_pitchers.find_by_name(name)
				pitcher.update_attributes(:starter => true)
			else
				puts name + ' not found'
			end

		end

		# Find starting hitters and set them to starting
		doc.css(".players div").each_with_index do |player, index|
			text = player.text
			lineup = text[0].to_i
			name = player.last_element_child.child.to_s
			href = player.last_element_child['data-bref']
			fangraph_text = player.last_element_child['data-razz']
			fangraph_id = 0
			if fangraph_text != ''
				fangraph_id = getFangraphID(fangraph_text)
			end

			if href != "" && hitter = nil_hitters.find_by_alias(href)
				hitter.update_attributes(:starter => true, :lineup => lineup)
			elsif fangraph_id != 0 && hitter = nil_hitters.find_by_fangraph_id(fangraph_id)
				hitter.update_attributes(:starter => true, :lineup => lineup)
			elsif hitter = nil_hitters.find_by_name(name)
				hitter.update_attributes(:starter => true, :lineup => lineup)
				puts hitter.name + ' found by name'
			else
				puts name + ' not found'
			end
		end


		todays_games = Game.where(:year => year, :month => month, :day => day).order("id ASC")
		var = team_index = 0
		game_index = -1
		team = nil
		doc.css(".player-link , .team-name").each do |player|
			name = player.child.to_s
			var += 1
			if store = Team.find_by_name(name)
				if team_index%2 == 0
					game_index += 1
				end
				team = store
				team_index += 1
				var = 0
				next
			end

			game = todays_games[game_index]

			game_pitchers = Pitcher.where(:game_id => game.id)
			game_hitters = Hitter.where(:game_id => game.id)

			case var
			when 1
				name = player.child.to_s
				href = player['data-bref'].to_s
				# Look for pitcher in the games.
				if href != ""
					pitcher = game_pitchers.find_by_alias(href)
				else
					pitcher = game_pitchers.find_by_name(name)
				end

				if pitcher == nil
					if href != ""
						pitcher = nil_pitchers.find_by_alias(href)
					end
					if pitcher == nil
						pitcher = nil_pitchers.find_by_name(name)
					end
					if pitcher != nil
						Pitcher.create(:game_id => game.id, :team_id => pitcher.team.id, :name => pitcher.name, :alias => pitcher.alias, :fangraph_id => pitcher.fangraph_id, :bathand => pitcher.bathand,
								:throwhand => pitcher.throwhand, :starter => true, :FIP => pitcher.FIP, :LD_L => pitcher.LD_L, :WHIP_L => pitcher.WHIP_L, :IP_L => pitcher.IP_L,
								:SO_L => pitcher.SO_L, :BB_L => pitcher.BB_L, :ERA_L => pitcher.ERA_L, :wOBA_L => pitcher.wOBA_L, :FB_L => pitcher.FB_L, :xFIP_L => pitcher.xFIP_L,
								:KBB_L => pitcher.KBB_L, :LD_R => pitcher.LD_R, :WHIP_R => pitcher.WHIP_R, :IP_R => pitcher.IP_R,
								:SO_R => pitcher.SO_R, :BB_R => pitcher.BB_R, :ERA_R => pitcher.ERA_R, :wOBA_R => pitcher.wOBA_R, :FB_R => pitcher.FB_R, :xFIP_R => pitcher.xFIP_R,
								:KBB_R => pitcher.KBB_R, :GB_R => pitcher.GB_R, :GB_L => pitcher.GB_L, :LD_30 => pitcher.LD_30, :WHIP_30 => pitcher.WHIP_30, :IP_30 => pitcher.IP_30, :SO_30 => pitcher.SO_30, :BB_30 => pitcher.BB_30, 
								:FIP_previous => pitcher.FIP_previous, :FB_previous_L => pitcher.FB_previous_L, :xFIP_previous_L => pitcher.xFIP_previous_L, :KBB_previous_L => pitcher.KBB_previous_L,
								:wOBA_previous_L => pitcher.wOBA_previous_L, :FB_previous_R => pitcher.FB_previous_R, :xFIP_previous_R => pitcher.xFIP_previous_R, :KBB_previous_R => pitcher.KBB_previous_R,
								:wOBA_previous_R => pitcher.wOBA_previous_R, :GB_previous_L => pitcher.GB_previous_L, :GB_previous_R => pitcher.GB_previous_R)
						puts name + ' created'
					else
						puts name + ' not found'
					end
				end
			when 2..19
				name = player.child.to_s
				href = player['data-bref'].to_s
				# Look for pitcher in the games.
				if href != ""
					hitter = game_hitters.find_by_alias(href)
				else
					hitter = game_hitters.find_by_name(name)
				end
				if hitter == nil
					if href != ""
						hitter = nil_hitters.find_by_alias(href)
					end
					if hitter == nil
						hitter = nil_hitters.find_by_name(name)
					end
					if hitter != nil
						Hitter.create(:game_id => game.id, :team_id => hitter.team.id, :name => hitter.name, :alias => hitter.alias, :fangraph_id => hitter.fangraph_id, :bathand => hitter.bathand,
								:throwhand => hitter.throwhand, :lineup => hitter.lineup, :starter => true, :SB_L => hitter.SB_L, :wOBA_L => hitter.wOBA_L,
								:OBP_L => hitter.OBP_L, :SLG_L => hitter.SLG_L, :AB_L => hitter.AB_L, :BB_L => hitter.BB_L, :SO_L => hitter.SO_L, :LD_L => hitter.LD_L,
								:wRC_L => hitter.wRC_L, :SB_R => hitter.SB_R, :wOBA_R => hitter.wOBA_R, :OBP_R => hitter.OBP_R, :SLG_R => hitter.SLG_R, :AB_R => hitter.AB_R,
								:BB_R => hitter.BB_R, :SO_R => hitter.SO_R, :LD_R => hitter.LD_R, :wRC_R => hitter.wRC_R, :SB_14 => hitter.SB_14, :wOBA_14 => hitter.wOBA_14,
								:OBP_14 => hitter.OBP_14, :SLG_14 => hitter.SLG_14, :AB_14 => hitter.AB_14, :BB_14 => hitter.BB_14, :SO_14 => hitter.SO_14, :LD_14 => hitter.LD_14,
								:wRC_14 => hitter.wRC_14, :SB_previous_L => hitter.SB_previous_L, :wOBA_previous_L => hitter.wOBA_previous_L, :OBP_previous_L => hitter.OBP_previous_L,
								:SLG_previous_L => hitter.SLG_previous_L, :AB_previous_L => hitter.AB_previous_L, :BB_previous_L => hitter.BB_previous_L, :SO_previous_L => hitter.SO_previous_L,
								:LD_previous_L => hitter.LD_previous_L, :wRC_previous_L => hitter.wRC_previous_L, :SB_previous_R => hitter.SB_previous_R, :wOBA_previous_R => hitter.wOBA_previous_R, 
								:OBP_previous_R => hitter.OBP_previous_R, :SLG_previous_R => hitter.SLG_previous_R, :AB_previous_R => hitter.AB_previous_R, :BB_previous_R => hitter.BB_previous_R,
								:SO_previous_R => hitter.SO_previous_R, :LD_previous_R => hitter.LD_previous_R, :wRC_previous_R => hitter.wRC_previous_R)
						puts name + ' created'
					else
						puts name+ ' not found'
					end
				end
			end

		end


		# Get the bullpen pitchers and delete extra players
		nil_bullpen_pitchers = nil_pitchers.where(:bullpen => true)
		nil_starting_pitchers = nil_pitchers.where(:starter => true)
		nil_starting_hitters = nil_hitters.where(:starter => true)
		todays_games.each do |game|

			game_hitters = Hitter.where(:game_id => game.id)
			game_pitchers = Pitcher.where(:game_id => game.id)

			bullpen_pitchers = nil_bullpen_pitchers.where(:team_id => game.home_team.id) + nil_bullpen_pitchers.where(:team_id => game.away_team.id)

			bullpen_pitchers.each do |pitcher|
				if game_pitchers.find_by_alias(pitcher.alias) == nil
					Pitcher.create(:game_id => game.id, :team_id => pitcher.team.id, :name => pitcher.name, :alias => pitcher.alias, :fangraph_id => pitcher.fangraph_id, :bathand => pitcher.bathand,
						:throwhand => pitcher.throwhand, :bullpen => true, :one => pitcher.one, :two => pitcher.two, :three => pitcher.three, :FIP => pitcher.FIP, :LD_L => pitcher.LD_L, :WHIP_L => pitcher.WHIP_L, :IP_L => pitcher.IP_L,
						:SO_L => pitcher.SO_L, :BB_L => pitcher.BB_L, :ERA_L => pitcher.ERA_L, :wOBA_L => pitcher.wOBA_L, :FB_L => pitcher.FB_L, :xFIP_L => pitcher.xFIP_L,
						:KBB_L => pitcher.KBB_L, :LD_R => pitcher.LD_R, :WHIP_R => pitcher.WHIP_R, :IP_R => pitcher.IP_R,
						:SO_R => pitcher.SO_R, :BB_R => pitcher.BB_R, :ERA_R => pitcher.ERA_R, :wOBA_R => pitcher.wOBA_R, :FB_R => pitcher.FB_R, :xFIP_R => pitcher.xFIP_R,
						:KBB_R => pitcher.KBB_R, :GB_L => pitcher.GB_L, :GB_R => pitcher.GB_R, :LD_30 => pitcher.LD_30, :WHIP_30 => pitcher.WHIP_30, :IP_30 => pitcher.IP_30, :SO_30 => pitcher.SO_30, :BB_30 => pitcher.BB_30, 
						:FIP_previous => pitcher.FIP_previous, :FB_previous_L => pitcher.FB_previous_L, :xFIP_previous_L => pitcher.xFIP_previous_L, :KBB_previous_L => pitcher.KBB_previous_L,
						:wOBA_previous_L => pitcher.wOBA_previous_L, :FB_previous_R => pitcher.FB_previous_R, :xFIP_previous_R => pitcher.xFIP_previous_R, :KBB_previous_R => pitcher.KBB_previous_R,
						:wOBA_previous_R => pitcher.wOBA_previous_R, :GB_previous_L => pitcher.GB_previous_L, :GB_previous_R => pitcher.GB_previous_R)
				end
			end


			starting_pitchers = game_pitchers.where(:starter => true)
			starting_hitters = game_hitters.where(:starter => true)
			starting_hitters.each do |hitter|
				if !nil_hitters.find_by_alias(hitter.alias).starter
					if !nil_hitters.find_by_name(hitter.name).starter
						hitter.destroy
						puts hitter.name + ' destroyed'
					end
				end
			end

			starting_pitchers.each do |pitcher|
				if !nil_pitchers.find_by_alias(pitcher.alias).starter
					if !nil_pitchers.find_by_name(pitcher.name).starter
						pitcher.destroy
						puts pitcher.name + ' destroyed'
					end
				end
			end
		end
	end

	task :ump => :environment do
		require 'nokogiri'
		require 'open-uri'

		url = "http://www.statfox.com/mlb/umpiremain.asp"
		doc = Nokogiri::HTML(open(url))

		hour, day, month, year = findDate(Time.now)

		if hour > 4 && hour < 20
			if month.size == 1
				month = "0" + month
			end
			if day.size == 1
				day = "0" + day
			end
			id = var = 0
			team = nil
			doc.css(".datatable a").each do |data|
				var += 1
				if var%3 == 2
					id = data['href']
				elsif var%3 == 0
					if data.text.size == 3
						var = 1
						next
					end
					ump = data.text
					case id
					when /ANGELS/
						team = "Angels"
					when /HOUSTON/
						team = "Astros"
					when /OAKLAND/
						team = "Athletics"
					when /TORONTO/
						team = "Blue Jays"
					when /ATLANTA/
						team = "Braves"
					when /MILWAUKEE/
						team = "Brewers"
					when /LOUIS/
						team = "Cardinals"
					when /CUBS/
						team = "Cubs"
					when /ARIZONA/
						team = "Diamondbacks"
					when /DODGERS/
						team = "Dodgers"
					when /FRANCISCO/
						team = "Giants"
					when /CLEVELAND/
						team = "Indians"
					when /SEATTLE/
						team = "Mariners"
					when /MIAMI/
						team = "Marlins"
					when /METS/
						team = "Mets"
					when /WASHINGTON/
						team = "Nationals"
					when /BALTIMORE/
						team = "Orioles"
					when /DIEGO/
						team = "Padres"
					when /PHILADELPHIA/
						team = "Phillies"
					when /PITTSBURGH/
						team = "Pirates"
					when /TEXAS/
						team = "Rangers"
					when /TAMPA/
						team = "Rays"
					when /BOSTON/
						team = "Red Sox"
					when /CINCINATTI/
						team = "Reds"
					when /COLORADO/
						team = "Rockies"
					when /KANSAS/
						team = "Royals"
					when /DETROIT/
						team = "Tigers"
					when /MINNESOTA/
						team = "Twins"
					when /WHITE/
						team = "White Sox"
					when /YANKEES/
						team = "Yankees"
					else
						team = "Not found"
					end
					if team = Team.find_by_name(team)
						puts ump
						puts team.name
						Game.where(:year => year, :month => month, :day => day, :home_team_id => team.id).first.update_attributes(:ump => ump)
					end
				end
			end
		end
	end


	task :tomorrow => :environment do
		require 'nokogiri'
		require 'open-uri'

		def convertTime(game, time)

			if !time.include?(":")
				return ""
			end

			colon = time.index(":")

			original_hour = time[0...colon].to_i
			suffix = time[colon..-4]
			hour = original_hour + game.home_team.timezone


			# Checks the borderline cases
			if original_hour == 12 && hour != 12 || hour < 0
				suffix[suffix.index("P")] = "A"
			end

			if hour < 1
				hour += 12
			end

			return hour.to_s + suffix

		end


		def starters()
			Pitcher.all.where(:tomorrow_starter => true, :game_id => nil).each do |pitcher|
				pitcher.update_attributes(:tomorrow_starter => false)
			end
		end


		url = "http://www.baseballpress.com/lineups/#{DateTime.now.tomorrow.to_date}"
		doc = Nokogiri::HTML(open(url))

		home = Array.new
		away = Array.new
		gametime = Array.new

		doc.css(".game-time").each do |time|
			gametime << time.text
		end

		doc.css(".team-name").each_with_index do |stat, index|
			team = Team.find_by_name(stat.text)
			if index%2 == 0
				away << team
			else
				home << team
			end
		end

		hour, day, month, year = findDate(Time.now.tomorrow)

		count = 1
		todays_games = Game.where(:year => year, :month => month, :day => day)
		(0...gametime.size).each{|i|
			games = todays_games.where(:home_team_id => home[i].id, :away_team_id => away[i].id)
			# Double header issues are located here
			if games.size == 2
				if count == 1
					game = games.first
				else
					game = games.second
					count = 0
				end
				time = convertTime(game, gametime[i])
				game.update_attributes(:time => time)
				count += 1
			elsif games.size == 1
				game = games.first
				time = convertTime(game, gametime[i])
				game.update_attributes(:time => time)
			else
				game = Game.create(:year => year, :month => month, :day => day, :home_team_id => home[i].id, :away_team_id => away[i].id, :num => '0')
				time = convertTime(game, gametime[i])
				game.update_attributes(:time => time)
				puts "Game created " + game.url
			end
		}

		starters()

		url = "http://www.baseballpress.com/lineups/#{DateTime.now.tomorrow.to_date}"
		puts url
		doc = Nokogiri::HTML(open(url))
		
		nil_pitchers = Pitcher.where(:game_id => nil)
		doc.css(".team-name+ div").each_with_index do |player, index|
			text = player.text
			href = player.child['data-bref']
			fangraph_id = player.child['data-mlb']
			if text == "TBD"
				next
			end
			name = text[0...-4]
			if pitcher = nil_pitchers.find_by_fangraph_id(fangraph_id)
				pitcher.update_attributes(:tomorrow_starter => true)
			elsif pitcher = nil_pitchers.find_by_alias(href)
				pitcher.update_attributes(:tomorrow_starter => true)
			elsif pitcher = nil_pitchers.find_by_name(text)
				pitcher.update_attributes(:tomorrow_starter => true)
			else
				pitcher = Pitcher.create(:name => name, :tomorrow_starter => true, :alias => href, :fangraph_id => fangraph_id)
				if index%2 == 0
					pitcher.update_attributes(:team_id => away[index/2].id)
				else
					pitcher.update_attributes(:team_id => home[index/2].id)
				end
				puts pitcher.name + ' created'
			end
		end
	end

	task :bullpen => :environment do
		require 'nokogiri'
		require 'open-uri'

		def bullpen()
			Pitcher.where(:bullpen => true, :game_id => nil).each do |pitcher|
				pitcher.update_attributes(:bullpen => false)
			end
		end

		def getNum(text)
			if text == "N/G"
				return 0
			else
				return text.to_i
			end
		end

		bullpen()

		url = "http://www.baseballpress.com/bullpenusage"
		doc = Nokogiri::HTML(open(url))
		bool = false
		pitcher = nil
		nil_pitchers = Pitcher.where(:game_id => nil)
		var = one = two = three = 0
		doc.css(".league td").each do |bullpen|
			text = bullpen.text
			case var
			when 1
				one = getNum(text)
				var += 1
			when 2
				two = getNum(text)
				var += 1
			when 3
				three = getNum(text)
				var = 0
				if pitcher != nil
					pitcher.update_attributes(:bullpen => true, :one => one, :two => two, :three => three)
				end
			end
			if text.include?("(")
				text = text[0...-4]
				href = bullpen.child['data-bref']
				fangraph_id = bullpen.child['data-mlb']
				if pitcher = nil_pitchers.find_by_name(text)
				elsif pitcher = nil_pitchers.find_by_fangraph_id(fangraph_id)
				elsif pitcher = nil_pitchers.find_by_alias(href)
				else
					puts 'Bullpen pitcher ' + text + ' not found'
					pitcher = nil
				end
				var = 1
			end
		end	
	end


	task :boxscores => :environment do
		require 'nokogiri'
		require 'open-uri'

		def getHref(stat)
			href = stat.last_element_child['href']
			return href[11..href.index(".")-1]
		end

		def getfangraphID(stat)
			href = stat.child['href']
			index = href.index("=")
			href = href[index+1..-1]
			index = href.index("&")
			href = href[0...index]
			return href.to_i
		end

		hour, day, month, year = findDate(Time.now.yesterday)

		games = Game.where(:year => year, :month => month, :day => day)
		nil_pitchers = Pitcher.where(:game_id => nil)
		nil_hitters = Hitter.where(:game_id => nil)

		games.each do |game|

			if game.pitcher_box_scores.size != 0
				next
			end

			url = "http://www.fangraphs.com/boxscore.aspx?date=#{game.year}-#{game.month}-#{game.day}&team=#{game.home_team.fangraph_abbr}&dh=#{game.num}&season=#{game.year}"
			doc = Nokogiri::HTML(open(url))
			puts url

			if doc == nil
				puts 'game did not work'
				next
			end

			array = ["#WinsBox1_dgab_ctl00 .grid_line_regular", "#WinsBox1_dghb_ctl00 .grid_line_regular", "#WinsBox1_dgap_ctl00 .grid_line_regular", "#WinsBox1_dghp_ctl00 .grid_line_regular"]

			array.each_with_index do |css, css_index|

				if css_index < 2
					int = 12
				else
					int = 11
				end

				if css_index%2 == 0
					home = false
				else
					home = true
				end

				name = hitter = pitcher = href = bo = pa = h = hr = r = rbi = bb = so = woba = pli = wpa = nil
				doc.css(css).each_with_index do |stat, index|
					text = stat.text
					case index%int
					when 0
						name = stat.child.text
						href = 0
						if name != 'Total'
							href = getfangraphID(stat)
							if css_index < 2
								if hitter = nil_hitters.find_by_fangraph_id(href)
								elsif hitter = nil_hitters.find_by_name(name)
									hitter.update_attributes(:fangraph_id => href)
								else
									puts 'hitter ' + name + ' not found, fix fangraph_id'
									puts href
								end
							else
								if pitcher = nil_pitchers.find_by_fangraph_id(href)
								elsif pitcher = nil_pitchers.find_by_name(name)
									pitcher.update_attributes(:fangraph_id => href)
								else
									puts 'pitcher ' + name + ' not found, fix fangraph_id'
									puts href
								end
							end
						end
					when 1
						if css_index < 2
							bo = text.to_i
						else
							bo = text.to_f
						end
					when 2
						pa = text.to_i
					when 3
						h = text.to_i
					when 4
						hr = text.to_i
					when 5
						r = text.to_i
					when 6
						rbi = text.to_i
					when 7
						bb = text.to_i
					when 8
						if css_index < 2
							so = text.to_i
						else
							so = text.to_f
						end
					when 9
						if css_index < 2
							woba = (text.to_f*1000).to_i
						else
							woba = text.to_f
						end
					when 10
						pli = text.to_f
						if css_index >= 2
							if pitcher != nil
								PitcherBoxScore.create(:game_id => game.id, :pitcher_id => pitcher.id, :name => pitcher.name, :home => home, :IP => bo, :TBF => pa, :H => h, :HR => hr, :ER => r, :BB => rbi,
									:SO => bb, :FIP => so, :pLI => woba, :WPA => pli)
							else
								PitcherBoxScore.create(:game_id => game.id, :pitcher_id => nil, :name => name, :home => home, :IP => bo, :TBF => pa, :H => h, :HR => hr, :ER => r, :BB => rbi,
									:SO => bb, :FIP => so, :pLI => woba, :WPA => pli)
							end
							pitcher = nil
						end
					when 11
						wpa = text.to_f
						if hitter != nil
							HitterBoxScore.create(:game_id => game.id, :hitter_id => hitter.id, :name => hitter.name, :home => home, :BO => bo, :PA => pa, :H => h, :HR => hr, :R => r, :RBI => rbi, :BB => bb,
									:SO => so, :wOBA => woba, :pLI => pli, :WPA => wpa)
						else
							HitterBoxScore.create(:game_id => game.id, :hitter_id => nil, :name => name, :home => home, :BO => bo, :PA => pa, :H => h, :HR => hr, :R => r, :RBI => rbi, :BB => bb,
									:SO => so, :wOBA => woba, :pLI => pli, :WPA => wpa)
						end
						hitter = nil
					end

				end

			end
		end
	end

	task :innings => :environment do
		require 'nokogiri'
		require 'open-uri'

		hour, day, month, year = findDate(Time.now.yesterday)

		games = Game.where(:year => year, :month => month, :day => day)

		games.each do |game|

			if game.innings.size != 0
				next
			end

			url = "http://www.baseball-reference.com/boxes/#{game.home_team.game_abbr}/#{game.url}.shtml"
			doc = Nokogiri::HTML(open(url))

			docs = doc.css("#linescore").first

			if docs == nil
				puts url + ' did not work'
				next
			else
				puts url
				text = docs.text
			end

			newline = text.index("\n")
			innings = text[0...newline]
			text = text[newline+1..-1]
			newline = text.index("\n")
			dashes = text[0...newline]
			text = text[newline+1..-1]
			newline = text.index("\n")
			away = text[0...newline]
			text = text[newline+1..-1]
			newline = text.index("\n")
			home = text[0...newline]


			num = 15
			innings = innings[num..-1]
			dashes = dashes[num..-1]
			away = away[num..-1]
			home = home[num..-1]

			inning_array = Array.new
			away_array = Array.new
			home_array = Array.new

			(0...innings.size).each do |i|
				if dashes[i] == '-'
					if innings[i-1] != ' '
						inning_array << innings[i-1] + innings[i]
					else
						inning_array << innings[i]
					end
					if away[i-1] != ' '
						away_array << away[i-1] + away[i]
					else
						away_array << away[i]
					end
					if home[i-1] != ' '
						home_array << home[i-1] + home[i]
					else
						home_array << home[i]
					end
				end
			end

			(0...inning_array.size).each do |i|
				Inning.create(:game_id => game.id, :number => inning_array[i], :away => away_array[i], :home => home_array[i])
			end
		end
	end

	task :closingline => :environment do
		require 'nokogiri'
		require 'open-uri'

		hour, day, month, year = findDate(Time.now)
		today_games = Game.where(:year => year, :month => month, :day => day)
		size = today_games.size
		url = "http://www.sportsbookreview.com/betting-odds/mlb-baseball/?date=#{year}#{month}#{day}"
		puts url
		doc = Nokogiri::HTML(open(url))
		game_array = Array.new
		doc.css(".team-name a").each_with_index do |stat, index|
			if index == size*2
				break
			end
			if index%2 == 1
				abbr = stat.child.text
				case abbr
				when "TB"
					abbr = "TBR"
				when "SF"
					abbr = "SFG"
				when "SD"
					abbr = "SDP"
				when "CWS"
					abbr = "CHW"
				when "KC"
					abbr = "KCR"
				when "WSH"
					abbr = "WSN"
				end
				team = Team.find_by_abbr(abbr)
				if team == nil
					game_array << nil
					next
				end
				games = today_games.where(:home_team_id => team.id)
				if games.size == 2
					if game_array.include?(games.first)
						game_array << games.second
					else
						game_array << games.first
					end
				elsif games.size == 1
					game_array << games.first
				else
					game_array << nil
				end
					
			end
		end

		away_money_line = Array.new
		home_money_line = Array.new
		doc.css(".eventLine-consensus+ .eventLine-book b").each_with_index do |stat, index|
			if index == size*2
				break
			end
			if index%2 == 0
				away_money_line << stat.text
			else
				home_money_line << stat.text
			end
		end

		away_totals = Array.new
		home_totals = Array.new
		url = "http://www.sportsbookreview.com/betting-odds/mlb-baseball/totals/"
		doc = Nokogiri::HTML(open(url))
		doc.css(".eventLine-consensus+ .eventLine-book b").each_with_index do |stat, index|
			if index == size*2
				break
			end
			if index%2 == 0
				away_totals << stat.text
			else
				home_totals << stat.text
			end
		end

		(0...size).each do |i|
			game = game_array[i]
			if game != nil
				game.update_attributes(:away_money_line => away_money_line[i], :home_money_line => home_money_line[i], :away_total => away_totals[i], :home_total => home_totals[i])
			end
		end

	end

	task :test => :environment do

		hour, day, month, year = findDate(Time.now)

		Game.where(:year => year, :month => month, :day => day).each do |game|
			pitchers_size = game.pitchers.where(:starter => true).size
			if pitchers_size != 2
				puts game.home_team.name + ' have ' + pitchers_size.to_s + ' pitchers'
			end
			hitters_size = game.hitters.where(:starter => true).size
			if hitters_size != 18
				puts game.home_team.name + ' have ' + hitters_size.to_s + ' hitters'
			end
		end

		hour, day, month, year = findDate(Time.now.tomorrow)

		Game.where(:year => year, :month => month, :day => day).each do |game|
			pitchers_size = (Pitcher.where(:tomorrow_starter => true, :team_id => game.home_team.id) + Pitcher.where(:tomorrow_starter => true, :team_id => game.away_team.id)).size
			if pitchers_size != 2
				puts game.home_team.name + ' have ' + pitchers_size.to_s + ' tomorrow pitchers'
			end
		end
	end

	task :iwantitnow => :environment do
		require 'open-uri'
		require 'mechanize'

		agent = Mechanize.new
		agent.add_auth("http://iwantitnow.parseapp.com/customers", "michele", "jeffers")
		agent.get("http://iwantitnow.parseapp.com/customers")
		var = 0
		agent.page.search("td").each_with_index do |stat, index|
			if index > 6
				var += 1
			end
			case var%8
			when 3
				puts stat.text
			end
		end
	end


end