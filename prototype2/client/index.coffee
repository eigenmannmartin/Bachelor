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


	#window.io.emit('message', {messageName:"S_API_WEB_get", message:{meta:{model:"Room"}}})
	#window.io.emit('message', {messageName:"S_API_WEB_get", message:{meta:{model:"Room",id:1}}})
	#window.io.emit('message', {messageName:"S_API_WEB_update", message:{ meta:{model:"Room"}, data:{ obj:{ id:1, ac:true} } } })
	#window.io.emit('message', {messageName:"S_API_WEB_put", message:{ meta:{model:"Room"}, data:{ obj:{ name:"Bodensee", ac:true} } } })
	#window.io.emit('message', {messageName:"S_API_WEB_delete", message:{ meta:{model:"Room"}, data:{ obj:{ id:1}}}})





