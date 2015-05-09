define 'visual/text', ['react', 'reactrouter', 'flux'
],(						React,   Router,		flux
) ->

	flux.createStore
		id: 'nameStore',
		initialState: 
			name: 'Alice'
		
		actionCallbacks: 
			changeText: ( updater, name ) ->
				updater.set {name: name} 



	User = React.createClass
		getInitialState: ->
			{name: flux.stores.nameStore.name }

		componentDidMount: ->
			me = this
			flux.stores.nameStore.on 'change:name', ( value ) ->
				me.setState {name: value}


		render: ->
			<div className="row">
				<div className="col-md-12">
					<div>Name: {this.state.name}</div>
				</div>
			</div>

	
	User
