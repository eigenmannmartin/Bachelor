define ['flux'],(flux) ->

	class API
		constructor: ->
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