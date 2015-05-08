###

TODO:
API-Design dependend on Domain

###

require.config
	paths:
		flux: '/bower_components/fluxify/build/fluxify.min',
		react: '/bower_components/react/react',
		reactrouter: '/bower_components/react-router/build/umd/ReactRouter',
		jquery:'/bower_components/jquery/dist/jquery.min',
		underscore:'/bower_components/underscore/underscore-min',
		text: '/components/requirejs/text'

	shim:
		'jquery':
			exports : '$'
		'underscore':
			exports : '_'




require ["app", 'flux', 'react', 'reactrouter'], (App, Flux, React, Router)->
	window.app = new App()
	#console.log Flux
	#console.log React
	#console.log Router

	Flux.dispatcher.register (payload) ->
		if payload.actionType is 'log' or 'log2'
			console.log "logging :-D"

		console.log arguments

	Flux.dispatcher.dispatch {actionType: 'log'}


	@User = React.createClass
		handleClick: (event) ->
			console.log event
		render: ->
			<div onClick=(@handleClick)>Users</div>;

	@User2 = React.createClass
		render: ->
			<div>Users2</div>;

	@asdf = React.createClass
		render: ->
			<div>asdf</div>;

	@NotFound = React.createClass
		render: ->
			<div>Not Found</div>;

	@App = React.createClass
		render: ->
			<div>
				<ul>
					<li><Router.Link to="user">User</Router.Link></li>
					<li><Router.Link to="user2">User2</Router.Link></li>
					<li><Router.Link to="asdf">asdf</Router.Link></li>
				</ul>
				<p>-----</p>
				<Router.RouteHandler/>
			</div>;

	@Home = React.createClass
		render: ->
			<h1>Home</h1>



	routes = (
		<Router.Route handler={@App} path="/">
			<Router.DefaultRoute handler={@Home} />
			<Router.Route name="user" handler={@User}>
				<Router.Route name="asdf" path="/asdf" handler={@asdf}/>
			</Router.Route>
			<Router.Route name="user2" handler={@User2} />
			<Router.NotFoundRoute handler={@NotFound}/>
		</Router.Route>
	);

	Router.run routes, Router.HashLocation, (Handler) ->
		React.render <Handler/>, document.body