Code starts executing at the start of the file Main.LOOF. If Main.LOOF cannot be found, the compilation will error.

Lines starting with "#" are pre-processor statements, and lines or tokens starting with "$" are linker statements.

### Comment:

// comment

### Variable definition:

ExampleVar = 123 // start ExampleVar with the number 123
ExampleVar = {} // set it to an empty array
ExampleVar[0] = 456 // add 456 to the array
ExampleVar["1"] = 789 // add 789 to the hashmap part of the array

Data Value types:
null
number
string
boolean
table (with both an array part and a HashMap

### If statements:

With basics.LOOF:
if ExampleTest
	// single statement code block
OR
if\_ ExampleTest then
	// multiple statement code block
end
	
Without Basics.LOOF:
if ExampleTest
	// single statement code block
OR
if not (ExampleTest)
skip
	// multiple statement code block
end

### Function definition:

With Basics.LOOF:
function ExampleFunc  -> Arg1, Arg2, etc
	// do stuff
	return // ALWAYS HAVE RETURN AT THE END OF YOUR FUNCTION
end

Without Basics.LOOF:
skip
$function ExampleFunc
	pop ARGS, Arg1, Arg2, etc
	// do stuff
	return
end

Functions work like labels, so you have to put a "skip" statement proceeding a function (and "end" after it) so that execution doesn't just go into the function when it gets to it. Also, if you don't have a return statement at the end of a function, execution will just keep going into whatever's next (it will probably skip over all the following functions and error when it gets to the end of the file)

### Calling a function:

With Basics.LOOF:
call ExampleFunc, Arg1, Arg2, etc
OR
call ExampleFunc, Arg1, Arg2, etc  -> ReturnValue1, ReturnValue2, etc

Without Basics.LOOF:
call $ExampleFunc, Arg1, Arg2, etc
OR
call $ExampleFunc, Arg1, Arg2, etc
pop ARGS, ReturnValue1, ReturnValue2, etc

### Linking a file:

 #link ParentFolder.ParentFolder(...).FileName
OR
 #link ParentFolder.ParentFolder(...).FileName as ShortenedName

When linking a file, only have to write out the end of the file name. If you want to link ExampleFolder.ExampleFile.LOOF, you can just write "#link e.LOOF". This example is obviously a bad idea, though, since you can only have one file that ends with "e.LOOF". It would be much better to write "#link ExampleFile.LOOF" here. If you try to link with a name that fits more than one file, the code will not compile.

### Calling a function from another file:

With Basics.LOOF:
call FileName.ExampleFunc, Arg1, Arg2, etc // FileName doesn't include ".LOOF"
OR
call ShortenedName.ExampleFunc, Arg1, Arg2, etc // FileName doesn't include ".LOOF"

Without Basics.LOOF:
call $FileName.ExampleFunc, Arg1, Arg2, etc // FileName doesn't include ".LOOF"
OR
call $ShortenedName.ExampleFunc, Arg1, Arg2, etc // FileName doesn't include ".LOOF"

### Printing:

With Basics.LOOF:
:println "ExampleString"
:println 12345

Without Basics:
callOutside "console", "println", "ExampleString"
callOutside "console", "println", 12345

Exiting:

With Basics.LOOF:
:exit

Without Basics.LOOF:
callOutside "interpreter", "stop"