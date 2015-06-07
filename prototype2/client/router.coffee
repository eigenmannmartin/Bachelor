define ['react', 'reactrouter', 'flux', 'staticPages', 'plannerPages'
],(		 React,   router,   	 flux,   staticPages,	planner
) ->
	class Router

		constructor: ->
			RouteHandler = router.RouteHandler
			Route = router.Route
			DefaultRoute = router.DefaultRoute
			NotFoundRoute = router.NotFoundRoute
			Link = router.Link

			[ App, NotFound, Nav, Home, About ] = staticPages
			[ Rooms, PlannerRoomSettings, PlannerRoomDates, Contact, ContactEdit ] = planner


			routes = (
				<Route handler={App} path="/">
					<DefaultRoute name="Home" handler={Home} />
					<Route name="About" handler={About} />
					<Route name="Contacts" path="Contacts" handler={Contact} />
					<Route name="Contact/Edit" path="Contacts/edit/:Id" handler={ContactEdit} />
					<Route name="Rooms" path="Rooms" handler={Rooms} />
					<Route name="Rooms/Edit" path="/Rooms/edit/:roomId" handler={PlannerRoomSettings} />
					<Route name="Rooms/Create" path="/Rooms/edit/new" handler={PlannerRoomSettings} />
					<Route name="Rooms/Dates" path="/Rooms/:roomId/Dates" handler={PlannerRoomDates} />
					<NotFoundRoute handler={NotFound} />
				</Route>
			);

			router.run routes, router.HashLocation, (Handler) ->
				React.render <Handler/>, document.body

	new Router
