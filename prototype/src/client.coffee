define 'client', [], () ->
  class App
  	constructor: ->

  	start: (a, b) ->
  		if a is b
  			true
  		else
  			false

  	stop: () ->
  		true

  	### istanbul ignore next ###
  	resume: () ->
  		true

  new App()