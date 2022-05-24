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

<br>
<br>
<br>

## Evaluator functions:

These use the value directly following the function. If the function takes in multiple arguments, they are all passed inside a table (examples: `x = max {1, 2}`, `y = sqrt 4` or `y = sqrt (4)`)

<br>

#### Math:

- **round Input (int or float)**
- **floor Input (int or float)**
- **ceiling Input (int or float)**
- **abs Input (int or float)**
- **sqrt Input (int or float)**
- **sign Input (int or float)**
  - returns 1 if VALUE is >= 0 or -1 if VALUE is < 0
- **not Input**
- **!! Input (int)**
  - returns bitwise not of Input
- **min InputArgs (table {int or float, ...})**
- **max InputArgs (table {int or float, ...})**
- **clamp InputArgs (table {Input (float or int), Min (float or int), Max (float or int)})**

<br>

#### Random:

- **random Input (int or float)**
  - returns a random number in the range [0, Input)
- **randomInt Input (int)**
  - returns a random integer in the range [0, Input]
- **randomInt InputArgs (table {min (int), max (int)})**
  - returns a random integer in the range [min, max]
- **chance Input (int or float)**
  - returns true Input % of the time (chance 50 would return true half of the time)

<br>

#### Tables:

- **lengthOf Table**
  - returns the number of items in the array part of Table 
- **lengthOf String**
  - returns the number of characters in String
- **lengthOf ByteArray**
  - returns the number of bytes in ByteArray
- **totalItemsIn Table**
  - returns the number of items in the array part of Table plus the number of items in the hashmap part of Table
- **endOf Table**
  - returns lengthOf Table - 1
- **endOf ByteArray**
  - returns lengthOf ByteArray - 1
- **lastItemOf Table**
  - returns the last item in the array part of Table
- **lastItemOf ByteArray**
  - returns the last item in the array part of ByteArray
- **keysOf Table**
  - returns a table containing all of the keys of the hashmap part of Table
- **valuesOf Table**
  - returns a table containing all of the values of the hashmap part of Table
- **randomItem Table**
  - returns a random item from the array part of Table
- **randomValue Table**
  - returns a random value from the hashmap part of Table
- **firstIndexOfItem InputArgs (table {TableIn, Item})**
  - returns the index of the first found occurrence of Item in TableIn
- **firstIndexOfItem InputArgs (table {TableIn, Item, StartIndex (int)})**
  - returns the index of the first found occurrence of Item in TableIn starting at StartIndex
- **lastIndexOfItem InputArgs (table {TableIn, Item})**
  - returns the index of the last found occurrence of Item in TableIn
- **lastIndexOfItem InputArgs (table {TableIn, Item, StartIndex (int)})**
  - returns the index of the last found occurrence of Item in TableIn starting at StartIndex
- **allIndexesOfItem InputArgs (table {TableIn, Item)}**
  - returns an array of all the indexes for the found occurrences of Item in TableIn
- **tableContainsItem InputArgs (table {TableIn, Item})**
  - returns true if the array part of TableIn contains Item or if the hashmap part of TableIn contains Item
- **arrayContainsItem InputArgs (table {TableIn, Item})**
  - returns true if the array part of TableIn contains Item
- **hashmapContainsItem InputArgs (table {TableIn, Item})**
  - returns true if the hashmap part of TableIn contains Item
- **splitTable InputArgs (table {TableIn, Position (int)})**
  - returns a table containing two more tables which are TableIn split at Position. (splitTable {{0, 1, 2}, 1} would evaluate to {{0}, {1, 2}})

<br>

#### Strings:

- **getChar InputArgs (table {StringIn, Position (int)})**
  - returns the character at Position of StringIn. Position is modulo-ed by the length of StringIn (with -1 mapping correctly to lengthOf StringIn - 1)
- **getCharInts String**
  - returns an array of the characters in String as ints
- **getCharBytes String**
  - returns a byteArray with the characters in String as bytes
- **getSubString InputArgs (table {StringIn, StartIndex (int), EndIndex (int)})**
  - returns a new string which is part of StringIn
  - both StartIndex and EndIndex are modulo-ed by the length of StringIn (with -1 mapping correctly to lengthOf StringIn - 1)
- **firstIndexOfString InputArgs (table {MainString, StringToFind})**
  - returns the index of the first found occurrence of StringToFind in MainString
- **firstIndexOfString InputArgs (table {MainString, StringToFind, StartIndex (int)})**
  - returns the index of the first found occurrence of StringToFind in MainString starting at StartIndex
- **lastIndexOfString InputArgs (table {MainString, StringToFind})**
  - returns the index of the last found occurrence of StringToFind in MainString
- **lastIndexOfString InputArgs (table {MainString, StringToFind, StartIndex (int)})**
  - returns the index of the last found occurrence of StringToFind in MainString starting at StartIndex
- **allIndexesOfString InputArgs (table {MainString, StringToFind)}**
  - returns an array of all the indexes for the found occurrences of StringToFind in MainString
- **splitString InputArgs (table {StringIn, Position (int)})**
  - returns a table containing two strings which are StringIn split at Position. (splitString {"abc", 1} would evaluate to {"a", "bc"})
- **splitString InputArgs (table {StringIn, StringToFind})**
  - returns a table containing all the sections in StringIn between the found occurrences of StringToFind. (splitString ("a b c", " ") would evaluate to {"a", "b", "c"})
- **stringStartsWith InputArgs (table {StringIn, StringToFind})**
  - returns true if StringIn starts with StringToFind
- **stringEndsWith InputArgs (table {StringIn, StringToFind})**
  - returns true if StringIn ends with StringToFind
- **replaceStrings InputArgs (table {StringIn, StringToFind, ReplacementString})**
  - returns a string which is StringIn but with all occurrences of StringToFind replaced with ReplacementString. (replaceStrings {"a b c", " ", ", "} would evaluate to "a, b, c")
- **toLowerCase String**
- **toUpperCase String**
- **trimString String**
  - returns String without any leading or trailing whitespace

<br>

#### Casting:

- **toInt Input**
- **toFloat Input**
- **toString Input**
- **toBool Input**

<br>

#### Misc:

- **typeOf Input**
  - returns a string representing the data type of Input
- **newByteArray Size (int)**
  - returns a new byte array with length of Size
- **timeSince StartTime (int or float)**
  - returns the number of seconds since StartTime

<br>
<br>
<br>

## Order of operations:

<br>

**(if not specified, right to left; evaluates parenthesis and tables as (and if) needed)**

- **1: Index queries**
- **2: Evaluator functions (left to right)**
- **3: ^**
- **4: bitwise operators**
- **5: %**
- **6: \* and /**
- **7: + and -**
- **8: ..**
- **9: ==, ===, >, < !=, !==, >=, and <=**
- **10: and, or, not, and xor**

<br>
<br>
<br>

## Conversion details:

<br>

### toInt Input:

- null: throws error
- int: returns VALUE
- float: returns floor (Input)
- string: returns the number in Input. Throws errors if Input cannot be cast
- bool: returns 1 for true and 0 for false
- table: throws error
- byteArray: throws error

<br>

### toFloat Input:

- null: throws error
- int: returns Input as a float
- float: returns Input
- string: returns the number in Input. Throws errors if Input cannot be cast
- bool: returns 1.0 for true and 0.0 for false
- table: throws error
- byteArray: throws error

<br>

### toString Input:

- null: returns "null"
- int: returns Input as a string
- float: returns Input as a string
- string: returns Input
- bool: returns "true" for true and "false" for false
- table: returns the contents of Input cast to strings (plus separators and brackets)
- byteArray: returns the contents of Input as ascii characters

<br>

### toBool Input:

- null: returns false
- int: returns (Input > 0)
- float: returns (Input > 0)
- String: returns (lengthOf Input > 0)
- bool: returns Input
- table: returns (lengthOf Input > 0)
- byteArray: returns (lengthOf Input > 0)

<br>
<br>
<br>

## Equality details:

<br>

- **null == null:** true
- **else:** false

<br>

- **int == int:** left number == right number ?
- **int == float:** left number == right number ?
- **else:** false

<br>

- **float == int:** left number == right number ?
- **float == float:** left number == right number ?
- **else:** false

<br>

- **string == string:** contents of left == contents of right ?
- **else:** false

<br>

- **bool == bool:** left == right ?
- **else:** false

<br>

- **table == table:** contents of left == contents of right ?
- **else:** false

<br>

- **byteArray == byteArray:** contents of left == contents of right ?
- **else:** false