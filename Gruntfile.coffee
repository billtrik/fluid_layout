module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    mochaTest:
      functional:
        options:
          reporter: 'spec',
          require: [
            'coffee-script/register'
            'spec/functional/globals.js',
          ]
        src: ['spec/functional/**/*_spec.coffee']

    watch:
      options:
        livereload: true
      index:
        files: [
          'index.html'
        ]
        tasks: []

      functional_tests:
        files: [
          'spec/functional/**/*_spec.coffee'
        ]
        tasks: ['mochaTest']

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
        files: {'public/css/application.css' : 'scss/application.scss'}

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
          {'public/js/html5shiv.js' : 'bower_components/html5shiv/dist/html5shiv.js'}
          {'public/js/jquery.js' : 'bower_components/jquery/dist/jquery.js'}
          {'public/js/require.js' : 'bower_components/requirejs/require.js'}
          {'public/js/chroma.js' : 'bower_components/chroma-js/chroma.js'}
          {'public/images/tile.gif' : 'images/tile.gif'}
        ]

  require('load-grunt-tasks') grunt

  #TESTING
  grunt.registerTask 'test', [
    'mochaTest:functional'
  ]

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

  #DEV
  grunt.registerTask 'start_web_server', ->
    grunt.log.writeln('Started web server on port 3000');
    require('./server').listen(3000)

  #DEFAULT TASKS
  grunt.registerTask 'default', [
    'start_web_server'
    'watch'
  ]

  #CLEANING UP
  grunt.registerTask 'cleanup', ['shell:cleanup']

  return