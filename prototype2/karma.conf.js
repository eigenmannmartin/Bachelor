// Karma configuration
// Generated on Sun May 03 2015 19:56:14 GMT+0200 (CEST)

module.exports = function(config) {
  config.set({

    // base path that will be used to resolve all patterns (eg. files, exclude)
    basePath: '',


    // frameworks to use
    // available frameworks: https://npmjs.org/browse/keyword/karma-adapter
    frameworks: ['jasmine', 'requirejs'],


    // list of files / patterns to load in the browser
    files: [
      
      {pattern: 'client/**/*.coffee', included: false},

      {pattern: 'server/**/*', included: false},

      {pattern: 'specs/**/*Spec.coffee', included: false},

      {pattern: 'bower_components/fluxify/build/fluxify.min.js', included: false},

      'specs/test-main.js',


    ],


    // list of files to exclude
    exclude: [
      'client/index.coffee',
      'server/index.coffee'
    ],


    // preprocess matching files before serving them to the browser
    // available preprocessors: https://npmjs.org/browse/keyword/karma-preprocessor
    preprocessors: {
        '**/*.coffee': 'cjsx',
        'server/**/*.coffee': 'coverage',
        'client/**/*.coffee': 'coverage'
    },

    coverageReporter: { 
      type : 'html', 
      dir : 'coverage/',
      includeAllSources: true,
    },
    //coverageReporter: { type : 'text', dir : 'coverage/', file : 'coverage.txt' },


    cjsxPreprocessor: {
      // options passed to the coffee compiler
      options: {
        bare: true,
        sourceMap: true
      }
    },


    // test results reporter to use
    // possible values: 'dots', 'progress'
    // available reporters: https://npmjs.org/browse/keyword/karma-reporter
    reporters: ['nyan', 'coverage'],


    // web server port
    port: 9876,


    // enable / disable colors in the output (reporters and logs)
    colors: true,


    // level of logging
    // possible values: config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
    logLevel: config.LOG_INFO,


    // enable / disable watching file and executing tests whenever any file changes
    autoWatch: true,


    // start these browsers
    // available browser launchers: https://npmjs.org/browse/keyword/karma-launcher
    browsers: [/*'Chrome','Firefox',*/  'PhantomJS'],


    // Continuous Integration mode
    // if true, Karma captures browsers, runs the tests and exits
    singleRun: false
  });
};
