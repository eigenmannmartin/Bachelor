(function() {
  require.config({
    paths: {
      flux: '/bower_components/fluxify/build/fluxify.min',
      react: '/bower_components/react/react',
      reactrouter: '/bower_components/react-router/build/umd/ReactRouter',
      io: '/socket.io/socket.io'
    }
  });

  require(['flux', 'io'], function(flux, io) {
    window.socket = io.connect('http://localhost:3000/');
    return window.flux = flux;
  });

}).call(this);

//# sourceMappingURL=index.js.map
