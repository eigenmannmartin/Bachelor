define ['react', 'reactrouter', 'flux'
],(		 React,   Router,		 flux
) ->

	@RouteHandler = Router.RouteHandler
	@Route = Router.Route
	@NotFoundRoute = Router.NotFoundRoute
	@Link = Router.Link

	roomitem = React.createClass
		render: ->
			<Link to="Planner/Appointments" params={{roomId: @props.room.id}} className={@props.color+"-text collection-item"} activeClassName={@props.color+" white-text active"}>
				{@props.room.name}
			</Link>

	roomlist = React.createClass
		getInitialState: ->
			rooms: flux.stores.prototype_rooms.getState().rooms
			color: flux.stores.materialize_colors.getState().active_color

		componentDidMount: ->
			me = @
			flux.stores.materialize_colors.on 'change:rooms', ( rooms ) ->
				me.setState 
					rooms: rooms

			flux.stores.materialize_colors.on 'change:active_color', ( active_color ) ->
				me.setState 
					color: active_color
		render: ->
			me = @
			<ul className="collection with-header">
				<li className="collection-header"><h4>Rooms</h4></li>
				{@state.rooms.map (room) ->
					return <roomitem key={room.id} room={room} color={me.state.color}/>
				}
			</ul>


	houritem = React.createClass
		render: ->
			from = @props.hour + ":00"
			to = @props.hour + 1 + ":00"
			text = from + " - " + to
			<Link to="Planner/Appointments/Time" params={{timeId: @props.hour, roomId: @props.roomId}} className={@props.color+"-text collection-item"} activeClassName={@props.color+" white-text active"}>
				 {text}
			</Link>

	dateslist = React.createClass
		getInitialState: ->
			color: flux.stores.materialize_colors.getState().active_color
			hours: [6..19]

		componentDidMount: ->
			me = @
			flux.stores.materialize_colors.on 'change:active_color', ( active_color ) ->
				me.setState
					color: active_color

		render: ->
			me = @
			<ul className="collection with-header">
				<li className="collection-header"><h4>Dates</h4></li>
				{@state.hours.map (hour) ->
					return <houritem key={hour} hour={hour} roomId={me.props.roomId} color={me.state.color}/>
				}
			</ul>


	roomDetails = React.createClass
		render: ->
			<div>
				Details Room
			</div>

	p_planner = React.createClass
		render: ->
			<div className="row">
				<div className="col s4">
					<roomlist />
				</div>
				<RouteHandler />
			</div>

	p_appointments = React.createClass
		render: ->
			<div>
				<div className="col s4">
					<dateslist roomId={@props.params.roomId} />
				</div>
				<RouteHandler />
			</div>

	p_details = React.createClass
		render: ->
			<div className="col s4">
				Details Appointments
			</div>


	[ p_planner, p_appointments, p_details ]