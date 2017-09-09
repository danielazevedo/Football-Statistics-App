//acede ao return do getInfo
app.controller('BoxController', ['$scope', '$rootScope', '$location', 'sharedProperties', function($scope, $rootScope, $location, sharedProperties ) {
  $scope.teams = {'Primeira Liga 2017/18': 457, 'Premier League 2017/18': 445, 'Ligue 1 2017/18': 450, '1. Bundesliga 2017/18': 452, 'Primera Division 2017/18':455, 'Serie A 2017/18': 456}
  $scope.current_team = 'Primeira Liga 2017/18'


  $scope.method = function() {
            $rootScope.$emit("CallMethod", {});
        }

  $scope.changeButtonColor = function(league, color) {
      
      document.getElementById(league).style.backgroundColor = color;

        }

  $scope.changeLeague = function(league, leagueName) {
       
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
  

}]);
