(function() {
  define(['react', 'reactrouter', 'flux'], function(React, Router, flux) {
    var About, App, Home, Nav, Nav_connectionIndicator, NotFound;
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
    Nav_connectionIndicator = React.createClass({
      getInitialState: function() {
        return {
          connected: flux.stores.prototype_api.getState().connected,
          connecting: flux.stores.prototype_api.getState().connecting,
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
        flux.stores.prototype_api.on('change:connecting', function(data) {
          return me.setState({
            connecting: data
          });
        });
        return flux.stores.prototype_api.on('change:disabled', function(data) {
          return me.setState({
            disabled: data
          });
        });
      },
      disable: function() {
        return flux.doAction('prototype_api_disable');
      },
      enable: function() {
        return flux.doAction('prototype_api_enable');
      },
      render: function() {
        return React.createElement("div", null, (this.state.connected ? React.createElement("i", {
          "className": "mdi-notification-sync",
          "onClick": this.disable
        }) : this.state.disabled ? React.createElement("i", {
          "className": "mdi-notification-sync-disabled",
          "onClick": this.enable
        }) : !this.state.connected ? React.createElement("i", {
          "className": "mdi-notification-sync-problem",
          "onClick": this.disable
        }) : void 0));
      }
    });
    Nav = React.createClass({
      getInitialState: function() {
        return {
          color: flux.stores.materialize_colors.getState().active_color
        };
      },
      componentDidMount: function() {
        var me;
        me = this;
        return flux.stores.materialize_colors.on('change:active_color', function(active_color) {
          return me.setState({
            color: active_color
          });
        });
      },
      render: function() {
        return React.createElement("div", {
          "className": "navbar-fixed-2 "
        }, React.createElement("nav", null, React.createElement("div", {
          "className": "nav-wrapper " + this.state.color
        }, React.createElement("ul", {
          "id": "nav-mobile",
          "className": "right hide-on-med-and-down"
        }, React.createElement("li", null, React.createElement(Link, {
          "to": "Home"
        }, "Home")), React.createElement("li", null, React.createElement(Link, {
          "to": "Rooms"
        }, "Planner")), React.createElement("li", null, React.createElement(Link, {
          "to": "About"
        }, "About")), React.createElement("li", null, React.createElement(Nav_connectionIndicator, null))))));
      }
    });
    About = React.createClass({
      getInitialState: function() {
        return {
          color: ''
        };
      },
      componentDidMount: function() {
        var me;
        me = this;
        return flux.stores.materialize_colors.on('change:active_color', function(active_color) {
          return me.setState({
            color: active_color
          });
        });
      },
      componentWillUnmount: function() {},
      changeColor: function() {
        return flux.doAction('materialize_pick_color');
      },
      partyColor: function() {
        return flux.doAction('materialize_party_color');
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
        }, " github.com ")), React.createElement("p", null, " You do not like this color?  ", React.createElement("br", null), React.createElement("a", {
          "className": "waves-effect waves-light btn " + this.state.color,
          "onClick": this.changeColor
        }, "Change")), React.createElement("p", null, "\t\t\t\t\t\t\tYou still think this is not fancy enough? ", React.createElement("br", null), React.createElement("a", {
          "className": "waves-effect waves-light btn " + this.state.color,
          "onClick": this.partyColor
        }, "Party Mode")))));
      }
    });
    App = React.createClass({
      contextTypes: {
        router: React.PropTypes.func
      },
      render: function() {
        var name;
        name = this.context.router.getCurrentPath();
        return React.createElement("div", null, React.createElement(Nav, null), React.createElement(RouteHandler, {
          "key": name
        }));
      }
    });
    return [App, NotFound, Nav, Home, About];
  });

}).call(this);

//# sourceMappingURL=static.js.map
