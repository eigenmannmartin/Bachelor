(function() {
  require.config({
    paths: {
      flux: '/bower_components/fluxify/build/fluxify.min',
      react: '/bower_components/react/react-with-addons',
      reactrouter: '/bower_components/react-router/build/umd/ReactRouter',
      io: '/socket.io/socket.io'
    }
  });

  require(['api', 'store', 'router', 'flux'], function(api, store, router, flux) {
    window.api = api;
    return window.flux = flux;

    /*
    	{"name":"Test","free":false, "ac": true, "beamer":true, "seats":333, "description":"some description"} 
    
    	{"id": , "delete":true}
     */
  });

}).call(this);

//# sourceMappingURL=index.js.map
