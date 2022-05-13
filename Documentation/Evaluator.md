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

- **round VALUE**
- **floor VALUE**
- **ceiling VALUE**
- **sqrt VALUE**
- **sign VALUE**
  - returns 1 if VALUE is >= 0 or -1 if VALUE is < 0
- **not VALUE**
- **min VALUE (table)**
- **max VALUE (table)**

<br>

- **random VALUE (int or float)**
  - returns a random number in the range [0, VALUE)
- **randomInt VALUE (int)**
  - returns a random integer in the range [0, VALUE]
- **chance VALUE (int or float)**
  - returns true VALUE % of the time (chance 50 would return true half of the time)

<br>

- **typeOf VALUE**
  - returns a string representing the data type of VALUE
- **lengthOf VALUE (table, byteArray, or string)**
  - returns the number of items in the array part of VALUE (for tables), the number of bytes in VALUE (for byteArrays), or the number of characters in VALUE (for strings)
- **totalItemsIn VALUE (table)**
  - returns the number of items in the array part of VALUE plus the number of items in the hashmap part of VALUE
- **endOf VALUE (table)**
  - returns lengthOf VALUE - 1
- **keysOf VALUE (table)**
  - returns a table containing all of the keys of VALUE
- **valuesOf VALUE (table)**
  - returns a table containing all of the values of VALUE
- **randomItem VALUE (table)**
  - returns a random item from the array part of VALUE
- **randomValue VALUE (table)**
  - returns a random value from the hashmap part of VALUE

<br>

- **getChar VALUE (table {StringIn (string), Position (int)})**
  - returns the character at Position of StringIn. Position is modulo-ed by the length of StringIn (with -1 mapping correctly to lengthOf StringIn - 1)
- **getChars VALUE (string)**
  - returns an array of the characters in VALUE as ints
- **subString VALUE (table {StringIn (string), StartIndex (int), EndIndex (int)})**
  - returns a new string which is part of StringIn
  - both StartIndex and EndIndex are modulo-ed by the length of StringIn (with -1 mapping correctly to lengthOf StringIn - 1)

<br>

- **toInt VALUE**
- **toFloat VALUE**
- **toString VALUE**
- **toBool VALUE**
- **toChars VALUE**

<br>

- **newByteArray VALUE (int)**
  - returns a new byte array with length VALUE

<br>

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

### toChars VALUE:

- string: returns a new byteArray with the characters of VALUE
- else: throws error

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