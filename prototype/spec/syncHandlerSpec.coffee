define ['syncHandler'], (SyncHandler) ->
	describe 'checking basic setup', ->
		beforeEach () ->
			@SH = new SyncHandler()
			@SH.define( 'users', 
				user: { type: SyncHandler.STRING }
				lastname: { type: SyncHandler.STRING }
			)
			@SH.run()
			

		it 'app sould be able to get instanciated', ->
			expect(@SH).toBeDefined

		it 'schould use opts:DatastoreConfig or false', ->
			expect(new SyncHandler().DatastoreConfig).toEqual false

		it 'should startup a Datastore', ->
			###!!! this test might not work !!!###
			expect( @SH.Datastore ).toBeDefined


		it 'schould accept messages', ->
			expect( @SH.dispatch({}) ).toBe false

		it 'should accept put messages', ->
			message = 
				ressourece: ""
				data : ""
		
			result = @SH.dispatch({ actionType: "put", msg: message })

			expect( result ).toBe 0

		it 'should execute put actions', ->
			u1 = []
			u1['user'] = "Martin"
			u1['lastname'] = "Eigenmann"

			message =
				ressource: "users"
				data: [ u1 ]
		
			result = @SH.dispatch({ actionType: "put", msg: message })

			expect( @SH.Datastore.datastore['users'][0]['user']).toEqual "Martin"
			expect( result ).toBe 1

		it 'set default fields created, modified and guid', ->
			@SH.define( 'users', {
				user: { type: SyncHandler.STRING }
				lastname: { type: SyncHandler.STRING }
			})
			@SH.run()

			expect( @SH.Datastore.schema['users'][2] ).toEqual 'created'
			expect( @SH.Datastore.schema['users'][3] ).toEqual 'modified'
			expect( @SH.Datastore.schema['users'][4] ).toEqual 'id'

		it 'should execute put actions and insert create, modified and id', ->
			u1 = []
			u1['user'] = "Martin"
			u1['lastname'] = "Eigenmann"

			message =
				ressource: "users"
				data: [ u1 ]
		
			result = @SH.dispatch({ actionType: "put", msg: message })

			expect( @SH.Datastore.datastore['users'][0]['user']).toEqual "Martin"
			expect( result ).toBe 1

			expect( @SH.Datastore.datastore['users'][0]['id'].length ).toEqual 36
			expect( @SH.Datastore.datastore['users'][0]['created']).toEqual jasmine.any( Number )
			expect( @SH.Datastore.datastore['users'][0]['modified']).toEqual jasmine.any( Number )

	describe 'get/update/delete', ->
		beforeEach () ->
			@SH = new SyncHandler()
			@SH.define( 'users', 
				user: { type: SyncHandler.STRING }
				lastname: { type: SyncHandler.STRING }
			)
			@SH.run()

			u1 = []
			u1['user'] = "Martin"
			u1['lastname'] = "Eigenmann"

			u2 = []
			u2['user'] = "Domenik"
			u2['lastname'] = "Eigenmann"

			u3 = []
			u3['user'] = "Fabian"
			u3['lastname'] = "Eison"

			message =
				ressource: "users"
				data: [ u1, u2, u3 ]
			result = @SH.dispatch({ actionType: "put", msg: message })

		it 'should execute get actions', ->
			message =
				ressource: "users"
				data: { pk: "0" }

			result = @SH.dispatch({ actionType: "get", msg: message })
			expect( result[0]['user'] ).toEqual "Martin"

		it 'should execute update actions', ->
			message =
				ressource: "users"
				data: { select: {pk: "0"}, update:{ user: "Maddin", id: @SH.Datastore.datastore['users'][0]['id']} }

			result = @SH.dispatch({ actionType: "update", msg: message })
			expect( result ).toEqual 1
			expect( @SH.Datastore.datastore['users'][0]['user'] ).toEqual "Maddin"

		it 'should execute delete action', ->
			message =
				ressource: "users"
				data: { pk: "0" }
			result = @SH.dispatch({ actionType: "delete", msg: message })
			expect( result ).toEqual 1
			expect( @SH.Datastore.datastore['users'][0]['user'] ).toEqual "Domenik"


	describe 'define datastructure', ->
		beforeEach () ->
			@SH = new SyncHandler()

		it 'defines "define" as a function', ->
			expect( @SH.define() ).toBeDefined

		it 'creates structure', ->
			@SH.define( 'users', {
				user: { type: SyncHandler.STRING }
				lastname: { type: SyncHandler.STRING }
			})
			@SH.run()

			expect( @SH.Datastore.datastore['users'] ).toBeDefined
			expect( @SH.Datastore.schema['users'][0] ).toEqual 'user'


		it 'update schould check id by default', ->
			@SH.define( 'users', {
				first_name: { }
				last_name: 	{ }
				user_name: 	{ }
				birthday: 	{ }
				note: 		{ }
			})
			@SH.run()

			u1 = []
			u1['first_name'] = "Martin"
			u1['last_name'] = "Eigenmann"

			u2 = []
			u2['first_name'] = "Domenik"
			u2['last_name'] = "Eigenmann"

			u3 = []
			u3['first_name'] = "Fabian"
			u3['last_name'] = "Eison"

			message =
				ressource: "users"
				data: [ u1, u2, u3 ]
			@SH.dispatch({ actionType: "put", msg: message })

			message =
				ressource: "users"
				data: { pk: 0 }
			result = @SH.dispatch({ actionType: "get", msg: message })

			u1 = []
			u1['first_name'] = "Maddin"
			u1['last_name'] = "Eigenmann"
			u1['pk'] = 0
			u1['id'] = result[0]['id']

			message =
				ressource: "users"
				data: { select: { pk: u1['pk'] }, update: u1 }
			@SH.dispatch({ actionType: "update", msg: message })

			expect( @SH.Datastore.datastore['users'][0]['first_name'] ).toEqual "Maddin"

			u1 = []
			u1['first_name'] = "Martin"
			u1['last_name'] = "Eigenmann"
			u1['pk'] = 0
			u1['id'] = "b2628b33-fecd-48cf-ba55-8fee7ef99fa9"

			message =
				ressource: "users"
				data: { select: { pk: u1['pk'] }, update: u1 }
			
			SH = @SH
			func = () ->
				SH.dispatch({ actionType: "update", msg: message })

			expect( func ).toThrowError "You are trying to update an already changed element"

			
		it '', ->
			@SH.define( 'users', {
				first_name: { type: SyncHandler.STRING, 	kind: SyncHandler.STATIC, 	group: "user_name" }
				last_name: 	{ type: SyncHandler.STRING, 								group: "user_name" }
				user_name: 	{ type: SyncHandler.STRING, 	kind: SyncHandler.DYNAMIC, 	group: "user_name" }
				birthday: 	{ type: SyncHandler.DATE, 		kind: SyncHandler.STATIC, 					   }
				note: 		{ type: SyncHandler.TEXT, 		context: "user_name", 		group: "user_info" }
			})
			@SH.run()
			message =
				ressource: "users"
				data: { pk: 0 }
			result = @SH.dispatch({ actionType: "get", msg: message })