define ['flux', 'state'],( flux, state ) ->

	class Sync

		constructor: ->
			@setup()
			
		setup: ->
			sync = @
			flux.dispatcher.register ( actionType, data ) ->

				if actionType is 'prototype_sync_rooms_init'
					sync.prototype_sync_rooms_init data

				if actionType is 'prototype_sync_rooms_update'
					sync.sync_rooms_update data

				if actionType is 'prototype_sync_rooms_create'
					sync.sync_rooms_create data


		prototype_sync_rooms_init: ( socket ) ->
			state.models.Room.findAll().then ( rooms ) ->
				for room in rooms
					flux.doAction 'prototype_api_private_stores_rooms_update_insert', room, socket


		sync_rooms_update: ( data ) ->
			state.models.Room.find( data.recent.id ).then ( room ) ->
				for key, val of data.recent
					room[ key ] = val

				room.save()
				flux.doAction 'prototype_api_stores_rooms_update_insert', room

		sync_rooms_create: ( data ) ->
			state.models.Room.create(
				name: data.recent.name
				description: data.recent.description
				free: data.recent.free
				beamer: data.recent.beamer
				ac: data.recent.ac
				seats: data.recent.seats
				image: data.recent.image
			).then ( room ) ->
				console.log "created: " + room.name
				flux.doAction 'prototype_api_stores_rooms_update_insert', room
				console.log "/created"

	Sync
				
