define [
		'datastoreInMemory'
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

	describe 'select', ->
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
			expect( @iStore.select({ table: 'users', query: { pk: "0" } } )[0]['user'] ).toEqual "Martin"

		it 'schould read multiple elements (lastname="Eigenmann")', ->
			expect( @iStore.select( { table: 'users', query: { lastname: "Eigenmann" } } )[0]['user'] ).toEqual "Martin"
			expect( @iStore.select( { table: 'users', query: { lastname: "Eigenmann" } } )[1]['user'] ).toEqual "Domenik"

		it 'schould read evaluate wildcards (lastname=/Eis.*/)', ->
			expect( @iStore.select( { table: 'users', query: { lastname: /Eis.*/ } } )[0]['user'] ).toEqual "Fabian"

		it 'schould read only requested elements (lastname=/Eis/)', ->
			expect( @iStore.select( { table: 'users', query: { lastname: /Eis/ } } ).length ).toEqual 0
