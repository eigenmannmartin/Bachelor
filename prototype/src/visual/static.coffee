define 'visual/static', ['react', 'reactrouter', 'flux'
],(				   		  React,   Router,   	  flux
) ->

	@RouteHandler = Router.RouteHandler
	@Route = Router.Route
	@NotFoundRoute = Router.NotFoundRoute
	@Link = Router.Link


	NotFound = React.createClass
		render: ->
			<div className="row">
				<div className="col-md-12">
					<div>Not Found</div>
				</div>
			</div>

	Home = React.createClass
		render: ->
			<div className="row">
				<div className="col-md-12">
					<h1>Home</h1>
				</div>
			</div>

	Nav = React.createClass
		render: ->
			<nav className="navbar navbar-inverse navbar-fixed-top">
				<div className="container">

					<div id="navbar" className="collapse navbar-collapse">
						<ul className="nav navbar-nav">
							<li><Link to="Home">Home</Link></li>
							<li><Link to="App">App</Link></li>
							<li><Link to="About">About</Link></li>
						</ul>
					</div>
				</div>
			</nav>

	About = React.createClass
		render: ->
			<div className="row">
				<div className="col-md-12">
					<h1>About <small>this prototype</small></h1>
					<p> Find Github Repo <a href="https://github.com/eigenmannmartin/Bachelor"> github.com/eigenmannmartin/Bachelor</a> </p>
				</div>
			</div>

	App = React.createClass
		render: ->
			<div>
				<Nav/>
				<div className="container">
					<RouteHandler/>
				</div>
			</div>

	User = React.createClass
		render: ->
			<div>
				<h1>Rooms <small>Application</small></h1>
				<RouteHandler/>
			</div>


	[App, NotFound, Nav, Home, About, User]