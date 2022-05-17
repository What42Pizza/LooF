## EVERYTHING HERE IS EXTREMELY LIKELY TO CHANGE

<br>
<br>
<br>

### Console:

- **"println", VALUE (to print)**
  - Prints VALUE to the console

<br>

### Interpreter:

- **"pause", VALUE (time)**
  - Pauses execution for VALUE seconds. Errors if VALUE is not a number.
- **"pause until", VALUE (end time)**
  - Pauses until timeSince 0 >= VALUE. Errors if VALUE is not a number.
- **"stop"**
  - Stops execution

<br>

### Files:

- **"get file properties", VALUE (file path)**
  - Pushes data relating to the file VALUE to the general stack.
  - Return data: {Name (string), Path table {string, ...}, IsFolder (bool), CanRead (bool), CanWrite (bool)}.
  - Errors if VALUE is not a string or an array of strings or if the file does not exist.
- **"check file exists", VALUE (file path)**
  - Pushes an array containing a bool for whether the file VALUE exists to the general stack.
  - Errors if VALUE is not a string or an array of strings.
- **"get folder contents", VALUE (folder path)**
  - Pushes a table containing the names of the files and folders inside the folder VALUE to the general stack.
  - Errors if VALUE is not a string or an array of strings.
- **"read file as strings", VALUE (file path)**
  - Pushes the contents of the file VALUE to the general stack as a table full of strings.
  - Errors if VALUE is not a string or an array of strings, if the file does not exist, or if the file is a folder.
- **"read file as byteArray", VALUE (file path)**
  - Pushes the contents of the file VALUE to the general stack as a byteArray.
  - Errors if VALUE is not a string or an array of strings, if the file VALUE cannot be found, or if the VALUE is a folder.
- **"write to file", VALUE (file path), VALUE (contents)**
  - Writes the data of the second VALUE to the file of the first VALUE (which is created if necessary).
  - Errors if the first VALUE is not a string or an array of strings or if the second VALUE is not an array of strings or a byteArray.
- **"delete file", VALUE (file path)**
  - Deletes the file VALUE.
  - Errors if VALUE is not a string or an array of strings or if the file VALUE cannot be found.

<br>

### Graphics:

- **"set properties", VALUE (new data)**
  - Sets the internal data about the graphics to VALUE. Errors if VALUE is not a table.
- **"set frame", VALUE (new frame)**
  - Sets the current frame being displayed to VALUE. Errors if VALUE is not a byteArray or if lengthOf Value is not data.Width * data.Height * 3.