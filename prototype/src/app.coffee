define 'src/app', ['src/client', 'src/datastoreInMemory'], ( client, ds ) ->
  class App

  	constructor: ->

  	start: ()->
  		new ds({tables:[ users: { 'gender':{ struct:'enum', type:'static', group:'' }}]})

  App
