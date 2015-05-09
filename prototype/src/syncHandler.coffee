define 'syncHandler', ['flux', 'datastoreInMemory'
],( 	 				flux, 	datastoreInMemory
) ->
	class SyncHandler

		constructor: ( opts ) ->
			@DatastoreConfig = if opts?['DatastoreConfig'] then opts['DatastoreConfig'] else false


		run: () ->
			#log just to indicate
			flux.dispatcher.dispatch {actionType: 'log.info', msg: 'called SyncHandler.run()'}


			@Datastore = new datastoreInMemory( @DatastoreConfig )


		dispatch: ( message ) ->
			result = false

			flux.dispatcher.dispatch {actionType: 'log.info', msg: 'syncHandler recived message to dispatch'}


			switch message.actionType
				when "get" then result = @_get message.msg
				when "put" then result = @_put message.msg
				when "update" then result = @_update message.msg


			result


		_get: ( msg ) ->
			_statement = {
				table: msg.ressource
				select: msg.data
			}
			@Datastore.select( _statement )

		_put: ( msg ) ->
			_statement = {
				table: msg.ressource,
				data: msg.data
			}
			@Datastore.insert( _statement )

		_update: ( msg ) ->
			_statement = {
				table: msg.ressource,
				select: msg.data.select,
				update: msg.data.update
			}
			@Datastore.update( _statement )




	
	SyncHandler
