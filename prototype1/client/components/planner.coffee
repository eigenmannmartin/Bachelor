define ['react', 'reactrouter', 'flux'
],(		 React,   Router,		 flux
) ->

	@RouteHandler = Router.RouteHandler
	@Route = Router.Route
	@NotFoundRoute = Router.NotFoundRoute
	@Link = Router.Link

	p_roomlist = React.createClass
		componentDidMount: ->
			console.log @.getDOMNode().collapsible()
		render: ->
			<ul className="collapsible" data-collapsible="accordion">
				<li>
					<div className="collapsible-header"><i className="mdi-image-filter-drama"></i>First</div>
					<div className="collapsible-body"><p>Lorem ipsum dolor sit amet.</p></div>
				</li>
				<li>
					<div className="collapsible-header"><i className="mdi-maps-place"></i>Second</div>
					<div className="collapsible-body"><p>Lorem ipsum dolor sit amet.</p></div>
				</li>
				<li>
					<div className="collapsible-header"><i className="mdi-social-whatshot"></i>Third</div>
					<div className="collapsible-body"><p>Lorem ipsum dolor sit amet.</p></div>
				</li>
			</ul>


	p_planner = React.createClass
		render: ->
			<div className="row">
				<div className="col s4">
					<p_roomlist />
				</div>
				<RouteHandler />
			</div>

	p_appointments = React.createClass
		render: ->
			<div>
				<div className="col s4">
					Dates
				</div>
				<RouteHandler />
			</div>

	p_details = React.createClass
		render: ->
			<div className="col s4">
				Details
			</div>


	[ p_planner, p_appointments, p_details ]