define 'src/datastoreInMemory', [], () ->
	class inMemoryDatastore

		datastore: []
		schema: {}

		constructor: ( opts ) ->
			if opts
				this.init opts 

		init: ( opts ) ->
			this.datastore = []
			this.schema = []
			for tables in opts[ 'tables' ]
				for name,table of tables
					this.schema[ name ] = table
					this.datastore[ name ] = []

		insert: ( data ) ->
			_tblname = data[ 'table' ]
			_tblrows = data[ 'data' ]


			for row in _tblrows
				newrow = []
				for key, val of row[0]
					if key not in this.schema[ _tblname ]
						throw new Error( key + " is not defined in schema" )
					else
						newrow[ key ] = val

				newrow[ 'pk' ] = this.datastore[ _tblname ].length
				this.datastore[ _tblname ].push newrow


		get: ( data ) ->
			_tblname = data[ 'table' ]
			_query = data[ 'query' ]
			result = []
			for key, val of _query
				for index of this.datastore[ _tblname ]
					if this.datastore[ _tblname ][index][key] is val
						result.push this.datastore[ _tblname ][index]

			result



	inMemoryDatastore