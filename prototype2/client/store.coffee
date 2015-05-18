define ['flux'], (flux) ->

	class Store
		constructor: ->
			flux.createStore
			id: "materialize_colors",
			initialState:
				colors: [ 'red', 'pink', 'purple', 'deep-purple', 'indigo', 'blue', 'light-blue', 'cyan', 'teal', 'green', 'light-green', 'lime', 'yellow', 'amber', 'orange', 'deep-orange', 'brown', 'grey', 'blue-grey']
				active_color: 'indigo'

			actionCallbacks:
				# data = meta:{ model:[model_name] }, data:{}
				C_PRES_STORE_update: ( updater, data ) ->
					if data.meta.model is "Color"
						updater.set { active_color: data.color }
			


		flux.createStore
			id: "prototype_rooms",
			initialState: 
				rooms : []
			
			actionCallbacks:
				#msg = meta:{ model:[model_name] }, data:{}
				C_PRES_STORE_update: ( updater, msg ) ->
					if msg.meta.model is "Room"
						if msg.data.id #do not add rooms without id to the store
							index = null
							newrooms = @.getState().rooms  #get all rooms
							for r in newrooms
								if r.id is msg.data.id
									index = newrooms.indexOf r  #find index of element to update

							if index isnt null
								for key,val of msg.data
									newrooms[ index ][key] = val
							else
								newrooms.push msg.data

							updater.set { rooms: newrooms }
							updater.emit 'change', @.getState()

				C_PRES_STORE_delete: ( updater, msg ) ->
					if msg.meta.model is "Room"
						index = null
						newrooms = @.getState().rooms
						for r in newrooms
							if r.id is msg.data.id
								index = newrooms.indexOf r

						if index isnt null
							newrooms.splice index, 1
						
						updater.set { rooms: newrooms }
						updater.emit 'change', @.getState()

	new Store