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
			materialize_pick_color: ( updater ) ->
				colors = updater.get "colors"
				active_color = colors[ Math.floor Math.random()*(colors.length - 2) ]
				updater.set { active_color: active_color }
				
		}

	flux.doAction 'materialize_pick_color'


	flux.createStore
		id: "prototype_rooms",
		initialState: {
			rooms: [ { id: 0, name: "Säntis" }, { id: 1, name: "Eiger" }, { id: 2, name: "Bodensee" } ]
		}
		actionCallbacks: {
				
		}



	false