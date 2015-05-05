define [
		'src/datastoreInMemory'
	], ( 
		inMemoryDatastore
	) ->
	describe 'inMemoryDatastore', ->
		it 'should be defined', ->
			expect( inMemoryDatastore ).toBeDefined

		it 'should be a function', ->
			expect( inMemoryDatastore ).toEqual( jasmine.any(Function) )

		it 'should be instancable', ->
			iStore = new inMemoryDatastore
			expect( iStore ).toEqual( jasmine.any(Object) )

	describe 'init', ->
		it 'sould create a 2 attr table', ->
			iStore = new inMemoryDatastore
			iStore.init({
				tables: [ users: [ 'firstname', 'lastname' ] ]
			})

			expect( iStore.schema['users'] ).toEqual ['firstname', 'lastname']

		it 'schould be callable via constructor', ->
			iStore = new inMemoryDatastore({
				tables: [ users: [ 'firstname' ] ]
			})

			expect( iStore.schema['users'] ).toEqual ['firstname' ]

		it 'schould handle schema dependencies', ->
			@iStore = new inMemoryDatastore
			@iStore.init({
				tables: [
					users: {
						'gender': 		{ struct:'enum', type:'static', 					group:'' },
						'firstname': 	{ struct:'text', type:'depend', 	context:'name', group:'name' },
						'lastname': 	{ struct:'text', type:'depend', 	context:'name', group:'name' },
						'username': 	{ struct:'text', type:'dynamic', 	context:'name',	group:'name' },
						'email': 		{ struct:'text', type:'excl', 						group:'' },
						'street': 		{ struct:'text', type:'excl', 						group:'location' },
						'city': 		{ struct:'text', type:'excl', 						group:'location' },
						'state': 		{ struct:'text', type:'dynamic', 	context:'zip',	group:'location' },
						'zip': 			{ struct:'text', type:'excl', 						group:'location' },
						'job': 			{ struct:'text', type:'excel', 						group:'' },
						'phone': 		{ struct:'text', type:'excel', 						group:'' },
						'cell': 		{ struct:'text', type:'excel', 						group:'' },
						'registered': 	{ struct:'text', type:'static', 					group:'' }
						'lastlogin': 	{ struct:'text', type:'temp', 						group:'' }
					}
				]
			})
			expect( @iStore.schema['users']['gender']['type'] ).toEqual "static"

	describe 'insert', ->
		beforeEach () ->
			@iStore = new inMemoryDatastore
			@iStore.init({
				tables: [ users: [ 'user', 'lastname' ] ]
			})

		it 'schould be able to insert multiple rows', ->
			@iStore.insert({
				table: 'users',
				data: [[ user: "Martin" ],
					   [ user: "Domenik" ]]
			})

			expect( @iStore.datastore['users'][0]['user'] ).toEqual  "Martin"

		it 'schould be able to insert multiple rows (2 attributes)', ->
			@iStore.insert({
				table: 'users',
				data: [[ user: "Martin", lastname: "Eigenmann" ],
					   [ user: "Domenik", lastname: "Eigenmann" ]]
			})
			expect( @iStore.datastore['users'][0]['user'] ).toEqual "Martin"
			expect( @iStore.datastore['users'][1]['lastname'] ).toEqual "Eigenmann"
		
		it 'schould only insert data to defined schema-fields', ->
			iStore = @iStore
			func = () -> 
				iStore.insert({
					table: 'users',
					data: [[ user: "Martin", age: "20" ]]
				})

			expect( func ).toThrowError "age is not defined in schema"

	describe 'get', ->
		beforeEach () ->
			@iStore = new inMemoryDatastore
			@iStore.init({
				tables: [ users: [ 'user', 'lastname' ] ]
			})
			@iStore.insert({
				table: 'users'
				data: [[ user: "Martin", lastname: "Eigenmann" ],
					   [ user: "Domenik", lastname: "Eigenmann" ],
					   [ user: "Fabian", lastname: "Eison" ]]
			})

		it 'schould read single element (pk=0)', ->
			expect( @iStore.get({ table: 'users', query: { pk: "0" } } )[0]['user'] ).toEqual "Martin"

		it 'schould read multiple elements (lastname="Eigenmann")', ->
			expect( @iStore.get( { table: 'users', query: { lastname: "Eigenmann" } } )[0]['user'] ).toEqual "Martin"
			expect( @iStore.get( { table: 'users', query: { lastname: "Eigenmann" } } )[1]['user'] ).toEqual "Domenik"

		it 'schould read evaluate wildcards (lastname=/Eis.*/)', ->
			expect( @iStore.get( { table: 'users', query: { lastname: /Eis.*/ } } )[0]['user'] ).toEqual "Fabian"

		it 'schould read only requested elements (lastname=/Eis/)', ->
			expect( @iStore.get( { table: 'users', query: { lastname: /Eis/ } } ).length ).toEqual 0
