define ['flux', 'state'],( flux, state ) ->


	###
	# GENERAL / ALL API INSTANCES
	###	

	# only send to given client
	flux.dispatcher.register ( actionType, data, socket ) ->
		if actionType is 'prototype_api_private_stores_rooms_update_insert'
			console.log "private update"
			socket.emit 'message', { actionType: 'prototype_stores_rooms_update_insert', data: data }

	flux.dispatcher.register ( actionType, data ) ->
		if actionType is 'prototype_api_stores_rooms_update_insert'
			console.log "public update"
			state.socket.emit 'message', { actionType: 'prototype_stores_rooms_update_insert', data: data }


	class Api

		constructor: ( socket = false ) ->
			if not socket
				throw new Error "API.constructor - constructor needs a socket"

			api = @
			# handle incoming messages
			socket.on 'message', ( msg ) ->
				api.handle_message msg.actionType, { prev: msg.prev, recent: msg.recent }

			# send all data to the client
			flux.doAction 'prototype_sync_rooms_init', socket


		handle_message: ( actionType, data ) ->
			if actionType is "prototype_api_rooms_update"
				console.log  actionType + " - " + data.prev.name + " to " + data.recent.name
				flux.doAction 'prototype_sync_rooms_update', data

			if actionType is "prototype_api_rooms_create"
				console.log  actionType + " - " + data.recent.name
				flux.doAction 'prototype_sync_rooms_create', data

	Api
