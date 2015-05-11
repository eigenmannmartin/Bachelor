
requirejs = require 'requirejs'

requirejs.config
{
    nodeRequire: require
}

requirejs ['express', 'socket.io', 'http', 'api'],(express, io, http, api) ->

	app = express()
	server = http.createServer(app);


	socket = io.listen(server)
	socket.on 'connection', ( socket ) ->
		a = new api( socket )
	


	app.use( '/', express.static( __dirname + '/../client/'))
	app.use( '/bower_components/', express.static( __dirname + '/../../bower_components/'))
	


	server.listen process.env.PORT || 3000 
	console.log 'Server running at http://127.0.0.1:3000/'

	
	



