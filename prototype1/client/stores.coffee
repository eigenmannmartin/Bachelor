define ['flux'
],( 	 flux
) ->

	
	flux.createStore
		id: "materialize_colors",
		initialState: {
			colors: [ 'red', 'pink', 'purple', 'deep-purple', 'indigo', 'blue', 'light-blue', 'cyan', 'teal', 'green', 'light-green', 'lime', 'yellow', 'amber', 'orange', 'deep-orange', 'brown', 'grey', 'blue-grey']
			active_color: ''
		}
		actionCallbacks: {
			materialize_pick_color: ( updater, doNotResetInterval=false ) ->
				if not doNotResetInterval and @colors_interval? then clearInterval @colors_interval
				colors = updater.get "colors"
				active_color = colors[ Math.floor Math.random()*(colors.length - 2) ]
				updater.set { active_color: active_color }

			materialize_set_color: ( updater, color ) ->
				if @colors_interval? then clearInterval @colors_interval
				updater.set { active_color: color }

			materialize_party_color: ( updater ) ->
				func = () ->
					flux.doAction 'materialize_pick_color', true
				@colors_interval  = setInterval func, 250

				
		}

	flux.doAction 'materialize_set_color', 'indigo'
		


	flux.createStore
		id: "prototype_rooms",
		initialState: {
			rooms : []
			###rooms: [ 
				{ id: 0, ac: true, beamer: true, seats: 24, name: "Säntis", description: "", free: true, image: "/img/rooms/0.jpg"  } 
				{ id: 1, ac: true, beamer: true, seats: 12, name: "Eiger", description: "", free: true, image: "/img/rooms/1.jpg" }
				{ id: 2, ac: false, beamer: false, seats: 10, name: "Bodensee", description: "", free: false, image: "/img/rooms/2.jpg" }
				{ id: 3, ac: false, beamer: true, seats: 40, name: "Grand Canyon", description: "", free: true, image: "/img/rooms/3.jpg" }
				{ id: 4, ac: true, beamer: true, seats: 18, name: "Himalaya", description: "", free: true, image: "/img/rooms/4.jpg" }
			]###
		}
		actionCallbacks: {
			###
			# on Message.actionType 'prototype_stores_rooms_update'
			# updates an existing room in the store
			###
			prototype_stores_rooms_update: ( updater, room ) ->
				# get old room instance
				newrooms = @.getState().rooms
				for index, r of newrooms
					if r.id is room.id
						oldroom = r
						oldindex = index

				# preserve recent and previous values and send a new message for the api
				recent = room
				prev = JSON.parse(JSON.stringify( r ))
				flux.doAction 'prototype_api_rooms_update', { recent: room, prev: prev }


				# update given room
				for key, val of room
					newrooms[ oldindex ][key] = val
				updater.set { rooms: newrooms }
				updater.emit 'change', @.getState()

			prototype_stores_rooms_create: ( updater, room ) ->
				# send a new message for the api
				recent = room
				flux.doAction 'prototype_api_rooms_create', { recent: room, prev: false }

				# get all rooms
				newrooms = @.getState().rooms
				# set new ID 
				# !!! caution !!! - length + 1 might be an id that is already used
				room.id = newrooms.length + 1
				# set default image
				room.image = "/img/rooms/"+room.name+".jpg"
				# add new room to collection
				newrooms.push room
				updater.set { rooms: newrooms }
				updater.emit 'change', @.getState()

			prototype_stores_rooms_update_insert: ( updater, room ) ->
				console.log "update"
				# get all rooms
				index = false
				newrooms = @.getState().rooms
				for r in newrooms
					if parseInt(r.id) is parseInt(room.id)
						index = newrooms.indexOf r

				if index
					newrooms[ index ] = room
				else
					newrooms.push room


				updater.set { rooms: newrooms }
				updater.emit 'change', @.getState()
		}


	flux.createStore
		id: "prototype_api",
		initialState: {
			connected: false
			connecting: false
			disabled: false
		}
		actionCallbacks: {
			prototype_stores_api_connect: ( updater ) ->
				updater.set { connected: true, connecting: false, disabled: false }
			prototype_stores_api_disconnect: ( updater ) ->
				updater.set { connected: false, connecting: false, disabled: false }
			prototype_stores_api_connecting: ( updater ) ->
				updater.set { connected: false, connecting: true, disabled: false }
			prototype_stores_api_disable: ( updater ) ->
				updater.set { connected: false, connecting: false, disabled: true }
			
		}


	false