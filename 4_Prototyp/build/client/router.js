(function() {
  define(['react', 'reactrouter', 'flux', 'staticPages', 'plannerPages'], function(React, router, flux, staticPages, planner) {
    var Router;
    Router = (function() {
      function Router() {
        var About, App, Contact, ContactEdit, DefaultRoute, Home, Link, Nav, NotFound, NotFoundRoute, Route, RouteHandler, routes;
        RouteHandler = router.RouteHandler;
        Route = router.Route;
        DefaultRoute = router.DefaultRoute;
        NotFoundRoute = router.NotFoundRoute;
        Link = router.Link;
        App = staticPages[0], NotFound = staticPages[1], Nav = staticPages[2], Home = staticPages[3], About = staticPages[4];
        Contact = planner[0], ContactEdit = planner[1];
        routes = React.createElement(Route, {
          "handler": App,
          "path": "/"
        }, React.createElement(DefaultRoute, {
          "name": "Home",
          "handler": Home
        }), React.createElement(Route, {
          "name": "About",
          "handler": About
        }), React.createElement(Route, {
          "name": "Contacts",
          "path": "Contacts",
          "handler": Contact
        }), React.createElement(Route, {
          "name": "Contact/Edit",
          "path": "Contacts/edit/:Id",
          "handler": ContactEdit
        }), React.createElement(NotFoundRoute, {
          "handler": NotFound
        }));
        router.run(routes, router.HashLocation, function(Handler) {
          return React.render(React.createElement(Handler, null), document.body);
        });
      }

      return Router;

    })();
    return new Router;
  });

}).call(this);

//# sourceMappingURL=router.js.map
