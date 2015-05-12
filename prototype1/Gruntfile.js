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
        files: ['client/**/*'],
        tasks: ['cjsx:compileCLI', 'copy'/*'requirejs'*/],
        options: {
          livereload: true
        }
      },

      server: {
        files: ['server/**/*'],
        tasks: ['cjsx:compileSRV', 'express:dev', 'copy:srv'],
        options: {
          spawn: false 
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

    cjsx: {
      compileCLI: {
        expand: true,
        flatten: false,
        cwd: './client/',
        src: ['**/*.coffee'],
        dest: './build/client',
        bare: true,
        ext: '.js',
        options: {
          sourceMap: true
        }
      },
      compileSRV: {
        expand: true,
        flatten: false,
        cwd: './server/',
        src: ['**/*.coffee'],
        dest: './build/server/',
        bare: true,
        ext: '.js',
        options: {
          sourceMap: false
        }
      },
    },

    copy: {
      srv: {
        files: [
          {expand: true, src: ['server/**/*.js', 'server/**/*.json'], dest: 'build/'},
        ]
      },
      cli:{
        files: [
          {expand: true, src: ['client/**/*.html'], dest: 'build/'},
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

    express: {
      options: {
        // Override defaults here
      },
      dev: {
        options: {
          script: 'build/server/index.js'
        }
      }
    }

  });

  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-connect');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-coffee-react');
  grunt.loadNpmTasks('grunt-contrib-requirejs');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-express-server');

  grunt.registerTask('default', [
      'cjsx:compileSRV',
      'cjsx:compileCLI',
      'copy',
      //'requirejs',
      //'connect:app',
      //'connect:coverage',
      'express:dev',
      'watch'
    ]);

};
