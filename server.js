'use strict';

var express     = require('express'),
    MongoClient = require('mongodb').MongoClient,
    converter   = require("color-convert"),
    path        = require('path'),
    euclidean = require('euclidean-distance');

var app = express();

app.use(express.static(path.join(__dirname, 'public')));

app.get('/categories/', function (req, res) {
    res.json(['womens-clothing-dresses',
        'womens-shoes-high-heels',
        'purses',
        'mens-clothing-casual-shirts',
        'mens-clothing-chinos',
        'mens-shoes-sporty-lace-ups']);
});



app.get('/categories/:category/:color', function (req, res) {
    var rgb = req.params.color.split(',');
    var lab = converter.rgb2lab(rgb);
    console.log(lab);
    MongoClient.connect('mongodb://localhost:27017/zalando', function(err, db) {
        var articles = db.collection('articles');
        articles.find({category:req.params.category}).toArray(function(err, docs){
            docs.sort(function(a, b){

                return  euclidean([a.colorLab.l,a.colorLab.a,a.colorLab.b],lab) - euclidean([b.colorLab.l,b.colorLab.a,b.colorLab.b],lab);
            });

            res.json(docs.slice(0,10));
        });
    });
});

app.get('/articles/:color', function (req, res) {
    var rgb = req.params.color.split(',');
    var lab = converter.rgb2lab(rgb);
    console.log(lab);
    MongoClient.connect('mongodb://localhost:27017/zalando', function(err, db) {
        var articles = db.collection('articles');
        articles.find().toArray(function(err, docs){
            docs.sort(function(a, b){

                return  euclidean([a.colorLab.l,a.colorLab.a,a.colorLab.b],lab) - euclidean([b.colorLab.l,b.colorLab.a,b.colorLab.b],lab);
            });

            res.json(docs.slice(0,10));
        });
    });
});


app.use(function(req, res, next) {
    var err = new Error('Not Found');
    err.status = 404;
    next(err);
});

app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    res.json({
        error: err.message
    });
});

var server = app.listen(3000, function () {

    var host = server.address().address;
    var port = server.address().port;

    console.log('the App listening at http://%s:%s', host, port);
});