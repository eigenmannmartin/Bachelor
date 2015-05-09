define ['flux','client','visual/datastore','datastoreInMemory'
],( 	 Flux,  client,  visualdatastore,   datastore
) ->
	class App

		constructor: ->
			Flux.dispatcher.dispatch {actionType: 'log2'}
			@run()

		run: () ->
	
			@store = new datastore({
				tables:[
					users: ['gender','firstname','lastname','username','email','street','city','state','zip','job']
				]
			})

			@store.insert({ table: 'users', data: [[ gender: "Male", 
							 firstname: "Martin", 
							 lastname: "Eigenmann",
							 username: "eim",
							 email: "mail@mail.com",
							 street: "Strasse 12",
							 city: "St.Gallen",
							 zip: "9000",
							 job: "IT specialist" ]]
			})

			vStore = new visualdatastore( @store )
			


			#$('#container').html(  "it works!" )

	
	App
