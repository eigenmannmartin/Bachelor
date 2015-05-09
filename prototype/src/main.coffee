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




require ["app", 'flux', 'router'
],(		  App,   Flux,   Router
)->
	window.app = new App()
	window.flux = Flux
	#console.log Flux
	#console.log React
	#console.log Router

	Flux.dispatcher.register (payload) ->
		if payload.actionType is 'log' or 'log2'
			console.log "logging :-D"

		console.log arguments

	Flux.dispatcher.dispatch {actionType: 'log'}
		.then ()->
			console.log "everithing dispatched properly"






