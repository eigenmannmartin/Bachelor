define ['flux', 'io'], (flux, io) ->

	class API
		constructor: ->
			@.io = io('http://localhost:3000')
			@.io.on 'message', ( msg ) ->
				if msg.messageName is 'C_PRES_STORE_update'
					flux.doAction 'C_PRES_STORE_update', {meta:{ model:msg.message.meta.model, updated:true }, data:msg.message.data}
				if msg.messageName is 'C_PRES_STORE_delete'
					flux.doAction 'C_PRES_STORE_delete', {meta:{ model:msg.message.meta.model, updated:true }, data:msg.message.data}
				if msg.messageName is 'C_PRES_STORE_conflict'
					flux.doAction 'C_PRES_STORE_conflict', {meta:{ model:msg.message.meta.model, updated:true }, data:msg.message.data}


			me = @

			@io.on 'connect', () ->
				me._initial_sync()
				flux.doAction 'prototype_stores_api_connect'

			@io.on 'reconnect', () ->
				me._initial_sync()
				flux.doAction 'prototype_stores_api_connect'

			@io.on 'reconnecting', () ->
				flux.doAction 'prototype_stores_api_connecting'

			@io.on 'disconnect', () ->
				flux.doAction 'prototype_stores_api_disable'

			@io.on 'connect_failed', () ->
				flux.doAction 'prototype_stores_api_disconnect'

			@io.on 'reconnect_failed', () ->
				flux.doAction 'prototype_stores_api_disconnect'
			
			flux.dispatcher.register 'api', (messageName, message) ->
				me.dispatch messageName, message

			window.io = @io


		_initial_sync: ->
			@io.emit 'message', 
				messageName: 'S_API_WEB_get'
				message:
					meta:
						model:"Contact"


		dispatch: (messageName, message) ->
			if messageName is 'C_API_Connection'
				if message.meta.function is 'disconnect'
					@io.close()
				if message.meta.function is 'connect'
					@io.open()

			if messageName is 'C_PRES_STORE_update'
				if message.meta.function?
					@.io.emit 'message',
						messageName:"S_API_WEB_execute"
						message:
							meta:
								function:message.meta.function
							data:
								args:message.args

			if message.meta.updated then return false  #ignore messages with updated flag

			if messageName is 'C_PRES_STORE_update'
				if message.data.id
					@.io.emit 'message',
						messageName:"S_API_WEB_update"
						message:
							meta:
								model:message.meta.model
							data:
								obj:message.data
								prev: message.prev
				else
					@.io.emit 'message',
						messageName:"S_API_WEB_put"
						message:
							meta:
								model:message.meta.model
							data:
								obj:message.data


			if messageName is 'C_PRES_STORE_delete'
				@.io.emit 'message',
					messageName:"S_API_WEB_delete"
					message:
						meta:
							model:message.meta.model
						data:
							obj:message.data





	new API