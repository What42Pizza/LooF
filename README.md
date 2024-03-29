# LooF

<br>

# THIS IS STILL A WORK IN PROGRESS AND IS NOT MEANT TO BE USED YET

<br>

### This is a language that is loosely functional. It's interpreted, loosely typed, and has (mostly) mutable data.

### The interpreter for this language was made using Processing 3 (and it should work with Processing 4), and you need Processing 3 or 4 to use this.

<br>
<br>
<br>

## I highly suggest checking out LooFDocumentation/Guide.md to get started with leaning this language.

<br>
<br>
<br>
<br>
<br>

## The goals I have for this language (in order of importance):

<br>

### Finish it

I haven't finished any of my programming languages in years, and the last one I did finish was probably an assembly language. Most of my previous languages were taken over by feature-creeping, and when it came time to make the interpreter, I got overwhelmed and "pushed it to the side".

### Practicalness

I want this to be a decent choice for actually getting something done, which would be a first for my languages.

### Simplicity

I want this language to be really simple (partially so that it's easier to make), and I'm okay with this goal sometimes getting in the way of the language being easy to use.

### Modularity

I want this language to be very modular, and there are currently 5 ways to easily add features to this language:

- **Interpreter Modules**
  - These contain java code that can be accesses through LooF code
- **Interpreter Assignments**
  - These define statements that alter the values of variables (eg "=", "+=", etc)
- **Interpreter Functions**
  - These define statements that alter the environment, variables, and more (eg "if", "loop", "return", etc)
- **Evaluator Operations**
  - These define operations that the evaluator can use (eg "+", "%", "==", etc). These take in inputs from both the left and the right
- **Evaluator Functions**
  - These define functions that the evaluator can use (eg "min", "typeOf", etc). These take in a single input from the right

### Decent speed

I'm doing my best to take performance into account, and I'm having the compiler do as much of the work as possible. Being that the core interpreter (not counting add-ons) is (currently) 5x times smaller than the compiler, I'm pretty sure I've done a good job.

### Decent error messages

I'm also doing my best to make the error messages informative, easy to read, and as helpful as possible.

<br>
<br>
<br>

## Example code:

<br>

### Factorial:

```
#include Basics.LOOF



function Factorial  args: In
	returnIf (In == 1), 1
	call Factorial, In - 1  -> NextProduct
	return In * NextProduct
end



call Factorial, 10  -> FactorialResult
:print FactorialResult
:exit
```

<br>

### Linking example:

```
// in GeneralFunctions.LOOF

#include Basics.LOOF

function ConvertTableToString  args: TableIn, Seperator  throwsErrors {"InvalidArgType"}
	errorIf (typeOf TableIn != "table"), "function ConvertTableToString must take a table as its first arg.", {"InvalidArgType"}
	Seperator <<defaultsTo ", "
	errorIf (typeOf Seperator != "string"), "function ConvertTableToString must take a string or null as its second arg.", {"InvalidArgType"}
	
	returnIf (lengthOf TableIn == 0), ""
	
	StringOut = toString TableIn[0]
	loop i, 1, endOf TableIn
		StringOut ..= Sepeator .. TableIn[i]
	repeat
	
	return StringOut
end



// in Main.LOOF

#include Basics.LOOF
$link GeneralFunctions.LOOF as F

call F.ConvertTableToString, {10, 20, "Example"}  -> TableAsString
:print TableAsString
:exit
```

<br>
<br>
<br>

## License

[MIT License](LICENSE)