define ['server_storage', 'flux'], (storage, flux) ->

	describe 'Server Logic', ->
		beforeEach () ->
			@TestData =
				Object1:
					name: "Säntis"
					seats: 12
					ac: true

			@Sequelize =
				Room:
					find: jasmine.createSpy( "find" )
					findAll: jasmine.createSpy( "findAll" ).and.returnValue [@TestData.Object1]


			@Storage = new storage( @Sequelize )


		afterEach () ->
			@Storage = null


		describe 'public API', ->
			it 'constructor returns a Object', ->
				expect( @Storage ).toBeDefined
				expect( @Storage ).toEqual jasmine.any Object

			it 'offers a dispatch function', ->
				expect( @Storage.dispatch ).toEqual jasmine.any Function

			it 'constructor takes a sequelize instance', ->
				Storage = new storage( @Sequelize )
				expect( Storage.Sequelize ).toEqual @Sequelize

			it 'constructor throws an error if no sequelize instance was passed', ->
				func = () ->
					new storage()
				expect( func ).toThrowError "you need to pass a sequelize instance"

		describe 'private API', ->
			it 'offers _select method', ->
				expect( @Storage._select ).toEqual jasmine.any Function

			it 'offers _insert method', ->
				expect( @Storage._insert ).toEqual jasmine.any Function

			it 'offers _update method', ->
				expect( @Storage._update ).toEqual jasmine.any Function

			it 'offers _delete method', ->
				expect( @Storage._delete ).toEqual jasmine.any Function

			it 'offers _send_message method', ->
				expect( @Storage._send_message ).toEqual jasmine.any Function

			it '_send_message calls flux dispatcher', ->
				flux.doAction = jasmine.createSpy( "doAction" ).and.callFake () -> true
				@Storage._send_message 'S_LOGIC_SM_get', { meta: { model: "model" } }

				expect( flux.doAction ).toHaveBeenCalledWith 'S_LOGIC_SM_get', jasmine.any Object

		describe 'dispatch function working correctly', ->
			it 'calls _select function on S_STORAGE_DB_select message', ->
				@Storage._select = jasmine.createSpy( "_select" ).and.callFake () -> true
				@Storage.dispatch 'S_STORAGE_DB_select', { meta: { model: "model" } }
				
				expect( @Storage._select ).toHaveBeenCalledWith jasmine.any Object

			it 'calls _put function on S_STORAGE_DB_insert message', ->
				@Storage._insert = jasmine.createSpy( "_insert" ).and.callFake () -> true
				@Storage.dispatch 'S_STORAGE_DB_insert', { meta: { model: "model" }, data: {} }

				expect( @Storage._insert ).toHaveBeenCalledWith jasmine.any Object

			it 'calls _update function on S_STORAGE_DB_update message', ->
				@Storage._update = jasmine.createSpy( "_update" ).and.callFake () -> true
				@Storage.dispatch 'S_STORAGE_DB_update', { meta: { model: "model" }, data: {} }

				expect( @Storage._update ).toHaveBeenCalledWith jasmine.any Object

			it 'calls _delete function on S_STORAGE_DB_delete message', ->
				@Storage._delete = jasmine.createSpy( "_delete" ).and.callFake () -> true
				@Storage.dispatch 'S_STORAGE_DB_delete', { meta: { model: "model" }, data: {} }

				expect( @Storage._delete ).toHaveBeenCalledWith jasmine.any Object


		describe 'interaction with sequelize', ->
			it '_select does execute correct sequelize calls', ->
				result = @Storage._select { meta: { model: "Room" } }

				expect( @Sequelize.Room.findAll.calls.count() ).toEqual 1
				expect( @Sequelize.Room.findAll ).toHaveBeenCalledWith
				expect( result ).toEqual [ @TestData.Object1 ]
