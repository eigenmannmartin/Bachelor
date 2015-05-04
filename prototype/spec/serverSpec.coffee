define ['src/server'], ( server ) ->
    describe 'checking basic setup', ->
        it 'should be defined', ->
            expect( server ).toBeDefined

        it 'should be a function', ->
            expect( server ).toEqual( jasmine.any(Function) )

        it 'should be able to get instanciated', ->
        	iServer = new server()
        	expect( iServer ).toEqual( jasmine.any(Object) )

