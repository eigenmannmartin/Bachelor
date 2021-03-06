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
				id: "prototype_contacts",
				initialState: 
					contacts : []
				
				actionCallbacks:
					#msg = meta:{ model:[model_name] }, data:{}
					C_PRES_STORE_update: ( updater, msg ) ->
						if msg.meta.model is "Contact"
							if msg.data.id #do not add contacts without id to the store
								index = null
								newcontacts = @.getState().contacts  #get all contacts
								for r in newcontacts
									if r.id is msg.data.id
										index = newcontacts.indexOf r  #find index of element to update

								if index isnt null
									for key,val of msg.data
										newcontacts[ index ][key] = val
								else
									newcontacts.push msg.data

								updater.set { contacts: newcontacts }
								updater.emit 'change', @.getState()

					C_PRES_STORE_delete: ( updater, msg ) ->
						if msg.meta.model is "Contact"
							index = null
							newcontacts = @.getState().contacts
							for r in newcontacts
								if r.id is msg.data.id
									index = newcontacts.indexOf r

							if index isnt null
								newcontacts.splice index, 1
							
							updater.set { contacts: newcontacts }
							updater.emit 'change', @.getState()

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

				flux.createStore
					id: "prototype_msgs",
					initialState: {
						messages:[]
					}
					actionCallbacks: {
						C_PRES_STORE_update: ( updater, msg ) ->
							newmessages = @.getState().messages
							newmessages.push { name:"C_PRES_STORE_update", msg:msg, id:newmessages.length }
							updater.set { messages: newmessages }
							updater.emit 'change', @.getState()

						C_PRES_STORE_delete: ( updater, msg ) ->
							newmessages = @.getState().messages
							newmessages.push { name:"C_PRES_STORE_delete", msg:msg, id:newmessages.length }
							updater.set { messages: newmessages }
							updater.emit 'change', @.getState()

						C_PRES_STORE_conflict: ( updater, msg ) ->
							newmessages = @.getState().messages
							newmessages.push { name:"C_PRES_STORE_conflict", msg:msg, id:newmessages.length }
							updater.set { messages: newmessages }
							updater.emit 'change', @.getState()
					}

	new Store