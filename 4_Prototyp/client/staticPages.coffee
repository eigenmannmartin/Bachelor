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
			connected: flux.stores.prototype_api.getState().connected
			disabled: flux.stores.prototype_api.getState().disabled

		componentDidMount: ->
			me = @
			flux.stores.prototype_api.on 'change:connected', ( data ) ->
				me.setState
					connected: data

			flux.stores.prototype_api.on 'change:disabled', ( data ) ->
				me.setState
					disabled: data

		disconnect: () ->
			flux.doAction( 'C_API_Connection', { meta:{function:"disconnect"} } )

		connect: () ->
			flux.doAction( 'C_API_Connection', { meta:{function:"connect"} } )

		render: ->
			<div className="navbar-fixed-2 ">
				<nav>
					<div className="nav-wrapper indigo">
						<ul id="nav-mobile" className="right">
							{if @state.connected
								<li><i className="mdi-notification-sync" onClick={@disconnect}></i></li>
							else if @state.disabled
								<li><i className="mdi-notification-sync-disabled" onClick={@connect}></i></li>
							else if not @state.connected
								<li><i className="mdi-notification-sync-problem"></i></li>
							}
							<li><Link to="Contacts">Contacts</Link></li>
							<li><Link to="About">About</Link></li>
						</ul>
					</div>
				</nav>
			</div>

	About = React.createClass
		componentWillUnmount: ->

		exec_init: () ->
			flux.doAction( 'C_PRES_STORE_update', { meta:{function:"init"}, args:"" } )

		

		render: ->
			<div className="container">
				<div className="row">
					<div className="col-md-12">
						<h1>About <small>this prototype</small></h1>
						<p> Find Github Repo <br />
							<a className="waves-effect waves-light btn" href="https://github.com/eigenmannmartin/Bachelor"> github.com </a> 
						</p>
						<p> Setup Contacts DB <br />
							<a className="waves-effect waves-light btn" onClick={@exec_init}>Init</a> 
						</p>
					</div>
				</div>
			</div>

	Messages = React.createClass
		getInitialState: ->
			messages:flux.stores.prototype_msgs.getState().messages

		componentDidMount: ->
			me = @
			flux.stores.prototype_msgs.on 'change', ( data ) ->
				me.setState
					messages: data.messages

		messageToggle: ->
			$('#messages').toggle()

		render: () ->
			<div>
				<a id="messages-btn" className="btn-floating btn-large waves-effect grey waves-red btn" onClick={@messageToggle}><i className="mdi-content-add"></i></a>
				<div id="messages">
					<div id="messages-row" className="row grey">
						<div className="col s12 l10 offset-l1">
							<table>
								{@state.messages.slice(0).reverse().map (msg) ->
									if msg.msg.meta.function?
										<tr key={msg.id}>
											<td>{msg.id}</td>
											<td><i className="mdi-communication-call-split blue"></i></td>
											<td>{msg.msg.meta.function}</td>
											<td>Function Call</td>
										</tr>
									else if msg.name is "C_PRES_STORE_conflict"
										<tr key={msg.id}>
											<td>{msg.id}</td>
											<td><i className="mdi-communication-call-missed red"></i></td>
											<td>{msg.msg.data.id}</td>
											<td>Conflict</td>
										</tr>

									else if msg.name is "C_PRES_STORE_conflict"
										<tr key={msg.id}>
											<td>{msg.id}</td>
											<td><i className="mdi-communication-call-received purble"></i></td>
											<td>{msg.msg.data.id}</td>
											<td>Delete</td>
										</tr>
									else
										<tr key={msg.id}>
											<td>{msg.id}</td>
											<td><i className={if msg.msg.meta.updated then "mdi-communication-call-received green" else "mdi-communication-call-made blue"}></i></td>
											<td>{msg.msg.data.id}</td>
											<td>Update</td>
											<td>{msg.msg.data.title} {msg.msg.data.first_name} {msg.msg.data.middle_name} {msg.msg.data.last_name}</td>
											<td>{msg.msg.data.email}</td>
										</tr>
								}
							</table>
						</div>
					</div>
				</div>
			</div>

	App = React.createClass
		contextTypes:
			router: React.PropTypes.func

		getInitialState: ->
			sync_error:false

		componentDidMount: ->
			# Error Message Handler
			flux.dispatcher.register (messageName, message) ->
				if messageName is 'C_PRES_STORE_conflict'
					alert "An error occured while syncing - sorry about that!"

		render: ->
			name = @context.router.getCurrentPath()
			<div>
				<Nav />
				<RouteHandler key={name} />
				<Messages />
			</div>


	[App, NotFound, Nav, Home, About]