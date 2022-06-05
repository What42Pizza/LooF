### Files that start with #include Basics.LOOF can use these tricks that improve the syntax

<br>
<br>
<br>

### Defining a function:

<br>

```
function ExampleFunction
	// do stuff
	return // ALWAYS HAVE RETURN AT THE END OF YOUR FUNCTION
end

OR

function ExampleFunction  -> Arg1, Arg2, etc
	// do stuff
	return // ALWAYS HAVE RETURN AT THE END OF YOUR FUNCTION
end

OR

function ExampleFunction  throwsErrors {"ErrorType1", "ErrorType2", etc}
	// do stuff
	return // ALWAYS HAVE RETURN AT THE END OF YOUR FUNCTION
end

OR

function ExampleFunction  -> Arg1, Arg2, etc  throwsErrors {"ErrorType1", "ErrorType2", etc}
	// do stuff
	return // ALWAYS HAVE RETURN AT THE END OF YOUR FUNCTION
end
```

<br>
<br>
<br>

### Calling a function:

<br>

```
call ExampleFunction
OR
call ExampleFunction, Arg1, Arg2, etc
OR
call ExampleFunction  -> ReturnValue1, ReturnValue2, etc
OR
call ExampleFunction, Arg1, Arg2, etc  -> ReturnValue1, ReturnValue2, etc
```

<br>
<br>
<br>

### If statements:

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

### Inserting values into strings:

<br>

```
ExampleValue1 = 1
ExampleValue2 = 2.5

ExampleString = "First value: {\`ExampleValue1\`}, second value: {\`ExampleValue2\`}, combined: {\`ExampleValue1 + ExampleValue2\`}."
```

<br>
<br>
<br>

### Calling functions in BasicFunctions.LOOF:

<br>

If there's a function in BasicFunctions.LOOF that you want to call, you can just write ":" and the name of the function. Examples:

```
:print "Hello, World!"
:exit
```

<br>
<br>
<br>

### BasicFunctions.LOOF functions: (more probably to come)

<br>

- **:print (optional) Arg1, (Optional) Arg2, etc**
- **:exit**
- **:addItem TableIn, Item**
- **:removeIndex TableIn, Index (int)**
- **:addAll TargetTable, SourceTable**
- **:ensureArgTypesAreCorrect Args (table), ExpectedArgTypes (table {string, ...})**