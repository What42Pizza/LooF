This is a language that is loosely functional. It's interpreted, loosely typed, and has (mostly) mutable data.





Basics:



Code starts executing at the start of the file Main.LOOF. If Main.LOOF cannot be found, the compilation will error.

The character '#' generally refers to pre-processor statements and the character '$' generally refers to linker statements.





Comment:
// comment





Variable definition:

ExampleVar = 123 // start ExampleVar with the number 123
ExampleVar = {} // set it to an empty array
ExampleVar[0] = 456 // add 456 to the array
ExampleVar["1"] = 789 // add 789 to the hashmap part of the array

Data Value types:
null
number
string
boolean
table (with both an array part and a HashMap <String, LooFDataValue> part)





If statements:

With basics.LOOF:
if ExampleTest
	// single statement code block
OR
if_ ExampleTest then
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





Function definition:

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





Calling a function:

With Basics.LOOF:
call ExampleFunc, Arg1, Arg2, etc
OR
call ExampleFunc, Arg1, Arg2, etc  -> ReturnValue1, ReturnValue2, etc

Without Basics.LOOF:
call $ExampleFunc, Arg1, Arg2, etc
OR
call $ExampleFunc, Arg1, Arg2, etc
pop ARGS, ReturnValue1, ReturnValue2, etc





Linking a file:
#link ParentFolder.ParentFolder(...).FileName
OR
#link ParentFolder.ParentFolder(...).FileName as ShortenedName

When linking a file, only have to write out the end of the file name. If you want to link ExampleFolder.ExampleFile.LOOF, you can just write "#link e.LOOF". This example is obviously a bad idea, though, since you can only have one file that ends with "e.LOOF". It would be much better to write "#link ExampleFile.LOOF" here. If you try to link with a name that fits more than one file, the code will not compile.





Calling a function from another file:

With Basics.LOOF:
call FileName.ExampleFunc, Arg1, Arg2, etc // FileName doesn't include ".LOOF"
OR
call ShortenedName.ExampleFunc, Arg1, Arg2, etc // FileName doesn't include ".LOOF"

Without Basics.LOOF:
call $FileName.ExampleFunc, Arg1, Arg2, etc // FileName doesn't include ".LOOF"
OR
call $ShortenedName.ExampleFunc, Arg1, Arg2, etc // FileName doesn't include ".LOOF"





Printing:

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





You can look through the rest of this to see how to use the different statements and "callOutside" Modules.




















Statements:



VAR_NAME = VALUE
	Sets VAR_NAME to VAlUE

VAR_NAME [VALUE (int)] ... = VALUE
	Sets the given index of VAR_NAME to the last VALUE

default VAR_NAME = VALUE
	Sets VAR_NAME to VALUE only if VAR_NAME is null



push VALUE
	Pushes VALUE to the general stack

pop VAR_NAME
	Pops the first value of the general stack into VAR_NAME. Errors if the general stack is empty

pop VAR_NAME (table), VAR_NAME (item 0 of table), ...
	Pops the first value of the general stack into the first VAR_NAME, then sets the second VAR_NAME to index 0 of the first VAR_NAME, sets the thrid VAR_NAME to index 1 of the first VAR_NAME, etc. Errors if the first VAR_NAME is not a table or if the general stack is empty



call VALUE (int: funtion line numebr)
	Pushes the instruction pointer to a stack and jumps execution to line described by VALUE

call VALUE (string: function file name), VALUE (int: function line number)

call VALUE (int: funtion line number), VALUE (arg 1), ...
	Pushes the instruction pointer to a stack and jumps execution to line described by VALUE and pushes all remaining VALUEs to the general stack in a single table

call VALUE (string: function file name), VALUE (int: function line number), VALUE (arg 1), ...
	Pushes the instruction pointer to a stack and jumps execution to line described by the first VALUE in file described by the second VALUE and pushes all remaining VALUEs to the general stack in a single table



return
	Jumps execution to the popped value of the IP stack. Errors if the IP stack is empty

return VALUE
	Pushes VALUE to the general stack and jumps execution to the popped value of the IP stack. Erros if the IP stack is empty

returnIf VALUE (condition)
	Only if VALUE is truthy, jumps execution to the popped value of the IP stack. Errors if the IP stack is empty

returnIf VALUE (condition), VALUE (return value)
	Only if the first VALUE is truthy, pushes the second VALUE to the general stack and jumps execution to the popped value of the IP stack. Erros if the IP stack is empty



if VALUE (contition)
	Only if VALUE is truthy, executes the next line of code (otherwise skips it)



skip
	Jumps execution to after the first 'end' statement it can find that is on the same code block level. Errors if no suitable 'end' statement is found

end
	Effectively nop; only useful because of 'skip' statements



loop
	Effectively nop; only useful because of repeat

loop VAR_NAME, VALUE (start), VALUE (end)
	Same as statement 'loop VAR_NAME, VALUE, VALUE, VALUE' but the thrid VALUE is assumed to be the number 1

loop VAR_NAME, VALUE (start), VALUE (end), VALUE (increment)
	If VAR_NAME is null:  Sets VAR_NAME to the first VALUE
	If VAR_NAME plus the second VALUE is less than the second VALUE:  Increments VAR_NAME by the third VALUE
	If VAR_NAME plus the second VALUE is greater than or equal to the second VALUE:  Jumps execution to after the first 'repeat' statement it can find that is on the same code block level. Errors if no suitable 'repeat' statement is found

forEach VAR_NAME, VALUE (table)
	Same as statement 'forEach VAR_NAME, VALUE, VAR_NAME' but with the second VAR_NAME being is assumed to be "_" .. the first VAR_NAME. Errors if VALUE is not a table

forEach VAR_NAME, VALUE (table), VAR_NAME
	If the second VAR_NAME is null:  Sets the second VAR_NAME to 0 and the first VAR_NAME to VALUE indexed with the second VAR_NAME. Erros if VALUE is not a table
	If the second VAR_NAME plus 2 is less than the length of VALUE:  Increments the second VAR_NAME and sets the first VAR_NAME to VALUE indexed with the second VAR_NAME. Erros if VALUE is not a table
	If the second VAR_NAME plus 2 is not less than the length of VALUE:  Jumps execution to after the first 'repeat' statement it can find that is on the same code block level. Errors if VALUE is not a table or if no suitable 'repeat' statement is found

while VALUE
	If VALUE is truthy:  Effectively nop; only useful because of the other while conditions
	If VALUE is falsey:  Jumps execution to after the first 'repeat' statement it can find that is on the same code block level. Errors if no suitable 'repeat' statement is found

repeat
	Jumps execution to the first 'loop', 'while', or 'forEach' statement it can find proceeding this repeat statement that is on the same code block level. Errors if no suitable 'loop' or 'while' statement is found

repeatIf VALUE (condition)
	Only is VALUE is truthy, jumps execution to the first 'loop' or 'while' statement it can find proceeding this repeat statement that is on the same code block level. Errors if no suitable 'loop' or 'while' statement is found

continue
	Jumps execution to the next 'repeat' statement

continueIf VALUE (condition)
	Only if VALUE is truthy, jumps execution to the next 'repeat' statement'

break
	Jumps execution to after the first 'repeat' statement it can find that is on the same code block level. Errors if no suitable 'repeat' statement is found

breakIf VALUE
	Only if VALUE is truthy, jumps execution to after the first 'repeat' statement it can find that is on the same code block level. Errors if no suitable 'repeat' statement is found



error VALUE (error message)
	Stops execution with the interpreter in an error state and with VALUE as the error message. Overrides this error with a new error if VALUE is not a string

error VALUE (error message), VALUE (table: tags)
	Stops execution with the interpreter in an error state, with the first VALUE as the error message, and with the second VALUE as the tags for the error. Overrides this error with a new error if the first VALUE is not a string or if the second VALUE is not a table

errorIf VALUE (condition), VALUE (error message)
	Only if the first VALUE is truthy, stops execution with the interpreter in an error state and with the second VALUE as the error message. Overrides this error with a new error if the second VALUE is not a string

errorIf VALUE (condition), VALUE (error message), VALUE (table: tags)
	Only if the first VALUE is truthy, stops execution with the interpreter in an error state, with the second VALUE as the error message, and with the third VALUE as the tags for the error. Overrides this error with a new error if the second VALUE is not a string or if the third VALUE is not a table



callOutside VALUE (string: module), VALUE (arg 1), ...
	Sends the the remaining VALUEs to the external module VALUE. Erros if the first VALUE is not a string.










Preprocessor statements:

#include FILE_NAME
	copies and pastes the contents of the FILE_NAME

#replace STRING1 STRING2
	replaces all occurances of STRING1 with STRING2

#if_equal STRING1 STRING2
	deletes all following code up to next #end_if (on same level) if STRING1 does not equal STRING2

#if_not_equal STRING1 STRING2
	deletes all following code up to next #end_if (on same level) if STRING1 equals STRING2

#end_if
	effectively nop; only useful because of 'if' statements

#ignore_header
	skips adding the header file if this is the first line in the file (#include-s are processed after this check, so if file A includes a file B that starts with #ignore_header, file A will still include the header)



NOT IMPLEMENTED:
#replace_recursive STRING1 STRING2
	works like #replace but acts recursively





Linker statements:

$function FUNCTION_NAME
	defines the location of a function pointer

$link FILE_NAME
	gives the current file access to all the functions in FILE_NAME. Calls to functions in FILE_NAME have to be proceeded by the name of the linked file, with only a period instead of ".LOOF"

$link FILE_NAME as STRING
	gives the current file access to all the functions in FILE_NAME. Calls to functions in FILE_NAME have to be proceeded by STRING and a period










Evaluator operators:

+
-
*
/
^
%
..
==
>
<
!=
>=
<=
and
or
not
xor



Evaluator functions:

round VALUE
floor VALUE
ceiling VALUE
sqrt VALUE

min VALUE (table)
max VALUE (table)

random VALUE (number)
	returns a random number in the range [0, VALUE)
randomInt VALUE (number (int))
	returns a random integer in the range [0, VALUE]
chance VALUE
	returns true VALUE % of the time

typeOf VALUE
lengthOf VALUE (table)
endOf VALUE (table)
	returns lengthOf VALUE - 1
keysOf VALUE (table)
	returns a table containing all of the keys of VALUE
valuesOf VALUE (table)
	returns a table containing all of the values of VALUE
randomItem VALUE (table)

toNumber VALUE (string or bool)
toString VALUE
toChars VALUE (string)
toBool VALUE

timeSince VALUE (number)
	returns the number of seconds since VALUE










Default modules:



Console:

"println", VALUE (to print)
	Prints VALUE to the console



Interpreter:

"pause", VALUE (time)
	Pauses execution for VALUE seconds. Errors if VALUE is not a number.

"pause until", VALUE (end time)
	Pauses until timeSince 0 >= VALUE. Errors if VALUE is not a number.

"stop"
	Stops execution



Graphics:

"set data", VALUE (new data)
	Sets internal data about graphics to VALUE. Errors if VALUE is not a table.

"set frame", VALUE (new frame)
	Sets the current frame being displayed to VALUE. Errors if VALUE is not a table, if lengthOf Value is not data.Width * data.Height, or if VALUE contains non-int values.



Files:

"get file data", VALUE (file path)
	Pushes data relating to the file VALUE to the general stack. Errors if VALUE is not a string.
	Return data includes: Name, Path, IsFolder

"read file as strings", VALUE (file path)
	Pushes the contents of the file VALUE to the general stack as a table full of strings. Errors if VALUE is not a string, if the file VALUE cannot be found or if the VALUE is a folder.

"write to file", VALUE (file path), VALUE (contents)
	Writes the data of the second VALUE to the file of the first VALUE (which is created if necessary). Errors if the first VALUE is not a string.