(function() {
  define(['flux'], function(flux) {
    var API;
    API = (function() {
      function API(socket) {
        var me;
        if (socket == null) {
          socket = false;
        }
        if (socket) {
          this.Socket = socket;
        } else {
          throw new Error("you need to pass a websocket instance");
        }
        me = this;
        this.Socket.on('message', function(msg) {
          return me.dispatch(msg.messageName, msg.message);
        });
        flux.dispatcher.register(function(messageName, message) {
          return me.dispatch(messageName, message);
        });
      }

      API.prototype.dispatch = function(messageName, message) {
        if (messageName === 'S_API_WEB_get') {
          this._get(message);
        }
        if (messageName === 'S_API_WEB_put') {
          this._put(message);
        }
        if (messageName === 'S_API_WEB_update') {
          this._update(message);
        }
        if (messageName === 'S_API_WEB_delete') {
          this._delete(message);
        }
        if (messageName === 'S_API_WEB_execute') {
          this._execute(message);
        }
        if (messageName === 'S_API_WEB_send') {
          return this._send(message);
        }
      };

      API.prototype._execute = function(message) {
        message.meta.socket = this.Socket;
        return this._send_message('S_LOGIC_SM_execute', message);
      };

      API.prototype._send = function(message) {
        var messageName;
        if (message.data.deleted != null) {
          messageName = 'C_PRES_STORE_delete';
        } else {
          messageName = 'C_PRES_STORE_update';
        }
        if (message.meta.conflict != null) {
          messageName = 'C_PRES_STORE_conflict';
        }
        if ('socket' in message.meta) {
          if (this.Socket.id === message.meta.socket.id) {
            return message.meta.socket.emit('message', {
              messageName: messageName,
              message: {
                meta: {
                  model: message.meta.model
                },
                data: message.data
              }
            });
          }
        } else {
          return this.Socket.emit('message', {
            messageName: messageName,
            message: {
              meta: {
                model: message.meta.model
              },
              data: message.data
            }
          });
        }
      };

      API.prototype._get = function(message) {
        message.meta.socket = this.Socket;
        return this._send_message('S_LOGIC_SM_get', message);
      };

      API.prototype._put = function(message) {
        return this._send_message('S_LOGIC_SM_create', message);
      };

      API.prototype._update = function(message) {
        message.meta.socket = this.Socket;
        return this._send_message('S_LOGIC_SM_update', message);
      };

      API.prototype._delete = function(message) {
        return this._send_message('S_LOGIC_SM_delete', message);
      };

      API.prototype._send_message = function(messageName, message) {
        return flux.doAction(messageName, message);
      };

      return API;

    })();
    return API;
  });

}).call(this);
