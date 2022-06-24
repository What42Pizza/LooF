## Files that start with #include Basics.LOOF can use these tricks that improve the syntax

<br>
<br>
<br>

## Defining a function:

<br>

**Start a line with "function " then write the name of the function. At the end of the function, have "return" and "end".**

**After that, you can add args seperated by commas. At the end of the line, you can write "  -> " (two spaces on the right, one space on the left) followed by the names of variables to put the args in.**

**After that, you can write "  throwsErrors " (two spaces on the right, one space on the left) followed by a table containing the types of errors that the function will pass on if / when they occur.**

**Examples:**

```
function ExampleFunction1
	// do stuff
	return // ALWAYS HAVE RETURN AT THE END OF YOUR FUNCTION
end

OR

function ExampleFunction2  -> Arg1, Arg2, etc
	// do stuff
	return // ALWAYS HAVE RETURN AT THE END OF YOUR FUNCTION
end

OR

function ExampleFunction3  throwsErrors {"ErrorType1", "ErrorType2", etc}
	// do stuff
	return // ALWAYS HAVE RETURN AT THE END OF YOUR FUNCTION
end

OR

function ExampleFunction4  -> Arg1, Arg2, etc  throwsErrors {"ErrorType1", "ErrorType2", etc}
	// do stuff
	return // ALWAYS HAVE RETURN AT THE END OF YOUR FUNCTION
end
```

<br>
<br>
<br>

## Calling a function:

<br>

**Start a line with "call " and write the name of the function.**

**After that, you can add args seperated by commas. At the end of the line, you can write "  -> " (two spaces on the right, one space on the left) followed by the names of variables to put the return values in.**

<br>

Examples:

```
call ExampleFunction

call ExampleFunction, Arg1, Arg2, etc

call ExampleFunction  -> ReturnValue1, ReturnValue2, etc

call ExampleFunction, Arg1, Arg2, etc  -> ReturnValue1, ReturnValue2, etc
```

<br>

### Calling a function in a lower-level way:

```
ExampleFunc = $Basics.print
call_ ExampleFunc

call_ switch {"A", {A: $Basics.exit, B: $Basics.print}}
```

<br>

**NOTE: this works by replacing lines like "call FuncName" with "call $FuncName" and by replacing lines like "call_ FuncPointer" with "call FuncPointer".**

<br>
<br>
<br>

## If statements:

<br>

```
// single statement block:
if ExampleCondition
	// code

OR

// multiple statement block
if ExampleCondition then
	//code
end
```

<br>
<br>
<br>

## Inserting values into strings:

<br>

**In a quote, put "{\`" to start an expression and "\`}" to end it.**=

**Example:**

```
ExampleValue1 = 1
ExampleValue2 = 2.5

ExampleString = "First value: {`ExampleValue1`}, second value: {`ExampleValue2`}, combined: {`ExampleValue1 + ExampleValue2`}."
```

<br>
<br>
<br>

## Separating / combining lines of code:

<br>

**If you want a line of code to be separated into multiple lines of code, put a semicolon where you want the line to split.**

**If you want a line of code to be appended to the previous line of code, start the line of code with a back-tick (`).**

**Example:**

```
// Combined lines of code:
if ExampleCondition; :println "ExampleCondition is true"

// Seperated line of code:
ExampleVar = {
`	"A",
`	"B",
`	"C"
`}
```

<br>
<br>
<br>

## Calling functions in BasicFunctions.LOOF:

<br>

**If there's a function in BasicFunctions.LOOF that you want to call, you can just write ":" and the name of the function.**

**Examples:**

```
:print "Hello, World!"
:exit
```

<br>
<br>
<br>

## Functions in BasicFunctions.LOOF: (more probably to come)

<br>

- **:print (optional) Arg1, (Optional) Arg2, etc**
- **:exit**
- **:addItem TableIn, Item**
- **:removeIndex TableIn, Index (int)**
- **:addAll TargetTable, SourceTable**
- **:ensureArgTypesAreCorrect Args (table), ExpectedArgTypes (table {string, ...})**