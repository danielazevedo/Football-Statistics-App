//acede ao return do getInfo
app.controller('BoxController', ['$scope', '$rootScope', '$location', 'sharedProperties', function($scope, $rootScope, $location, sharedProperties ) {
  $scope.teams = {'Primeira Liga Portuguesa': 439, 'Premier League 2016/17': 426, 'Ligue 1 2016/17': 434, '1. Bundesliga 2016/17': 430, 'Primera Division 2016/17':436, 'Serie A 2016/17': 438}
  $scope.current_team = 'Primeira Liga Portuguesa'


  $scope.method = function() {
            $rootScope.$emit("CallMethod", {});
        }

  $scope.changeButtonColor = function(league, color) {
      
      document.getElementById(league).style.backgroundColor = color;

        }

  $scope.changeLeague = function(league, leagueName) {
      console.log("agora")
       
       document.getElementById("MainDiv").style.opacity = "0.5";
       document.getElementById("liga").innerHTML = "LOADING...";
      $scope.changeButtonColor($scope.current_team,"#7192c6")
      $scope.current_team = leagueName
      $scope.changeButtonColor(leagueName,"#2471A3")
      sharedProperties.setLeagueName(league)  
      console.log($scope.current_team)
      $scope.method();
      $location.url('/');

        
    };
  
  
    //$scope.changeButtonColor('Primeira Liga Portuguesa',"#0000FF");


}]);