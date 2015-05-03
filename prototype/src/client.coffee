define 'src/client', [], () ->
  class App
  	constructor: ->

  	start: (a, b) ->
  		if a is b
  			true
  		else
  			false

  	stop: () ->
  		true

  	resume: ( a, b ) ->
  		if a or b
  			true
  		else
  			false

  new App()