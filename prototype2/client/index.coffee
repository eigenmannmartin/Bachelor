require.config
	paths:
		flux: '/bower_components/fluxify/build/fluxify.min'
		react: '/bower_components/react/react-with-addons'
		reactrouter: '/bower_components/react-router/build/umd/ReactRouter'
		io: '/socket.io/socket.io'



require ['api', 'store', 'router', 'flux'],(api, store, router, flux)->

	# debug output
	flux.dispatcher.register (messageName, message) ->
		console.log " ----- " + messageName + " ----- Server: " + message.meta.updated
		console.log message
	
	window.api = api
	window.flux = flux


	#window.api.io.emit('message', {messageName:"S_API_WEB_get", message:{meta:{model:"Room"}}})
	#window.api.io.emit('message', {messageName:"S_API_WEB_get", message:{meta:{model:"Room",id:1}}})
	#window.api.io.emit('message', {messageName:"S_API_WEB_update", message:{ meta:{model:"Room"}, data:{ obj:{ id:1, ac:true} } } })
	#window.api.io.emit('message', {messageName:"S_API_WEB_put", message:{ meta:{model:"Room"}, data:{ obj:{ name:"Bodensee", ac:true} } } })
	#window.api.io.emit('message', {messageName:"S_API_WEB_delete", message:{ meta:{model:"Room"}, data:{ obj:{ id:1}}}})



	#window.flux.doAction( 'C_PRES_STORE_update', { meta:{model:"room"}, data:{id:"22", ac:false} } )
	#window.flux.stores.prototype_rooms.getState()



