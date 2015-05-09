define 'router', ['react', 'reactrouter', 'flux', 'visual/text'
],(				   React,   Router,   	   flux,   text
) ->

	flux.createStore
		id: 'nameStore',
		initialState: 
			name: 'Alice'
		
		actionCallbacks: 
			changeName: ( updater, name ) ->
				updater.set {name: name} 



	@RouteHandler = Router.RouteHandler
	@Route = Router.Route
	@NotFoundRoute = Router.NotFoundRoute
	@Link = Router.Link


	@asdf = React.createClass
		getInitialState: ->
			{name: flux.stores.nameStore.name }

		componentDidMount: ->
			me = this
			flux.stores.nameStore.on 'change:name', ( value ) ->
				me.setState {name: value}


		render: ->
			<div className="row">
				<div className="col-md-12">
					<div>Name: {this.state.name}</div>
				</div>
			</div>





	@User2 = React.createClass
		handleClick: (event) ->
			console.log event
		render: ->
			<div className="row">
				<div className="col-md-12">
					<div onClick=(@handleClick)>
						<p>User2</p>
						<RouteHandler/>
					</div>
				</div>
			</div>

	@User = text;



	@NotFound = React.createClass
		render: ->
			<div className="row">
				<div className="col-md-12">
					<div>Not Found</div>
				</div>
			</div>

	@Home = React.createClass
		render: ->
			<div className="row">
				<div className="col-md-12">
					<h1>Home</h1>
				</div>
			</div>

	@Nav = React.createClass
		render: ->
			<nav className="navbar navbar-inverse navbar-fixed-top">
				<div className="container">

					<div id="navbar" className="collapse navbar-collapse">
						<ul className="nav navbar-nav">
							<li><Link to="home">Home</Link></li>
							<li><Link to="user">User</Link></li>
							<li><Link to="About">About</Link></li>
						</ul>
					</div>
				</div>
			</nav>

	@About = React.createClass
		render: ->
			<div className="row">
				<div className="col-md-12">
					<h1>About <small>this prototype</small></h1>
					<p> Find Github Repo <a href="https://github.com/eigenmannmartin/Bachelor"> github.com/eigenmannmartin/Bachelor</a> </p>
				</div>
			</div>

	@App = React.createClass
		render: ->
			<div>
				<Nav/>
				<div className="container">
					<RouteHandler/>
				</div>
			</div>



	routes = (
		<Route handler={App} path="/">
			<Route name="home" handler={Home} />
			<Route name="user" handler={User}>
				<Route name="asdf" path="/asdf" handler={asdf}/>
			</Route>
			<Route name="About" handler={About} />
			<NotFoundRoute handler={NotFound}/>
		</Route>
	);

	Router.run routes, Router.HashLocation, (Handler) ->
		React.render <Handler/>, document.body
