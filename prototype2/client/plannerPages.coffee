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


		render: ->
			<div className="container">
				<div className="row">
					{@state.rooms.map (room) ->
						return <p>Name: {room.name} | free: {if room.free then "yes" else "no"}</p>
					}
				</div>
				<div className="fixed-action-btn">
					<Link to="Rooms/Create" className="btn-floating btn-large red">
						<i className="large mdi-content-add"></i>
					</Link>
				</div>
			</div>


	[ Rooms, PlannerRoomSettings, PlannerRoomDates ]