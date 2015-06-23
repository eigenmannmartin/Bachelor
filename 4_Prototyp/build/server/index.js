(function() {
  var requirejs;

  requirejs = require('requirejs');

  requirejs.config({
    nodeRequire: require
  });

  requirejs(['express', 'socket.io', 'http', 'api', 'logic', 'flux'], function(express, io, http, api, logic, flux) {
    var app, lp, sequelize, server, socket;
    flux.dispatcher.register(function(messageName, message) {
      return console.log(" ----- " + messageName + " ----- ");
    });
    app = express();
    server = http.createServer(app);
    socket = io.listen(server);
    socket.on('connection', function(socket) {
      return new api(socket);
    });
    sequelize = require(__dirname + '/models/');
    lp = new logic(sequelize);
    app.use('/', express["static"](__dirname + '/../client/'));
    app.use('/bower_components/', express["static"](__dirname + '/../../bower_components/'));
    return sequelize.sequelize.sync().then(function() {
      server.listen(process.env.PORT || 3000);
      return console.log('Server running at http://127.0.0.1:3000/');
    });
  });

}).call(this);
