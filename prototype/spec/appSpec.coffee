define ['src/app'], (app) ->
    describe 'just checking', ->
        it 'works for app', ->
            App = new app()
            expect(App).toBeDefined
            expect(App.asdf()).toBe false