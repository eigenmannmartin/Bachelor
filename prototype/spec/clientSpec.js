define(['src/client'], function( client ) {

    describe('just checking', function() {

        it('works for app', function() {
            dump(client);
            expect(client).toBe(true);
        });
    });

});