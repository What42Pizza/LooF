## Variables

- **VAR\_NAME = VALUE**
  - Sets VAR\_NAME to VAlUE
- **VAR\_NAME [VALUE (int)] ... = VALUE**
  -Sets the given index of VAR\_NAME to the last VALUE
- **default VAR\_NAME = VALUE**
  - Sets VAR\_NAME to VALUE only if VAR\_NAME is null
- **unlock VAR\_NAME**
  - Unlocks VAR\_NAME so that it and its indexes can be re-assigned

<br>

## General Stack

- **push VALUE**
  - Pushes VALUE to the general stack
- **pop VAR\_NAME**
  - Pops the first value of the general stack into VAR\_NAME. Errors if the general stack is empty
- **pop VAR\_NAME (table), VAR\_NAME (item 0 of table), ...**
  - Pops the first value of the general stack into the first VAR\_NAME, then sets the second VAR\_NAME to index 0 of the first VAR\_NAME, sets the third VAR\_NAME to index 1 of the first VAR\_NAME, etc. If the number of items in the first VAR_NAME runs out, all remaining VAR_NAME-s will be set to null. Errors if the first VAR\_NAME is not a table or if the general stack is empty

<br>

## Functions

- **call VALUE (int: function line number)**
  - Pushes the instruction pointer to the IP stack and jumps execution to the line described by VALUE
- **call VALUE (string: function file name), VALUE (int: function line number)**
  - Pushes the instruction pointer to the IP stack and jumps execution to the line described by the first VALUE in the file described by the second VALUE
- **call VALUE (int: function line number), VALUE (arg 1), ...**
  - Pushes the instruction pointer to the IP stack, jumps execution to line described by VALUE, and pushes all remaining VALUE-s to the general stack in a single table
- **call VALUE (string: function file name), VALUE (int: function line number), VALUE (arg 1), ...**
  - Pushes the instruction pointer to the IP stack, jumps execution to the line described by the first VALUE in file described by the second VALUE, and pushes all remaining VALUE-s to the general stack in a single table
- **return**
  - Jumps execution to the value popped off of the IP stack. Errors if the IP stack is empty
- **return VALUE (return value 1), ...**
  - Pushes all remaining VALUE-s to the general stack in a single table and jumps execution to the value popped off of the IP stack. Errors if the IP stack is empty
- **returnIf VALUE (condition)**
  - Only if VALUE is truthy, jumps execution to the value popped off of the IP stack. Errors if the IP stack is empty
- **returnIf VALUE (condition), VALUE (return value)**
  - Only if the first VALUE is truthy, pushes all remaining VALUE-s to the general stack in a single table and jumps execution to the value popped off of the IP stack. Errors if the IP stack is empty

<br>

## If Statements

- **if VALUE (condition)**
  - Only if VALUE is truthy, executes the next line of code (otherwise skips it)
- **skip**
  - Jumps execution to after the first 'end' statement it can find that is on the same code block level. Errors if no suitable 'end' statement is found
- **end**
  - Effectively nop; only useful because of 'skip' statements

<br>

## Loops

- **loop**
  - Effectively nop; only useful because of repeat
- **loop VAR\_NAME, VALUE (start), VALUE (end)**
  - Same as statement 'loop VAR\_NAME, VALUE, VALUE, VALUE' but the third VALUE is assumed to be 1
- **loop VAR\_NAME, VALUE (start), VALUE (end), VALUE (increment)**
  - If VAR\_NAME is null:  Sets VAR\_NAME to the first VALUE
  - If VAR\_NAME plus the second VALUE is less than the second VALUE:  Increments VAR\_NAME by the third VALUE
  - If VAR\_NAME plus the second VALUE is greater than or equal to the second VALUE:  Jumps execution to after the first 'repeat' statement it can find that is on the same code block level. Errors if no suitable 'repeat' statement is found
- **forEach VAR\_NAME, VALUE (table)**
  - Same as statement 'forEach VAR\_NAME, VALUE, VAR\_NAME' but with the second VAR\_NAME being is assumed to be "\_" .. the first VAR\_NAME. Errors if VALUE is not a table
- **forEach VAR\_NAME, VALUE (table), VAR\_NAME**
  - If the second VAR\_NAME is null:  Sets the second VAR\_NAME to 0 and the first VAR\_NAME to VALUE indexed with the second VAR\_NAME. Errors if VALUE is not a table
  - If the second VAR\_NAME plus 2 is less than the length of VALUE:  Increments the second VAR\_NAME and sets the first VAR\_NAME to VALUE indexed with the second VAR\_NAME. Errors if VALUE is not a table
  - If the second VAR\_NAME plus 2 is not less than the length of VALUE:  Jumps execution to after the first 'repeat' statement it can find that is on the same code block level. Errors if VALUE is not a table or if no suitable 'repeat' statement is found
- **while VALUE**
  - If VALUE is truthy:  Effectively nop; only useful because of the other while conditions
  - If VALUE is falsey:  Jumps execution to after the first 'repeat' statement it can find that is on the same code block level. Errors if no suitable 'repeat' statement is found
- **repeat**
  - Jumps execution to the first 'loop', 'while', or 'forEach' statement it can find proceeding this repeat statement that is on the same code block level. Errors if no suitable 'loop' or 'while' statement is found
- **repeatIf VALUE (condition)**
  - Only is VALUE is truthy, jumps execution to the first 'loop' or 'while' statement it can find proceeding this repeat statement that is on the same code block level. Errors if no suitable 'loop' or 'while' statement is found
- **continue**
  - Jumps execution to the next 'repeat' statement
- **continueIf VALUE (condition)**
  - Only if VALUE is truthy, jumps execution to the next 'repeat' statement'
- **break**
  - Jumps execution to after the first 'repeat' statement it can find that is on the same code block level. Errors if no suitable 'repeat' statement is found
- **breakIf VALUE**
  - Only if VALUE is truthy, jumps execution to after the first 'repeat' statement it can find that is on the same code block level. Errors if no suitable 'repeat' statement is found

<br>

## Errors

- **error VALUE (error message)**
  - Stops execution with the interpreter in an error state and with VALUE as the error message. Overrides this error with a new error if VALUE is not a string
- **error VALUE (error message), VALUE (table: tags)**
  - Stops execution with the interpreter in an error state, with the first VALUE as the error message, and with the second VALUE as the tags for the error. Overrides this error with a new error if the first VALUE is not a string or if the second VALUE is not a table
- **errorIf VALUE (condition), VALUE (error message)**
  - Only if the first VALUE is truthy, stops execution with the interpreter in an error state and with the second VALUE as the error message. Overrides this error with a new error if the second VALUE is not a string
- **errorIf VALUE (condition), VALUE (error message), VALUE (table: tags)**
  - Only if the first VALUE is truthy, stops execution with the interpreter in an error state, with the second VALUE as the error message, and with the third VALUE as the tags for the error. Overrides this error with a new error if the second VALUE is not a string or if the third VALUE is not a table

<br>

## Interacting with external code

- **callOutside VALUE (string: module), VALUE (arg 1), ...**
  - Sends the the remaining VALUEs to the external module VALUE. Errors if the first VALUE is not a string.