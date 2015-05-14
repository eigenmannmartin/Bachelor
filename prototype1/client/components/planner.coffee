define ['react', 'reactrouter', 'flux'
],(		 React,   Router,		 flux
) ->

	@RouteHandler = Router.RouteHandler
	@Route = Router.Route
	@NotFoundRoute = Router.NotFoundRoute
	@Link = Router.Link



	RoomCardBookLink = React.createClass
		render: ->
			<div>
				{if @props.room.free
					<Link to="Rooms/Dates" params={{roomId: @props.room.id}} className="waves-effect waves-light btn">Book</Link>
				else
					<Link to="Rooms/Dates" params={{roomId: @props.room.id}} className="waves-effect waves-light btn disabled red">Booked</Link>
				}
			</div>

	RoomCard = React.createClass
		render: ->
			<div className="col s12 m6 l4">
				<div className="card">
					<div className="card-image waves-effect waves-block waves-light">
						<img className="activator" src={@props.room.image} />
						<span className="card-title activator">{@props.room.name} <i className="mdi-navigation-more-vert right activator"></i></span>
					</div>
					<div className="card-content">
						<div className="row">
							<div className="col s12 center">
								<RoomCardBookLink room={@props.room} />
							</div>
						</div>
					</div>
					<div className="card-reveal">
						<span className="card-title grey-text text-darken-4">{@props.room.name} <i className="mdi-navigation-close right"></i></span>
						<p>{@props.room.description}</p>
						<p>
							<input type="checkbox" id="beamer" checked={@props.room.beamer} disabled=true />
							<label htmlFor="beamer">Beamer</label>
						</p>
						<p>
							<input type="checkbox" id="ac" checked={@props.room.ac} disabled=true />
							<label htmlFor="ac">Air Con</label>
						</p>
						<p>
							<a id="seats" className="planner-a-details grey-text">{@props.room.seats}</a>
							<label htmlFor="seats">Seats</label>
						</p>
						<Link to="Rooms/Edit" params={{roomId: @props.room.id}} className="waves-effect waves-light btn right">Edit</Link>
					</div>
				</div>
			</div>

	PlannerRoomSettings = React.createClass
		mixins: [Router.Navigation]

		getInitialState: ->
			if @props.params.roomId isnt 'new'
				room = flux.stores.prototype_rooms.getState().rooms[@props.params.roomId]
				return {
					room_id: room.id
					room_name: room.name 
					room_description: room.description 
					room_free: room.free
					room_beamer: room.beamer
					room_seats: room.seats
					room_ac: room.ac
					room_new: false
				}
 
			else
				return {
					room_new: true
					room_id: false
					room_name: ""
					room_description: ""
					room_free: true
					room_beamer: false
					room_seats: 0
					room_ac: false
				}

		componentDidMount: ->
			me = @
			if @props.params.roomId? isnt 'new'
				flux.stores.prototype_rooms.on 'change:rooms', ( rooms ) ->
					me.setState
						room_id: rooms[@props.params.roomId].id
						room_name: rooms[@props.params.roomId].name
						room_description: rooms[@props.params.roomId].description
						room_free: rooms[@props.params.roomId].free
						room_beamer: rooms[@props.params.roomId].beamer
						room_seats: rooms[@props.params.roomId].seats
						room_ac: rooms[@props.params.roomId].ac

		click_free: (event) ->
			result = !event.target.checked
			@.setState 
				room_free: result

		change_name: (event) ->
			result = event.target.value
			@.setState
				room_name: result

		change_description: (event)->
			result = event.target.value
			@.setState
				room_description: result

		click_beamer: (event) ->
			result = event.target.checked
			@.setState 
				room_beamer: result

		click_ac: (event) ->
			result = event.target.checked
			@.setState 
				room_ac: result

		change_seats: (event) ->
			result = event.target.value
			@.setState
				room_seats: result

		_assemble_room: () ->
			room = {}
			room.id = @state.room_id
			room.name = @state.room_name
			room.description = @state.room_description
			room.free = @state.room_free
			room.beamer = @state.room_beamer
			room.seats = @state.room_seats
			room.ac = @state.room_ac

			room

		click_save: (event) ->
			flux.doAction 'prototype_stores_rooms_update', @_assemble_room()
			@transitionTo('Rooms')

		click_create: (event) ->
			flux.doAction 'prototype_stores_rooms_create', @_assemble_room()
			@transitionTo('Rooms')

		render: ->
			<div className="container">
				<div className="row">
					<div className="col s12 l10 offset-l1">

						<div className="card-panel teal lighten-1">
							<div className="card-panel">
								{if @state.room_new
									<a className="btn-floating btn-large waves-effect waves-light red right planner-add-btn" onClick={@click_create}><i className="mdi-content-add"></i></a>
								else
									<a className="btn-floating btn-large waves-effect waves-light red right planner-save-btn" onClick={@click_save}><i className="mdi-content-save"></i></a>
								}

								<div className="row">
									<form className="col s12">
										<div className="row">
											<div className="input-field col s12">
												<input id="name" type="text" defaultValue={@state.room_name} onChange={@change_name} className="validate" />
												<label htmlFor="name" className={if @state.room_name then "active"}>Name</label>
											</div>
										</div>
										<div className="row">
											<div className="input-field col s6">
												<textarea id="description" className="materialize-textarea" defaultValue={@state.room_description} onChange={@change_description}></textarea>
												<label htmlFor="description">Description</label>
											</div>
											<div className="col s6 center">
												<div className="switch">
													<label>
														free
														<input type="checkbox" checked={not @state.room_free} onChange={@click_free} />
														<span className="lever"></span>
														occupied
													</label>
												</div>
											</div>
										</div>
										<div className="row">
											<div className="col s12">
												<p>
													<input type="checkbox" id="beamer" checked={@state.room_beamer} onChange={@click_beamer} />
													<label htmlFor="beamer">Beamer</label>
												</p>
											</div>
										</div>
										<div className="row">
											<div className="col s12">
												<p>
													<input type="checkbox" id="ac" checked={@state.room_ac} onChange={@click_ac} />
													<label htmlFor="ac">Air Con</label>
												</p>
											</div>
										</div>
										<div className="row">
											<div className="col s4">
												{@state.room_seats} Seats
											</div>
											<div className="col s5">
												<p className="range-field">
													<input type="range" id="seats" min="5" max="50" value=@state.room_seats onChange={@change_seats}/>
												</p>
											</div>
										</div>

									</form>

								</div>
							</div>
						</div>

					</div>
				</div>
			</div>


	PlannerRoomDates = React.createClass
		render: ->
			<div className="container">
				<div className="row">
						Dates
				</div>
			</div>


	Rooms = React.createClass
		getInitialState: ->
			rooms: flux.stores.prototype_rooms.getState().rooms

		componentDidMount: ->
			me = @
			flux.stores.materialize_colors.on 'change:rooms', ( rooms ) ->
				me.setState 
					rooms: rooms
		render: ->
			<div className="container">
				<div className="row">
						{@state.rooms.map (room) ->
							return <RoomCard key={room.id} room={room} />
						}
				</div>
				<div className="fixed-action-btn">
					<Link to="Rooms/Create" className="btn-floating btn-large red">
						<i className="large mdi-content-add"></i>
					</Link>
				</div>
			</div>


	[ Rooms, PlannerRoomSettings, PlannerRoomDates ]