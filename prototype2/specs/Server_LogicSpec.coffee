define [ 'server_logic', 'flux' ], ( logic, flux ) ->

	describe 'Server Logic', ->
		beforeEach () ->
			@Socket = {}

			@TestData =
				Object1:
					id: 1
					name: "Säntis"
					seats: 12
					ac: true

				Return1:
					id: 1
					name: "Säntis"
					seats: 12
					ac: true
					then: jasmine.createSpy( "then" )
					updateAttributes: jasmine.createSpy( "updateAttributes" )
					destory: jasmine.createSpy( "destory" )

				Object2:
					id: 1
					name: "Säntis2"
					seats: 12
					ac: true

				Return2:
					id: 1
					name: "Säntis"
					seats: 12
					ac: true
					then: jasmine.createSpy( "then" )
					updateAttributes: jasmine.createSpy( "updateAttributes" )
					destory: jasmine.createSpy( "destory" )

			@Sequelize =
				Room:
					find: jasmine.createSpy( "find" ).and.returnValue @TestData.Return1
					findAll: jasmine.createSpy( "findAll" ).and.returnValue [ @TestData.Return1 ]
					create: jasmine.createSpy( "create" ).and.returnValue @TestData.Return1

			@Logic = new logic( @Sequelize )

		afterEach () ->
			@Logic = null

		describe 'Business logic ;-)', ->
			it 'get a single element (private)', ->
				message = meta:{ model:"Room", socket:@Socket, id:1 }
				@Logic._DB_select = jasmine.createSpy( "_DB_select" ).and.returnValue @TestData.Return1
				@Logic._send_message = jasmine.createSpy( "_send_message" )

				r = @Logic._get message
				expect( @Logic._DB_select ).toHaveBeenCalledWith message
				#expect( @Logic._send_message ).toHaveBeenCalledWith 'S_API_WEB_send', { meta:{ model:"Room", socket:@Socket }, data: @TestData.Return1 }

			it 'TBI - get a single element (public)', ->
				me = @
				message = meta:{ model:"Room", id:1 }
				func = () ->
					me.Logic._get message
				expect( func ).toThrowError "not implemented yet!"

			it 'create a single element', ->
				message = meta:{ model:"Room" }, data:{ obj: @TestData.Object1 }
				@Logic._DB_insert = jasmine.createSpy( "_insert" ).and.returnValue @TestData.Return1
				@Logic._send_message = jasmine.createSpy( "_send_message" )

				@Logic._create message

				expect( @Logic._DB_insert ).toHaveBeenCalledWith meta:{ model:"Room" }, data: @TestData.Object1
				#expect( @Logic._send_message ).toHaveBeenCalledWith 'S_API_WEB_send', { meta:{ model:"Room" }, data: @TestData.Return1 }

			it 'update a single, non changed element', ->
				message = meta:{ model:"Room" }, data:{ obj:@TestData.Object2, prev:@TestData.Object1 }

				@Logic._DB_update = jasmine.createSpy( "_update" ).and.returnValue @TestData.Return2
				@Logic._send_message = jasmine.createSpy( "_send_message" )

				@Logic._update message

				expect( @Logic._DB_update ).toHaveBeenCalledWith meta:{ model:"Room" }, data: @TestData.Object2
				#expect( @Logic._send_message ).toHaveBeenCalledWith 'S_API_WEB_send', { meta:{ model:"Room" }, data: @TestData.Return2 }


			it 'delete a single, non changed element', ->
				message = meta:{ model:"Room" }, data:{ obj:@TestData.Object1 }

				@Logic._DB_delete = jasmine.createSpy( "_update" ).and.returnValue @TestData.Return1
				@Logic._send_message = jasmine.createSpy( "_send_message" )

				@Logic._delete message

				expect( @Logic._DB_delete ).toHaveBeenCalledWith meta:{ model:"Room" }, data: @TestData.Object1
				#expect( @Logic._send_message ).toHaveBeenCalledWith 'S_API_WEB_send', { meta:{ model:"Room", deleted:true }, data: @TestData.Return1 }


			it 'Sync:repeatable', ->
				expect( @Logic.sync._repeatable ).toEqual jasmine.any Function
				data = {}
				db_obj = a: 5
				new_obj = a: 3
				prev_obj = a: 4
				attr = 'a'

				@Logic.sync._repeatable( data, db_obj, new_obj, prev_obj, attr )

			it 'Sync:combining', ->
				expect( @Logic.sync._combining ).toEqual jasmine.any Function

				data = {}
				db_obj = a: 5
				new_obj = a: 3
				prev_obj = a: 4
				attr = 'a'

				@Logic.sync._combining( data, db_obj, new_obj, prev_obj, attr )
				

			it 'Sync:traditional', ->
				expect( @Logic.sync._traditional ).toEqual jasmine.any Function

				data = {}
				db_obj = a: 5
				new_obj = a: 3
				prev_obj = a: 4
				attr = 'a'

				@Logic.sync._traditional( data, db_obj, new_obj, prev_obj, attr )

			it 'Sync:contextual', ->
				expect( @Logic.sync._contextual ).toEqual jasmine.any Function

				data = {}
				db_obj = a: 5
				new_obj = a: 3
				prev_obj = a: 4
				attr = 'a'

				@Logic.sync._contextual( data, db_obj, new_obj, prev_obj, attr )

		
			it '', ->
			it '', ->
			it '', ->
			it '', ->
			it '', ->
			it '', ->
			it '', ->
			it '', ->
			it '', ->


		describe 'public API', ->
			it 'constructor returns a Object', ->
				expect( @Logic ).toBeDefined
				expect( @Logic ).toEqual jasmine.any Object

			it 'offers a dispatch function', ->
				expect( @Logic.dispatch ).toEqual jasmine.any Function

			it 'constructor takes a sequelize instance', ->
				Logic = new logic( @Sequelize )
				expect( Logic.Sequelize ).toEqual @Sequelize

			it 'constructor throws an error if no sequelize instance was passed', ->
				func = () ->
					new logic()
				expect( func ).toThrowError "you need to pass a sequelize instance"


		describe 'private API', ->
			it 'offers _get method', ->
				expect( @Logic._get ).toEqual jasmine.any Function

			it 'offers _put method', ->
				expect( @Logic._create ).toEqual jasmine.any Function

			it 'offers _update method', ->
				expect( @Logic._update ).toEqual jasmine.any Function

			it 'offers _delete method', ->
				expect( @Logic._delete ).toEqual jasmine.any Function

			it 'offers _send_message method', ->
				expect( @Logic._send_message ).toEqual jasmine.any Function

			it '_send_message calls flux dispatcher', ->
				flux.doAction = jasmine.createSpy( "doAction" ).and.callFake () -> true
				@Logic._send_message 'S_LOGIC_SM_get', { meta: { model: "model" } }

				expect( flux.doAction ).toHaveBeenCalledWith 'S_LOGIC_SM_get', jasmine.any Object


		describe 'dispatch function working correctly', ->
			it 'calls _get function on S_LOGIC_SM_get message', ->
				@Logic._get = jasmine.createSpy( "_get" ).and.callFake () -> true
				@Logic.dispatch 'S_LOGIC_SM_get', { meta: { model: "model" } }
				
				expect( @Logic._get ).toHaveBeenCalledWith jasmine.any Object

			it 'calls _create function on S_LOGIC_SM_create message', ->
				@Logic._create = jasmine.createSpy( "_put" ).and.callFake () -> true
				@Logic.dispatch 'S_LOGIC_SM_create', { meta: { model: "model" }, data: {} }

				expect( @Logic._create ).toHaveBeenCalledWith jasmine.any Object

			it 'calls _update function on S_LOGIC_SM_update message', ->
				@Logic._update = jasmine.createSpy( "_update" ).and.callFake () -> true
				@Logic.dispatch 'S_LOGIC_SM_update', { meta: { model: "model" }, data: {} }

				expect( @Logic._update ).toHaveBeenCalledWith jasmine.any Object

			it 'calls _delete function on S_LOGIC_SM_delete message', ->
				@Logic._delete = jasmine.createSpy( "_delete" ).and.callFake () -> true
				@Logic.dispatch 'S_LOGIC_SM_delete', { meta: { model: "model" }, data: {} }

				expect( @Logic._delete ).toHaveBeenCalledWith jasmine.any Object



		describe 'interaction with sequelize', ->
			it '_DB_select does execute correct sequelize calls (find all)', ->
				result = @Logic._DB_select { meta: { model: "Room" } }

				expect( @Sequelize.Room.findAll.calls.count() ).toEqual 1
				expect( @Sequelize.Room.findAll ).toHaveBeenCalledWith
				expect( result ).toEqual [ @TestData.Return1 ]

			it '_DB_select does execute correct sequelize calls (find one)', ->
				result = @Logic._DB_select { meta: { model: "Room", id: 1} }

				expect( @Sequelize.Room.find.calls.count() ).toEqual 1
				expect( @Sequelize.Room.find ).toHaveBeenCalledWith 1
				expect( result ).toEqual @TestData.Return1

			it '_DB_insert does execute correct sequelize calls', ->		
				result = @Logic._DB_insert { meta: { model: "Room" }, data: @TestData.Object1 }

				expect( @Sequelize.Room.create.calls.count() ).toEqual 1
				expect( @Sequelize.Room.create ).toHaveBeenCalledWith @TestData.Object1
				expect( result ).toEqual @TestData.Return1

			it '_DB_update does execute correct sequelize calls', ->
				# TODO: call updateAttributes is not watched
				result = @Logic._DB_update { meta: { model: "Room" }, data: @TestData.Object1 }

				expect( @Sequelize.Room.find.calls.count() ).toEqual 1
				expect( @TestData.Return1.then.calls.count() ).toEqual 1

				expect( @Sequelize.Room.find ).toHaveBeenCalledWith @TestData.Object1.id
				expect( @TestData.Return1.then ).toHaveBeenCalledWith jasmine.any Function

			it '_DB_delete does execute correct sequelize calls', ->
				# TODO: call destroy is not watched
				result = @Logic._DB_delete { meta: { model: "Room" }, data: @TestData.Object1 }

				expect( @Sequelize.Room.find.calls.count() ).toEqual 1
				expect( @TestData.Return1.then.calls.count() ).toEqual 1

				expect( @Sequelize.Room.find ).toHaveBeenCalledWith @TestData.Object1.id
