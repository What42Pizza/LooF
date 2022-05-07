## Console:

<br>

##### "println", VALUE (to print)

- Prints VALUE to the console

<br>
<br>
<br>

## Interpreter:

<br>

##### "pause", VALUE (time)

- Pauses execution for VALUE seconds. Errors if VALUE is not a number.

<br>

##### "pause until", VALUE (end time)

- Pauses until timeSince 0 >= VALUE. Errors if VALUE is not a number.

<br>

##### "stop"

- Stops execution

<br>
<br>
<br>

## Files:

<br>

##### "get file properties", VALUE (file path)

- Pushes data relating to the file VALUE to the general stack. Errors if VALUE is not a string.
- Return data includes: string Name, string Path, bool IsFolder

<br>

##### "read file as strings", VALUE (file path)

- Pushes the contents of the file VALUE to the general stack as a table full of strings. Errors if VALUE is not a string, if the file VALUE cannot be found, or if the VALUE is a folder.

<br>

##### "read file as byteArray", VALUE (file path)

- Pushes the contents of the file VALUE to the general stack as a byteArray. Errors if VALUE is not a string, if the file VALUE cannot be found, or if the VALUE is a folder.

<br>

##### "write to file", VALUE (file path), VALUE (contents)

- Writes the data of the second VALUE to the file of the first VALUE (which is created if necessary). Errors if the first VALUE is not a string or if the second VALUE is not an array of strings or a byteArray.

<br>
<br>
<br>

## Graphics:

<br>

##### "set properties", VALUE (new data)

- Sets the internal data about the graphics to VALUE. Errors if VALUE is not a table.

<br>

##### "set frame", VALUE (new frame)

- Sets the current frame being displayed to VALUE. Errors if VALUE is not a byteArray or if lengthOf Value is not data.Width * data.Height * 3.