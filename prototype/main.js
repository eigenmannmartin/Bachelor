(function() {
  define('client', [], function() {
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


      /* istanbul ignore next */

      App.prototype.resume = function() {
        return true;
      };

      return App;

    })();
    return new App();
  });

}).call(this);

(function() {
  define(['client'], function(client) {
    var App;
    App = (function() {
      function App() {
        console.log('asdfasdfasdfasdf');
        console.log(client.start());
      }

      return App;

    })();
    return new App();
  });

}).call(this);
