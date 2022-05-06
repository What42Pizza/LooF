## Evaluator operators:

<br>

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

<br>

These use the value directly following the function. If the function takes in multiple arguments, they are all passed inside a table (example: x = max {1, 2}).

<br>

- **round VALUE**
- **floor VALUE**
- **ceiling VALUE**
- **sqrt VALUE**
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
- **lengthOf VALUE (string or table)**
  - returns the number of items in the array part of VALUE or the number of characters in VALUE
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
  - returns the character at Position of StringIn
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
- **7: ==, >, < !=, >=, and <=**
- **8: and, or, not, and xor**

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

<br>

### toFloat VALUE:

- null: throws error
- int: returns VALUE as a float
- float: returns VALUE
- string: returns the number in VALUE. Throws errors if VALUE cannot be cast
- bool: returns 1.0 for true and 0.0 for false
- table: throws error

<br>

### toString VALUE:

- null: returns "null"
- int: returns VALUE as a string
- float: returns VALUE as a string
- string: returns VALUE
- bool: returns "true" for true and "false" for false
- table: returns the contents of VALUE cast to strings (plus separators and brackets)

<br>

### toBool VALUE:

- null: returns false
- int: returns (VALUE > 0)
- float: returns (VALUE > 0)
- String: returns (lengthOf VALUE > 0)
- bool: returns VALUE
- table: returns (lengthOf VALUE > 0)

<br>
<br>
<br>

## Equality details:

<br>

- **null == null:** true
- **null == int:** false
- **null == float:** false
- **null == string:** false
- **null == bool:** false
- **null == table:** false

<br>

- **int == null:** false
- **int == int:** (Left == Right)
- **int == float:** (Left == Right)
- **int == string:** false
- **int == bool:** false
- **int == table:** false

<br>

- **float == null:** false
- **float == int:** (left == right)
- **float == float:** (left == right)
- **float == string:** false
- **float == bool:** false
- **float == table:** false

<br>

- **string == null:** false
- **string == int:** false
- **string == float:** false
- **string == string:** (left == right)
- **string == bool:** false
- **string == table:** false

<br>

- **bool == bull:** false
- **bool == int:** false
- **bool == float:** false
- **bool == string:** false
- **bool == bool:** (left == right)
- **bool == table:** false

<br>

- **table == null:** false
- **table == int:** false
- **table == float:** false
- **table == string:** false
- **table == bool:** false
- **table == table:** (left == right)