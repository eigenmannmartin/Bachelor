define ['flux'], (flux) ->

	class Logic

		constructor: (sequelize=false) ->
			if sequelize 
				@Sequelize = sequelize
			else
				throw new Error "you need to pass a sequelize instance"

			flux.dispatcher.register (messageName, message) ->
				@dispatch messageName, message

		dispatch: (messageName, message) ->
			if messageName is 'S_LOGIC_SM_get'
				@_get message

			if messageName is 'S_LOGIC_SM_create'
				@_put message

			if messageName is 'S_LOGIC_SM_update'
				@_update message

			if messageName is 'S_LOGIC_SM_delete'
				@_delete message

		###
		# @message: meta:{ model:[model_name], socket:[socket], [id:[element_id]] } 
		###
		_get: (message) ->
			if 'socket' not of message.meta
				throw new Error "not implemented yet!"

				#@_send_message 'S_API_WEB_send', { meta:{ model:message.meta.model }, data: model }
			
			models = @_DB_select message

			for model in models
				@_send_message 'S_API_WEB_send', { meta:{ model:message.meta.model, socket:message.meta.socket }, data: model }
					
		###
		# @message: meta:{ model:[model_name] }, data:{ obj:{} } 
		###
		_create: (message) ->
			model = @_DB_insert meta:{ model:message.meta.model }, data: message.data.obj
			@_send_message 'S_API_WEB_send', { meta:{ model:message.meta.model }, data: model }

		###
		# @message: meta:{ model:[model_name] }, data:{ obj:{}, prev:{} } 
		###
		_update: (message) ->
			model = @_DB_update meta:{ model:message.meta.model }, data: message.data.obj
			@_send_message 'S_API_WEB_send', { meta:{ model:message.meta.model }, data: model }

		###
		# @message: meta:{ model:[model_name] }, data:{ obj:{} } 
		###
		_delete: (message) ->
			model = @_DB_delete meta:{ model:message.meta.model }, data: message.data.obj
			@_send_message 'S_API_WEB_send', { meta:{ model:message.meta.model, deleted:true }, data: model }


		_send_message: (messageName, message) ->
			flux.doAction messageName, message



		_DB_select: (message) ->
			if 'id' of message.meta
				r = [ @Sequelize[message.meta.model].find(message.meta.id) ]
			else
				r = @Sequelize[message.meta.model].findAll()

			return r

		_DB_insert: (message) ->
			@Sequelize[message.meta.model].create( message.data )

		_DB_update: (message) ->
			r = @Sequelize[message.meta.model].find( message.data.id )
			r.updateAttributes( message.data )

		_DB_delete: (message) ->
			r = @Sequelize[message.meta.model].find( message.data.id )
			r.destory()

	Logic