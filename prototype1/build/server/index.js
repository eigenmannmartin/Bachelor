(function() {
  var requirejs;

  requirejs = require('requirejs');

  requirejs.config({
    nodeRequire: require
  });

  requirejs(['express', 'socket.io', 'http', 'api', 'state', 'sync'], function(express, io, http, api, state, sync) {
    var app, manager, server;
    app = express();
    server = http.createServer(app);
    manager = new sync();
    state.socket = io.listen(server);
    state.socket.on('connection', function(socket) {
      var a;
      return a = new api(socket);
    });
    state.models = require(__dirname + '/models/');
    app.use('/', express["static"](__dirname + '/../client/'));
    app.use('/bower_components/', express["static"](__dirname + '/../../bower_components/'));
    return state.models.sequelize.sync().then(function() {
      server.listen(process.env.PORT || 3000);
      return console.log('Server running at http://127.0.0.1:3000/');
    });
  });

}).call(this);
