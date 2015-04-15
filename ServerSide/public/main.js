function getDresses(el) {
    var color = hexToRgb(el.value);
    console.log(color);
    var httpRequest = new XMLHttpRequest();
    httpRequest.onreadystatechange = function(){
        var result = JSON.parse(httpRequest.responseText);
        console.log(result);
        var resultHTML = '';

        for(var i=0; i<result.length;i++) {
            var itemColor = result[i].colorRGB.r + ',' + result[i].colorRGB.g + ',' + result[i].colorRGB.b;
            resultHTML += '<div style="border-color:rgb(' + itemColor + ')">';
            resultHTML += '<h5>' + result[i].name + '</h5>';
            resultHTML += '<p>' + result[i].price + '</p>';
            resultHTML += '<img src="' + result[i].image.smallUrl + '")></img>';
            //resultHTML += '<img style="width: 180px;" src="img/' + result[i].id + '.jpg")></img>';
            resultHTML += '</div>';
        }

        document.getElementById('result-container').innerHTML = resultHTML;
    };
    var colorQuery = color.r + ',' + color.g + ',' + color.b;

    httpRequest.open('GET', 'categories/womens-clothing-dresses/' + colorQuery);
    httpRequest.send();
}

function hexToRgb(hex) {
    var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
    return result ? {
        r: parseInt(result[1], 16),
        g: parseInt(result[2], 16),
        b: parseInt(result[3], 16)
    } : null;
}