How to Compose Functions in Javascript
======================================

Of course you have heard of the
[_.compose](http://underscorejs.org/#compose) function in the
[Underscore](http://underscorejs.org) library. But thinking of
function composition as an operator I would like to be able to write 

~~~~~~~
f.g 
~~~~~~~

Given how JS doesn't let you define new operators, I guess i can make do with

~~~~~~~
f.after(g)
~~~~~~~

So, extending the Function.prototype thus

~~~~~~~
Function.prototype.after = function after (f){
    if (typeof this !== "function") {     
        throw new TypeError("Function.prototype.after - can only compose with a function!");
    }

    var self = this;

    return function(){
        args = Array.prototype.slice.apply(arguments);
        return self(f.apply(this, args));
    };
};
~~~~~~~

allows just that. So now you can do this:

~~~~~~~
function add1(x){
    return x+1;
}

function add5(x){
    return x+5;
}

function id(x){
    return x;
}

console.log(add5.after(add1)(2)); // 8

console.log(id.after(id)("hello", "there")); // "hello"
~~~~~~~
