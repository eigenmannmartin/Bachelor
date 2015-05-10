define 'api', ['flux'
],( 	 	   flux
) ->
	class Api

		@CLIENT = "client"
		@SERVER = "server"


		@GET = "get"
		@UPDATE = "update"
		@PUT = "put"
		@DELETE = "delete"
		

		constructor: ->
			@type = false
			@url = false
			@token = false

		configure: ( opts ) ->
			@type = if opts['type']? then opts['type']
			@url = if opts['url']? then opts['url']
			@token = if opts['token']? then opts['token']


			@srv = if opts['server']? then opts['server'] else false
			@syncmgr = if opts['syncmgr']? then opts['syncmgr'] else false

		dispatch: ( msg ) ->
			type = if msg.type? then msg.type else false
			ressource = if msg.ressource? then msg.ressource else false
			latest = if msg.latest? then msg.latest else false
			recent = if msg.recent? then msg.recent else false
			id = if msg.id? then msg.id else false


			switch type
				when Api.GET
					msg = {
						ressource: ressource
						data: {pk: id}
					}
				when Api.PUT
					msg = {
						ressource: ressource
						data: [latest]
					}
				when Api.UPDATE
					msg = {
						ressource: ressource
						data: {select: {pk:id}, update: latest}
						recent: recent
					}
				when Api.DELETE
					msg = {
						ressource: ressource
						data: {pk: latest.id}
					}
				else
					msg = false

			if msg	
				@_send( type, msg )
			else
				throw new Error "msg type wrong or not defined - you used: \""+type+"\""

			


		_send: ( type, msg ) ->
			if @type is Api.CLIENT
				return @_recive( type, msg )

			if @type is Api.SERVER
				throw new Error "not implemented yet! - you can not send messages from the server to the client"

			throw new Error "you need to configure an API type first"



		_recive: ( type, msg ) ->
			@srv.syncmgr.dispatch({ actionType: type, msg: msg })
			



	
	Api
