// cerner_2^5_2016
// prints A-Z!
var alphabets = '';
var handler = {
    get: function(target, name){
        alphabets = alphabets + name;
        if (name === 'Z') {
            console.log(alphabets)
            return;
        }
        eval('Driver.' + String.fromCharCode(name.charCodeAt(0) + 1));
    }
}
var Driver = new Proxy({}, handler);
Driver.A
