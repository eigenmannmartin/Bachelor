(function() {
  define('src/app', ['src/client'], function(client) {
    var App;
    App = (function() {
      function App() {}

      return App;

    })();
    return App;
  });

}).call(this);

(function() {
  define('src/client', [], function() {
    var Client;
    Client = (function() {
      function Client() {}

      return Client;

    })();
    return Client;
  });

}).call(this);

(function() {
  require;
  ({
    paths: {
      jquery: 'Libs/jquery/jquery-1.8.0.min'
    },
    shim: {
      'jquery': {
        exports: '$'
      }
    }
  });

  require(["src/app"], function(App) {
    var app;
    return app = new App();
  });

}).call(this);

(function() {
  define('src/server', [], function() {
    var Server;
    Server = (function() {
      function Server() {}

      return Server;

    })();
    return Server;
  });

}).call(this);
