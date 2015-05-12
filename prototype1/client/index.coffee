require.config
	paths:
		flux: '/bower_components/fluxify/build/fluxify.min'
		react: '/bower_components/react/react'
		reactrouter: '/bower_components/react-router/build/umd/ReactRouter'
		io: '/socket.io/socket.io'
		mui: '/bower_components/material-ui/src/index'



require ['flux', 'io', 'app'
],(		  flux,	  io,	app
)->

	window.app = new app
	window.app.run()

	window.socket = io.connect 'http://localhost:3000/'

	window.flux = flux





