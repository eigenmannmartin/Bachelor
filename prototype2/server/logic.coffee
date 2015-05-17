define ['flux'], (flux) ->

	class Logic

		constructor: (sequelize=false) ->
			if sequelize 
				@Sequelize = sequelize
			else
				throw new Error "you need to pass a sequelize instance"

			me = @
			flux.dispatcher.register (messageName, message) ->
				me.dispatch messageName, message

		dispatch: (messageName, message) ->
			if messageName is 'S_LOGIC_SM_get'
				@_get message

			if messageName is 'S_LOGIC_SM_create'
				@_create message

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

			me = @
			models.then (models) ->
				if models.constructor is Array
					for model in models
						me._send_message 'S_API_WEB_send', { meta:{ model:message.meta.model, socket:message.meta.socket }, data: model }
				else
					me._send_message 'S_API_WEB_send', { meta:{ model:message.meta.model, socket:message.meta.socket }, data: models }

		###
		# @message: meta:{ model:[model_name] }, data:{ obj:{} } 
		###
		_create: (message) ->
			if not  message.data.obj.image?
				message.data.obj.image = '/img/rooms/'+message.data.obj.name+'.jpg'

			model = @_DB_insert meta:{ model:message.meta.model }, data: message.data.obj
			me = @
			model.then (model) ->
				me._send_message 'S_API_WEB_send', { meta:{ model:message.meta.model }, data: model }

		###
		# @message: meta:{ model:[model_name] }, data:{ obj:{}, prev:{} } 
		###
		_update: (message) ->
			model = @_DB_update meta:{ model:message.meta.model }, data: message.data.obj
			me = @
			model.then (model) ->
				me._send_message 'S_API_WEB_send', { meta:{ model:message.meta.model }, data: model }

		###
		# @message: meta:{ model:[model_name] }, data:{ obj:{} } 
		###
		_delete: (message) ->
			@_send_message 'S_API_WEB_send', { meta:{ model:message.meta.model }, data: { id: message.data.obj.id, deleted: 1 } }
			@_DB_delete meta:{ model:message.meta.model }, data: message.data.obj


		_send_message: (messageName, message) ->
			flux.doAction messageName, message



		_DB_select: (message) ->
			if 'id' of message.meta
				r = @Sequelize[message.meta.model].find(message.meta.id)
			else
				r = @Sequelize[message.meta.model].findAll()

			return r

		_DB_insert: (message) ->
			r = @Sequelize[message.meta.model].create( message.data )

		_DB_update: (message) ->
			r = @Sequelize[message.meta.model].find( message.data.id )
			r.then (el) ->
				el.updateAttributes( message.data )

		_DB_delete: (message) ->
			@Sequelize[message.meta.model].find(message.data.id).then (el) ->
				el.destroy()

	Logic