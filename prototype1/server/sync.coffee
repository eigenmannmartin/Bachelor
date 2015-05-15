define ['flux'],( flux ) ->

	class Sync

		constructor: ->
			@setup()
			
		setup: ->
			flux.dispatcher.register (payload) ->
				console.log "dispatched"
				console.log payload 

	Sync
				
