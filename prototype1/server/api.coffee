define ['fluxify', 'flux'],( flux, a ) ->

	class Api

		constructor: ( socket = false ) ->
			if not socket
				throw new Error "API.constructor - constructor needs a socket"

			api = @
			socket.on 'message', ( msg ) ->
				api.handle_message msg.actionType, { prev: msg.prev, recent: msg.recent }

		handle_message: ( actionType, data ) ->
			if actionType is "prototype_api_rooms_update"
				console.log  actionType + " - " + data.prev.name + " to " + data.recent.name
				console.log "doAction: test"
				flux.doAction 'test' 

			if actionType is "prototype_api_rooms_create"
				console.log  actionType + " - " + data.recent.name

	Api
