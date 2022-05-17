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

<br>
<br>
<br>

## Evaluator functions:

These use the value directly following the function. If the function takes in multiple arguments, they are all passed inside a table (examples: `x = max {1, 2}`, `y = sqrt 4` or `y = sqrt (4)`)

<br>

#### Math:

- **round VALUE**
- **floor VALUE**
- **ceiling VALUE**
- **sqrt VALUE**
- **sign VALUE**
  - returns 1 if VALUE is >= 0 or -1 if VALUE is < 0
- **not VALUE**
- **min VALUE (table)**
- **max VALUE (table)**
- **clamp VALUE (table {Input (float or int), Min (float or int), Max (float or int)})**

<br>

#### Random:

- **random VALUE (int or float)**
  - returns a random number in the range [0, VALUE)
- **randomInt VALUE (int)**
  - returns a random integer in the range [0, VALUE]
- **randomInt VALUE (table {min (int), max (int)})**
  - returns a random integer in the range [min, max]
- **chance VALUE (int or float)**
  - returns true VALUE % of the time (chance 50 would return true half of the time)

<br>

#### Tables:

- **lengthOf VALUE (table)**
  - returns the number of items in the array part of VALUE 
- **lengthOf VALUE (string)**
  - returns the number of characters in VALUE
- **lengthOf VALUE (byteArray)**
  - returns the number of bytes in VALUE
- **totalItemsIn VALUE (table)**
  - returns the number of items in the array part of VALUE plus the number of items in the hashmap part of VALUE
- **endOf VALUE (table)**
  - returns lengthOf VALUE - 1
- **endOf VALUE (byteArray)**
  - returns lengthOf VALUE - 1
- **keysOf VALUE (table)**
  - returns a table containing all of the keys of VALUE
- **valuesOf VALUE (table)**
  - returns a table containing all of the values of VALUE
- **randomItem VALUE (table)**
  - returns a random item from the array part of VALUE
- **randomValue VALUE (table)**
  - returns a random value from the hashmap part of VALUE
- **firstIndexOfItem VALUE (table {TableIn, Item})**
  - returns the index of the first found occurrence of Item in TableIn
- **firstIndexOfItem VALUE (table {TableIn, Item, StartIndex (int)})**
  - returns the index of the first found occurrence of Item in TableIn starting at StartIndex
- **lastIndexOfItem VALUE (table {TableIn, Item})**
  - returns the index of the last found occurrence of Item in TableIn
- **lastIndexOfItem VALUE (table {TableIn, Item, StartIndex (int)})**
  - returns the index of the last found occurrence of Item in TableIn starting at StartIndex
- **allIndexesOfItem VALUE (table {TableIn, Item)}**
  - returns an array of all the indexes for the found occurrences of Item in TableIn
- **tableContainsItem VALUE (table {TableIn, Item})**
  - returns true if the array part of TableIn contains Item or if the hashmap part of TableIn contains Item
- **arrayContainsItem VALUE (table {TableIn, Item})**
  - returns true if the array part of TableIn contains Item
- **hashmapContainsItem VALUE (table {TableIn, Item})**
  - returns true if the hashmap part of TableIn contains Item
- **splitTable VALUE (table {TableIn, Position (int)})**
  - returns a table containing two more tables which are TableIn split at Position. (splitTable {{0, 1, 2}, 1} would evaluate to {{0}, {1, 2}})

<br>

#### Strings:

- **getChar VALUE (table {StringIn, Position (int)})**
  - returns the character at Position of StringIn. Position is modulo-ed by the length of StringIn (with -1 mapping correctly to lengthOf StringIn - 1)
- **getCharInts VALUE (string)**
  - returns an array of the characters in VALUE as ints
- **getCharBytes VALUE (string)**
  - returns a byteArray with the characters in VALUE as bytes
- **getSubString VALUE (table {StringIn, StartIndex (int), EndIndex (int)})**
  - returns a new string which is part of StringIn
  - both StartIndex and EndIndex are modulo-ed by the length of StringIn (with -1 mapping correctly to lengthOf StringIn - 1)
- **firstIndexOfString VAlUE (table {MainString, StringToFind})**
  - returns the index of the first found occurrence of StringToFind in MainString
- **firstIndexOfString VAlUE (table {MainString, StringToFind, StartIndex (int)})**
  - returns the index of the first found occurrence of StringToFind in MainString starting at StartIndex
- **lastIndexOfString VAlUE (table {MainString, StringToFind})**
  - returns the index of the last found occurrence of StringToFind in MainString
- **lastIndexOfString VAlUE (table {MainString, StringToFind, StartIndex (int)})**
  - returns the index of the last found occurrence of StringToFind in MainString starting at StartIndex
- **allIndexesOfString VALUE (table {MainString, StringToFind)}**
  - returns an array of all the indexes for the found occurrences of StringToFind in MainString
- **splitString VALUE (table {StringIn, Position (int)})**
  - returns a table containing two strings which are StringIn split at Position. (splitString {"abc", 1} would evaluate to {"a", "bc"})
- **splitString VALUE (table {StringIn, StringToFind})**
  - returns a table containing all the sections in StringIn between the found occurrences of StringToFind. (splitString ("a b c", " ") would evaluate to {"a", "b", "c"})
- **stringStartsWith VALUE (table {StringIn, StringToFind})**
  - returns true if StringIn starts with StringToFind
- **stringEndsWith VALUE (table {StringIn, StringToFind})**
  - returns true if StringIn ends with StringToFind
- **replaceStrings VALUE (table {StringIn, StringToFind, ReplacementString})**
  - returns a string which is StringIn but with all occurrences of StringToFind replaced with ReplacementString. (replaceStrings {"a b c", " ", ", "} would evaluate to "a, b, c")
- **toLowerCase VALUE (string)**
- **toUpperCase VALUE (string)**
- **trimString VALUE (string)**
  - returns VALUE without any leading or trailing whitespace

<br>

#### Casting:

- **toInt VALUE**
- **toFloat VALUE**
- **toString VALUE**
- **toBool VALUE**
- **toChars VALUE**

<br>

#### Misc:

- **typeOf VALUE**
  - returns a string representing the data type of VALUE
- **newByteArray VALUE (int)**
  - returns a new byte array with length VALUE
- **timeSince VALUE (number)**
  - returns the number of seconds since VALUE

<br>
<br>
<br>

## Order of operations:

<br>

**(if not specified, right to left; evaluates parenthesis and tables as (and if) needed)**

- **1: Index queries**
- **2: Evaluator functions (left to right)**
- **3: ^**
- **4: %**
- **5: \* and /**
- **6: + and -**
- **7: ..**
- **8: ==, ===, >, < !=, !==, >=, and <=**
- **9: and, or, not, and xor**

<br>
<br>
<br>

## Conversion details:

<br>

### toInt VALUE:

- null: throws error
- int: returns VALUE
- float: returns floor (VALUE)
- string: returns the number in VALUE. Throws errors if VALUE cannot be cast
- bool: returns 1 for true and 0 for false
- table: throws error
- byteArray: throws error

<br>

### toFloat VALUE:

- null: throws error
- int: returns VALUE as a float
- float: returns VALUE
- string: returns the number in VALUE. Throws errors if VALUE cannot be cast
- bool: returns 1.0 for true and 0.0 for false
- table: throws error
- byteArray: throws error

<br>

### toString VALUE:

- null: returns "null"
- int: returns VALUE as a string
- float: returns VALUE as a string
- string: returns VALUE
- bool: returns "true" for true and "false" for false
- table: returns the contents of VALUE cast to strings (plus separators and brackets)
- byteArray: returns the contents of VALUE as ascii characters

<br>

### toBool VALUE:

- null: returns false
- int: returns (VALUE > 0)
- float: returns (VALUE > 0)
- String: returns (lengthOf VALUE > 0)
- bool: returns VALUE
- table: returns (lengthOf VALUE > 0)
- byteArray: returns (lengthOf VALUE > 0)

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