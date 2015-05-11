define [ 's_api' ], ( api ) ->

	describe 'Server API', ->
		beforeEach () ->
			@socket = {}
			@socket.on = jasmine.createSpy( "on" ).and.callFake () ->
				return true

		afterEach () ->
			@socket = {}

		it 'constructor takes socket as argument', ->
			Api = new api( @socket )
			expect( @socket ).toHaveBeenCalled

		it 'constructor throws error if no socket argument is given', ->
			func = () ->
				Api = new api()

			expect( func ).toThrow Error "API.constructor - constructor needs a socket"

		it 'constructor calls socket.on', ->
			Api = new api( @socket )
			expect( @socket.on ).toHaveBeenCalledWith 'message', jasmine.any Function

