define ['react', 'reactrouter', 'flux'
],(		 React,   Router,		 flux
) ->

	@RouteHandler = Router.RouteHandler
	@Route = Router.Route
	@NotFoundRoute = Router.NotFoundRoute
	@Link = Router.Link
	@ReactCSSTransitionGroup = React.addons.CSSTransitionGroup


	NotFound = React.createClass
		render: ->
			<div className="row">
				<div className="col-md-12">
					<div>Not Found</div>
				</div>
			</div>

	Home = React.createClass
		render: ->
			<div className="container">
				<div className="row">
					<div className="col s12">
						<h1>Home</h1>
					</div>
				</div>
			</div>

	Nav = React.createClass
		getInitialState: ->
			color: flux.stores.materialize_colors.getState().active_color

		componentDidMount: ->
			me = @
			flux.stores.materialize_colors.on 'change:active_color', ( active_color ) ->
				me.setState 
					color: active_color

		render: ->
			<div className="navbar-fixed-2 ">
				<nav>
					<div className={"nav-wrapper "+@state.color}>
						<ul id="nav-mobile" className="right hide-on-med-and-down">
							<li><Link to="Home">Home</Link></li>
							<li><Link to="Rooms">Planner</Link></li>
							<li><Link to="About">About</Link></li>
						</ul>
					</div>
				</nav>
			</div>

	About = React.createClass
		getInitialState: ->
			color: ''

		componentDidMount: ->
			me = @
			flux.stores.materialize_colors.on 'change:active_color', ( active_color ) ->
				me.setState
					color: active_color

		componentWillUnmount: ->

		changeColor: ->
			flux.doAction 'materialize_pick_color'

		partyColor: ->
			flux.doAction 'materialize_party_color'

		render: ->
			<div className="container">
				<div className="row">
					<div className="col-md-12">
						<h1>About <small>this prototype</small></h1>
						<p> Find Github Repo <br />
							<a className="waves-effect waves-light btn" href="https://github.com/eigenmannmartin/Bachelor"> github.com </a> 
						</p>
						<p> You do not like this color?  <br />
							<a className={"waves-effect waves-light btn "+@state.color} onClick={@changeColor}>Change</a>
						</p>
						<p>
							You still think this is not fancy enough? <br />
							<a className={"waves-effect waves-light btn "+@state.color} onClick={@partyColor}>Party Mode</a>
						</p>
					</div>
				</div>
			</div>

	App = React.createClass
		contextTypes:
			router: React.PropTypes.func

		render: ->
			name = @context.router.getCurrentPath()
			<div>
				<Nav />
				<RouteHandler key={name} />
			</div>


	[App, NotFound, Nav, Home, About]