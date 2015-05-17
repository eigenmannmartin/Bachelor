
requirejs = require 'requirejs'

requirejs.config
	nodeRequire: require



requirejs ['express', 'socket.io', 'http', 'api', 'logic' ],(express, io, http, api, logic) ->

	# start the express app
	app = express()
	# set the http server for websockets
	server = http.createServer(app);

	# setup websockets
	socket = io.listen(server)

	socket.on 'connection', (socket) ->
		new api( socket )

	# load all persistence
	sequelize = require __dirname + '/models/'

	#start logic processor
	lp = new logic( sequelize )

	#a = sequelize.Room.create({ name:"Eiger" })
	#r = models.Room.findAll()
	#r.then (rooms)->
	#	for room in rooms
	#		console.log room.name

	# deliver the web-UI
	app.use '/', express.static __dirname + '/../client/'
	app.use '/bower_components/', express.static __dirname + '/../../bower_components/'

	# connect to db
	sequelize.sequelize.sync().then () -> 
		# start the server
		server.listen process.env.PORT || 3000 
		console.log 'Server running at http://127.0.0.1:3000/'

	
	



