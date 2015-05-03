module.exports = function(grunt) {

// show elapsed time at the end
//require('time-grunt')(grunt);
// load all grunt tasks
require('load-grunt-tasks')(grunt);

  grunt.initConfig({
    app: {
      files: ['Gruntfile.js', './src/**/*.coffee'],
    },
    watch: {
      app: {
        files: 'src/**/*',
        tasks: ['coffee:compile'],
        options: {
          livereload: true
        }
      },

      tests: {
        files: 'spec/**/*',
        tasks: []
      }
    },

    connect: {
      app: {
        options: {
          port: 9991,
          base: './',
          livereload: true,
          open: true
        }
      },
      coverage: {
        options: {
          port: 9992,
          base: './coverage',
          open: true
        }
      }
    },  

    coffee: {
      compile: {
        files: {
          './main.js': ['src/**/*.coffee']
        }
      },
    },

    karma: {
      test: {
        configFile: 'karma.conf.js'
      }
    },

  });

  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-connect');
  grunt.loadNpmTasks('grunt-contrib-coffee');

  grunt.registerTask('default', [
      
      'connect:app',
      'connect:coverage',
      'coffee',
      'watch'
    ]);

};
