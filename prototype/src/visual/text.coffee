define 'visual/text', ['react', 'reactrouter'
],(						React,   Router
) ->

	User = React.createClass
		render: ->
			<div>
				<p>Yolo - Test!</p>
				<RouteHandler/>
			</div>;

	
	User
