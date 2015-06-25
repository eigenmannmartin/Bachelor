(function() {
  define(['flux', 'io'], function(flux, io) {
    var API;
    API = (function() {
      function API() {
        var me;
        this.io = io('http://localhost:3000');
        this.io.on('message', function(msg) {
          if (msg.messageName === 'C_PRES_STORE_update') {
            flux.doAction('C_PRES_STORE_update', {
              meta: {
                model: msg.message.meta.model,
                updated: true
              },
              data: msg.message.data
            });
          }
          if (msg.messageName === 'C_PRES_STORE_delete') {
            flux.doAction('C_PRES_STORE_delete', {
              meta: {
                model: msg.message.meta.model,
                updated: true
              },
              data: msg.message.data
            });
          }
          if (msg.messageName === 'C_PRES_STORE_conflict') {
            return flux.doAction('C_PRES_STORE_conflict', {
              meta: {
                model: msg.message.meta.model,
                updated: true
              },
              data: msg.message.data
            });
          }
        });
        me = this;
        this.io.on('connect', function() {
          me._initial_sync();
          return flux.doAction('prototype_stores_api_connect');
        });
        this.io.on('reconnect', function() {
          me._initial_sync();
          return flux.doAction('prototype_stores_api_connect');
        });
        this.io.on('reconnecting', function() {
          return flux.doAction('prototype_stores_api_connecting');
        });
        this.io.on('disconnect', function() {
          return flux.doAction('prototype_stores_api_disable');
        });
        this.io.on('connect_failed', function() {
          return flux.doAction('prototype_stores_api_disconnect');
        });
        this.io.on('reconnect_failed', function() {
          return flux.doAction('prototype_stores_api_disconnect');
        });
        flux.dispatcher.register('api', function(messageName, message) {
          return me.dispatch(messageName, message);
        });
        window.io = this.io;
      }

      API.prototype._initial_sync = function() {
        return this.io.emit('message', {
          messageName: 'S_API_WEB_get',
          message: {
            meta: {
              model: "Contact"
            }
          }
        });
      };

      API.prototype.dispatch = function(messageName, message) {
        if (messageName === 'C_API_Connection') {
          if (message.meta["function"] === 'disconnect') {
            this.io.close();
          }
          if (message.meta["function"] === 'connect') {
            this.io.open();
          }
        }
        if (messageName === 'C_PRES_STORE_update') {
          if (message.meta["function"] != null) {
            this.io.emit('message', {
              messageName: "S_API_WEB_execute",
              message: {
                meta: {
                  "function": message.meta["function"]
                },
                data: {
                  args: message.args
                }
              }
            });
          }
        }
        if (message.meta.updated) {
          return false;
        }
        if (messageName === 'C_PRES_STORE_update') {
          if (message.data.id) {
            this.io.emit('message', {
              messageName: "S_API_WEB_update",
              message: {
                meta: {
                  model: message.meta.model
                },
                data: {
                  obj: message.data,
                  prev: message.prev
                }
              }
            });
          } else {
            this.io.emit('message', {
              messageName: "S_API_WEB_put",
              message: {
                meta: {
                  model: message.meta.model
                },
                data: {
                  obj: message.data
                }
              }
            });
          }
        }
        if (messageName === 'C_PRES_STORE_delete') {
          return this.io.emit('message', {
            messageName: "S_API_WEB_delete",
            message: {
              meta: {
                model: message.meta.model
              },
              data: {
                obj: message.data
              }
            }
          });
        }
      };

      return API;

    })();
    return new API;
  });

}).call(this);

//# sourceMappingURL=api.js.map
