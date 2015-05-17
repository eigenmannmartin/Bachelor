define ['flux', 'io'], (flux, io) ->

	class API
		constructor: ->
			@.io = io('http://localhost:3000')
			@.io.on 'message', ( msg ) ->
				if msg.messageName is 'C_PRES_STORE_update'
					flux.doAction 'C_PRES_STORE_update', {meta:{ model:msg.message.meta.model, updated:true }, data:msg.message.data}
			
			me = @
			@io.on 'connect', () ->
				me._initial_sync()

			@io.on 'reconnect', () ->
				me._initial_sync()
			
			flux.dispatcher.register (messageName, message) ->
				me.dispatch messageName, message


		_initial_sync: ->
			@.io.emit 'message', 
				messageName: 'S_API_WEB_get'
				message:
					meta:
						model:"Room"


		dispatch: (messageName, message) ->
			if messageName is 'C_PRES_STORE_update'
				if not message.meta.updated
					if message.data.id
						@.io.emit 'message',
							messageName:"S_API_WEB_update"
							message:
								meta:
									model:message.meta.model
								data:
									obj:message.data
					else
						@.io.emit 'message',
							messageName:"S_API_WEB_put"
							message:
								meta:
									model:message.meta.model
								data:
									obj:message.data







	new API