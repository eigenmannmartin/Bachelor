
requirejs = require 'requirejs'

requirejs.config
	nodeRequire: require



requirejs ['express', 'socket.io', 'http', 'api', 'state', 'sync' ],(express, io, http, api, state, sync ) ->

	# start the express app
	app = express()
	# set the http server for websockets
	server = http.createServer(app);

	manager = new sync()

	# setup websockets
	state.socket = io.listen(server)
	state.socket.on 'connection', ( socket ) ->
		# each client gets a dedicated api
		a = new api( socket )

	# load all persistence
	state.models = require __dirname + '/models/'

	# deliver the web-UI
	app.use '/', express.static __dirname + '/../client/'
	app.use '/bower_components/', express.static __dirname + '/../../bower_components/'

	# connect to db
	state.models.sequelize.sync().then () -> 
		# start the server
		server.listen process.env.PORT || 3000 
		console.log 'Server running at http://127.0.0.1:3000/'

	
	



