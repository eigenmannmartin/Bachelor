define 'syncHandler', ['flux', 'datastoreInMemory'
],( 	 				flux, 	datastoreInMemory
) ->
	class SyncHandler

		@INTEGER = "int"
		@STRING = "str"
		@BOOLEAN = "bool"
		@DATE = "date"
		@TEXT = "text"

		@STATIC = "stat"
		@PRIVATE = "priv"
		@DYNAMIC = "dyn"
		@TEMPORARY = "temp"

		constructor: ( opts ) ->
			@DatastoreConfig = false
			@DATASTORE = false
			@Models = []


		run: () ->
			flux.dispatcher.dispatch {actionType: 'log.info', msg: 'called SyncHandler.run()'}
			@Datastore = new datastoreInMemory( { tables: [@DatastoreConfig] } )


		dispatch: ( message ) ->
			flux.dispatcher.dispatch {actionType: 'log.info', msg: 'syncHandler recived message to dispatch'}
			
			result = false
			switch message.actionType
				when "get" then result = @_get message.msg
				when "put" then result = @_put message.msg
				when "update" then result = @_update message.msg
				when "delete" then result = @_delete message.msg

			result

		define: ( name, definition={} ) ->
			flux.dispatcher.dispatch {actionType: 'log.info', msg: 'syncHandler recived define for ' + name}

			definition.created = { type: SyncHandler.DATE }
			definition.modified = { type: SyncHandler.DATE }
			definition.id = { type: SyncHandler.INTEGER }
			
			@Models[name] = definition

			table = []
			for key, val of definition
				table.push key

			if not @DatastoreConfig then @DatastoreConfig = []
			@DatastoreConfig[ name ] = table



		_uuid: () ->
			'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) ->
				r = Math.random() * 16 | 0
				v = if c is 'x' then r else (r & 0x3|0x8)
				v.toString(16)
			)


		_get: ( msg ) ->
			[ressource, data] = @_getHoock( msg.ressource, msg.data )
			_statement = {
				table: ressource
				select: data
			}
			@Datastore.select( _statement )


		_put: ( msg ) ->
			[ressource, data] = @_putHoock( msg.ressource, msg.data )
			_statement = {
				table: ressource,
				data: data
			}
			@Datastore.insert( _statement )


		_update: ( msg ) ->
			[ressource, select, update] = @_updateHoock( msg.ressource, msg.data.select, msg.data.update, msg.recent )
			_statement = {
				table: ressource,
				select: select,
				update: update
			}
			@Datastore.update( _statement )


		_delete: ( msg ) ->
			[ressource, data] = @_deleteHoock( msg.ressource, msg.data )
			_statement = {
				table: ressource
				select: data
			}
			@Datastore.delete( _statement )



		_getHoock: ( ressource, data ) ->
			[ressource, data]

		_updateHoock: ( ressource, select, update, recent ) ->
			all_existing = @Datastore.select({ table: ressource, select: select })
			existing = all_existing[0]
			if all_existing.length > 1 then throw new Error "Update failed: selected multiple elements to update"
			
			if existing.id isnt update.id
				# here we need to handle all the sync-magic
				throw new Error "You are trying to update an already changed element"

			[ressource, select, update]

		_putHoock: ( ressource, data ) ->
			for element in data  #set default fields
				element.id = @_uuid()
				element.created = new Date().getTime()
				element.modified = 0

			[ressource, data]

		_deleteHoock: ( ressource, data ) ->
			[ressource, data]

	
	SyncHandler
