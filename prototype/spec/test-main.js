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
  baseUrl: '/base/src/',

  paths : {
    jquery:'/base/bower_components/jquery/dist/jquery.min',
    underscore: '/base/bower_components/underscore/underscore-min',
    text: '/base/components/requirejs/text',
    flux: '/base/bower_components/fluxify/build/fluxify.min',
    react: '/base/bower_components/react/react',
    reactrouter: '/base/bower_components/react-router/build/umd/ReactRouter.min',

    spec:'../spec'
  },

  shim : {
      'jquery' : {
          exports : '$'
      }
  },

  // dynamically load all test files
  deps: allTestFiles,

  // we have to kickoff jasmine, as it is asynchronous
  callback: window.__karma__.start
});