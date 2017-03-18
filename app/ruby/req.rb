require 'sinatra' 
require 'unirest'
require 'uri'
require 'net/http'
require 'open-uri'

def make_request

	uri = URI.parse('http://api.football-data.org/v1/competitions/354/fixtures/?matchday=22')
	headers = {'5e79a1bf10b04819898c84fb4f46ce66'=> 'YOUR_API_TOKEN', 'X-Response-Control'=> 'minified'}
	
	http = Net::HTTP.new(uri.host, uri.port)
	request = Net::HTTP::Get.new(uri.request_uri)
	request.initialize_http_header({'X-Auth-Token'=> '5e79a1bf10b04819898c84fb4f46ce66','X-Response-Control'=>'minified'})

	response = http.request(request)
	puts response.code

end

def tt
	

    FootballData.configure do |config|
    # get api key at 'http://api.football-data.org/register'
    config.api_key = '5e79a1bf10b04819898c84fb4f46ce66'

    # default api version is 'alpha' if not setted
    config.api_version = 'alpha'

    # the default control method is 'full' if not setted
    # see request section on 'http://api.football-data.org/documentation'
    config.response_control = 'minified'


    FootballData.fetch(:soccerseasons)
end

end


get '/goalsHome' do 
	tt
	"Just Do It||| TESTE" 

end
