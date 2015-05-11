(function() {
  var requirejs;

  requirejs = require('requirejs');

  requirejs.config;

  ({
    nodeRequire: require
  });

  requirejs(['express', 'socket.io', 'http', 'api'], function(express, io, http, api) {
    var app, server, socket;
    app = express();
    server = http.createServer(app);
    socket = io.listen(server);
    socket.on('connection', function(socket) {
      var a;
      return a = new api(socket);
    });
    app.use('/', express["static"](__dirname + '/../client/'));
    app.use('/bower_components/', express["static"](__dirname + '/../../bower_components/'));
    server.listen(process.env.PORT || 3000);
    return console.log('Server running at http://127.0.0.1:3000/');
  });

}).call(this);

//# sourceMappingURL=index.js.map
