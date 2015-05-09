define 'router', ['react', 'reactrouter', 'flux', 'visual/static', 'visual/text'
],(				   React,   Router,   	   flux,   staticPages,		    text
) ->

	flux.createStore
		id: 'nameStore',
		initialState: 
			name: 'Alice'
		
		actionCallbacks: 
			changeText: ( updater, name ) ->
				updater.set {name: name} 



	@RouteHandler = Router.RouteHandler
	@Route = Router.Route
	@NotFoundRoute = Router.NotFoundRoute
	@Link = Router.Link

	[App, NotFound, Nav, Home, About, User] = staticPages

	routes = (
		<Route handler={App} path="/">
			<Route name="Home" handler={Home} />
			<Route name="User" handler={User}>
				<Route name="asdf" path="/asdf" handler={text}/>
			</Route>
			<Route name="About" handler={About} />
			<NotFoundRoute handler={NotFound}/>
		</Route>
	);

	Router.run routes, Router.HashLocation, (Handler) ->
		React.render <Handler/>, document.body
