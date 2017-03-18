var app = angular.module('App', ['ngRoute','chart.js']);

app.config(function ($routeProvider, $locationProvider) {
  //$locationProvider.html5Mode(true);

  $routeProvider 
  	.when('/', {
      templateUrl: "teams.html"
    })
    .when('/Head2Head', {
      controller: "homeController", 
      t: "DEU!!",
      templateUrl: 'H2H.html' 
    });
});
