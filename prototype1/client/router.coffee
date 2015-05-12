define ['react', 'reactrouter', 'flux', 'components/staticPages', 'components/planner'
],(		 React,   Router,   	 flux,   staticPages,			   planner
) ->

	@RouteHandler = Router.RouteHandler
	@Route = Router.Route
	@DefaultRoute = Router.DefaultRoute
	@NotFoundRoute = Router.NotFoundRoute
	@Link = Router.Link

	[ App, NotFound, Nav, Home, About ] = staticPages
	[ p_planner, p_appointments, p_details ] = planner


	routes = (
		<Route handler={App} path="/">
			<DefaultRoute name="Home" handler={Home}/>
			<Route name="About" handler={About} />
			<Route name="Planner" path="/room" handler={p_planner}>
				<Route path=":roomId/appointment" handler={p_appointments}>
					<Route path=":apId" handler={p_details} />
				</Route>
			</Route>
			<NotFoundRoute handler={NotFound}/>
		</Route>
	);

	Router.run routes, Router.HashLocation, (Handler) ->
		React.render <Handler/>, document.body
