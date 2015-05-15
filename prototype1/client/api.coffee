define ['flux', 'io'
],( 	 flux,	io
) ->

	class Api

		constructor: ->
			@setup()

		setup: ->
			# setup a new websocket instance
			socket = new io() 


			# emit connection state changes
			socket.on 'connect', () ->
				flux.doAction 'prototype_stores_api_connect'

			socket.on 'reconnect', () ->
				flux.doAction 'prototype_stores_api_connect'

			socket.on 'reconnecting', () ->
				flux.doAction 'prototype_stores_api_connecting'

			socket.on 'connect_failed', () ->
				flux.doAction 'prototype_stores_api_disconnect'

			socket.on 'reconnect_failed', () ->
				flux.doAction 'prototype_stores_api_disconnect'
			
			#socket.on 'disconnect', () ->
			#	flux.doAction 'prototype_stores_api_disconnect'

			# connect to the host where we came from
			socket.connect 'http://localhost:3000/'


			# register a disable method
			@socket = socket
			flux.dispatcher.register (payload) ->
				if payload is 'prototype_api_disable'
					socket.close()
					flux.doAction 'prototype_stores_api_disable'

				if payload is 'prototype_api_enable'
					flux.doAction 'prototype_stores_api_enable'
					socket.open()


				

			###
			# register a dispatcher listener for the api
			###
			flux.dispatcher.register ( actionType, data ) ->
	
				# listen to prototype_api_rooms_update
				if actionType is "prototype_api_rooms_update"
					msg = 
						actionType: actionType
						recent: data.recent
						prev: data.prev
					
					socket.send msg

				# listen to prototype_api_rooms_create
				if actionType is "prototype_api_rooms_create"
					msg = 
						actionType: actionType
						recent: data.recent
						prec: false

					socket.send msg


	Api