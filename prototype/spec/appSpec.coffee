define ['app'], (app) ->
    describe 'checking basic setup', ->
        it 'app sould be able to get instanciated', ->
            App = new app()
            expect(App).toBeDefined