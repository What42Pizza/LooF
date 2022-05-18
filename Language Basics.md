**Code starts executing at the start of the file Main.LOOF. If Main.LOOF cannot be found, the compilation will error.**

**Lines starting with "#" are pre-processor statements, and lines or tokens starting with "$" are linker statements.**

**NOTE: This language has no real sense of code blocks. The main effect of this is that a variable that is initialized in what looks like a code block will be accessible outside that "block".**

<br>
<br>
<br>

### Comment:

<br>

// comment

<br>
<br>
<br>

### Variable definition:

<br>

ExampleVar = 123 // start ExampleVar with the number 123

ExampleVar = {} // set it to an empty array

ExampleVar[0] = 456 // add 456 to the array

ExampleVar["1"] = 789 // add 789 to the hashmap part of the array

<br>

#### Data Value types:

null

int

float

string

bool

table (with both an array part and a hashmap part (with String keys))

byteArray

<br>
<br>
<br>

### If statements:

<br>

With basics.LOOF:

```
if ExampleCondition
	// single statement code block

OR

if\_ ExampleCondition then
	// multiple statement code block
end
```

<br>
	
Without Basics.LOOF:

```
if ExampleCondition
	// single statement code block

OR

if not ExampleCondition
skip
	// multiple statement code block
end
```

<br>
<br>
<br>

### Function definition:

<br>

With Basics.LOOF:

```
function ExampleFunction  -> Arg1, Arg2, etc
	// do stuff
	return // ALWAYS HAVE RETURN AT THE END OF YOUR FUNCTION
end
```

<br>

Without Basics.LOOF:

```
skip
$function ExampleFunction
	pop ARGS, Arg1, Arg2, etc
	// do stuff
	return
end
```

<br>

Functions work like labels, so you have to put a "skip" statement proceeding a function (and "end" after it) so that execution doesn't just go into the function when it gets to it. Also, if you don't have a return statement at the end of a function, execution will just keep going into whatever's next (it will probably skip over all the following functions and error when it gets to the end of the file)

<br>
<br>
<br>

### Calling a function:

<br>

With Basics.LOOF:

```
call ExampleFunction, Arg1, Arg2, etc
OR
call ExampleFunction, Arg1, Arg2, etc  -> ReturnValue1, ReturnValue2, etc
```

<br>

Without Basics.LOOF:

```
call $ExampleFunction, Arg1, Arg2, etc
OR
call $ExampleFunction, Arg1, Arg2, etc
pop ARGS, ReturnValue1, ReturnValue2, etc
```

<br>
<br>
<br>

### Linking a file:

<br>

```
#link ExampleFolder.ExampleFolder(...).ExampleFileName
OR
#link ExampleFolder.ExampleFolder(...).ExampleFileName as ExampleShortenedName
```

<br>

When linking a file, only have to write out the end of the file name. If you want to link ExampleFolder.ExampleFileName.LOOF, you can just write "#link e.LOOF". This example is obviously a bad idea, though, since you can only have one file that ends with "e.LOOF". It would be much better to write "#link ExampleFileName.LOOF" here. If you try to link with a name that fits more than one file, the code will not compile.

<br>
<br>
<br>

### Calling a function from another file:

<br>

With Basics.LOOF:

```
call ExampleFileName.ExampleFunction, Arg1, Arg2, etc // file name doesn't include ".LOOF"
OR
call ExampleShortenedName.ExampleFunction, Arg1, Arg2, etc // file name doesn't include ".LOOF"
```

Without Basics.LOOF:

```
call $ExampleFileName.ExampleFunction, Arg1, Arg2, etc // file name doesn't include ".LOOF"
OR
call $ExampleShortenedName.ExampleFunction, Arg1, Arg2, etc // file name doesn't include ".LOOF"
```

<br>
<br>
<br>

### Printing:

<br>

With Basics.LOOF:

```
:println "ExampleString"
:println 12345
```

<br>

Without Basics.LOOF:

```
callOutside "console", "println", "ExampleString"
callOutside "console", "println", 12345
```

<br>
<br>
<br>

### Exiting:

<br>

With Basics.LOOF:

```
:exit
```

<br>

Without Basics.LOOF:

```
callOutside "interpreter", "stop"
```