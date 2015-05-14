(function() {
  require.config({
    paths: {
      flux: '/bower_components/fluxify/build/fluxify.min',
      react: '/bower_components/react/react-with-addons',
      reactrouter: '/bower_components/react-router/build/umd/ReactRouter',
      io: '/socket.io/socket.io'
    }
  });

  require(['flux', 'app'], function(flux, app) {
    window.app = new app;
    window.app.run();
    return window.flux = flux;
  });

}).call(this);

//# sourceMappingURL=index.js.map
