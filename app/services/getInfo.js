

app.factory('getInfo', ['$http', 'sharedProperties', function($http,sharedProperties) { 
	return{
		make_request:  function(sharedProperties){
			var request = $http.get('http://localhost:4567/getNextGames?league='+sharedProperties.getLeagueName().toString()) 
				.success(function(data) {
					return data; 
				}) 
			.error(function(err) { 
				console.log(err)
					return err; 
			}); 
			return request
		}
	}
}]);



app.factory('getInfoTotal', ['$http', function($http) { 
	return {
		make_request: function(team){
			var request = $http.get('http://localhost:4567/getInfoTotal?team='+team) 
				.success(function(data) { 
					return data; 
				}) 
			.error(function(err) { 
				console.log(err)
					return err; 
			}); 
			return request
		}
	}
}]);


app.factory('getInfoHome', ['$http', function($http) { 
	return {
		make_request: function(team){
			var request = $http.get('http://localhost:4567/getInfoHome?team='+team) 
				.success(function(data) { 
					return data; 
				}) 
			.error(function(err) { 
				console.log(err)
					return err; 
			}); 
			return request
		}
	}
}]);

app.factory('getInfoAway', ['$http', function($http) { 
	return {
		make_request: function(team){
			var request = $http.get('http://localhost:4567/getInfoAway?team='+team) 
				.success(function(data) { 
					return data; 
				}) 
			.error(function(err) { 
				console.log(err)
					return err; 
			}); 
			return request
		}
	}
}]);

app.factory('getPrevGames', ['$http', 'sharedProperties', function($http,sharedProperties) { 
	return {
		make_request: function(sharedProperties){
			var request = $http.get('http://localhost:4567/getPrevGames?team1='+sharedProperties.getHomeTeam()+'+&team2='+sharedProperties.getAwayTeam()) 
				.success(function(data) { 
					return data; 
				}) 
			.error(function(err) { 
				console.log(err)
					return err; 
			}); 
			return request
		}
	}
}]);
