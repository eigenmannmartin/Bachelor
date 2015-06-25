(function() {
  define(['flux'], function(flux) {
    var Store;
    Store = (function() {
      function Store() {
        flux.createStore({
          id: "materialize_colors",
          initialState: {
            colors: ['red', 'pink', 'purple', 'deep-purple', 'indigo', 'blue', 'light-blue', 'cyan', 'teal', 'green', 'light-green', 'lime', 'yellow', 'amber', 'orange', 'deep-orange', 'brown', 'grey', 'blue-grey'],
            active_color: 'indigo'
          },
          actionCallbacks: {
            C_PRES_STORE_update: function(updater, data) {
              if (data.meta.model === "Color") {
                return updater.set({
                  active_color: data.color
                });
              }
            }
          }
        });
        flux.createStore({
          id: "prototype_contacts",
          initialState: {
            contacts: []
          },
          actionCallbacks: {
            C_PRES_STORE_update: function(updater, msg) {
              var index, key, newcontacts, r, val, _i, _len, _ref;
              if (msg.meta.model === "Contact") {
                if (msg.data.id) {
                  index = null;
                  newcontacts = this.getState().contacts;
                  for (_i = 0, _len = newcontacts.length; _i < _len; _i++) {
                    r = newcontacts[_i];
                    if (r.id === msg.data.id) {
                      index = newcontacts.indexOf(r);
                    }
                  }
                  if (index !== null) {
                    _ref = msg.data;
                    for (key in _ref) {
                      val = _ref[key];
                      newcontacts[index][key] = val;
                    }
                  } else {
                    newcontacts.push(msg.data);
                  }
                  updater.set({
                    contacts: newcontacts
                  });
                  return updater.emit('change', this.getState());
                }
              }
            },
            C_PRES_STORE_delete: function(updater, msg) {
              var index, newcontacts, r, _i, _len;
              if (msg.meta.model === "Contact") {
                index = null;
                newcontacts = this.getState().contacts;
                for (_i = 0, _len = newcontacts.length; _i < _len; _i++) {
                  r = newcontacts[_i];
                  if (r.id === msg.data.id) {
                    index = newcontacts.indexOf(r);
                  }
                }
                if (index !== null) {
                  newcontacts.splice(index, 1);
                }
                updater.set({
                  contacts: newcontacts
                });
                return updater.emit('change', this.getState());
              }
            }
          }
        }, flux.createStore({
          id: "prototype_api",
          initialState: {
            connected: false,
            connecting: false,
            disabled: false
          },
          actionCallbacks: {
            prototype_stores_api_connect: function(updater) {
              return updater.set({
                connected: true,
                connecting: false,
                disabled: false
              });
            },
            prototype_stores_api_disconnect: function(updater) {
              return updater.set({
                connected: false,
                connecting: false,
                disabled: false
              });
            },
            prototype_stores_api_connecting: function(updater) {
              return updater.set({
                connected: false,
                connecting: true,
                disabled: false
              });
            },
            prototype_stores_api_disable: function(updater) {
              return updater.set({
                connected: false,
                connecting: false,
                disabled: true
              });
            }
          }
        }), flux.createStore({
          id: "prototype_msgs",
          initialState: {
            messages: []
          },
          actionCallbacks: {
            C_PRES_STORE_update: function(updater, msg) {
              var newmessages;
              newmessages = this.getState().messages;
              newmessages.push({
                name: "C_PRES_STORE_update",
                msg: msg,
                id: newmessages.length
              });
              updater.set({
                messages: newmessages
              });
              return updater.emit('change', this.getState());
            },
            C_PRES_STORE_delete: function(updater, msg) {
              var newmessages;
              newmessages = this.getState().messages;
              newmessages.push({
                name: "C_PRES_STORE_delete",
                msg: msg,
                id: newmessages.length
              });
              updater.set({
                messages: newmessages
              });
              return updater.emit('change', this.getState());
            },
            C_PRES_STORE_conflict: function(updater, msg) {
              var newmessages;
              newmessages = this.getState().messages;
              newmessages.push({
                name: "C_PRES_STORE_conflict",
                msg: msg,
                id: newmessages.length
              });
              updater.set({
                messages: newmessages
              });
              return updater.emit('change', this.getState());
            }
          }
        }));
      }

      return Store;

    })();
    return new Store;
  });

}).call(this);

//# sourceMappingURL=store.js.map
