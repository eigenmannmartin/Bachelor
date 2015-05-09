define 'datastoreInMemory', [ 'flux'
], (						   flux
) ->
	class inMemoryDatastore

		datastore: []
		schema: {}

		constructor: ( opts ) ->
			if opts
				this.init opts 

		init: ( opts ) ->
			flux.dispatcher.dispatch {actionType: 'log.info', msg: 'called datastoreInMemory.init()'}

			this.datastore = []
			this.schema = []
			for tables in opts[ 'tables' ]
				for name,table of tables
					this.schema[ name ] = table
					this.datastore[ name ] = []

		insert: ( data ) ->
			_tblname = data[ 'table' ]
			_tblrows = data[ 'data' ]

			flux.dispatcher.dispatch {actionType: 'log.info', msg: 'called datastoreInMemory.insert() on table: ' + _tblname}

			result = 0
			for row in _tblrows
				newrow = []
				for key, val of row
					if key not in this.schema[ _tblname ]
						throw new Error key + " is not defined in schema" 
					else
						newrow[ key ] = val

				newrow[ 'pk' ] = this.datastore[ _tblname ].length
				this.datastore[ _tblname ].push newrow
				result += 1

			result


		select: ( data ) ->
			_tblname = data[ 'table' ]
			_query = data[ 'select' ]

			flux.dispatcher.dispatch {actionType: 'log.info', msg: 'called datastoreInMemory.select() on table: ' + _tblname}

			result = []
			for key, val of _query
				for index of this.datastore[ _tblname ]
					_match = this.datastore[ _tblname ][index][key].toString().match( val ) 
					if _match and _match[0] is this.datastore[ _tblname ][index][key].toString()
						result.push this.datastore[ _tblname ][index]

			result

		update: ( data )->
			_tblname = data[ 'table' ]
			_query = data[ 'select' ]
			_update = data[ 'update' ]

			flux.dispatcher.dispatch {actionType: 'log.info', msg: 'called datastoreInMemory.update() on table: ' + _tblname}

			result = 0

			for key, val of _query
				for index of this.datastore[ _tblname ]
					_match = this.datastore[ _tblname ][index][key].toString().match( val ) 
					if _match and _match[0] is this.datastore[ _tblname ][index][key].toString()
						result += 1
						for u_key, u_val of _update							
							this.datastore[ _tblname ][index][u_key] = u_val

			result



		delete: ( data ) ->
			_tblname = data[ 'table' ]
			_query = data[ 'select' ]

			flux.dispatcher.dispatch {actionType: 'log.info', msg: 'called datastoreInMemory.delete() on table: ' + _tblname}

			result = []
			for key, val of _query
				for index of this.datastore[ _tblname ]
					_match = this.datastore[ _tblname ][index][key].toString().match( val )
					#dump "key: "+ key + " val: " + val + " match: " + _match
					if _match and _match[0] is this.datastore[ _tblname ][index][key].toString()
						result.push index

			adjust = 0
			for index in result
				this.datastore[ _tblname ].splice (index - adjust) ,1
				adjust += 1

			result.length





	inMemoryDatastore