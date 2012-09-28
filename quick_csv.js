/**
 * Created with JetBrains WebStorm.
 * User: aantich
 * Date: 9/28/12
 * Time: 3:37 PM
 * To change this template use File | Settings | File Templates.
 */
// CSV sample - Copyright David Worms <open@adaltas.com> (BSD Licensed)
// cat samples/sample.in | node samples/sample-stdin.js

var csv = require('csv');

process.stdin.resume();
csv()
    .fromStream(process.stdin)
    .toPath(__dirname+'/sample.out')
    .transform(function(data){
        data.unshift(data.pop());
        return data;
    })
    .on('data',function(data,index){
        console.log(JSON.stringify(data));
    })
    /*
    .on('end',function(count){
        console.log('Number of lines: '+count);
    })*/
    .on('error',function(error){
        console.log(error.message);
    });
