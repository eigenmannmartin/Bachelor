define ['react', 'reactrouter', 'flux', 'components/staticPages', 'components/planner'
],(		 React,   Router,   	 flux,   staticPages,			   planner
) ->

	@RouteHandler = Router.RouteHandler
	@Route = Router.Route
	@DefaultRoute = Router.DefaultRoute
	@NotFoundRoute = Router.NotFoundRoute
	@Link = Router.Link

	[ App, NotFound, Nav, Home, About ] = staticPages
	[ Rooms, PlannerRoomSettings ] = planner


	routes = (
		<Route handler={App} path="/">
			<DefaultRoute name="Home" handler={Home} />
			<Route name="About" handler={About} />
			<Route name="Rooms" path="Rooms" handler={Rooms} />
			<Route name="Rooms/Edit" path="/Rooms/edit/:roomId" handler={PlannerRoomSettings} />
			<Route name="Rooms/Create" path="/Rooms/edit/new" handler={PlannerRoomSettings} />
			<NotFoundRoute handler={NotFound} />
		</Route>
	);

	Router.run routes, Router.HashLocation, (Handler) ->
		React.render <Handler/>, document.body
