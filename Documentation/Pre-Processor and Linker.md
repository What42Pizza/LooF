## Preprocessor statements:

- **\#include FileName**
  - copies and pastes the contents from FileName (this copies the original contents of FileName (without the header added))
- **\#replace "String1" "String2"**
  - replaces all non-quote occurrences of String1 with String2
- **\#replaceIgnoreQuotes "String1" "String2"**
  - replaces all occurrences of String1 with String2
- **\#replaceMultiLine "String1" "String2"**
  - replaces all occurrences of String1 with String2
  - can (and has to) detect strings across multiple lines
- **\#if\_equal "String1" "String2"**
  - deletes all following code up to and including the next #end\_if (on same level) if String1 does not equal String2
- **\#if\_not\_equal "String1" "String2"**
  - deletes all following code up to and including the next #end\_if (on same level) if String1 equals String2
- **\#end\_if**
  - effectively nop and is always removed; only useful because of 'if' statements
- **\#ignore\_header**
  - skips adding the header file if this is the first line in the file (#include-s are processed after this check, so if file A includes a file B that starts with #ignore\_header, file A will still include the header)

**Note:** you can replace strings that are only at the start of a line like this: `#replace "\nStringToFind" "\nStringToReplaceWith"` (you can do the same thing for detecting strings at the end of a line. Also, doing this will still work for the first line of a file since the pre-processor adds an extra blank line of code to the front and back of each file. And if you're wondering why there's no `#replaceMultiLineIgnoreQuotes`, it's because there should be no reason it's needed)

<br>

## Linker statements:

- **$function FunctionName**
  - defines the starting location of a function
- **$link FileName**
  - gives the current file access to all the functions in FileName. Calls to functions in FileName have to be proceeded by the name of the linked file, with only a period instead of ".LOOF" (example: `call ExampleFileName.ExampleFunctionName`)
- **$link FileName as ShortenedFileName**
  - gives the current file access to all the functions in FileName. Calls to functions in FileName have to be proceeded by ShortenedFileName and a period (example: `call ExampleShortendName.ExampleFunctionName`)
- **(anywhere in line) $FunctionName**
  - replaces $FunctionName with the values required to call FunctionName