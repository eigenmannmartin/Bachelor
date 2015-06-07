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
								<td><Link to="Contact/Edit" params={Id:contact.id}>Edit</Link></td>
							</tr>
						}
						</tbody>
					</table>
				</div>
			</div>

	ContactEdit = React.createClass
		mixins: [Router.Navigation]

		getInitialState: ->
			contact: @getContact @props.params.Id

		componentDidMount: ->
			me = @
			flux.stores.prototype_contacts.on 'change', ( state ) ->
				me.setState
					contact: me.getContact me.props.params.Id

		getContact: (id) ->
			result = false
			for contact in flux.stores.prototype_contacts.getState().contacts
				if contact.id is parseInt(id)
					result = contact

			JSON.parse JSON.stringify result

		change_title: (event) ->
			contact = @state.contact
			contact.title = event.target.value
			@setState
				contact: contact

		change_first_name: (event) ->
			contact = @state.contact
			contact.first_name = event.target.value
			@setState
				contact: contact

		change_last_name: (event) ->
			contact = @state.contact
			contact.last_name = event.target.value
			@setState
				contact: contact

		change_middle_name: (event) ->
			contact = @state.contact
			contact.middle_name = event.target.value
			@setState
				contact: contact

		change_street: (event) ->
			contact = @state.contact
			contact.street = event.target.value
			@setState
				contact: contact

		change_country: (event) ->
			contact = @state.contact
			contact.country = event.target.value
			@setState
				contact: contact

		change_state: (event) ->
			contact = @state.contact
			contact.state = event.target.value
			@setState
				contact: contact

		change_city: (event) ->
			contact = @state.contact
			contact.city = event.target.value
			@setState
				contact: contact

		change_email: (event) ->
			contact = @state.contact
			contact.email = event.target.value
			@setState
				contact: contact

		change_phone: (event) ->
			contact = @state.contact
			contact.phone = event.target.value
			@setState
				contact: contact

		click_save: (event) ->
			object = JSON.parse JSON.stringify @state.contact
			prev = @getContact object.id

			flux.doAction( 'C_PRES_STORE_update', { meta:{model:"Contact"}, data:object, prev:prev } )
			@transitionTo('Contacts')

		render: ->
			contact = @state.contact
			if contact
				<div className="container">
					<div className="row">
						<div className="col s12 l10 offset-l1">

							<div className="card-panel teal lighten-1">
								<div className="card-panel">
									<a className="btn-floating btn-large waves-effect waves-light red right planner-save-btn" onClick={@click_save}><i className="mdi-content-save"></i></a>
									<div className="row">
										<form className="col s12">
											<div className="row">
												<div className="input-field col s2">
													<input id="title" type="text" defaultValue={contact.title} onChange={@change_title} className="validate" />
													<label htmlFor="title" className={if contact.title then "active"}>Title</label>
												</div>
												<div className="input-field col s3">
													<input id="first_name" type="text" defaultValue={contact.first_name} onChange={@change_first_name} className="validate" />
													<label htmlFor="first_name" className={if contact.first_name then "active"}>Firstname</label>
												</div>
												<div className="input-field col s2">
													<input id="middle_name" type="text" defaultValue={contact.middle_name} onChange={@change_middle_name} className="validate" />
													<label htmlFor="middle_name" className={if contact.middle_name then "active"}>Middlename</label>
												</div>
												<div className="input-field col s5">
													<input id="last_name" type="text" defaultValue={contact.last_name} onChange={@change_last_name} className="validate" />
													<label htmlFor="last_name" className={if contact.last_name then "active"}>Lastname</label>
												</div>
											</div>

											<div className="row">
												<div className="input-field col s4">
													<input id="country" type="text" defaultValue={contact.country} onChange={@change_country} className="validate" />
													<label htmlFor="country" className={if contact.country then "active"}>Country</label>
												</div>
												<div className="input-field col s3">
													<input id="state" type="text" defaultValue={contact.state} onChange={@change_state} className="validate" />
													<label htmlFor="state" className={if contact.state then "active"}>State</label>
												</div>
												<div className="input-field col s5">
													<input id="city" type="text" defaultValue={contact.city} onChange={@change_city} className="validate" />
													<label htmlFor="city" className={if contact.city then "active"}>City</label>
												</div>
											</div>

											<div className="row">
												<div className="input-field col s12">
													<input id="street" type="text" defaultValue={contact.street} onChange={@change_street} className="validate" />
													<label htmlFor="street" className={if contact.street then "active"}>Street</label>
												</div>
											</div>

											<div className="row">
												<div className="input-field col s6">
													<input id="email" type="text" defaultValue={contact.email} onChange={@change_email} className="validate" />
													<label htmlFor="email" className={if contact.email then "active"}>E-mail</label>
												</div>
												<div className="input-field col s6">
													<input id="phone" type="text" defaultValue={contact.phone} onChange={@change_phone} className="validate" />
													<label htmlFor="phone" className={if contact.phone then "active"}>Phone</label>
												</div>
											</div>

										</form>

									</div>
								</div>
							</div>

						</div>
					</div>
				</div>
			else
				<div>
					Contact not found yet!
				</div>	


	[ Rooms, PlannerRoomSettings, PlannerRoomDates, Contacts, ContactEdit ]