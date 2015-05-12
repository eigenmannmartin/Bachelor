(function() {
  var requirejs;

  requirejs = require('requirejs');

  requirejs.config;

  ({
    nodeRequire: require
  });

  requirejs(['express', 'socket.io', 'http', 'api', 'state'], function(express, io, http, api, state) {
    var app, server, socket;
    app = express();
    server = http.createServer(app);
    state.models = require(__dirname + '/models/');
    socket = io.listen(server);
    socket.on('connection', function(socket) {
      var a;
      return a = new api(socket);
    });
    app.use('/', express["static"](__dirname + '/../client/'));
    app.use('/bower_components/', express["static"](__dirname + '/../../bower_components/'));
    return state.models.sequelize.sync().then(function() {
      server.listen(process.env.PORT || 3000);
      return console.log('Server running at http://127.0.0.1:3000/');
    });
  });

}).call(this);
