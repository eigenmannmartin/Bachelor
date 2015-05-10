define 'visual/rooms', ['react', 'reactrouter', 'flux'
],(				  		 React,   Router,		  		 flux
) ->

	
	SetupStore = ( name ) ->

		@CB = {}
		@CB[ name+"_changeRoom"] = ( updater, room ) ->
			newrooms = updater.get "rooms"
			newrooms[room.id] = room.data
			updater.set { rooms: newrooms }
			this.emit("change:rooms", updater.get "rooms")

		@CB[ name+"_addRoom"] = ( updater, room ) ->
			newrooms = updater.get "rooms"
			roomsdata = room.data
			roomsdata['id'] = newrooms.length
			newrooms.push roomsdata
			updater.set { rooms: newrooms }
			this.emit("change:rooms", updater.get "rooms")

		flux.createStore
			id: name,
			initialState: 
				rooms: []
				meetings: []
				users: []

			actionCallbacks: @CB


	SetupStore( "Store1" )
	SetupStore( "Store2" )

		
		

	RoomAddBtn = React.createClass
		addRoom: ->
			flux.doAction('Store2_addRoom', {data: {name:"New"}})

		render: ->
			<div>
				<button onClick={@addRoom} type="button" className="btn btn-danger">Add Room</button>
			</div>

	RoomElementLink = React.createClass
		render: ->
			<li><a>{@props.room.name}</a></li>

	RoomElementEdit = React.createClass
		handleChange: (event) ->
			console.log event.target.value
			console.log @props.room.id
			console.log @props.id
		render: ->
			<li><input type="text" defaultValue={@props.room.name} onChange={@handleChange}/></li>

	RoomElement = React.createClass
		getInitialState: ->
			{ edit: false }
		editRoom: ->
			if not @state.edit
				@setState { edit: !@state.edit }
		render: ->
			<div>
				{if @state.edit
					<RoomElementEdit id={@props.id} room={@props.room}/>
				else
					<RoomElementLink room={@props.room}/>
				}
				<div onClick={@editRoom}>
					(edit)
				</div>
			</div>
				
				

	RoomList = React.createClass
		render: ->
			<ul className="nav nav-pills nav-stacked">
				{me = @
				@props.rooms.map (room) ->
					return <RoomElement id={me.props.id} room={room} />
				}
			</ul>


	Rooms = React.createClass
		getInitialState: ->
			{
				Store1_rooms: []
				Store2_rooms: [] 
			}
		
		componentDidMount: ->
			me = @
			flux.stores[ "Store1"].on 'change:rooms', ( value ) ->
				me.setState { Store1_rooms: value }
			flux.stores[ "Store2"].on 'change:rooms', ( value ) ->
				me.setState { Store2_rooms: value }
		
		render: ->
			id = @props.params.id
			<div className="row">
				<div className="col-md-3">
					<RoomAddBtn id={id} />
					<RoomList id={id} rooms={@state['Store'+id+'_rooms']} />
				</div>
				<div className="col-md-3">
					<div>{@props.rooms}</div>
				</div>
				<div className="col-md-3">
					<div>{@props.rooms}</div>
				</div>
				<div className="col-md-3">
					<div>{@props.rooms}</div>
				</div>
			</div>


	Rooms
