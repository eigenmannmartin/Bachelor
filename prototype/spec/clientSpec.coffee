define ['src/client'], (client) ->
    describe 'just checking', ->
        it 'works for app', ->
            expect(client.start(1,1)).toBe true 

        it 'works for app', ->
            expect(client.start(1,2)).toBe false

    describe 'stoping', ->
        it 'really needs to stop', ->
            expect(client.stop()).toBe true 

        it 'resume', ->
            expect(client.resume( true )).toBe true
            expect(client.resume( false )).toBe false