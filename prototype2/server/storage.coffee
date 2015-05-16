define ['flux'],(flux) ->

	class Storage
		constructor: (sequelize=false) ->
			if sequelize 
				@Sequelize = sequelize
			else
				throw new Error "you need to pass a sequelize instance"
			

			flux.dispatcher.register (messageName, message) ->
				@dispatch messageName, message

		dispatch: (messageName, message) ->
			if messageName is 'S_STORAGE_DB_select'
				@_select message

			if messageName is 'S_STORAGE_DB_insert'
				@_insert message

			if messageName is 'S_STORAGE_DB_update'
				@_update message

			if messageName is 'S_STORAGE_DB_delete'
				@_delete message


		_select: (message) ->
			@Sequelize[message.meta.model].findAll()
		_insert: () ->
		_update: () ->
		_delete: () ->

		_send_message: ( messageName, message ) ->
			flux.doAction messageName, message

	Storage
