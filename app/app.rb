require 'sinatra' 
require "faraday"
require 'uri'
require 'net/http'
require 'open-uri'
require 'json'
require 'date'
$API_KEY = '5e79a1bf10b04819898c84fb4f46ce66'
$teams_ids = Hash.new

	def make_request(path)		
		data = params['team']
		response = nil
		error = {"error"=>"You reached your request limit. Wait 50 seconds."}
		uri = URI.parse('http://api.football-data.org/v1/'+path)
		
			connection ||= Faraday.new(url: uri, headers: {"X-Auth-Token" => $API_KEY, "X-Response-Control" => 'full'},request: {
  open_timeout: 10, timeout: 10})
			c= connection.get
			response = JSON.parse(c.body)
			
		return response

	end

	def getTeamId(team)
		puts team
		if($teams_ids.keys.include? team)
			puts "Team found in hash"
			return $teams_ids[team]
		end
		response = make_request('competitions')
		response.each do |i|

			teams =  make_request('competitions/' << i['id'].to_s << '/teams')
			teams_1 = teams['teams']			
			teams_1.each do |j|
				if (j['name'] == team || j['shortname'] == team)
					aux = j['_links']["self"]["href"]
					id = aux[aux.index('/teams/')+7..-1]
					id = id.to_i
					$teams_ids[team] = id
					return id
				end

			end
		end
		return -1
	end
	

	get '/getInfoTotal' do
		golosMarcados = 0
		golosSofridos = 0
		team = params['team']
		id = getTeamId(team)
		if(id == -1)
			puts "Team not found"
			return {"error"=> "Team not found"}.to_json
		else
			puts "Team Id: #{id}"
		end

		response = make_request('teams/'+id.to_s+'/fixtures')
		puts team, id
		
		aux = getGoalsAway(response)
		goals = getGoalsHome(response)
	       	
		i = 0
		goals.each do |x,y|
	   		goals[x] += aux[x]
		   	i +=1
		end

		aux = getResultsAway(response)
		results = getResultsHome(response)

		i = 0
		results.each do |x,y|
		   results[x] += aux[x]
		   i +=1
		end

		last5Games = get5LastGames(response,team)
		next5Games = get5NextGames(response,team)
		serie = serieTotal(response,team)
		
		my_hash = {}
		my_hash["team"] = team
		my_hash["goals"] = goals
		my_hash["results"] = results
		my_hash["last5Games"] = last5Games
		my_hash["next5Games"] = next5Games
		my_hash["serie"] = serie


		return my_hash.to_json
	end

	get '/getInfoHome' do
		golosMarcados = 0
		golosSofridos = 0
		team = params['team']
		id = getTeamId(team)
		if(id == -1)
			puts "Team not found"
			return {"error"=> "Team not found"}.to_json
		else
			puts "Team Id: #{id}"
			puts "InfoHome"
		end

		response = make_request('teams/'+id.to_s+'/fixtures')
		puts team, id
		
		goalsHome = getGoalsHome(response)
		resultsHome = getResultsHome(response)
		last5Games = get5LastGames(response,team,'HOME')
		next5Games = get5NextGames(response,team, 'HOME')
		serie = serie(response,team,'HOME')
		
		my_hash = {}
		my_hash["team"] = team
		my_hash["goals"] = goalsHome
		my_hash["results"] = resultsHome
		my_hash["last5Games"] = last5Games
		my_hash["next5Games"] = next5Games
		my_hash["serie"] = serie


		return my_hash.to_json
	end
	get '/getInfoAway' do
		golosMarcados = 0
		golosSofridos = 0
		team = params['team']
		id = getTeamId(team)
		if(id == -1)
			puts "Team not found"
			return {"error"=> "Team not found"}.to_json
		else
			puts "Team Id: #{id}"
			puts "AwayInfo"
		end

		response = make_request('teams/'+id.to_s+'/fixtures')
		puts team, id
		
		goalsAway = getGoalsAway(response)
		resultsAway = getResultsAway(response)
		last5Games = get5LastGames(response,team,'AWAY')
		next5Games = get5NextGames(response,team, 'AWAY')
		serie = serie(response,team,'AWAY')
		
		my_hash = {}
		my_hash["team"] = team
		my_hash["goals"] = goalsAway
		my_hash["results"] = resultsAway
		my_hash["last5Games"] = last5Games
		my_hash["next5Games"] = next5Games
		my_hash["serie"] = serie
		

		return my_hash.to_json
	end

	def getGoalsHome(response)
		golosMarcados = 0
		golosSofridos = 0
		jogosGolos = 0
		golosMarcados_antesInt=0
		golosSofridos_antesInt=0
		team = params['team']
		
		response = response['fixtures']
		response.each do |i|
			if(i['homeTeamName'] == team && i['status'] == 'FINISHED')
				if(i['result']['halfTime'] != nil)
					jogosGolos += 1
					golosMarcados_antesInt += i['result']['halfTime']['goalsHomeTeam'].to_i
					golosSofridos_antesInt += i['result']['halfTime']['goalsAwayTeam'].to_i
				end
				
				golosMarcados += i['result']['goalsHomeTeam'].to_i
	            golosSofridos += i['result']['goalsAwayTeam'].to_i
	        end
        end
		
		my_hash = {"golosMarcados"=> golosMarcados, "golosSofridos"=> golosSofridos, "golosMarcados_antesInt"=> golosMarcados_antesInt, "golosSofridos_antesInt"=> golosSofridos_antesInt, "jogosGolos"=> jogosGolos}
		return my_hash
	end

	def getGoalsAway(response)
		golosMarcados = 0
		golosSofridos = 0
		jogosGolos = 0
		golosMarcados_antesInt=0
		golosSofridos_antesInt=0
		team = params['team']

		
		response = response['fixtures']
		response.each do |i|
			if(i['awayTeamName'] == team && i['status'] == 'FINISHED')
				if(i['result']['halfTime'] != nil)
					jogosGolos += 1
					golosMarcados_antesInt += i['result']['halfTime']['goalsAwayTeam'].to_i
					golosSofridos_antesInt += i['result']['halfTime']['goalsHomeTeam'].to_i
					#puts i['homeTeamName'], i['awayTeamName'], i['result']['halfTime']
				end

				golosMarcados += i['result']['goalsAwayTeam'].to_i
            	golosSofridos += i['result']['goalsHomeTeam'].to_i
	        end
        end
		
		my_hash = {"golosMarcados"=> golosMarcados, "golosSofridos"=> golosSofridos, "golosMarcados_antesInt"=> golosMarcados_antesInt, "golosSofridos_antesInt"=> golosSofridos_antesInt, "jogosGolos"=> jogosGolos}
		return my_hash
	end

	def getResultsHome(response)
		team = params['team']
		
	    vitorias = 0
	    empates = 0
	    derrotas = 0
	    
	    response = response['fixtures']
	    response.each do |i|
	    	if(i['homeTeamName'] == team and i['status'] == 'FINISHED')
            
                if(i['result']['goalsHomeTeam'] > i['result']['goalsAwayTeam'])
	                vitorias += 1
	            elsif(i['result']['goalsHomeTeam'] == i['result']['goalsAwayTeam'])
	                empates += 1
	            else
	                derrotas += 1
	            end


	    	end
	    end
	    my_hash = {"vitorias"=> vitorias, "empates"=> empates, "derrotas"=> derrotas}
	    return my_hash

	end

	def getResultsAway(response)
		team = params['team']
	    vitorias = 0
	    empates = 0
	    derrotas = 0
	    
	    response = response['fixtures']
	    response.each do |i|
	    	if(i['awayTeamName'] == team and i['status'] == 'FINISHED')
            
                if(i['result']['goalsHomeTeam'] < i['result']['goalsAwayTeam'])
	                vitorias += 1
	            elsif(i['result']['goalsHomeTeam'] == i['result']['goalsAwayTeam'])
	                empates += 1
	            else
	                derrotas += 1
	            end


	    	end
	    end
	    my_hash = {"vitorias"=> vitorias, "empates"=> empates, "derrotas"=> derrotas}
	    return my_hash

	end

	def get5LastGames(response, team, restriction='NONE')

		
		#d = DateTime.now.to_date
		#data = DateTime.parse("2016-08-12T19:30:00Z").to_date
		jogos = []
		response = response['fixtures']
		if(response.length == 0)
			j = 0
		else
			j = response.length-1
		end
		i = 0
		until i == 5 || j < 0 do
			if(response[j]['status'] == 'FINISHED')

				case restriction
					when 'HOME' then
						if(response[j]['homeTeamName'] == team)
							i += 1
							jogos.push(response[j])
						end

					when 'AWAY'
						if(response[j]['awayTeamName'] == team)
							i += 1
							jogos.push(response[j])
						end
					when 'NONE' then
						i += 1
						jogos.push(response[j])	
				end				
			end
			j -= 1
		end
		return jogos

	end

	def get5NextGames(response, team, restriction='NONE')
		
		jogos = []
		response = response['fixtures']
		j = 0
		i = 0
		until i == 5 || j >= response.length do
			if(response[j]['status'] == 'TIMED' || response[j]['status'] == 'SCHEDULED')
				
				case restriction
					when 'HOME' then
						if(response[j]['homeTeamName'] == team)
							i += 1
							jogos.push(response[j])
						end

					when 'AWAY'
						if(response[j]['awayTeamName'] == team)
							i += 1
							jogos.push(response[j])
						end
					when 'NONE' then
						i += 1
						jogos.push(response[j])	
				end
			end
			j += 1
		end
		return jogos

	end

	def serie(response, team, restriction = 'HOME')
		response = response['fixtures']
		j = response.length-1
		count = 0
		res = nil
		loop do
			if(response[j]['status'] == 'FINISHED' && restriction == 'HOME' && response[j]['homeTeamName'] == team)
				diff = response[j]['result']['goalsHomeTeam'].to_i - response[j]['result']['goalsAwayTeam'].to_i

				if diff > 0
						res = 'Vitoria'
						until (response[j]['result']['goalsHomeTeam'].to_i - response[j]['result']['goalsAwayTeam'].to_i <= 0 && response[j]['homeTeamName'] == team)
							if(response[j]['result']['goalsHomeTeam'].to_i > response[j]['result']['goalsAwayTeam'].to_i && response[j]['homeTeamName'] == team)
							
								count+=1
							end
							j-=1
						end
				elsif diff == 0
					res = 'Empate'
					until (response[j]['result']['goalsHomeTeam'].to_i - response[j]['result']['goalsAwayTeam'].to_i != 0 && response[j]['homeTeamName'] == team)
							if(response[j]['result']['goalsHomeTeam'].to_i == response[j]['result']['goalsAwayTeam'].to_i && response[j]['homeTeamName'] == team)
								count+=1
							end
							
							j-=1


					end
				else
					res = 'Derrota'
					until (response[j]['result']['goalsHomeTeam'].to_i - response[j]['result']['goalsAwayTeam'].to_i >= 0 && response[j]['homeTeamName'] == team) 
						if (response[j]['result']['goalsHomeTeam'].to_i - response[j]['result']['goalsAwayTeam'].to_i < 0 && response[j]['homeTeamName'] == team)
							
							count+=1
						end
						j-=1


					end
				end
				break
				
			elsif (response[j]['status'] == 'FINISHED' && restriction == 'AWAY' && response[j]['awayTeamName'] == team)
				diff = response[j]['result']['goalsHomeTeam'] - response[j]['result']['goalsAwayTeam']
					
				if diff < 0
					res = 'Vitoria'
					until (response[j]['result']['goalsHomeTeam'].to_i - response[j]['result']['goalsAwayTeam'].to_i >= 0 && response[j]['awayTeamName'] == team)
						
						if (response[j]['result']['goalsHomeTeam'].to_i - response[j]['result']['goalsAwayTeam'].to_i < 0 && response[j]['awayTeamName'] == team)
							
							count+=1
						end
						j-=1


					end
				elsif diff == 0
					res = 'Empate'
					until (response[j]['result']['goalsHomeTeam'].to_i - response[j]['result']['goalsAwayTeam'].to_i != 0)
						
						if (response[j]['result']['goalsHomeTeam'].to_i == response[j]['result']['goalsAwayTeam'].to_i && response[j]['awayTeamName'] == team)
							
							count+=1
						end
						j-=1


					end
				else
					res = 'Derrota'
					until (response[j]['result']['goalsHomeTeam'].to_i - response[j]['result']['goalsAwayTeam'].to_i <= 0 && response[j]['awayTeamName'] == team)
						
						if (response[j]['result']['goalsHomeTeam'].to_i - response[j]['result']['goalsAwayTeam'].to_i > 0 && response[j]['awayTeamName'] == team)
							count+=1
						end
						j-=1


					end

				end
				break
			end
			j -= 1
			
		end
		
		my_hash = {"resultado" => res, "serie"=> count}
		return my_hash


	end


	def serieTotal(response, team, restriction = 'HOME')
		response = response['fixtures']
		j = response.length-1
		count = 0
		res = nil
		loop do
			if(response[j]['status'] == 'FINISHED')
				if(response[j]['homeTeamName'] == team)
					diff = response[j]['result']['goalsHomeTeam'] - response[j]['result']['goalsAwayTeam']
					
					if diff > 0
						res = 'Vitoria'
						until (response[j]['result']['goalsHomeTeam'] - response[j]['result']['goalsAwayTeam'] <= 0 && response[j]['homeTeamName'] == team) or (response[j]['result']['goalsHomeTeam'] - response[j]['result']['goalsAwayTeam'] >= 0 && response[j]['awayTeamName'] == team)
							j-=1
							count+=1

						end
					elsif diff == 0
						res = 'Empate'
						until (response[j]['result']['goalsHomeTeam'] - response[j]['result']['goalsAwayTeam'] != 0)
							j-=1
							count+=1


						end
					else
						res = 'Derrota'
						until (response[j]['result']['goalsHomeTeam'].to_i - response[j]['result']['goalsAwayTeam'].to_i >= 0 && response[j]['homeTeamName'] == team) or (response[j]['result']['goalsHomeTeam'].to_i - response[j]['result']['goalsAwayTeam'].to_i <= 0 && response[j]['awayTeamName'] == team)
							j-=1
							count+=1


						end
					end
					break

				elsif(response[j]['awayTeamName'] == team)
					diff = response[j]['result']['goalsHomeTeam'] - response[j]['result']['goalsAwayTeam']
					
					if diff < 0
						res = 'Vitoria'
						until (response[j]['result']['goalsHomeTeam'] - response[j]['result']['goalsAwayTeam'] >= 0 && response[j]['awayTeamName'] == team) or (response[j]['result']['goalsHomeTeam'] - response[j]['result']['goalsAwayTeam'] <= 0 && response[j]['homeTeamName'] == team)
							j-=1
							count+=1


						end
					elsif diff == 0
						res = 'Empate'
						until (response[j]['result']['goalsHomeTeam'] - response[j]['result']['goalsAwayTeam'] != 0)
							j-=1
							count+=1


						end
					else
						res = 'Derrota'
						until (response[j]['result']['goalsHomeTeam'] - response[j]['result']['goalsAwayTeam'] <= 0 && response[j]['awayTeamName'] == team) or (response[j]['result']['goalsHomeTeam'] - response[j]['result']['goalsAwayTeam'] >= 0 && response[j]['homeTeamName'] == team)
							j-=1
							count+=1


						end

					end

				end
				
				break
			end
			j -= 1
		end
		my_hash = {"resultado" => res, "serie"=> count}

		return my_hash

	end


	def getGames(league,nDays=7)
		final = []
		league_name = make_request('competitions/'+league.to_s)
		
		final.push([league_name['caption']])

		
		response = make_request('competitions/'+league.to_s+'/fixtures?timeFrame=n'+nDays.to_s)
		response = response['fixtures']

		logosResponse = make_request('competitions/'+league.to_s+'/teams')
		logosResponse = logosResponse['teams']
		logos = {}
		logosResponse.each do |y|
			if(y['name'] == 'FC Ingolstadt 04')
				logos[y['name']] = 'https://upload.wikimedia.org/wikipedia/en/0/0b/FC_Ingolstadt_04_logo.svg'
			elsif(y['name'] == 'Bayer Leverkusen')
				logos[y['name']] = 'https://upload.wikimedia.org/wikipedia/en/5/59/Bayer_04_Leverkusen_logo.svg'
			elsif(y['name'] == 'Red Bull Leipzig')
				logos[y['name']] = 'https://upload.wikimedia.org/wikipedia/en/4/49/RB_Leipzig_2014_logo.svg.png'
			elsif(y['name'] == 'FC Schalke 04')
				logos[y['name']] = 'https://upload.wikimedia.org/wikipedia/commons/6/6d/FC_Schalke_04_Logo.svg'
			elsif(y['name'] == 'Hertha BSC')
				logos[y['name']] = 'https://upload.wikimedia.org/wikipedia/en/d/dd/Hertha_Zehlendorf.png'
			elsif(y['name'] == 'TSG 1899 Hoffenheim')
				logos[y['name']] = 'https://upload.wikimedia.org/wikipedia/commons/e/e7/Logo_TSG_Hoffenheim.svg'
			elsif(y['name'] == '1. FC Köln')
				logos[y['name']] = 'https://upload.wikimedia.org/wikipedia/en/5/53/FC_Cologne_logo.svg'
			elsif(y['name'] == 'FC Augsburg')
				logos[y['name']] = 'https://upload.wikimedia.org/wikipedia/en/c/c5/FC_Augsburg_logo.svg'
			elsif(y['name'] == 'Feirense')
				logos[y['name']] = 'https://upload.wikimedia.org/wikipedia/en/2/2a/CD_Feirense.png'
			else
				logos[y['name']] = y['crestUrl']
			end
		end
		

		response.each do |x|
			
			logo1 = logos[x['homeTeamName']]
			logo2 = logos[x['awayTeamName']]
			x['date'] = DateTime.parse(x['date']).to_s
			x['date'].sub! 'T', '  '
			x['date'].sub! ':00+00:00', ''
			l = [x['homeTeamName'], x['awayTeamName'], x['date'], x['status'],logo1, logo2]
			final.push(l)
		end

		return final


	end

	def getLeagueTable(league)

		points = []
		teams = []
		response = make_request('competitions/'+league.to_s+'/leagueTable')
		response =  response['standing']
		response.each do |x|
			points.push(x['points'])
			teams.push(x['teamName'])
		end
		return [teams, points]
		end


	get '/getNextGames' do
		league = params['league']
		nDays = params['nDays']
		if(!nDays.nil?)
			my_hash = getGames(league,nDays)
		else
			my_hash = getGames(league)
		end
		table = getLeagueTable(league)
		my_hash.insert(0,table)
		
		return my_hash.to_json

	end


	get '/getPrevGames' do
		res = []
		team1 = params['team1']
		team2 = params['team2']
		response = make_request('fixtures/')
		response = response['fixtures']
		# && x['awayTeamName'].to_s == team2.to_s
		response.each do |x|
			if x['awayTeamName'].to_s == team2.to_s
				aux = x['_links']["self"]["href"]
				n = aux[aux.index('/fixtures/')+10..-1]
				r = make_request('fixtures/'+n+'/')
				r = r['head2head']['fixtures']
				r.each do |y|
					y['date'] = DateTime.parse(y['date']).to_date
					res.push(y)
				end
			end
		end
		
		return res.to_json
	end






