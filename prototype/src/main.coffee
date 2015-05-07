###

TODO:
API-Design dependend on Domain

###

require.config
	paths:
	    jquery:'/bower_components/jquery/dist/jquery.min',
	    underscore:'/bower_components/underscore/underscore-min',
	    text: '/components/requirejs/text'

	shim:
	    'jquery':
	        exports : '$'
	    'underscore':
	    	exports : '_'

require ["app"], (App)->
	window.app = new App()