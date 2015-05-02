module.exports = function(grunt) {

// show elapsed time at the end
//require('time-grunt')(grunt);
// load all grunt tasks
require('load-grunt-tasks')(grunt);

  grunt.initConfig({
    documentation: {
      files: ['Gruntfile.js', './*/*.md'],
    },
    watch: {
      files: ['<%= documentation.files %>'],
      tasks: ['shell:makepdf']
    },

    shell: {
      'makepdf': {
        command: 'make pdf',
        options: {
          stdout: true,
          stderr: true,
          async: false
        }
      }
    }

  });

  grunt.loadNpmTasks('grunt-contrib-watch');

  grunt.registerTask('default', ['watch']);

};
