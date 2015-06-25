(function() {
  define(['react', 'reactrouter', 'flux'], function(React, Router, flux) {
    var About, App, Home, Messages, Nav, NotFound;
    this.RouteHandler = Router.RouteHandler;
    this.Route = Router.Route;
    this.NotFoundRoute = Router.NotFoundRoute;
    this.Link = Router.Link;
    this.ReactCSSTransitionGroup = React.addons.CSSTransitionGroup;
    NotFound = React.createClass({
      render: function() {
        return React.createElement("div", {
          "className": "row"
        }, React.createElement("div", {
          "className": "col-md-12"
        }, React.createElement("div", null, "Not Found")));
      }
    });
    Home = React.createClass({
      render: function() {
        return React.createElement("div", {
          "className": "container"
        }, React.createElement("div", {
          "className": "row"
        }, React.createElement("div", {
          "className": "col s12"
        }, React.createElement("h1", null, "Home"))));
      }
    });
    Nav = React.createClass({
      getInitialState: function() {
        return {
          connected: flux.stores.prototype_api.getState().connected,
          disabled: flux.stores.prototype_api.getState().disabled
        };
      },
      componentDidMount: function() {
        var me;
        me = this;
        flux.stores.prototype_api.on('change:connected', function(data) {
          return me.setState({
            connected: data
          });
        });
        return flux.stores.prototype_api.on('change:disabled', function(data) {
          return me.setState({
            disabled: data
          });
        });
      },
      disconnect: function() {
        return flux.doAction('C_API_Connection', {
          meta: {
            "function": "disconnect"
          }
        });
      },
      connect: function() {
        return flux.doAction('C_API_Connection', {
          meta: {
            "function": "connect"
          }
        });
      },
      render: function() {
        return React.createElement("div", {
          "className": "navbar-fixed-2 "
        }, React.createElement("nav", null, React.createElement("div", {
          "className": "nav-wrapper indigo"
        }, React.createElement("ul", {
          "id": "nav-mobile",
          "className": "right"
        }, (this.state.connected ? React.createElement("li", null, React.createElement("i", {
          "className": "mdi-notification-sync",
          "onClick": this.disconnect
        })) : this.state.disabled ? React.createElement("li", null, React.createElement("i", {
          "className": "mdi-notification-sync-disabled",
          "onClick": this.connect
        })) : !this.state.connected ? React.createElement("li", null, React.createElement("i", {
          "className": "mdi-notification-sync-problem"
        })) : void 0), React.createElement("li", null, React.createElement(Link, {
          "to": "Contacts"
        }, "Contacts")), React.createElement("li", null, React.createElement(Link, {
          "to": "About"
        }, "About"))))));
      }
    });
    About = React.createClass({
      componentWillUnmount: function() {},
      exec_init: function() {
        return flux.doAction('C_PRES_STORE_update', {
          meta: {
            "function": "init"
          },
          args: ""
        });
      },
      render: function() {
        return React.createElement("div", {
          "className": "container"
        }, React.createElement("div", {
          "className": "row"
        }, React.createElement("div", {
          "className": "col-md-12"
        }, React.createElement("h1", null, "About ", React.createElement("small", null, "this prototype")), React.createElement("p", null, " Find Github Repo ", React.createElement("br", null), React.createElement("a", {
          "className": "waves-effect waves-light btn",
          "href": "https://github.com/eigenmannmartin/Bachelor"
        }, " github.com ")), React.createElement("p", null, " Setup Contacts DB ", React.createElement("br", null), React.createElement("a", {
          "className": "waves-effect waves-light btn",
          "onClick": this.exec_init
        }, "Init")))));
      }
    });
    Messages = React.createClass({
      getInitialState: function() {
        return {
          messages: flux.stores.prototype_msgs.getState().messages
        };
      },
      componentDidMount: function() {
        var me;
        me = this;
        return flux.stores.prototype_msgs.on('change', function(data) {
          return me.setState({
            messages: data.messages
          });
        });
      },
      messageToggle: function() {
        return $('#messages').toggle();
      },
      render: function() {
        return React.createElement("div", null, React.createElement("a", {
          "id": "messages-btn",
          "className": "btn-floating btn-large waves-effect grey waves-red btn",
          "onClick": this.messageToggle
        }, React.createElement("i", {
          "className": "mdi-content-add"
        })), React.createElement("div", {
          "id": "messages"
        }, React.createElement("div", {
          "id": "messages-row",
          "className": "row grey"
        }, React.createElement("div", {
          "className": "col s12 l10 offset-l1"
        }, React.createElement("table", null, this.state.messages.slice(0).reverse().map(function(msg) {
          if (msg.msg.meta["function"] != null) {
            return React.createElement("tr", {
              "key": msg.id
            }, React.createElement("td", null, msg.id), React.createElement("td", null, React.createElement("i", {
              "className": "mdi-communication-call-split blue"
            })), React.createElement("td", null, msg.msg.meta["function"]), React.createElement("td", null, "Function Call"));
          } else if (msg.name === "C_PRES_STORE_conflict") {
            return React.createElement("tr", {
              "key": msg.id
            }, React.createElement("td", null, msg.id), React.createElement("td", null, React.createElement("i", {
              "className": "mdi-communication-call-missed red"
            })), React.createElement("td", null, msg.msg.data.id), React.createElement("td", null, "Conflict"));
          } else if (msg.name === "C_PRES_STORE_conflict") {
            return React.createElement("tr", {
              "key": msg.id
            }, React.createElement("td", null, msg.id), React.createElement("td", null, React.createElement("i", {
              "className": "mdi-communication-call-received purble"
            })), React.createElement("td", null, msg.msg.data.id), React.createElement("td", null, "Delete"));
          } else {
            return React.createElement("tr", {
              "key": msg.id
            }, React.createElement("td", null, msg.id), React.createElement("td", null, React.createElement("i", {
              "className": (msg.msg.meta.updated ? "mdi-communication-call-received green" : "mdi-communication-call-made blue")
            })), React.createElement("td", null, msg.msg.data.id), React.createElement("td", null, "Update"), React.createElement("td", null, msg.msg.data.title, " ", msg.msg.data.first_name, " ", msg.msg.data.middle_name, " ", msg.msg.data.last_name), React.createElement("td", null, msg.msg.data.email));
          }
        }))))));
      }
    });
    App = React.createClass({
      contextTypes: {
        router: React.PropTypes.func
      },
      getInitialState: function() {
        return {
          sync_error: false
        };
      },
      componentDidMount: function() {
        return flux.dispatcher.register(function(messageName, message) {
          if (messageName === 'C_PRES_STORE_conflict') {
            return alert("An error occured while syncing - sorry about that!");
          }
        });
      },
      render: function() {
        var name;
        name = this.context.router.getCurrentPath();
        return React.createElement("div", null, React.createElement(Nav, null), React.createElement(RouteHandler, {
          "key": name
        }), React.createElement(Messages, null));
      }
    });
    return [App, NotFound, Nav, Home, About];
  });

}).call(this);

//# sourceMappingURL=staticPages.js.map
