## EVERYTHING HERE IS EXTREMELY LIKELY TO CHANGE

<br>
<br>
<br>

### Console:

- **"println", ToPrint1, ToPrint2, etc**
  - Prints all arguments to the console, separated with spaces.

<br>

### Interpreter:

- **"pause", Time (int or float)**
  - Pauses execution for Time seconds.
- **"pause until", EndTime (int or float)**
  - Pauses until timeSince 0 >= EndTime.
- **"stop"**
  - Stops execution.

<br>

### Files:

- **"get file properties", FilePath (string or table {string, ...})**
  - Pushes data relating to the file at FilePath to the general stack.
  - Return data: {Name (string), Path (table {string, ...}), IsFolder (bool), CanRead (bool), CanWrite (bool)}.
  - Errors if the file at FilePath does not exist.
- **"check file exists", FilePath (string or table {string, ...})**
  - Pushes an array containing a bool for whether the file at FilePath exists to the general stack.
- **"get folder contents", FolderPath (string or table {string, ...})**
  - Pushes a table containing the names (as arrays of strings) of the files and folders inside the folder at FolderPath to the general stack.
  - Errors if the file at FolderPath is not a folder.
- **"read file as strings", FilePath (string or table {string, ...})**
  - Pushes the contents of the file at FilePath to the general stack as an array of strings.
  - Errors if the file at FilePath does not exist or if the file at FilePath is a folder.
- **"read file as byteArray", FilePath (string or table {string, ...})**
  - Pushes the contents of the file at FilePath to the general stack as a byteArray.
  - Errors if the file at FilePath does not exist or if the file at FilePath is a folder.
- **"write to file", FilePath (string or table {string, ...}), Contents (table {string, ...} or byteArray)**
  - Writes the data of Contents to the file at FilePath (which is created if necessary).
- **"delete file", FilePath (string or table {string, ...})**
  - Deletes the file at FilePath.
  - Errors if the file at FilePath cannot be found.

<br>

### Graphics:

- **"set properties", NewProperties (table)**
  - Sets the internal data about the graphics to NewProperties.
- **"set frame", NewFrame (byteArray)**
  - Sets the current frame being displayed to NewFrame.
  - Errors if lengthOf NewFrame is not data.Width * data.Height * 3.