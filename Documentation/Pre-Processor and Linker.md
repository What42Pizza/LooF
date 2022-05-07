## Preprocessor statements:

- **\#include FILE\_NAME**
  - copies and pastes the contents from FILE\_NAME
- **\#replace "STRING1" "STRING2"**
  - replaces all occurances of STRING1 with STRING2
- **\#if\_equal "STRING1" "STRING2"**
  - deletes all following code up to and including the next #end\_if (on same level) if STRING1 does not equal STRING2
- **\#if\_not\_equal "STRING1" "STRING2"**
  - deletes all following code up to and including the next #end\_if (on same level) if STRING1 equals STRING2
- **\#end\_if**
  - effectively nop and is always removed; only useful because of 'if' statements
- **\#ignore\_header**
  - skips adding the header file if this is the first line in the file (#include-s are processed after this check, so if file A includes a file B that starts with #ignore\_header, file A will still include the header)

<br>

## Linker statements:

- **$function FUNCTION\_NAME**
  - defines the starting location of a function
- **$link FILE\_NAME**
  - gives the current file access to all the functions in FILE\_NAME. Calls to functions in FILE\_NAME have to be proceeded by the name of the linked file, with only a period instead of ".LOOF" (example: `call ExampleFileName.ExampleFunctionName`)
- **$link FILE\_NAME as SHORTENED\_FILE\_NAME**
  - gives the current file access to all the functions in FILE\_NAME. Calls to functions in FILE\_NAME have to be proceeded by SHORTENED\_FILE\_NAME and a period (example: `call ExampleShortendName.ExampleFunctionName`)