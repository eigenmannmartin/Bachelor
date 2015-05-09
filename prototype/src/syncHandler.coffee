define 'syncHandler', ['flux', 'datastoreInMemory'
],( 	 				flux, 	datastoreInMemory
) ->
	class SyncHandler

		@INTEGER = "int"
		@STRING = "str"
		@BOOLEAN = "bool"
		@DATE = "date"
		@TEXT = "text"

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
			
			@Models[name] = definition

			table = []
			for key, val of definition
				table.push key

			if not @DatastoreConfig then @DatastoreConfig = []
			@DatastoreConfig[ name ] = table




		_get: ( msg ) ->
			[ressource, data] = @_getHoock( msg.ressource, msg.data )
			_statement = {
				table: ressource
				select: data
			}
			@Datastore.select( _statement )

		_getHoock: ( ressource, data ) ->
			[ressource, data]


		_put: ( msg ) ->
			[ressource, data] = @_putHoock( msg.ressource, msg.data)
			_statement = {
				table: ressource,
				data: data
			}
			@Datastore.insert( _statement )

		_putHoock: ( ressource, data ) ->
			[ressource, data]


		_update: ( msg ) ->
			[ressource, select, update] = @_updateHoock( msg.ressource, msg.data.select, msg.data.update)
			_statement = {
				table: ressource,
				select: select,
				update: update
			}
			@Datastore.update( _statement )

		_updateHoock: ( ressource, select, update ) ->
			[ressource, select, update]


		_delete: ( msg ) ->
			[ressource, data] = @_updateHoock( msg.ressource, msg.data)
			_statement = {
				table: ressource
				select: data
			}
			@Datastore.delete( _statement )

		_deleteHoock: ( ressource, data ) ->
			[ressource, data]

	
	SyncHandler
