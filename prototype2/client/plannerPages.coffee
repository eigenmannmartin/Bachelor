define ['react', 'reactrouter', 'flux'
],(		 React,   Router,		 flux
) ->

	@RouteHandler = Router.RouteHandler
	@Route = Router.Route
	@NotFoundRoute = Router.NotFoundRoute
	@Link = Router.Link

	PlannerRoomSettings = React.createClass
		render: ->
			<div className="container">
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
			flux.stores.prototype_rooms.on 'change', ( state ) ->
				me.setState
					rooms: state.rooms

		get_room: (id) ->
			for room in @state.rooms
				if room.id is id
					return room

		manual_command: (event) ->
			if event.key is 'Enter'
				event.preventDefault()
				object = JSON.parse event.target.value
				prev = if object.id? then JSON.parse JSON.stringify @get_room object.id else {} #real copy
				if object.delete?
					flux.doAction( 'C_PRES_STORE_delete', { meta:{model:"Room"}, data:object } )
				else
					flux.doAction( 'C_PRES_STORE_update', { meta:{model:"Room"}, data:object, prev:prev } )


		render: ->
			<div className="container">
				<div className="row">
					<p>
						<textarea onKeyDown={@manual_command}
						defaultValue='{"id": 1, "name":"Eiger","free":false, "ac": true, "beamer":true, "seats":12, "description":"some description"} '></textarea>
					</p>
					{@state.rooms.map (room) ->
							<p>id: {room.id}
							| name: {room.name} 
							| free: {if room.free then "yes" else "no"}
							| ac: {if room.ac then "yes" else "no"}
							| beamer: {if room.beamer then "yes" else "no"}
							| seats: {room.seats}
							| desc: {room.description}
							</p>
					}
				</div>
				<div className="fixed-action-btn">
					<Link to="Rooms/Create" className="btn-floating btn-large red">
						<i className="large mdi-content-add"></i>
					</Link>
				</div>
			</div>




	Contacts = React.createClass
		getInitialState: ->
			contacts: flux.stores.prototype_contacts.getState().contacts

		componentDidMount: ->
			me = @
			flux.stores.prototype_contacts.on 'change', ( state ) ->
				me.setState
					contacts: state.contacts

		get_contact: (id) ->
			for contact in @state.contacts
				if contact.id is id
					return contact

		exec_init: () ->
			flux.doAction( 'C_PRES_STORE_update', { meta:{function:"init"}, args:"asdf" } )

		manual_command: (event) ->
			if event.key is 'Enter'
				event.preventDefault()
				object = JSON.parse event.target.value
				prev = if object.id? then JSON.parse JSON.stringify @get_contact object.id else {} #real copy
				if object.delete?
					flux.doAction( 'C_PRES_STORE_delete', { meta:{model:"Contact"}, data:object } )
				else
					flux.doAction( 'C_PRES_STORE_update', { meta:{model:"Contact"}, data:object, prev:prev } )


		render: ->
			<div className="container">
				<div className="row">
					<p>
						<textarea onKeyDown={@manual_command}
						defaultValue='{"id":1,"last_name":"Eigenmann"}'></textarea>
					</p>
					<table className="hoverable">
						<thead>
							<tr>
								<th>Name</th>
								<th>Phone</th>
								<th>Email</th>
								<th>Country</th>
							</tr>
						</thead>
						<tbody>
						{@state.contacts.map (contact) ->
							<tr>
								<td>{contact.title} {contact.first_name} {contact.last_name}</td>
								<td>{contact.phone}</td> 
								<td>{contact.email}</td>
								<td>{contact.country}</td>
							</tr>
						}
						</tbody>
					</table>
				</div>
			</div>


	[ Rooms, PlannerRoomSettings, PlannerRoomDates, Contacts ]