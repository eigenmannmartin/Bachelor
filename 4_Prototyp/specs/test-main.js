var allTestFiles = [];
var TEST_REGEXP = /(spec|test)\.js$/i;

var pathToModule = function(path) {
  return path.replace(/^\/base\//, '').replace(/\.js$/, '');
};

Object.keys(window.__karma__.files).forEach(function(file) {
  if (TEST_REGEXP.test(file)) {
    // Normalize paths to RequireJS module names.
    allTestFiles.push(pathToModule(file));
  }
});

require.config({
  // Karma serves files under /base, which is the basePath from your config file
  baseUrl: '/',

  paths : {
    flux: '/base/bower_components/fluxify/build/fluxify.min',
    react: '/base/bower_components/react/react',
    reactrouter: '/base/bower_components/react-router/build/umd/ReactRouter.min',
    specs: '/base/specs',

    server_api: 'base/server/api',
    server_logic: 'base/server/logic',
    server_storage: 'base/server/storage',

    client_store: 'base/client/store',
    client_api: 'base/client/api',
    staticPages: 'base/client/staticPages',

  },


  // dynamically load all test files
  deps: allTestFiles,

  // we have to kickoff jasmine, as it is asynchronous
  callback: window.__karma__.start
});
