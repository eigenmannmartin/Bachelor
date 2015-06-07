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
			[ Contact, ContactEdit ] = planner


			routes = (
				<Route handler={App} path="/">
					<DefaultRoute name="Home" handler={Home} />
					<Route name="About" handler={About} />
					<Route name="Contacts" path="Contacts" handler={Contact} />
					<Route name="Contact/Edit" path="Contacts/edit/:Id" handler={ContactEdit} />
					<NotFoundRoute handler={NotFound} />
				</Route>
			);

			router.run routes, router.HashLocation, (Handler) ->
				React.render <Handler/>, document.body

	new Router
