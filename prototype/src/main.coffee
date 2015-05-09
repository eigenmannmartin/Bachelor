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




require ["app", 'flux'
],(		  App,   Flux
)->
	window.app = new App()
	window.app.run()


	window.flux = Flux





