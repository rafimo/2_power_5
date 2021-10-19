// scrape through the 2^5 submissions site and derive insights!
// cerner_2tothe5th_2021

// intention is to run as a bookmarklet - so pure JS! - run this in a browser console

// no names or id for elements - so parsing based on current DOM!
// get left div of submissions page - find the second table
var submissions = submissions=document.getElementsByClassName("left")[0]
    .getElementsByTagName("table")[1]
    .getElementsByTagName("tr")[0]
    .getElementsByTagName("tbody")[0].
    getElementsByTagName("tr");

console.log("Total Submissions:" + submissions.length);    

// parse submissions first td that has the author name - group by name!
var authors = Array.prototype.map.call(submissions, function(x) { return x.getElementsByTagName("td")[0].innerText })
    // group authors
    .reduce((accu, value) => {
        accu[value] = accu[value] || 0;
        accu[value] = accu[value] + 1; return accu;
    }, {});

console.log("Authors: ", authors)

// parse extensions - last td has file name
var files = Array.prototype.map.call(submissions, function(x) { return x.getElementsByTagName("td")[3].innerText });
var extensions = files.map(file => { return file.substring(file.lastIndexOf('.') + 1) })
    // group extentions    
    .reduce((accu, value) => {
        accu[value] = accu[value] || 0;
        accu[value] = accu[value] + 1; return accu;
    }, {});

console.log("Extensions: ", extensions)
