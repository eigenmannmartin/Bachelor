(function() {
  define('src/app', ['src/client'], function(client) {
    var App;
    App = (function() {
      function App() {
        console.log('asdfasdfasdfasdf');
        console.log(client.start());
      }

      App.prototype.asdf = function() {
        return false;
      };

      return App;

    })();
    return App;
  });

}).call(this);

(function() {
  define('src/client', [], function() {
    var App;
    App = (function() {
      function App() {}

      App.prototype.start = function(a, b) {
        if (a === b) {
          return true;
        } else {
          return false;
        }
      };

      App.prototype.stop = function() {
        return true;
      };

      App.prototype.resume = function(a, b) {
        if (a || b) {
          return true;
        } else {
          return false;
        }
      };

      return App;

    })();
    return new App();
  });

}).call(this);

(function() {
  require;
  ({
    paths: {
      jquery: 'Libs/jquery/jquery-1.8.0.min'
    },
    shim: {
      'underscore': {
        exports: '_'
      }
    }
  });

  require(["src/app"], function(App) {
    var app;
    return app = new App();
  });

}).call(this);
