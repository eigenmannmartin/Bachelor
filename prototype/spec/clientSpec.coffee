define ['src/client'], ( client ) ->
    describe 'checking basic setup', ->
        it 'should be defined', ->
            expect( client ).toBeDefined

        it 'should be a function', ->
            expect( client ).toEqual( jasmine.any(Function) )
