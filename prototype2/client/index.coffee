require.config
	paths:
		flux: '/bower_components/fluxify/build/fluxify.min'
		react: '/bower_components/react/react-with-addons'
		reactrouter: '/bower_components/react-router/build/umd/ReactRouter'
		io: '/socket.io/socket.io'



require ['io'],(io)->

	window.io = io('http://localhost:3000')
	window.io.on 'message', ( msg ) ->
		console.log msg
		
	console.log window.io



