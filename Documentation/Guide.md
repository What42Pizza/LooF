# LooF Guide

#### This is a collection of information and challenges that can help you learn LooF.

<br>
<br>
<br>

## Value Types

<br>

**In LooF, there are 8 types of values:**

- **null**
- **int**
- **float**
- **string**
- **bool**
- **table**
- **byteArray**
- **function**

<br>

**Examples:**

```
ExampleNull = null
ExampleInt = 10
ExampleFloat = 3.14
ExampleString = "Hello, World!"
ExampleBool = true
ExampleTable = {1, 2, 3}
ExampleByteArray = newByteArray 10
ExampleFunction = $ExampleFunctionName
```

<br>

**Extra information about value types:**

- **null: Nothing special, it's just null**
- **int: Just a 64-bit integer (long in Java)**
- **float: Just a 64-bit float (double in Java)**
- **string: Just a string (acts the same as in java)**
- **bool: Just a bool**
- **table: Tables have both an array part and a hashmap part. The array part is indexed with ints, and the hashmap part is indexed with strings.**
- **byteArray: Useful when you want to store a lot of data in an efficient manner.**
- **function: A struct for defining where a function is.**

<br>
<br>
<br>

## Basic Syntax

<br>

**Statements in LooF generally all follow the same patterns. Exceptions to these rules can only exist because of the pre-processor, which is used heavily to improve LooF's syntax.**

<br>

**For variable declaration / assignment, you write the variable name, the assignment operation, and (optionally) the value to assign to / modify with. Examples:**

```
i = 0
i ++
i += 10
```

<br>

**For other statements, you write the statement name and (optionally) its arguments (with commas in-between each arg). Examples:**

```
loop i, 1, 10
	breakIf i == 3
repeat
```

<br>

**For a full list of statements (including variable definitions and assignments) and information about arguments and general statement details, you can go to LooF/Documentation/Statements.md**

**For a guide on more complicated syntax, you can go to LooF/Documentation/Basics.LOOF.md**

<br>

**Formulas are an important part of LooF (or any language for that matter), so I made sure to do them well. You can write things out pretty much like you'd expect, though there are some oddities you need to know about.**

**There are two types of 'operations' that you can use in LooF. The first type, known as EvaluatorOperation, works exactly as expected. They take two inputs, one on each side, and evaluate for a single value. Examples:**

```
_ = 1 + 2  // 3
_ = "Hello, " .. "World!"  // "Hello, World!"
_ = "10" == 10  // throws error
```

<br>

**The other type of 'operation' is called EvaluatorFunction. It takes a single input (on the right) and evaluates to a single value. EvaluatorFunctions include round, min, max, random, and MANY more. You might have noticed something wrong, though, which is that these functions (including min and max) can only take a single value. The way LooF gets around this is by passing multiple values using a table. Examples:**

```
_ = round 1.5  // 2
_ = min {3, 4} // 3
_ = sqrt 4  // 2
_ = sqrt (4)  // 2
_ = sqrt(4)  // 2
_ = atan2 {y, x}
_ = lengthOf "Hello, World!"  // 13
_ = lengthOf {1, 2, 3, 4, 5}  // 5
```

**For a list of all EvaluatorOperations, EvaluatorFunctions, order of operations, constants, convertion details, and equality details, you can go to LooF/Documentation/Evaluator.md**

<br>

**As you'd expect, tables start and end with curly braces, they're indexed with brackets, and formulas can be created with parentheses (statements and tables don't need their arguments (which are formulas) to be enclosed in parentheses, which means you don't have to write `a = (3)` or `return (false)`). Also, you can initialize a table with hashmap values by writing the string key followed by a colon and the value to set it to. Examples:**

```
ExampleTable[3] = {lengthOf A, B * (C + D), E[F + G]}
ExampleTable = {1, 2, 3, a: 4, b: 5, c: 6, 7, 8, 9}
```

<br>
<br>
<br>
<br>
<br>

# Challenge 1:

#### Write a Hello World program.

**(You'll probably have to look further than Statements.md)**