# Football-Statistics-App

**Football-Statistics-App** is a simple app that shows the upcoming games of the main European football leagues, as well as their league table.

## Requirements

  - Ruby 2.4.1p111
  - football-data API KEY (http://www.football-data.org/)

## Installation
1. Clone the repository:

    ```
    $ git clone https://github.com/danielazevedo/Football-Statistics-App.git
    ```
2. Go to the repository path. To run the app locally, you will need to open two terminals:

- One to run a python HTTPServer
    ```
    $ python -m SimpleHTTPServer 8000
    ```
- Other to run the ruby app
    ```
    $ cd app
    $ ruby app.rb
    ```

## Usage
To use the app you just need to open **main.html** on views folder in your browser, example:

    http://localhost:8000/repository_path/app/views/main.html

## Built With
 - [Sinatra](http://www.sinatrarb.com/) - Ruby Framework
 - [AngularJS](https://angularjs.org/) - Javascript Framework
 
## Screenshots
1.
![alt text](https://github.com/danielazevedo/Football-Statistics-App/blob/master/app/screenshots/img2.png?raw=true)

2.  
![alt text](https://github.com/danielazevedo/Football-Statistics-App/blob/master/app/screenshots/img3.png?raw=true)
