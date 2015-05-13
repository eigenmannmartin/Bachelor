define ['flux', 'state'
],( 	 flux,   state
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
			rooms: [ 
				{ id: 0, ac: true, beamer: true, seats: 24, name: "Säntis", description: "", free: true, image: "/img/rooms/0.jpg"  } 
				{ id: 1, ac: true, beamer: true, seats: 12, name: "Eiger", description: "", free: true, image: "/img/rooms/1.jpg" }
				{ id: 2, ac: false, beamer: false, seats: 5, name: "Bodensee", description: "", free: false, image: "/img/rooms/2.jpg" }
				{ id: 3, ac: false, beamer: true, seats: 40, name: "Grand Canyon", description: "", free: true, image: "/img/rooms/3.jpg" }
				{ id: 4, ac: true, beamer: true, seats: 18, name: "Himalaya", description: "", free: true, image: "/img/rooms/4.jpg" }
			]
		}
		actionCallbacks: {
			prototype_rooms_save_room: ( updater, room ) ->
				newrooms = @.getState().rooms
				for key, val of room
					newrooms[ room.id ][key] = val
				updater.set { rooms: newrooms }

			prototype_rooms_create_room: ( updater, room ) ->
				console.log room
				newrooms = @.getState().rooms
				room.id = newrooms.length
				room.image = "/img/rooms/"+room.id+".jpg"
				newrooms.push room
				updater.set { rooms: newrooms }
				console.log newrooms
		}



	false