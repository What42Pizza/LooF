## Evaluator operators:

These use values from both sides of the operator.

<br>

- **+**
- **-**
- **\***
- **/**
- **^**
- **%**
- **..**
- **==**
- **===**
- **>**
- **<**
- **!=**
- **!==**
- **>=**
- **<=**
- **and**
- **or**
- **orDefault**
  - if the left argument if it is not null, return the left argument, else return the right argument
- **xor**
- **&&**
  - bitwise and
- **||**
  - bitwise or
- **^^**
  - bitwise xor
- **<<**
  - bitwise shift right
- **>>**
  - bitwise shift left

**NOTE:** You can create a ternary operator (`A ? B : C`) by doing `A and B or C` (just like Lua)

<br>
<br>
<br>

## Evaluator functions:

These act like evaluator operaters, but they only take in the value to the right. If a function needs to take in multiple arguments, you pass the values inside a table. (examples: `x = max {1, 2}`, `y = sqrt 4` or `y = sqrt (4)`)

<br>

#### Basic Math:

- **round Input (int, float, or table {Input (int or float), RoundTo (int or float)})**
- **floor Input (int, float, or table {Input (int or float), RoundTo (int or float)})**
- **ceiling Input (int, float, or table {Input (int or float), RoundTo (int or float)})**
- **abs Input (int or float)**
- **sqrt Input (int or float)**
- **sign Input (int or float)**
  - returns 1 if VALUE is >= 0 or -1 if VALUE is < 0
- **min {int or float, ...}**
- **max {int or float, ...}**
- **clamp {Input (float or int), Min (float or int), Max (float or int)}**
- **log {Input (int or float), Base (int or float)}**
- **log10 Input (int or float)**
  - should be slightly faster than `log {Input, 10}`
- **ln Input (int or float)**
  - returns `log {Input, E}`, but probably slightly faster
- **toDegrees Input (int or float)**
- **toRadians Input (int or float)**

<br>

#### Advanced Math:

- **not Input**
- **!! Input (int)**
  - returns bitwise not of Input
- **isNaN Input (float)**
  - returns whether Input is in a NaN state
- **isInfinity Input (float)**
  - returns whether Input is infinity

<br>

#### Trig:

- **sin Input (int or float)**
- **cos Input (int or float)**
- **tan Input (int or float)**
- **asin Input (int or float)**
- **acos Input (int or float)**
- **atan Input (int or float)**
- **atan2 {y (int or float), x (int or float)}**
- **sinh Input (int or float)**
- **cosh Input (int or float)**
- **tanh Input (int or float)**

<br>

#### Random:

- **random Input (int or float)**
  - returns a random number in the range [0, Input)
- **randomInt Input (int)**
  - returns a random integer in the range [0, Input]
- **randomInt {min (int), max (int)}**
  - returns a random integer in the range [min, max]
- **chance Input (int or float)**
  - returns true Input % of the time (chance 50 would return true half of the time)

<br>

#### Tables:

- **lengthOf TableIn**
  - returns the number of items in the array part of TableIn
- **lengthOf ByteArrayIn**
  - returns the number of bytes in ByteArrayIn
- **isEmpty TableIn**
  - returns whether or not TableIn is empty
- **isEmpty ByteArrayIn**
  - returns whether or not ByteArrayIn is empty
- **totalLengthOf TableIn**
  - returns the number of items in the array part of TableIn plus the number of items in the hashmap part of TableIn
- **lengthOfHashMap TableIn**
  - returns the number of items in the hashmap part of TableIn
- **endOf TableIn**
  - returns lengthOf TableIn - 1
- **endOf ByteArrayIn**
  - returns lengthOf ByteArrayIn - 1
- **lastItemOf TableIn**
  - returns the last item in the array part of TableIn
- **lastItemOf ByteArrayIn**
  - returns the last item in the array part of ByteArrayIn
- **keysOf TableIn**
  - returns a table containing all of the keys of the hashmap part of TableIn
- **valuesOf TableIn**
  - returns a table containing all of the values of the hashmap part of TableIn
- **randomItem TableIn (table)**
  - returns a random value from either the array part of TableIn or the hashmap part of TableIn
- **randomArrayItem TableIn**
  - returns a random item from the array part of TableIn
- **randomHashmapItem TableIn**
  - returns a random item from the hashmap part of TableIn
- **randomByteArrayItem ByteArrayIn**
  - returns a random int in ByteArrayIn
- **firstIndexOf {TableIn (table or byteArray), Item (any)}**
  - returns the index of the first found occurrence of Item in TableIn
- **firstIndexOf {TableIn (table or byteArray), Item (any), StartIndex (int)}**
  - returns the index of the first found occurrence of Item in TableIn starting at StartIndex
- **lastIndexOf {TableIn (table or byteArray), Item (any)}**
  - returns the index of the last found occurrence of Item in TableIn
- **lastIndexOf  {TableIn (table or byteArray), Item (any), StartIndex (int)}**
  - returns the index of the last found occurrence of Item in TableIn starting at StartIndex
- **allIndexesOf {TableIn (table or byteArray), Item (any)}**
  - returns an array of all the indexes for the found occurrences of Item in TableIn
- **tableContains {TableIn, ItemToFind (any)}**
  - returns true if the array part of TableIn contains ItemToFind or if the hashmap part of TableIn contains ItemToFind
- **arrayContainsItem {TableIn, ItemToFind (any)}**
  - returns true if the array part of TableIn contains ItemToFind
- **hashmapContainsItem {TableIn, ItemToFind (any)}**
  - returns true if the hashmap part of TableIn contains ItemToFind
- **byteArrayContainsItems {ByteArrayIn, ByteToFind (int)}**
  - returns true if ByteArrayIn contains ByteToFind 
- **removeDuplicateItems TableIn (table or byteArray)**
  - returns a new table which contains a single instance of each item in TableIn
- **deepCloneTable TableIn**
  - returns a new table which contains deep cloned versions of all the items in TableIn
- **createFilledTable {FillItem (any), Size (int)}**
  - returns a new table with size Size and filled with FillItem
- **createFilledByteArray {FillByte (int), Size (int)}**
  - returns a new byteArray with size Size and filled with FillByte
- **getSubArray {TableIn (table or byteArray), StartIndex (int), EndIndex (int)}**
  - returns a new table or byteArray which is a sub-section of TableIn
  - both StartIndex and EndIndex are modulo-ed by the length of TableIn (with -1 mapping correctly to endOf TableIn)
- **replaceSubArray {TableIn (table or byteArray), StartIndex (int), EndIndex (int), NewItems (same type as TableIn)}**
  - returns a new table or byteArray where the sub-section of TableIn is replaced with NewItems
  - both StartIndex and EndIndex are modulo-ed by the length of TableIn (with -1 mapping correctly to endOf TableIn)
- **splitArray {TableIn (table or byteArray), Position (int)}**
  - returns a table containing two more tables which are TableIn split at Position. (`splitTable {{0, 1, 2}, 1}` would evaluate to {{0}, {1, 2}})
  - Position is modulo-ed by the length of TableIn (with -1 mapping correctly to endOf TableIn)

<br>

#### Strings:

- **lengthOf String**
  - returns the number of characters in String
- **isEmpty StringIn**
  - returns whether or not StringIn is empty
- **getChar {StringIn, Position (int)}**
  - returns the character at Position of StringIn. Position is modulo-ed by the length of StringIn (with -1 mapping correctly to lengthOf StringIn - 1)
- **getCharInts StringIn**
  - returns an array of the characters in StringIn as ints
- **getCharBytes StringIn**
  - returns a byteArray with the characters in StringIn as bytes
- **getSubString {StringIn, StartIndex (int), EndIndex (int)}**
  - returns a new string which is part of StringIn
  - both StartIndex and EndIndex are modulo-ed by the length of StringIn (with -1 mapping correctly to endOf StringIn)
- **replaceSubString {StringIn, StartIndex (int), EndIndex (int), NewString}**
  - returns a new string which is StringIn with the sub-string between StartIndex and EndIndex replaced with NewString
  - both StartIndex and EndIndex are modulo-ed by the length of StringIn (with -1 mapping correctly to endOf StringIn)
- **replaceStrings {StringIn, StringToFind, ReplacementString}**
  - returns a string which is StringIn but with all occurrences of StringToFind replaced with ReplacementString. (`replaceStrings {"a b c", " ", ", "}` would evaluate to "a, b, c")
- **firstIndexOf {StringIn, StringToFind}**
  - returns the index of the first found occurrence of StringToFind in StringIn
- **firstIndexOf {StringIn, StringToFind, StartIndex (int)}**
  - returns the index of the first found occurrence of StringToFind in StringIn starting at StartIndex
  - StartIndex is modulo-ed by the length of StringIn (with -1 mapping correctly to endOf StringIn)
- **lastIndexOf {StringIn, StringToFind})**
  - returns the index of the last found occurrence of StringToFind in StringIn
- **lastIndexOf {StringIn, StringToFind, StartIndex (int)}**
  - returns the index of the last found occurrence of StringToFind in StringIn starting at StartIndex
  - StartIndex is modulo-ed by the length of StringIn (with -1 mapping correctly to endOf StringIn)
- **allIndexesOf {StringIn, StringToFind)**
  - returns an array of all the indexes for the found occurrences of StringToFind in StringIn
- **splitString {StringIn, Position (int)}**
  - returns a table containing two strings which are StringIn split at Position. (`splitString {"abc", 1}` would evaluate to {"a", "bc"})
  - Position is modulo-ed by the length of StringIn (with -1 mapping correctly to endOf StringIn)
- **splitString {StringIn, StringToFind}**
  - returns a table containing all the sections in StringIn between the found occurrences of StringToFind. (`splitString ("a b c", " ")` would evaluate to {"a", "b", "c"})
- **stringStartsWith {StringIn, StringToFind}**
  - returns true if StringIn starts with StringToFind
- **stringEndsWith {StringIn, StringToFind}**
  - returns true if StringIn ends with StringToFind
- **toLowerCase StringIn**
- **toUpperCase StringIn**
- **trimString StringIn**
  - returns StringIn without any leading or trailing whitespace

<br>

#### Casting:

- **toInt Input (int, float, string, or bool)**
- **toFloat Input (int, float, string, or bool)**
- **toString Input (any)**
- **toBool Input (any)**

<br>

#### Functions:

- **newFunction {LineNumber (int)}**
  - returns a new value of type 'function' with LineNumber as the line to jump to and the current file as the page to jump to
- **newFunction {LineNumber (int), PageName (string)}**
  - returns a new value of type 'function' with LineNumber as the line to jump to and PageName as the page to jump to
- **getFunctionLine Function**
  - returns the line number of Function
- **getFunctionPage Function**
  - returns the page name of Function (returns null if the page name was not defined because it is assumed to jump to a function in the current file)

**NOTE:** Function values created with `newFunction InputArgs {LineNumber (int)}` (which includes `call FunctionName` / `call $FunctionName`) **should not be shared between files** since the file name will not be changed when calling functions created like that. Instead, you can do the following when you want to share a function value that points to a function in the current file:

```
$link TheCurrentFileName as this
FunctionValueToPass = $this.ExampleFunction
```

<br>

#### Misc:

- **typeOf Input (any)**
  - returns a string representing the data type of Input
- **isNumber Input (any)**
  - returns whether Input is of type int or float
- **isLocked Input (any)**
  - returns whether Input is locked
- **notNull Input (any)**
  - errors if Input is null, returns Input otherwise
- **cloneValue Input (any)**
  - returns a clone of Input
  - useful for having a local mutable copy of a locked value 
- **serialize Input (any)**
  - returns Input represented as a byteArray
- **deserialize Input (byteArray)**
  - returns the value represented by Input
- **timeSince StartTime (int or float)**
  - returns the number of seconds since StartTime
- **switch {SwitchValue (any), Cases (table), Default (any)}**

<br>

- **newByteArray Size (int)**
  - returns a new byte array with length of Size
- **newImage {Width (int), Height (int)}**
  - returns a new byte array that describes an image with the corresponding width and height
- **getImageWidth Image (byteArray)**
  - returns the width of Image
- **getImageHeight Image (byteArray)**
  - returns the height of Image
- **getImageIndex {XPos (int), YPos (int), Image (byteArray)}**
  - returns the index needed to access the pixel in Image at XPos, YPos