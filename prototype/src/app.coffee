define ['flux'
],( 	 flux
) ->
	class App

		constructor: ->
			@setupLogger()

		setupLogger: ->
			flux.dispatcher.register (payload) ->
				return false
				if payload.actionType is 'log.info'
					console.log "Info: " + payload.msg

				if payload.actionType is 'log.warn'
					console.log "Warn: " + payload.msg

				if payload.actionType is 'log.error'
					console.log "Error: " + payload.msg

		run: () ->
			#log just to indicate
			flux.dispatcher.dispatch {actionType: 'log.info', msg: 'called App.run()'}

			#fire up router
			require(['router'])


	
	App
