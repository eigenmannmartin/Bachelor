define 'visual/rooms', ['react', 'reactrouter', 'flux'
],(				  		 React,   Router,		  		 flux
) ->

	

	flux.createStore
		id: "Rooms",
		initialState: 
			rooms: []
		
		actionCallbacks: 
			Rooms_update: ( updater, room ) ->
				newrooms = updater.get "rooms"
				for key,val of room.data
					newrooms[room.id][key] = val
				updater.set { rooms: newrooms }
				this.emit("change", updater.get "rooms")

			Rooms_add: ( updater, room ) ->
				newrooms = updater.get "rooms"
				roomsdata = room.data
				roomsdata['id'] = newrooms.length
				newrooms.push roomsdata
				updater.set { rooms: newrooms }
				this.emit("change", updater.get "rooms")





		
		

	RoomAddBtn = React.createClass
		addRoom: ->
			flux.doAction('Store2_addRoom', {data: {name:"New"}})

		render: ->
			<div>
				<button onClick={@addRoom} type="button" className="btn btn-danger">Add Room</button>
			</div>

	RoomElementLink = React.createClass
		render: ->
			<li><Link to="SelectDate" params={{roomId: @props.room.id}}>{@props.room.name}</Link></li>

	RoomElementEdit = React.createClass
		handleChange: (event) ->
			flux.doAction('Rooms_update', {id:@props.room.id, data: {name: event.target.value}})
			console.log event.target.value
		render: ->
			<li><input type="text" defaultValue={@props.room.name} onChange={@handleChange}/></li>

	RoomElement = React.createClass
		getInitialState: ->
			{ edit: false }
		editRoom: ->
			@setState { edit: !@state.edit }
		render: ->
			<div>
				{if @state.edit
					<RoomElementEdit room={@props.room}/>
				else
					<RoomElementLink room={@props.room}/>
				}
				<div onClick={@editRoom}>
					(edit)
				</div>
			</div>
				
				

	RoomList = React.createClass
		getInitialState: ->
			{
				rooms: []
			}

		componentDidMount: ->
			me = @
			flux.stores.Rooms.on 'change', ( value ) ->
				me.setState { rooms: value }

			@setState {
				rooms: flux.stores.Rooms.getState().rooms
			}

		render: ->
			<ul className="nav nav-pills nav-stacked">
				{me = @
				@state.rooms.map (room) ->
					return <RoomElement room={room}/>
				}
			</ul>


	Rooms = React.createClass
		render: ->
			<div className="row">
				<div className="col-md-3">
					<RoomList />
				</div>
				<div className="col-md-9">
					<RouteHandler/>
				</div>
			</div>


	Rooms
