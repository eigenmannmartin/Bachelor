define ['api', 'flux', 'syncHandler'], (api, flux, syncHandler) ->

	describe 'API basic setup', ->
		beforeEach () ->
			SH = new syncHandler()
			SH.define( 'users', {
				first_name: { }
				last_name: 	{ }
				user_name: 	{ }
				birthday: 	{ }
				note: 		{ }
			})
			SH.run()

			@Server = new api()
			@Server.configure({
				type: api.SERVER
				url: "/local/"
				syncmgr: SH
			})

		it 'api sould be able to get instanciated', ->
			Api = new api()
			expect(Api).toBeDefined

		it 'schould take client setup', ->
			Api = new api()
			Api.configure({
				type: api.CLIENT
				url: "/local/"
				server: @Server
			})

			expect( api.CLIENT ).toEqual "client"
			expect( Api.url ).toEqual "/local/"
			expect( Api.type ).toEqual api.CLIENT
			expect( Api.srv ).toEqual @Server

		describe 'schould take messages to dispatch', ->
			beforeEach ()->
				@Api = new api()

				@Api.configure({
					type: api.CLIENT
					url: "/local/"
					server: @Server
				})

			it 'put/get action', ->
				u1 = []
				u1['first_name'] = "Martin"
				u1['last_name'] = "Eigenmann"

				@Api.dispatch({
					type: api.PUT,
					ressource: 'users'
					latest: u1
					token: '1234'
				})

				expect( @Api.srv.syncmgr.Datastore.datastore['users'][0]['first_name'] ).toEqual u1['first_name']


				result = @Api.dispatch({
					type: api.GET,
					ressource: 'users'
					id: 0
					token: '1234'
				})

				expect( result.length ).toEqual 1
				expect( result[0]['first_name'] ).toEqual "Martin"

			it 'update action', ->
				u1 = []
				u1['first_name'] = "Martin"
				u1['last_name'] = "Eigenmann"

				@Api.dispatch({
					type: api.PUT,
					ressource: 'users'
					latest: u1
					token: '1234'
				})

				u2 = []
				u2['first_name'] = "Maddin"
				u2['id'] = @Api.srv.syncmgr.Datastore.datastore['users'][0]['id']


				result = @Api.dispatch({
					type: api.UPDATE,
					ressource: 'users'
					id: 0 
					latest: u2
					recent: u1
					token: '1234'
				})

				expect( result.length ).toEqual 1
				expect( result[0]['first_name'] ).toEqual "Maddin"

