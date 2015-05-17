define ['flux'],(flux) ->

	class API
		constructor: (socket=false) ->
			if socket 
				@Socket = socket
			else
				throw new Error "you need to pass a websocket instance"

			flux.dispatcher.register (messageName, message) ->
				@dispatch messageName, message

		dispatch: (messageName, message) ->
			if messageName is 'S_API_WEB_get'
				@_get message

			if messageName is 'S_API_WEB_put'
				@_put message

			if messageName is 'S_API_WEB_update'
				@_update message

			if messageName is 'S_API_WEB_delete'
				@_delete message

			if messageName is 'S_API_WEB_send'
				@_send message

		_send: (message) ->
			if 'socket' of message.meta
				if @Socket.id is message.meta.socket.id
					message.meta.socket.emit { messageName:'C_PRES_STORE_update', message:{ meta:{ model:message.meta.model }, data:message.data } }
			else
				@Socket.emit { messageName:'C_PRES_STORE_update', message:{ meta:{ model:message.meta.model }, data:message.data } }
		_get: (message) ->
			@_send_message 'S_LOGIC_SM_get', message

		_put: (message) ->
			@_send_message 'S_LOGIC_SM_create', message

		_update: (message) ->
			@_send_message 'S_LOGIC_SM_update', message

		_delete: (message) ->
			@_send_message 'S_LOGIC_SM_delete', message

		_send_message: (messageName, message) ->
			flux.doAction messageName, message

	API