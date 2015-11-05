'use strict'
# directories
# --------------------
dir = {
	src:  'src'
	dest: 'build'
	img:  'images'
}

# requires
# --------------------
gulp         = require 'gulp'
browser      = require 'browser-sync'
copy         = require 'gulp-copy'
rename       = require 'gulp-rename'
plumber      = require 'gulp-plumber'
compass      = require 'gulp-compass'
sass         = require 'gulp-ruby-sass'
cssmin       = require 'gulp-cssmin'
coffee       = require 'gulp-coffee'
gutil        = require 'gulp-util'
uglify       = require 'gulp-uglify'
del          = require ('del')


# server
# --------------------
gulp.task 'server', ->
	browser({
		server:
			baseDir: "#{dir.src}",
		port: 8000,
		open: false,
	})



# compass sass
# --------------------
gulp.task 'compass', ->
	gulp.src "#{dir.src}/sass/**/*.scss"
			.pipe compass({
				config_file: 'config.rb'
				sass: "#{dir.src}/sass"
				css: "#{dir.src}/css"
			})

gulp.task 'sass', ->
	sass(dir.src+'/sass/', ({ style: 'expanded', compass: true }))
			.on 'error', (err)-> console.error 'Error!', err.message
			.pipe cssmin()
			.pipe gulp.dest "#{dir.src}/css"
			.pipe browser.reload({ stream: true })


# coffee uglify
# --------------------
gulp.task 'coffee', ->
	gulp.src "#{dir.src}/coffee/*.coffee"
			.pipe plumber()
			.pipe coffee({ bare: true }).on('error', gutil.log)
			#.pipe gulp.dest "#{dir.src}/js"
			.pipe uglify()
			.pipe rename({ extname: '.min.js' })
			.pipe gulp.dest "#{dir.src}/js"
			.pipe browser.reload({ stream: true })


# reload
# --------------------
gulp.task 'reload', ->
	gulp.src "#{dir.src}/*.html"
			.pipe browser.reload({ stream: true })




# build
# --------------------
gulp.task 'copy', (cb) ->
	gulp.src "#{dir.src}/**", {base: "#{dir.src}"}
			.pipe gulp.dest "#{dir.dest}"




gulp.task 'watch', ->
	gulp.watch "#{dir.src}/coffee/*.coffee", ['coffee']
	gulp.watch "#{dir.src}/sass/**/*.scss", ['sass']
	gulp.watch "#{dir.src}/index.html", ['reload']



# default task
# --------------------
gulp.task 'default', ['server', 'watch'], ->

gulp.task 'build', ['copy'], (cb) ->
	del ["#{dir.dest}/coffee", "#{dir.dest}/sass", "#{dir.dest}/index2.html"], cb
