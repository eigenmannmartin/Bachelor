(function() {
  define([], function() {
    var Api;
    Api = (function() {
      function Api(socket) {
        var api;
        if (socket == null) {
          socket = false;
        }
        if (!socket) {
          throw new Error("API.constructor - constructor needs a socket");
        }
        api = this;
        socket.on('message', function(msg) {
          return api.handle_message(msg);
        });
      }

      Api.prototype.handle_message = function(msg) {
        return console.log("got a new msg: " + msg);
      };

      return Api;

    })();
    return Api;
  });

}).call(this);

//# sourceMappingURL=api.js.map
