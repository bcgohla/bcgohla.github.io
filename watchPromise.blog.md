How to Track the Progress of Deferred Objects
=============================================

A very elegant way of writing asynchronous code in
[Node.js](http://www.nodejs.org) is to use
[promises](http://promises-aplus.github.io/promises-spec/). I've been
using the [Q](https://github.com/kriskowal/q) implementation of this
idea.

So, instead of having functions that use callbacks to process the
result of an asynchronous action, one returns a promise for that
result. A promise then is an object that can be queried and that we
can attach callbacks to dealing with resolution, rejection and
progress.

~~~~~~~~~~~~~{.numberLines startfrom=100}
var Q = require('q');

var defer = Q.defer();

function doSomeStuff(defer, i){
    defer.notify("progress: " + i);
    setTimeout(
        function(){
            if (i>0) {
            return doSomeStuff(defer, i-1);
            }
            else {
                defer.resolve('done');            
            }
        },
        100
    );

    return defer.promise;
}


function watch(prom){
    setTimeout(
        function(){
            console.log("watching the promise: " 
                + JSON.stringify(prom.inspect()));
            watch(prom);
        },
        1000
    );
}

watch(
    doSomeStuff(defer,100)
    .then(
        console.log,
        console.log,
        console.log
    )
);
~~~~~~~~~~~~~


When you run this in node.js you see this:

~~~~~~~~~~~~
progress: 99
progress: 98
progress: 97
progress: 96
progress: 95
progress: 94
progress: 93
progress: 92
progress: 91
progress: 90
watching the promise: {"state":"pending"}
progress: 89
progress: 88
progress: 87
progress: 86
progress: 85
…
progress: 7
progress: 6
progress: 5
progress: 4
progress: 3
progress: 2
progress: 1
watching the promise: {"state":"pending"}
progress: 0
done
watching the promise: {"state":"fulfilled"}
watching the promise: {"state":"fulfilled"}
watching the promise: {"state":"fulfilled"}
~~~~~~~~~~~~
