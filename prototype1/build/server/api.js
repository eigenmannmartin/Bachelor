(function() {
  define(['fluxify', 'flux'], function(flux, a) {
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
          return api.handle_message(msg.actionType, {
            prev: msg.prev,
            recent: msg.recent
          });
        });
      }

      Api.prototype.handle_message = function(actionType, data) {
        if (actionType === "prototype_api_rooms_update") {
          console.log(actionType + " - " + data.prev.name + " to " + data.recent.name);
          console.log("doAction: test");
          flux.doAction('test');
        }
        if (actionType === "prototype_api_rooms_create") {
          return console.log(actionType + " - " + data.recent.name);
        }
      };

      return Api;

    })();
    return Api;
  });

}).call(this);
