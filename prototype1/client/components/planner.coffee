define ['react', 'reactrouter', 'flux'
],(		 React,   Router,		 flux
) ->

	@RouteHandler = Router.RouteHandler
	@Route = Router.Route
	@NotFoundRoute = Router.NotFoundRoute
	@Link = Router.Link



	RoomCardFreeBadge = React.createClass
		render: ->
			<div>
				{if @props.free
					<a className="btn disabled green white-text">free</a>
				else
					<a className="btn disabled red white-text">reserved</a>
				}
			</div>

	RoomCard = React.createClass
		render: ->
			<div className="col s4">
				<div className="card">
					<div className="card-image waves-effect waves-block waves-light">
						<img className="activator" src={"img/rooms/"+@props.room.id+".jpg"} />
						<span className="card-title activator">{@props.room.name} <i className="mdi-navigation-more-vert right"></i></span>
					</div>
					<div className="card-content">
						<div className="row">
							<div className="col s6">
								<RoomCardFreeBadge free={@props.room.free} />
							</div>
							<div className="col s6">
								<Link to="Rooms/Edit" params={{roomId: @props.room.id}} className="btn right">Book</Link>
							</div>
						</div>
					</div>
					<div className="card-reveal">
						<span className="card-title grey-text text-darken-4">{@props.room.name} <i className="mdi-navigation-close right"></i></span>
						<p>{@props.room.description}</p>
						<Link to="Rooms/Edit" params={{roomId: @props.room.id}} className="btn right">Edit</Link>
					</div>
				</div>
			</div>

	PlannerRoomSettings = React.createClass
		getInitialState: ->
			if @props.params.roomId isnt 'new'
				room = flux.stores.prototype_rooms.getState().rooms[@props.params.roomId]
				return {
					room_id: room.id
					room_name: room.name 
					room_description: room.description 
					room_free: room.free
				}
 
			else
				return {
					room_id: false
					room_name: ""
					room_description: ""
					room_free: true
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


		click_save: (event) ->
			room={}
			room.id = @state.room_id
			room.name = @state.room_name
			room.description = @state.room_description
			room.free = @state.room_free

			flux.doAction 'prototype_rooms_save_room', room

		render: ->
			<div className="container">
				<div className="row">
					<div className="col s10 offset-s1">

						<div className="card-panel teal lighten-1">
							<div className="card-panel">
								{if @state.room_id
									<a className="btn-floating btn-large waves-effect waves-light red right planner-save-btn" onClick={@click_save}><i className="mdi-content-save"></i></a>
								else
									<a className="btn-floating btn-large waves-effect waves-light red right planner-add-btn"><i className="mdi-content-add"></i></a>
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
												<textarea id="description" className="materialize-textarea" onChange={@change_description}>{@state.room_description}</textarea>
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

									</form>

								</div>
							</div>
						</div>

					</div>
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


	[ Rooms, PlannerRoomSettings ]