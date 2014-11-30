# Generated on 2014-11-29 using generator-chrome-extension 0.2.11
'use strict'

# # Globbing
# for performance reasons we're only matching one level down:
# 'test/spec/{,*/}*.js'
# use this if you want to recursively match all subfolders:
# 'test/spec/**/*.js'

module.exports = (grunt)->
  # Load grunt tasks automatically
  require('load-grunt-tasks')(grunt)

  # Time how long tasks take. Can help when optimizing build times
  require('time-grunt')(grunt)

  # Configurable paths
  config =
    app: 'app',
    dist: 'dist'
    tmp: '.tmp'

  grunt.initConfig
    # Project settings
    config: config,

    # Watches files for changes and runs tasks based on the changed files
    watch:
      bower:
        files: ['bower.json']
        tasks: ['bowerInstall']
      coffee:
        files: ['<%= config.app %>/scripts/{,*/}*.coffee']
        tasks: [
          #'clean:dist',
          #'clean:tmp',
          'useminPrepare',
          'concurrent:dist',
          'copy:tmp'
          'chromeManifest:dist',
          'cssmin',
          'concat',
          'uglify',
          'copy:dist',
          'usemin',
        ]

      js:
        files: ['<%= config.app %>/scripts/{,*/}*.js']
        tasks: ['jshint']
        options:
          livereload: true
      html:
        files: ['<%= config.app %>/{,*/}*.html']
        tasks: [
          'clean:dist',
          'clean:tmp',
          'useminPrepare',
          'concurrent:dist',
          'copy:tmp'
          'chromeManifest:dist',
          'cssmin',
          'concat',
          'uglify',
          'copy:dist',
          'usemin',
        ]
      gruntfile:
        files: ['Gruntfile.coffee']
      styles:
        files: ['<%= config.app %>/styles/{,*/}*.css']
        tasks: ['useminPrepare', 'cssmin','copy:dist', 'usemin']
        options:
          livereload: true
      livereload:
        options:
          livereload: '<%= connect.options.livereload %>'
        files: [
          '<%= config.app %>/*.html',
          '<%= config.app %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}',
          '<%= config.app %>/manifest.json',
          '<%= config.app %>/_locales/{,*/}*.json'
        ]

    coffee:
      # https://github.com/ragingwind/grunt-chrome-manifest/issues/6
      dist:
        files: [
          expand: true
          cwd: '<%= config.app %>/scripts'
          src: '{,*/}*.coffee'
          dest: '<%= config.tmp %>/scripts'
          ext: '.js'
        ]
 
      test:
        files: [
          expand: true,
          cwd: 'test/spec'
          src: '{,*/}*.coffee'
          dest: '<%= config.tmp %>/spec'
          ext: '.js'
        ]


    # Grunt server and debug server setting
    connect:
      options:
        port: 9000
        livereload: 35729
        # change this to '0.0.0.0' to access the server from outside
        hostname: 'localhost'
      chrome:
        options:
          open: false
          base: [ '<%= config.app %>']
      test:
        options:
          open: false,
          base: ['test', '<%= config.app %>']

    # Empties folders to start fresh
    clean:
      chrome: { }
      dist:
        files: [{
          dot: true,
          src: [
            '<%= config.dist %>/*',
            '!<%= config.dist %>/.git*'
          ]
        }]
      tmp:
        files: [{
          dot: true,
          src: [
            '<%= config.tmp %>/*',
            '!<%= config.dist %>/.git*'
          ]
        }]

    # Make sure code styles are up to par and there are no obvious mistakes
    jshint:
      options:
        jshintrc: '.jshintrc'
        reporter: require('jshint-stylish')
      all: [
        'Gruntfile.js',
        '<%= config.app %>/scripts/{,*/}*.js'
        '!<%= config.app %>/scripts/vendor/*'
        'test/spec/{,*/}*.js'
      ]

    mocha:
      all:
        options:
          run: true
          urls: ['http://localhost:<%= connect.options.port %>/index.html']

    # Automatically inject Bower components into the HTML file
    bowerInstall:
      app:
        src: ['<%= config.app %>/*.html']

    # Reads HTML for usemin blocks to enable smart builds that automatically
    # concat, minify and revision files. Creates configurations in memory so
    # additional tasks can operate on them
    useminPrepare:
      options:
        dest: '<%= config.dist %>'
      html: [
        '<%= config.app %>/popup.html',
        '<%= config.app %>/options.html'
      ]

    # Performs rewrites based on rev and the useminPrepare configuration
    usemin:
      options:
        assetsDirs: ['<%= config.dist %>', '<%= config.dist %>/images']
      html: ['<%= config.dist %>/{,*/}*.html'],
      css: ['<%= config.dist %>/styles/{,*/}*.css']

    # The following *-min tasks produce minifies files in the dist folder
    imagemin:
      dist:
        files: [{
          expand: true,
          cwd: '<%= config.app %>/images',
          src: '{,*/}*.{gif,jpeg,jpg,png}',
          dest: '<%= config.dist %>/images'
        }]

    svgmin:
      dist:
        files: [{
          expand: true,
          cwd: '<%= config.app %>/images',
          src: '{,*/}*.svg',
          dest: '<%= config.dist %>/images'
        }]

    htmlmin:
      dist:
        options: {
          # removeCommentsFromCDATA: true,
          # collapseWhitespace: true,
          # collapseBooleanAttributes: true,
          # removeAttributeQuotes: true,
          # removeRedundantAttributes: true,
          # useShortDoctype: true,
          # removeEmptyAttributes: true,
          # removeOptionalTags: true
        }
        files: [{
          expand: true,
          cwd: '<%= config.app %>',
          src: '*.html',
          dest: '<%= config.dist %>'
        }]

    # By default, your `index.html`'s <!-- Usemin block --> will take care of
    # minification. These next options are pre-configured if you do not wish
    # to use the Usemin blocks.
    # cssmin: {
    #   dist: {
    #     files: {
    #       '<%= config.dist %>/styles/main.css': [
    #         '<%= config.app %>/styles/{,*/}*.css'
    #       ]
    #     }
    #   }
    # },
    # uglify: {
    #   dist: {
    #     files: {
    #       '<%= config.dist %>/scripts/scripts.js': [
    #         '<%= config.dist %>/scripts/scripts.js'
    #       ]
    #     }
    #   }
    # },
    # concat: {
    #   dist: {}
    # },

    # Copies remaining files to places other tasks can use
    copy:
      tmp:
        files: [
          expand: true,
          dot: true,
          cwd: '<%= config.app %>',
          dest: '<%= config.tmp %>',
          src: [
            'bower_components/jquery/dist/jquery.js',
            'bower_components/{,*/}*.js',
            'manifest.json'
          ]
        ]
      dist:
        files: [
          expand: true,
          dot: true,
          cwd: '<%= config.app %>',
          dest: '<%= config.dist %>',
          src: [
            '*.{ico,png,txt}',
            'images/{,*/}*.{webp,gif}',
            '{,*/}*.html',
            'styles/{,*/}*.css',
            'styles/fonts/{,*/}*.*',
            '_locales/{,*/}*.json',
          ]
        ,
          expand: true,
          dot: true,
          cwd: '<%= config.tmp %>',
          dest: '<%= config.dist %>',
          src: [
            'scripts/{,*/}*.js',
          ]
        ]

    # Run some tasks in parallel to speed up build process
    concurrent:
      chrome: [ ],
      dist: ['imagemin', 'svgmin', 'coffee'],
      test: [ ]

    # Auto buildnumber, exclude debug files. smart builds that event pages
    chromeManifest:
      dist:
        options:
          buildnumber: false,
          background:
            target: 'scripts/background-unified.js',
            exclude: [
              'scripts/chromereload.js'
            ]
        src: '<%= config.tmp %>',
        dest: '<%= config.dist %>'

    # Compres dist files to package
    compress:
      dist:
        options:
          archive: ->
            manifest = grunt.file.readJSON('app/manifest.json')
            return "package/Business Days-#{ manifest.version }.zip"
        files: [{
          expand: true,
          cwd: 'dist/',
          src: ['**'],
          dest: ''
        }]

  grunt.registerTask 'debug', ->
    grunt.task.run [
      'concurrent:chrome',
      #'connect:chrome',
      'build',
      'watch'
    ]

  grunt.registerTask 'test', [
    'connect:test',
    'mocha'
  ]

  grunt.registerTask 'build', [
    'clean:dist',
    'clean:tmp',
    'useminPrepare',
    'concurrent:dist',
    'copy:tmp'
    'chromeManifest:dist',
    'cssmin',
    'concat',
    'uglify',
    'copy:dist',
    'usemin',
    'compress'
  ]

  grunt.registerTask 'default', [
    'jshint',
    'test',
    'build'
  ]
