define ['flux'], (flux) ->

	class Logic


		sync:
			Function_init: (args) ->
				console.log "yea!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

			Contact: (Logic, new_obj, prev_obj) ->
				model = "Contact"
				@obj = new_obj
				@prev = prev_obj

				me = @  #bind @ to me
				promise = Logic._DB_select meta:{ model:model, id: new_obj.id }  #get current db item
				### istanbul ignore next ###
				promise.then ( db_objs ) ->  #return updated item
					data = id: me.obj.id  #new object

					#traditional transaction
					me._traditional data, db_objs, me.obj, me.prev, 'first_name'
					me._traditional data, db_objs, me.obj, me.prev, 'last_name'
					me._traditional data, db_objs, me.obj, me.prev, 'middle_name'

					#combining
					me._combining data, db_objs, me.obj, me.prev, 'title'


					#contextual 
					me._contextual data, db_objs, me.obj, me.prev, 'street', 'last_name'
					me._contextual data, db_objs, me.obj, me.prev, 'country', 'last_name'
					me._contextual data, db_objs, me.obj, me.prev, 'state', 'last_name'
					me._contextual data, db_objs, me.obj, me.prev, 'email', 'last_name'
					me._contextual data, db_objs, me.obj, me.prev, 'phone', 'last_name'



					data  #returning data


			_repeatable: (data, db_obj, new_obj, prev_obj, attr) ->
				### istanbul ignore else ###
				if new_obj[attr]?
					data[attr] = db_obj[attr] + (new_obj[attr] - prev_obj[attr])

			_combining: (data, db_obj, new_obj, prev_obj, attr) ->
				### istanbul ignore else ###
				if new_obj[attr]?
					data[attr] = if new_obj[attr] is prev_obj[attr] then db_obj[attr] else new_obj[attr]

			_traditional: (data, db_obj, new_obj, prev_obj, attr) ->
				### istanbul ignore else ###
				if new_obj[attr]?
					data[attr] = if prev_obj[attr] is db_obj[attr] then new_obj[attr] else db_obj[attr] 

			_contextual: (data, db_obj, new_obj, prev_obj, attr, context) ->
				### istanbul ignore else ###
				if new_obj[attr]?
					data[attr] = if prev_obj[context] is db_obj[context] then new_obj[attr] else db_obj[attr] 


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

			if messageName is 'S_LOGIC_SM_execute'
				@_execute message

			
		_execute: (message) ->
			if 'socket' not of message.meta
				throw new Error "not implemented yet!"

			@sync["Function_"+message.meta.function](message.data.args)

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
			model = @_DB_insert meta:{ model:message.meta.model }, data: message.data.obj
			me = @
			model.then (model) ->
				me._send_message 'S_API_WEB_send', { meta:{ model:message.meta.model }, data: model }

		###
		# @message: meta:{ model:[model_name] }, data:{ obj:{}, prev:{} } 
		###
		_update: (message) ->
			@message = message  #bind message to @
			me = @  #bind @ to me
			promise = @sync[message.meta.model]( @, message.data.obj, message.data.prev )  #call corresponding sync method
			promise.then (data) ->  #apply object do db
				model = me._DB_update( meta:{ model:me.message.meta.model }, data: data ).then (model) ->
					me._send_message 'S_API_WEB_send', { meta:{ model:me.message.meta.model }, data: model }  #send message, so clients know
				
				

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
				el.save()

		_DB_delete: (message) ->
			@Sequelize[message.meta.model].find(message.data.id).then (el) ->
				el.destroy()

	Logic