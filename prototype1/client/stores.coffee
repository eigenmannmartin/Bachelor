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
				if @colors_interval? then clearInterval @colors_interval
				func = () ->
					flux.doAction 'materialize_pick_color', true
				@colors_interval  = setInterval func, 250

				
		}

	flux.doAction 'materialize_set_color', 'blue'
		


	flux.createStore
		id: "prototype_rooms",
		initialState: {
			rooms: [ 
				{ id: 0, name: "Säntis", description: "", free: true  } 
				{ id: 1, name: "Eiger", description: "", free: true }
				{ id: 2, name: "Bodensee", description: "", free: false }
				{ id: 3, name: "Grand Canyon", description: "", free: true }
			]
		}
		actionCallbacks: {
			prototype_rooms_save_room: ( updater, room ) ->
				newrooms = @.getState().rooms
				newrooms[ room.id ] = room
				updater.set { rooms: newrooms }
		}



	false