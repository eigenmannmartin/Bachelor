define [
	 'jquery'
	,'client'
	,'visual/datastore'
	,'datastoreInMemory'
],( 
	 $
	,client
	,visualdatastore 
	,datastore
) ->
	class App

		constructor: ->
			this.run

		run: () ->
			this.store = new datastore({ tables:[users:{'gender','firstname','lastname','username','email','street','city','state','zip','job'}]})
			this.store.insert({ table: 'users', data: [[ gender: "Male", 
							 firstname: "Martin", 
							 lastname: "Eigenmann",
							 username: "eim",
							 email: "mail@mail.com",
							 street: "Strasse 12",
							 city: "St.Gallen",
							 zip: "9000",
							 job: "IT specialist" ]]
			})
			vStore = new visualdatastore( a )
			$('#container').html vStore.render()
	
	App
