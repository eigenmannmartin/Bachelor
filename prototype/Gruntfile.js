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
        files: ['src/**/*', 'index.html', 'copy'],
        tasks: ['coffee:compile', /*'requirejs'*/],
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
        expand: true,
        flatten: false,
        cwd: './src/',
        src: ['**/*.coffee'],
        dest: './js/src',
        bare: true,
        ext: '.js',
        options: {
          sourceMap: true
        }
      },
    },

    copy: {
      tpl: {
        files: [
          {expand: true, src: ['src/templates/**/*.tpl'], dest: 'js/'},
        ]
      }
    },

    requirejs: {
      compile: {
        options: {
          baseUrl: "./js/",
          mainConfigFile: "./js/src/main.js",
          name: "src/main",
          out: "./js/main.min.js"
        }
      }
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
  grunt.loadNpmTasks('grunt-contrib-requirejs');
  grunt.loadNpmTasks('grunt-contrib-copy');

  grunt.registerTask('default', [
      'coffee',
      'copy',
      //'requirejs',
      'connect:app',
      'connect:coverage',
      'watch'
    ]);

};
