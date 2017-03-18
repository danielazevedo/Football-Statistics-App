//acede ao return do getInfo
app.controller('MainController', ['$scope', '$rootScope', '$location', 'getInfo', 'sharedProperties', function($scope, $rootScope, $location, getInfo, sharedProperties ) {
  
	$scope.image1 = ''
	$scope.image1 = ''
	$scope.liga=["CHOOSE A LEAGUE"]

	$rootScope.$on("CallMethod", function(){
           $scope.loadData();
        });

	
	$scope.loadData = function () {
    	getInfo.make_request(sharedProperties).success(function(data) {
		    document.getElementById("MainDiv").style.opacity = "1";
		    document.getElementById("tabela").style.visibility = "visible";
		    $scope.tabelaTeams = data[0][0];
		    $scope.tabelaPoints = data[0][1];
		    $scope.liga = data[1];
		    data.shift();
		    data.shift();
		    $scope.data = data
		    console.log(data);
		    $scope.change = function(team1, team2) {
				sharedProperties.setTeams(team1,team2)
	  	 		$location.url('/Head2Head');
				};

		  });
  	};
  	//$scope.loadData();
  
  	console.log(sharedProperties.getLeagueName());

}]);
