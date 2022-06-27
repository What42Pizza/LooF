# LooF Guide

#### This is a collection of information and challenges that can help you learn LooF.

<br>
<br>
<br>

## Value Types

<br>

**In LooF, there are 8 types of values:**

- **null**
- **int**
- **float**
- **string**
- **bool**
- **table**
- **byteArray**
- **function**

<br>

**Examples:**

```
ExampleNull = null
ExampleInt = 10
ExampleFloat = 3.14
ExampleString = "Hello, World!"
ExampleBool = true
ExampleTable = {1, 2, 3}
ExampleByteArray = newByteArray 10
ExampleFunction = $ExampleFunctionName
```

<br>

**Extra information about value types:**

- **null: Nothing special, it's just null**
- **int: Just a 64-bit integer (long in Java)**
- **float: Just a 64-bit float (double in Java)**
- **string: Just a string (acts the same as in java)**
- **bool: Just a bool**
- **table: Tables have both an array part and a hashmap part. The array part is indexed with ints, and the hashmap part is indexed with strings.**
- **byteArray: Useful when you want to store a lot of data in an efficient manner.**
- **function: A struct for defining where a function is.**

<br>
<br>
<br>

## Basic Syntax

<br>

**Statements in LooF generally all follow the same patterns. Exceptions to these rules can only exist because of the pre-processor, which is used heavily to improve LooF's syntax.**

<br>
<br>

### Basic Statements

**For variable declaration / assignment, you write the variable name, the assignment operation, and (optionally) the value to assign to / modify with. Examples:**

```
i = 0
i ++
i += 10
```

<br>

**For other statements, you write the statement name and (optionally) its arguments (with commas in-between each arg). Examples:**

```
loop i, 1, 10
	breakIf i == 3
repeat
```

<br>
<br>

### Evaluator

**For a full list of statements (including variable definitions and assignments) and information about arguments and general statement details, you can go to LooF/Documentation/Statements.md**

**For a guide on more complicated syntax, you can go to LooF/Documentation/Basics.LOOF.md**

<br>

**Formulas are an important part of LooF (or any language for that matter), so I made sure to do them well. You can write things out pretty much like you'd expect, though there are some oddities you need to know about.**

**There are two types of 'operations' that you can use in LooF. The first type, known as EvaluatorOperation, works exactly as expected. They take two inputs, one on each side, and evaluate for a single value. Examples:**

```
_ = 1 + 2  // 3
_ = "Hello, " .. "World!"  // "Hello, World!"
_ = "10" == 10  // throws error
```

<br>

**The other type of 'operation' is called EvaluatorFunction. It takes a single input (on the right) and evaluates to a single value. EvaluatorFunctions include round, min, max, random, and MANY more. You might have noticed something wrong, though, which is that these functions (including min and max) can only take a single value. The way LooF gets around this is by passing multiple values using a table. Examples:**

```
_ = round 1.5  // 2
_ = min {3, 4} // 3
_ = sqrt 4  // 2
_ = sqrt (4)  // 2
_ = sqrt(4)  // 2
_ = atan2 {y, x}
_ = lengthOf "Hello, World!"  // 13
_ = lengthOf {1, 2, 3, 4, 5}  // 5
```

**For a list of all EvaluatorOperations, EvaluatorFunctions, order of operations, constants, convertion details, and equality details, you can go to LooF/Documentation/Evaluator.md**

<br>
<br>

### Formulas

**As you'd expect, tables start and end with curly braces, they're indexed with brackets, and formulas can be created with parentheses (statements and tables don't need their arguments (which are formulas) to be enclosed in parentheses, which means you don't have to write `a = (3)` or `return (false)`). Also, you can initialize a table with hashmap values by writing the string key followed by a colon and the value to set it to. Examples:**

```
ExampleTable[3] = {lengthOf A, B * (C + D), E[F + G]}
ExampleTable = {1, 2, 3, a: 4, b: 5, c: 6, 7, 8, 9}
```

<br>
<br>
<br>
<br>
<br>

# Challenge 1:

### Write a Hello World program (that doesn't crash)

<br>

**(Hint: you'll probably have to look further than Statements.md)**

<br>
<br>
<br>
<br>
<br>

### If Statements

**Below are two examples of how you can do 'if' statements. That should be all you need to figure it out.**

```
// single statement 'if'
if a > 2
	a += 3

// multi-statement 'if'
if a > 2 then
	a += 5
	a /= 3
end
```

<br>

**NOTE: The second example (the 'if-then') has to include Basics.LOOF to work.**

<br>
<br>
<br>

### Loops

**There are three ways to loop in LooF (not including recursion), and they are 'loop', 'while', and 'forEach'. All three of these need a 'repeat' / 'repeatIf' statement to end the code block they create).**

<br>

**Loop can take anywhere from 0 to 4 arguments (not 1 though).**

- **If there are no args, it will loop until 'break' / 'breakIf' are called.**
- **If args are present, the first arg will be the "index" variable (or whatever you're using it for).**
- **If there are two args, the second arg will be the final value (inclusive).**
- **If there are three args, the second arg will be the starting value and the third arg will be the final value (again, inclusive).**
- **If there are four args, the fourth arg will be the increment value.**

**Examples:**

```
loop
	// runs until broken
repeat

loop i, 5
	// runs with i from 0 to 5 (inclusive)
repeat

loop i, 2, 5
	// runs with i from 2 to 5 (inclusive)
repeat

loop i, 2, 7, 2
	// runs with i as 2, 4, and 6
repeat

loop i, 10
	// errors due to wrong ending statement
end



ExampleArray = {1, 2, 3, 4, 5}
Total = 0
loop i, endOf ExampleArray
	Total += ExampleArray[i]
repeat
```

<br>

**While acts just like you'd expect. It takes 1 arg and it loops until the arg is falsey. Example:**

```
while true
	// runs until broken
repeat
```

<br>

**ForEach allows you to iterate over an array. The first arg is the var to put the items in, the second arg is the table / byteArray to iterate over, and the third arg, if present, is the var to put the index in. Example:**

```
ExampleArray = {1, 2, 3, 4, 5}
Total = 0
forEach Item, ExampleArray
	Total += Item
repeat
```

<br>

**There are six statements relating to loops, some I've already talking about. They are 'continue', 'continueIf', 'break', 'breakIf', 'repeat', and 'repeatIf'. As you can see, half of them are 'if' variants, so there's really only three you need to know, and they all work exactly as you'd expect.**

**Continue starts the next loop, and continueIf starts the next loop if its arg is truthy.**

**Break exits the loop, and breakIf exits the loop if its arg is truthy.**

**Repeat and repeatIf act just like continue and continueIf, but these end the code block.**

**Example:**

```
i = 0
while true
	
	if // other code
		if // other other code
			break
		end
	end
	
	continueIf i == 3 // this freezes the program
	
	i ++
repeatIf i < 10
```

<br>
<br>
<br>
<br>
<br>

# Challenge 2:

### Write a FizzBuzz program

<br>

# Challenge 3:

### Using 'forEach', print the index and value of every item in a table.

<br>

#### Extra Challenge (4): Solve the Double Cola problem (https://codeforces.com/problemset/problem/82/A)

<br>
<br>
<br>
<br>
<br>

## Functions

**NOTE: All of this assumes you include Basics.LOOF**

<br>

**To define a function, you write "function " and the name of the function. At the end, you always put a 'return' statement and an 'end' statement. Example:**

```
function ExampleFunction
	a = 10
	return a * 5
end
```

<br>

**To pass arguments, you add "  -> " (two spaces, a dash, a greater than symbol, and one more space) after the name of the function, followed by the name of the args. Example:**

```
function Double  -> Input
	return Input * 2
end
```

<br>

**To pass errors so that the current function isn't visible on the stack trace, you add "  throwsErrors " (again, two spaces before and one space after) either before or after the arguments, followed by the types of errors to pass. If you want all errors to be passed, put "all" as the first (and only needed) value. Examples:**

```
function FunctionThatCrashes  throwsErrors {"CustomErrorType"}
	error "example error message", {"CustomErrorType"}
end

function AnotherFunctionThatCrashes  -> ThisArgIsVoid  throwsErrors {"all"}
	error "etc", {"CustomErrorType"}
end
```

<br>

**To call a function, you use the 'call' statement. The first argument is the function name, and all remaining arguments are passed to the function. Example:**

```
function Double  -> Input
	return Input * 2
end

call Double, 10
```

<br>

**To use the returned value, you can use the same syntax as function arguments. Example:**

```
function Double  -> Input
	return Input * 2
end

call Double, 10  -> DoubledValue
```

<br>
<br>
<br>
<br>
<br>

# Challenge 5:

### Write a Factorial function

<br>

# Challenge 6:

### Write a function that recursively prints all the values in this table:

```
TableToPrint = {1, 2, {3, 4, {5, 6, 7, 8}, 9, 10, {{11}}}, {12, {13}, 14}, 15, 16, {17, 18}}
```

<br>

# Challenge 7:

### Write an Ackermann function