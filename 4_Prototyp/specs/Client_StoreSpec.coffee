define ['client_store'], (store) ->

	describe 'Client Stores', ->
		it 'constructor returns a Object', ->
				expect( store ).toBeDefined
				expect( store ).toEqual jasmine.any Object


