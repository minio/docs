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
        dist: 'build/html/_static/css'
    },
    dist: 'build/html'
}

// Compile SCSS
function handleStyle() {
    
}


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


gulp.task('connect', function() {
    connect.server({
        root: paths.dist,
        livereload: true
    });
});


// Watch
gulp.task('watch', function () {
    gulp.watch(paths.scss.files, gulp.series('handleStyle'))
});

// Build
gulp.task('default', gulp.series('connect', 'watch'));