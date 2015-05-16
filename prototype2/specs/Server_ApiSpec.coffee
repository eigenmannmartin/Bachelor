define [ 'server_api', 'flux' ], ( api, flux ) ->

	describe 'Server API', ->
		beforeEach () ->
			@Api = new api()

		afterEach () ->
			@Api = null

		describe 'public API', ->
			it 'constructor returns a Object', ->
				expect( @Api ).toBeDefined
				expect( @Api ).toEqual jasmine.any Object

			it 'offers a dispatch function', ->
				expect( @Api.dispatch ).toEqual jasmine.any Function

		describe 'private API', ->
			it 'offers _get method', ->
				expect( @Api._get ).toEqual jasmine.any Function

			it 'offers _put method', ->
				expect( @Api._put ).toEqual jasmine.any Function

			it 'offers _update method', ->
				expect( @Api._update ).toEqual jasmine.any Function

			it 'offers _delete method', ->
				expect( @Api._delete ).toEqual jasmine.any Function

			it 'offers _send_message method', ->
				expect( @Api._send_message ).toEqual jasmine.any Function

		describe 'dispatch function working correctly', ->
			it 'calls _get function on S_API_WEB_get message', ->
				@Api._get = jasmine.createSpy( "_get" ).and.callFake () -> true
				@Api.dispatch 'S_API_WEB_get', { meta: { model: "model" } }
				
				expect( @Api._get ).toHaveBeenCalledWith jasmine.any Object

			it 'calls _put function on S_API_WEB_put message', ->
				@Api._put = jasmine.createSpy( "_put" ).and.callFake () -> true
				@Api.dispatch 'S_API_WEB_put', { meta: { model: "model" }, data: {} }

				expect( @Api._put ).toHaveBeenCalledWith jasmine.any Object

			it 'calls _update function on S_API_WEB_update message', ->
				@Api._update = jasmine.createSpy( "_update" ).and.callFake () -> true
				@Api.dispatch 'S_API_WEB_update', { meta: { model: "model" }, data: {} }

				expect( @Api._update ).toHaveBeenCalledWith jasmine.any Object

			it 'calls _delete function on S_API_WEB_delete message', ->
				@Api._delete = jasmine.createSpy( "_delete" ).and.callFake () -> true
				@Api.dispatch 'S_API_WEB_delete', { meta: { model: "model" }, data: {} }

				expect( @Api._delete ).toHaveBeenCalledWith jasmine.any Object

		describe '_get function delivers correct message for logic layer', ->
			it 'sends S_LOGIC_SM_get message', ->
				@Api._send_message = jasmine.createSpy( "_send_message" ).and.callFake () -> true
				@Api.dispatch 'S_API_WEB_get', { meta: { model: "model" } }

				expect( @Api._send_message ).toHaveBeenCalledWith 'S_LOGIC_SM_get', jasmine.any Object

			it '_send_message call flux.doAction with correct message', ->
				flux.doAction = jasmine.createSpy( "doAction" ).and.callFake () -> true
				@Api.dispatch 'S_API_WEB_get', { meta: { model: "model" } }

				expect( flux.doAction ).toHaveBeenCalledWith 'S_LOGIC_SM_get', jasmine.any Object

		describe '_put function delivers correct message for logic layer', ->
			it 'sends S_LOGIC_SM_create message', ->
				@Api._send_message = jasmine.createSpy( "_send_message" ).and.callFake () -> true
				@Api.dispatch 'S_API_WEB_put', { meta: { model: "model" } }

				expect( @Api._send_message ).toHaveBeenCalledWith 'S_LOGIC_SM_create', jasmine.any Object
			
			it '_send_message call flux.doAction with correct message', ->
				flux.doAction = jasmine.createSpy( "doAction" ).and.callFake () -> true
				@Api.dispatch 'S_API_WEB_put', { meta: { model: "model" } }

				expect( flux.doAction ).toHaveBeenCalledWith 'S_LOGIC_SM_create', jasmine.any Object

		describe '_update function delivers correct message for logic layer', ->
			it 'sends S_LOGIC_SM_create message', ->
				@Api._send_message = jasmine.createSpy( "_send_message" ).and.callFake () -> true
				@Api.dispatch 'S_API_WEB_update', { meta: { model: "model" } }

				expect( @Api._send_message ).toHaveBeenCalledWith 'S_LOGIC_SM_update', jasmine.any Object

			it '_send_message call flux.doAction with correct message', ->
				flux.doAction = jasmine.createSpy( "doAction" ).and.callFake () -> true
				@Api.dispatch 'S_API_WEB_update', { meta: { model: "model" } }

				expect( flux.doAction ).toHaveBeenCalledWith 'S_LOGIC_SM_update', jasmine.any Object

		describe '_delete function delivers correct message for logic layer', ->
			it 'sends S_LOGIC_SM_create message', ->
				@Api._send_message = jasmine.createSpy( "_send_message" ).and.callFake () -> true
				@Api.dispatch 'S_API_WEB_delete', { meta: { model: "model" } }

				expect( @Api._send_message ).toHaveBeenCalledWith 'S_LOGIC_SM_delete', jasmine.any Object

			it '_send_message call flux.doAction with correct message', ->
				flux.doAction = jasmine.createSpy( "doAction" ).and.callFake () -> true
				@Api.dispatch 'S_API_WEB_delete', { meta: { model: "model" } }

				expect( flux.doAction ).toHaveBeenCalledWith 'S_LOGIC_SM_delete', jasmine.any Object