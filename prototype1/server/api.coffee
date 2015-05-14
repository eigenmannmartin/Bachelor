define [],() ->

	class Api

		constructor: ( socket = false ) ->
			if not socket
				throw new Error "API.constructor - constructor needs a socket"

			api = @
			socket.on 'message', ( msg ) ->
				api.handle_message msg

		handle_message: ( msg ) ->
			console.log  msg.actionType + " - " + msg.data.name


	Api
