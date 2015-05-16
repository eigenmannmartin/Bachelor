define [ 'server_logic', 'flux' ], ( logic, flux ) ->

	describe 'Server Logic', ->
		beforeEach () ->
			@Logic = new logic()

		afterEach () ->
			@Logic = null


		describe 'public API', ->
			it 'constructor returns a Object', ->
				expect( @Logic ).toBeDefined
				expect( @Logic ).toEqual jasmine.any Object

			it 'offers a dispatch function', ->
				expect( @Logic.dispatch ).toEqual jasmine.any Function


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

			it 'calls _put function on S_LOGIC_SM_create message', ->
				@Logic._put = jasmine.createSpy( "_put" ).and.callFake () -> true
				@Logic.dispatch 'S_LOGIC_SM_create', { meta: { model: "model" }, data: {} }

				expect( @Logic._put ).toHaveBeenCalledWith jasmine.any Object

			it 'calls _update function on S_LOGIC_SM_update message', ->
				@Logic._update = jasmine.createSpy( "_update" ).and.callFake () -> true
				@Logic.dispatch 'S_LOGIC_SM_update', { meta: { model: "model" }, data: {} }

				expect( @Logic._update ).toHaveBeenCalledWith jasmine.any Object

			it 'calls _delete function on S_LOGIC_SM_delete message', ->
				@Logic._delete = jasmine.createSpy( "_delete" ).and.callFake () -> true
				@Logic.dispatch 'S_LOGIC_SM_delete', { meta: { model: "model" }, data: {} }

				expect( @Logic._delete ).toHaveBeenCalledWith jasmine.any Object



		describe '', ->