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
			u1 = []
			u1['user'] = "Martin"

			u2 = []
			u2['user'] = "Domenik"

			@iStore.insert({
				table: 'users',
				data: [u1, u2]
			})

			expect( @iStore.datastore['users'][0]['user'] ).toEqual  "Martin"

		it 'schould be able to insert multiple rows (2 attributes)', ->
			u1 = []
			u1['user'] = "Martin"
			u1['lastname'] = "Eigenmann"

			u2 = []
			u2['user'] = "Domenik"
			u2['lastname'] = "Eigenmann"

			@iStore.insert({
				table: 'users',
				data: [u1, u2]
			})
			expect( @iStore.datastore['users'][0]['user'] ).toEqual "Martin"
			expect( @iStore.datastore['users'][1]['lastname'] ).toEqual "Eigenmann"
		
		it 'schould only insert data to defined schema-fields', ->
			u1 = []
			u1['user'] = "Martin"
			u1['age'] = "20"

			iStore = @iStore
			func = () -> 
				iStore.insert({
					table: 'users',
					data: [u1]
				})

			expect( func ).toThrowError "age is not defined in schema"

	describe 'select/update/delete', ->
		beforeEach () ->
			@iStore = new inMemoryDatastore
			@iStore.init({
				tables: [ users: [ 'user', 'lastname' ] ]
			})

			u1 = []
			u1['user'] = "Martin"
			u1['lastname'] = "Eigenmann"

			u2 = []
			u2['user'] = "Domenik"
			u2['lastname'] = "Eigenmann"

			u3 = []
			u3['user'] = "Fabian"
			u3['lastname'] = "Eison"

			@iStore.insert({
				table: 'users'
				data: [u1, u2, u3]
			})

		describe 'select', ->

			xit 'table must be defined', ->
				iStore = @iStore
				func = () -> 
					iStore.select({ query: { pk: 0 } })
				expect( func ).toThrowError "table is not defined"

			it 'schould read single element (pk=0)', ->
				expect( @iStore.select({ table: 'users', select: { pk: "0" } } )[0]['user'] ).toEqual "Martin"

			it 'schould read multiple elements (lastname="Eigenmann")', ->
				expect( @iStore.select( { table: 'users', select: { lastname: "Eigenmann" } } )[0]['user'] ).toEqual "Martin"
				expect( @iStore.select( { table: 'users', select: { lastname: "Eigenmann" } } )[1]['user'] ).toEqual "Domenik"

			it 'schould read evaluate wildcards (lastname=/Eis.*/)', ->
				expect( @iStore.select( { table: 'users', select: { lastname: /Eis.*/ } } )[0]['user'] ).toEqual "Fabian"

			it 'schould read only requested elements (lastname=/Eis/)', ->
				expect( @iStore.select( { table: 'users', select: { lastname: /Eis/ } } ).length ).toEqual 0

		describe 'update', ->

			it 'should update sinlge element (pk=0)', ->
				@iStore.update({ table: 'users', select: { pk: 0 }, update: {user: "Maddin", lastname: "Eigenmann"} })
				expect( @iStore.datastore['users'][0]['user'] ).toEqual "Maddin"

			it 'schould update multiple elements (lastname="Eigenmann")', ->
				@iStore.update({ table: 'users', select: { lastname: "Eigenmann" }, update: {user: "Maddin", lastname: "Eigenmann"} })
				expect( @iStore.datastore['users'][0]['user'] ).toEqual "Maddin"
				expect( @iStore.datastore['users'][1]['user'] ).toEqual "Maddin"
				expect( @iStore.datastore['users'][2]['user'] ).toEqual "Fabian"

			it 'schould update multiple elements (user=/Fa.*/)', ->
				@iStore.update({ table: 'users', select: { user: /Fa.*/ }, update: {user: "Fäbi", lastname: "Eison"} })
				expect( @iStore.datastore['users'][0]['user'] ).toEqual "Martin"
				expect( @iStore.datastore['users'][1]['user'] ).toEqual "Domenik"
				expect( @iStore.datastore['users'][2]['user'] ).toEqual "Fäbi"

			it 'sould only update given elements', ->
				@iStore.update({ table: 'users', select: { pk: 0 }, update: {user: "Maddin"} })
				expect( @iStore.datastore['users'][0]['lastname'] ).toEqual "Eigenmann"

		describe 'delete', ->

			it 'should delete single element (pk=1)', ->
				@iStore.delete({ table: 'users', select: { pk: "1" } })
				expect( @iStore.datastore['users'][0]['pk'] ).toEqual 0
				expect( @iStore.datastore['users'][1]['pk'] ).toEqual 2

			it 'schould delete multiple elements (lastname="Eigenmann")', ->
				result = @iStore.delete({ table: 'users', select: { lastname: "Eigenmann" } })
				expect( result ).toBe 2
				expect( @iStore.datastore['users'].length ).toEqual 1

			it 'schould delete multiple elements (lastname=/Eis.{7}/)', ->
				result = @iStore.delete({ table: 'users', select: { lastname: /Ei.{7}/ } })
				expect( result ).toBe 2
				expect( @iStore.datastore['users'].length ).toEqual 1
