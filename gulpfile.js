'use strict';

var gulp = require ('gulp');
var $ = require ('gulp-load-plugins') ();
var connect = require('gulp-connect');

var paths = {
    scss: {
        dir: 'source/_static/scss',
        main: 'source/_static/scss/main.scss',
        files: 'source/_static/scss/**/*.scss'
    },
    css: {
        dir: 'source/_static/css',
        main: 'source/_static/scss/main.css',
        files: 'source/_static/scss/**/*.css',
        dist: 'build/master/html/_static/css'
    },
    js: {
        dir: 'source/_static/js',
        main: 'source/_static/js/main.js',
        files: 'source/_static/js/**/*.js',
        dist: 'build/master/html/_static/js',
    },
    dist: 'build/master/html'
}

// Compile SCSS
gulp.task('handleStyle', function() {
    return gulp.src (paths.scss.main)
        .pipe($.sass ())
        .pipe($.autoprefixer())
        .pipe(gulp.dest (paths.css.dir))
        .pipe($.cssmin())
        .pipe($.rename({
            suffix: '.min'
        }))
        .pipe(gulp.dest (paths.css.dir))
        .pipe(gulp.dest (paths.css.dist))
        .pipe(connect.reload());
});

// Minify and move JS
gulp.task('handleJs', function() {
    return gulp.src (paths.js.main)
        .pipe($.terser())
        .pipe(gulp.dest (paths.js.dist))
        .pipe(connect.reload());
});

// Live server
gulp.task('connect', function() {
    connect.server({
        root: paths.dist,
        livereload: true
    });
});


// Watch
gulp.task('watch', function () {
    gulp.watch(paths.scss.files, gulp.series('handleStyle'));
    gulp.watch(paths.js.files, gulp.series('handleJs'));
});

// Build
gulp.task('default', gulp.series('handleStyle', 'handleJs', 'watch'));