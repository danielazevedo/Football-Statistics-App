//acede ao return do getInfo
 app.controller('awayController', ['$scope', '$route','getInfoHome', 'getInfoAway','getInfoTotal', 'getPrevGames', 'sharedProperties', function ($scope, $route, getInfoHome, getInfoAway, getInfoTotal, getPrevGames, sharedProperties) {
      var paramValue = $route.current.$$route.t;
      
      var cache=[0,0,0];

      $scope.data = null;
      
      $scope.team1  = sharedProperties.getHomeTeam();
  	$scope.team2  = sharedProperties.getAwayTeam();
      
      $scope.tt = paramValue;
      $scope.totalGames = 0;
      $scope.vitorias = 0;
      $scope.empates = 0;
      $scope.derrotas = 0;
      $scope.activeTab = 1;
      $scope.diff = 0;
      $scope.golosM = 0;
      $scope.golosS = 0;
      $scope.nextGames = [];
      $scope.lastGames = [];
      $scope.serieV = 0;
      $scope.serieE = 0;
      $scope.serieD = 0;
      $scope.PrevGames = '';
      $scope.resultColors = [];

      $scope.labels = ["First Half.", "Second Half"];
      $scope.colors = ['#9AB6F0', '#C2D3F6']
      $scope.datas = [];
      $scope.datas1 = [];
      $scope.options =  { title: { display: true, text: 'Goals scored', position: 'bottom', padding: 5 }, legend: { display: true } };
      $scope.options1 =  { title: { display: true, text: 'Goals conceded', position: 'bottom', padding: 5 }, legend: { display: true } };
     

      var showComponents = function(){
            console.log("show Componentes");
            console.log(document.getElementById("Warning").style.display);
            document.getElementById("Warning").style.display = "none";
            document.getElementById("FirstTable").style.visibility = "visible";
            document.getElementById("SecondTable").style.visibility = "visible";
            document.getElementById("SerieT").style.visibility = "visible";
            document.getElementById("P1").style.visibility = "visible";
            document.getElementById("P2").style.visibility = "visible";
            document.getElementById("LastG").style.borderRight = "solid #000000";
      }

      var handleData = function(data){
            showComponents();
            $scope.data = data; 
            $scope.totalGames = data['results']['derrotas']+data['results']['vitorias']+data['results']['empates']
            $scope.vitorias = data['results']['vitorias'];
            $scope.empates = data['results']['empates'];
            $scope.derrotas = data['results']['derrotas'];
            $scope.golosM = data['goals']['golosMarcados'];
            $scope.golosS = data['goals']['golosSofridos'];
            $scope.diff = $scope.golosM - $scope.golosS;
            $scope.points = $scope.vitorias*3+$scope.empates

            $scope.datas=[data['goals']['golosMarcados_antesInt'], $scope.golosM-data['goals']['golosMarcados_antesInt']];
            $scope.datas1=[data['goals']['golosSofridos_antesInt'], $scope.golosS-data['goals']['golosSofridos_antesInt']];

            $scope.nextGames = [];
            $scope.lastGames = [];
            for(var i=0; i< data['next5Games'].length; i++){
                  x = data['next5Games'][i];
                  str = x['homeTeamName'] + ' vs '+x['awayTeamName'];
                  $scope.nextGames.push(str);
            }

            for(var i=data['last5Games'].length-1; i>= 0; i--){
                  x = data['last5Games'][i];
                  str = x['homeTeamName'] + ' '+x['result']['goalsHomeTeam']+' - '+x['result']['goalsAwayTeam']+' '+x['awayTeamName'];
                  $scope.lastGames.push(str);
            }

            $scope.serieV = 0;
            $scope.serieE = 0;
            $scope.serieD = 0;
            
            if(data['serie']['resultado'] == "Vitoria"){
                  $scope.serieV = data['serie']['serie'];
            }
            else if(data['serie']['resultado'] == "Empate"){
                  $scope.serieE = data['serie']['serie'];
            }
            else{
                  $scope.serieD = data['serie']['serie'];
            }

      }


      $scope.isSet = function () {
            return $scope.activeTab;
      };      


      $scope.setActiveTab = function(tabToSet) {
            $scope.activeTab = tabToSet;
            var homeInfo;
            var awayInfo;

            //total
            if(tabToSet == 1){
                  console.log("totalInfo");
                  if(cache[0] == 0){
                        getInfoTotal.make_request($scope.team2).success(function(data){
                              console.log(data);
                              handleData(data);
                              cache[0] = data;
                        });
                  }
                  else{
                        handleData(cache[0]);
                  }
            }
            //home
            else if(tabToSet == 2){
                  console.log("homeInfo");
                  if(cache[1] == 0){
                        getInfoHome.make_request($scope.team2).success(function(data1){
                              console.log(data1);
                              handleData(data1);
                              cache[1] = data1;
                        });
                  }
                  else{
                        handleData(cache[1]);
                  }
            }
            //away
            else if(tabToSet == 3){
                  console.log("awayInfo");
                  if(cache[2] == 0){
                        getInfoAway.make_request($scope.team2).success(function(data2){
                              console.log(data2);
                              handleData(data2);
                              cache[2] = data2;   
                              
                        });
                  }
                  else{
                        handleData(cache[2]);
                  }
            }
      }

      getPrevGames.make_request(sharedProperties).success(function(data) {
            $scope.PrevGames = data;
            $scope.resultColors = [];
            for(var i=0; i< data.length; i++){
                  
                  if(data[i]['result']['goalsHomeTeam']==data[i]['result']['goalsAwayTeam']){
                        $scope.resultColors.push('#AFEEEE');
                  }
                  else if(data[i]['result']['goalsHomeTeam']>data[i]['result']['goalsAwayTeam'] && data[i]['homeTeamName'] == $scope.team1){
                        $scope.resultColors.push('#00FF00');
                  }
                  else if(data[i]['result']['goalsHomeTeam']<data[i]['result']['goalsAwayTeam'] && data[i]['awayTeamName'] == $scope.team1){
                        $scope.resultColors.push('#00FF00');
                  }
                  else{
                        $scope.resultColors.push('#FF0000');
                  }
            
            }

            
      });


      
 }]);