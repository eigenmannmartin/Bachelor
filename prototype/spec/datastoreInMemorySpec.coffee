define [
		'src/datastoreInMemory'
	], ( 
		inMemoryDatastore
	) ->
	describe 'checking basic setup', ->
		it 'should be defined', ->
			expect( inMemoryDatastore ).toBeDefined

		it 'should be a function', ->
			expect( inMemoryDatastore ).toEqual( jasmine.any(Function) )

		it 'should be able to get instanciated', ->
			iStore = new inMemoryDatastore
			expect( iStore ).toEqual( jasmine.any(Object) )

	describe 'creating tables', ->
		it 'sould create a 2-value Table', ->
			iStore = new inMemoryDatastore
			iStore.init({
				tables: [ users: [ 'firstname', 'lastname' ] ]
			})

			expect( iStore.schema['users'] ).toEqual ['firstname', 'lastname']

		it 'init also callable via constructor', ->
			iStore = new inMemoryDatastore({
				tables: [ users: [ 'firstname' ] ]
			})

			expect( iStore.schema['users'] ).toEqual ['firstname' ]

	describe 'writing data to table', ->
		beforeEach () ->
			@iStore = new inMemoryDatastore
			@iStore.init({
				tables: [ users: [ 'user', 'lastname' ] ]
			})

		it 'insert 2 values to store', ->
			@iStore.insert({
				table: 'users',
				data: [[ user: "Martin" ],
					   [ user: "Domenik" ]]
			})

			expect( @iStore.datastore['users'][0]['user'] ).toEqual  "Martin"

		it 'insert 2 values to store (2 keys)', ->
			@iStore.insert({
				table: 'users',
				data: [[ user: "Martin", lastname: "Eigenmann" ],
					   [ user: "Domenik", lastname: "Eigenmann" ]]
			})
			expect( @iStore.datastore['users'][0]['user'] ).toEqual "Martin"
			expect( @iStore.datastore['users'][1]['lastname'] ).toEqual "Eigenmann"
		
		it 'only insert data to defined schema-fields', ->
			iStore = @iStore
			func = () -> 
				iStore.insert({
					table: 'users',
					data: [[ user: "Martin", age: "20" ]]
				})

			expect( func ).toThrowError "age is not defined in schema"

	describe 'reading from table', ->
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

		it 'single element', ->
			expect( @iStore.get({ table: 'users', query: { pk: "0" } } )[0]['user'] ).toEqual "Martin"

		it 'multiple elements ==', ->
			expect( @iStore.get( { table: 'users', query: { lastname: "Eigenmann" } } )[0]['user'] ).toEqual "Martin"
			expect( @iStore.get( { table: 'users', query: { lastname: "Eigenmann" } } )[1]['user'] ).toEqual "Domenik"

		it 'wildcard search', ->
			expect( @iStore.get( { table: 'users', query: { lastname: /Eis.*/ } } )[0]['user'] ).toEqual "Fabian"

		it 'wildcard search, only match required', ->
			expect( @iStore.get( { table: 'users', query: { lastname: /Eis/ } } ).length ).toEqual 0