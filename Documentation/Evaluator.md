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

## Constants:

<br>

- **null**
- **true**
- **false**
- **MATH_PI**
- **MATH_E**
- **MATH_MAX_INT**
- **MATH_MIN_INT**
- **MATH_MAX_FLOAT**
- **MATH_MIN_FLOAT**
- **MATH_POSITIVE_INFINITY**
- **MATH_NEGATIVE_INFINITY**
- **MATH_NAN_FLOAT**

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
- function: throws error

<br>

### toFloat Input:

- null: throws error
- int: returns Input as a float
- float: returns Input
- string: returns the number in Input. Throws errors if Input cannot be cast
- bool: returns 1.0 for true and 0.0 for false
- table: throws error
- byteArray: throws error
- function: throws error

<br>

### toString Input:

- null: returns "null"
- int: returns Input as a string
- float: returns Input as a string
- string: returns Input
- bool: returns "true" for true and "false" for false
- table: returns the contents of Input cast to strings (plus separators and brackets)
- byteArray: returns the contents of Input as ascii characters
- function: return data about Input as a string

<br>

### toBool Input:

- null: returns false
- int: returns (Input > 0)
- float: returns (Input > 0)
- String: returns (lengthOf Input > 0)
- bool: returns Input
- table: returns (lengthOf Input > 0)
- byteArray: returns (lengthOf Input > 0)
- function: return true

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

<br>

- **function == function:** contents of left == contents of right ?
- **else:** false