
requirejs = require 'requirejs'

requirejs.config
	nodeRequire: require



requirejs ['express', 'socket.io', 'http' ],(express, io, http ) ->

	# start the express app
	app = express()
	# set the http server for websockets
	server = http.createServer(app);

	# setup websockets
	socket = io.listen(server)

	# load all persistence
	models = require __dirname + '/models/'

	#a = models.Room.create({ name:"Eiger" })
	#r = models.Room.findAll()
	#r.then (rooms)->
	#	for room in rooms
	#		console.log room.name

	# deliver the web-UI
	app.use '/', express.static __dirname + '/../client/'
	app.use '/bower_components/', express.static __dirname + '/../../bower_components/'

	# connect to db
	models.sequelize.sync().then () -> 
		# start the server
		server.listen process.env.PORT || 3000 
		console.log 'Server running at http://127.0.0.1:3000/'

	
	



