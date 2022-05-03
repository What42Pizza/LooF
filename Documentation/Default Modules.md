## Console:

"println", VALUE (to print)
	Prints VALUE to the console

## Interpreter:

"pause", VALUE (time)
	Pauses execution for VALUE seconds. Errors if VALUE is not a number.

"pause until", VALUE (end time)
	Pauses until timeSince 0 >= VALUE. Errors if VALUE is not a number.

"stop"
	Stops execution

## Files:

"get file data", VALUE (file path)
	Pushes data relating to the file VALUE to the general stack. Errors if VALUE is not a string.
	Return data includes: Name, Path, IsFolder

"read file as strings", VALUE (file path)
	Pushes the contents of the file VALUE to the general stack as a table full of strings. Errors if VALUE is not a string, if the file VALUE cannot be found or if the VALUE is a folder.

"write to file", VALUE (file path), VALUE (contents)
	Writes the data of the second VALUE to the file of the first VALUE (which is created if necessary). Errors if the first VALUE is not a string.

## Graphics:

"set data", VALUE (new data)
	Sets internal data about graphics to VALUE. Errors if VALUE is not a table.

"set frame", VALUE (new frame)
	Sets the current frame being displayed to VALUE. Errors if VALUE is not a table, if lengthOf Value is not data.Width * data.Height, or if VALUE contains non-int values.