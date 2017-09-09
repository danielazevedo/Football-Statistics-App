app.service('sharedProperties', function () {
        var p1 = '';
        var p2 = '';
        var leagueName = 437
        return {
            getHomeTeam: function () {
                return p1;
            },
            getAwayTeam: function () {
                return p2;
            },
            setTeams: function(value, value1) {
                p1 = value;
                p2 = value1;
            },
            getLeagueName: function() {
                return leagueName;
            },
            setLeagueName: function(name){
                leagueName = name;
            }
        };
    });
