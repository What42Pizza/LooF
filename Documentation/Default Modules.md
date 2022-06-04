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
- **"add page from file", FilePath (string or table {string, ...}), CompileSettings (table)**
  - Compiles and adds a new page from the file at FilePath.
  - Errors if the file at FilePath does not exist.
- **"add pages from folder", FolderPath (string or table {string, ...}), CompileSettings (table)**
  - Compiles and adds all the files in the folder at FolderPath.
  - Errors if the folder at FolderPath does not exist.
- **"add page from strings", PageName (string), PageCode (table {string, ...}), CompileSettings (table)**
  - Compiles and adds a new page from the given code.
  - Errors if there is already a page names PageName.
- **"get page function locations", PageName (string)**
  - Pushes a table containing a table containing all the function locations in the page PageName.
  - Function locations are stored as ints in the hashmap part of the inner returned table with the function names as the keys.
  - Errors if no page named PageName exists
- **"get all pages"**
  - Pushes a table containing a table containing all the names of the currently loaded pages.
- **"remove page", PageName (string)**
  - Removed the page PageName from the environment.
  - Errors if no page named PageName exists or if the page being removed is in the call stack.

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
- **"restrict access to folder", FolderPath (string or table {string, ...})**
  - Makes this module only able to work with files inside FolderPath.
  - Errors if the folder at FolderPath cannot be found.

<br>

### Graphics:

- **"set properties", NewProperties (table)**
  - Sets the internal data about the graphics to NewProperties.
- **"set frame", NewFrame (byteArray)**
  - Sets the current frame being displayed to NewFrame.
  - Errors if lengthOf NewFrame is not data.Width * data.Height * 3.