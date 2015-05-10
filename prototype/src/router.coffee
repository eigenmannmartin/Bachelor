define 'router', ['react', 'reactrouter', 'flux', 'visual/static', 'visual/rooms'
],(				   React,   Router,   	   flux,   staticPages,		Rooms
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
			<Route name="App" path="/App/" handler={Rooms}>
			</Route>
			<Route name="About" handler={About} />
			<NotFoundRoute handler={NotFound}/>
		</Route>
	);

	Router.run routes, Router.HashLocation, (Handler) ->
		React.render <Handler/>, document.body
