(function() {
  define(['flux', 'state'], function(flux, state) {

    /*
    	 * GENERAL / ALL API INSTANCES
     */
    var Api;
    flux.dispatcher.register(function(actionType, data, socket) {
      if (actionType === 'prototype_api_private_stores_rooms_update_insert') {
        console.log("private update");
        return socket.emit('message', {
          actionType: 'prototype_stores_rooms_update_insert',
          data: data
        });
      }
    });
    Api = (function() {
      function Api(socket) {
        var api;
        if (socket == null) {
          socket = false;
        }
        this.socket = socket;
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
        flux.doAction('prototype_sync_rooms_init', socket);
        flux.dispatcher.register(function(actionType, data) {
          if (actionType === 'prototype_api_stores_rooms_update_insert') {
            console.log("public update");
            return api.socket.emit('message', {
              actionType: 'prototype_stores_rooms_update_insert',
              data: data
            });
          }
        });
      }

      Api.prototype.handle_message = function(actionType, data) {
        if (actionType === "prototype_api_rooms_update") {
          console.log(actionType + " - " + data.prev.name + " to " + data.recent.name);
          flux.doAction('prototype_sync_rooms_update', data);
        }
        if (actionType === "prototype_api_rooms_create") {
          console.log(actionType + " - " + data.recent.name);
          return flux.doAction('prototype_sync_rooms_create', data);
        }
      };

      return Api;

    })();
    return Api;
  });

}).call(this);
