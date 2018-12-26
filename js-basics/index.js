console.log('hello world');   // statement. log something on the console 

// variables 

let name1; // undefined 
let name = 'pusheen';  // string literal 
let age = 30;          // number literal 
let isApproved = true; // boolean literal 
let lastName = null;   // type of it is object
console.log(name);

// constant. can not re-assign a constant 
// if need to re-assign, use let. 
const interestRate = 0.3;
console.log(interestRate);


// primatives/value types: string, number, boolean, undefined, null
// reference types: object, array, function

// -------- object 

let cat = {     // object literal
    name: 'pusheen', 
    age: 3
};
console.log(cat);

// dot notation
cat.name = 'stormy';
console.log(cat.name);

// bracket notation 
cat['name'] = 'pip';
console.log(cat.name);



// -------- array (an object in js)
let selectedColors = ['red', 'blue'];   // array literal: denote an empty array 
selectedColors[2] = 'green';
console.log(selectedColors);   // index starts from 0
console.log(selectedColors.length);   // property

// --------------- functions 

function greet(name){    // parameter
    console.log('hello ' + name);
}

greet('stormy');  // argument
greet('sloth');

function add3(x){
    return x+3;   
}
console.log (add3(5));