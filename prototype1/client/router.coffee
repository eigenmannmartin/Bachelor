define ['react', 'reactrouter', 'flux', 'components/staticPages'
],(		 React,   Router,   	 flux,   staticPages
) ->

	@RouteHandler = Router.RouteHandler
	@Route = Router.Route
	@DefaultRoute = Router.DefaultRoute
	@NotFoundRoute = Router.NotFoundRoute
	@Link = Router.Link

	[App, NotFound, Nav, Home, About, User] = staticPages

	routes = (
		<Route handler={App} path="/">
			<DefaultRoute name="Home" handler={Home}/>
			<Route name="About" handler={About} />
			<NotFoundRoute handler={NotFound}/>
		</Route>
	);

	Router.run routes, Router.HashLocation, (Handler) ->
		React.render <Handler/>, document.body
