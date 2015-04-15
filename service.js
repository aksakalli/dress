'use strict';

var https       = require('https'),
    fs          = require('fs'),
    ColorThief  = require('color-thief'),
    MongoClient = require('mongodb').MongoClient,
    converter   = require("color-convert");

var colorThief = new ColorThief();

console.log('service started: ' + new Date());
process.on('exit', function(code) {
    console.log('service ended: ',new Date(),' code: ',code);
});


//var category = 'womens-clothing-dresses';
//var category = 'womens-shoes-high-heels';
//var category = 'purses';

//var category = 'mens-clothing-casual-shirts';
//var category = 'mens-clothing-chinos';
var category = 'mens-shoes-sporty-lace-ups';

var apiURL = 'https://api.zalando.com/articles?category=' + category;

MongoClient.connect('mongodb://localhost:27017/zalando', function(err, db) {
    if(err) {
        console.log('Connection Error!');
        process.exit(1);
    }

    var articles = db.collection('articles');

    pageRequest(apiURL,function(result){
        for(var i=1; i<result.totalPages;i++) {
            pageRequest(apiURL+'&page='+i, function(data) {

                for(var j=0;j<data.content.length;j++) {
                    var item = data.content[j];
                    var fileName = 'public/img/'+item.id + '.jpg';


                    //console.log('page: ',data.page,', item: ',item.id);
                    if(item.media.images[0]){
                        console.log('image for: ' + item.id);
                        download(item.media.images[0].mediumUrl, fileName, itemHandler(fileName,item,articles));
                    }
                    else {
                        console.log('no image for: ' + item.id);
                    }
                }
            });
        }
    });
});

var insertedIndex =0;
function itemHandler(fileName,item,articles){
    return function(){
        console.log("colorThief");
        var colorRgb = colorThief.getColor(fileName);
        console.log(++insertedIndex + ' - ' + item.id +', rgb(',colorRgb[0] + ',' + colorRgb[1] + ',' + colorRgb[2] + ')');
        var colorLab = converter.rgb2lab(colorRgb);

        var newArticle = {
            id:item.id,
            name:item.name,
            image:item.media.images[0],
            price: item.units[0].price.formatted,
            colorRGB:{
                r:colorRgb[0],
                g:colorRgb[1],
                b:colorRgb[2]
            },
            colorLab: {
                l:colorLab[0],
                a:colorLab[1],
                b:colorLab[2]
            },
            category: category
        };

        articles.insert(newArticle);
    };
}

function download(url, dest, cb) {
    var file = fs.createWriteStream(dest);
    https.get(url, function(response) {
        response.pipe(file);
        file.on('finish', function() {
            file.close(cb);  // close() is async, call cb after close completes.
        });
    });
}

function pageRequest(url,cb){
    https.get(url,function(res){
        var data = '';
        res.on('data', function (chunk){
            data += chunk;
        });
        res.on('end',function(){
            var result = JSON.parse(data);
            cb(result);
        })
    });
}