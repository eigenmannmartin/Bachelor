define ['syncHandler'], (SyncHandler) ->
	describe 'checking basic setup', ->
		beforeEach () ->
			@SH = new SyncHandler( { DatastoreConfig: {
				tables: [ users: [ 'user', 'lastname' ] ]
			}})
			@SH.run()
			

		it 'app sould be able to get instanciated', ->
			expect(@SH).toBeDefined

		it 'schould use opts:DatastoreConfig or false', ->
			expect(new SyncHandler().DatastoreConfig).toEqual false
			expect(new SyncHandler({DatastoreConfig: "test"}).DatastoreConfig).toEqual "test"


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
			message =
				ressource: "users"
				data: [[user: "Martin",lastname: "Eigenmann"]]
		
			result = @SH.dispatch({ actionType: "put", msg: message })

			expect( @SH.Datastore.datastore['users'][0]['user']).toEqual "Martin"
			expect( result ).toBe 1

	describe 'get/update/delete', ->
		beforeEach () ->
			@SH = new SyncHandler( { DatastoreConfig: {
				tables: [ users: [ 'user', 'lastname' ] ]
			}})
			@SH.run()

			message =
				ressource: "users"
				data: [ [user: "Martin",lastname: "Eigenmann"],
						[user: "Domenik",lastname: "Eigenmann"],
						[user: "Fabian", lastname: "Eison" ]]
			result = @SH.dispatch({ actionType: "put", msg: message })

		it 'schould execute get actions', ->
			message =
				ressource: "users"
				data: { pk: "0" }

			result = @SH.dispatch({ actionType: "get", msg: message })
			expect( result[0]['user'] ).toEqual "Martin"

		it 'schould execute update actions', ->
			message =
				ressource: "users"
				data: { select: {pk: "0"}, update:{ user: "Maddin" } }

			result = @SH.dispatch({ actionType: "update", msg: message })
			expect( result ).toEqual 1
			expect( @SH.Datastore.datastore['users'][0]['user'] ).toEqual "Maddin"