define ['flux'], (flux) ->

	class Logic

		constructor: () ->
			flux.dispatcher.register (messageName, message) ->
				@dispatch messageName, message

		dispatch: ( messageName, message ) ->
			if messageName is 'S_LOGIC_SM_get'
				@_get message

			if messageName is 'S_LOGIC_SM_create'
				@_put message

			if messageName is 'S_LOGIC_SM_update'
				@_update message

			if messageName is 'S_LOGIC_SM_delete'
				@_delete message

		_get: () ->
		_update: () ->
		_create: () ->
		_delete: () ->
		_send_message: (messageName, message) ->
			flux.doAction messageName, message

	Logic