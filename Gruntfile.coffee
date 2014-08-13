module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    watch:
      options:
        livereload: true
      index:
        files: [
          'index.html'
        ]
        tasks: []

      coffee:
        files: ['coffee/**/*.coffee']
        tasks: ['build_coffee']

      scss:
        files: ['scss/**/*.scss']
        tasks: ['build_scss']

    sass:
      options:
        style: 'expanded'
      src:
        expand: true,
        cwd: 'scss',
        src: ['**/*.scss']
        dest: 'public/css/'
        ext: '.css'

    coffee:
      options:
        bare: true
      src:
        expand: true
        cwd: 'coffee'
        src: ['**/*.coffee']
        dest: 'public/js/'
        ext: '.js'

    bower:
      install:
        options:
          install: true
          copy: false
          cleanTargetDir: false
          cleanBowerDir: false

    shell:
      cleanup:
        options:
          stdout: true
        command: 'rm -rf public'

    copy:
      bower:
        files:[
          {'public/js/jquery.js' : 'bower_components/jquery/dist/jquery.js'}
          {'public/js/require.js' : 'bower_components/requirejs/require.js'}
        ]

  require('load-grunt-tasks') grunt

  #TESTING
  grunt.registerTask 'test', []

  #BOWER TASKS
  grunt.registerTask 'bower_install', ['bower:install']

  #BUILDING
  grunt.registerTask 'build_coffee', ['coffee:src']
  grunt.registerTask 'build_scss', ['sass:src']
  grunt.registerTask 'build', [
    'bower_install'
    'copy:bower'
    'build_coffee'
    'build_scss'
  ]

  #DEFAULT TASKS
  grunt.registerTask 'default', [
    'watch'
  ]

  #CLEANING UP
  grunt.registerTask 'cleanup', ['shell:cleanup']

  return