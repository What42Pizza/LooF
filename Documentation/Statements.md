# Assignments

<br>

- **VarName = Value**
  - Sets VarName to Value
- **VarName defaultsTo Value**
  - If VarName is null, sets VarName to Value
- **VarName += Value (int or string)**
  - Adds Value to VarName
- **VarName -= Value (int or string)**
  - Subtracts Value from VarName
- **VarName \*= Value (int or string)**
  - Multiplies VarName by Value
- **VarName /= Value (int or string)**
  - Divides VarName by Value
- **VarName ^= Value (int or string)**
  - Takes VarName to the power of Value
- **VarName %= Value (int or string)**
  - Modulo-s VarName by Value
- **VarName ..= Value (VarName is string: string; VarName is table: any)**
  - Concatenates Value to VarName
  - `VarName (table) ..= Value (table)` adds all the items in the array part of Value to VarName. If you want it Value to be added as a single item, you can do `VarName (table) ..= {Value (table)}`.

<br>

- **VarName ++**
  - Increments VarName
- **VarName --**
  - Decrements VarName
- **VarName !!**
  - Toggles VarName

<br>
<br>
<br>
<br>
<br>

# Interpreter Functions

<br>

## General Stack

- **push Value**
  - Pushes Value to the general stack
- **pop VarName**
  - Pops the first value of the general stack into VarName. Errors if the general stack is empty
- **pop TableVarName (table), Item0, Item1, ...**
  - Pops the first value of the general stack into TableVarName, then sets the var Item0 to index 0 of TableVarName, sets the var Item0 to index 1 of TableVarName, etc. If the number of items in TableVarName runs out, all remaining arguments will be set to null. Errors if the general stack is empty

<br>

## Functions

- **call FunctionLineNumber (int)**
  - Pushes the instruction pointer to the IP stack and jumps execution to FunctionLineNumber
- **call FileName (string), FunctionLineNumber (int)**
  - Pushes the instruction pointer to the IP stack and jumps execution to FunctionLineNumber in the file FileName
- **call FunctionLineNumber (int), Arg1, Arg2, ...**
  - Pushes the instruction pointer to the IP stack, jumps execution to FunctionLineNumber, and pushes all remaining arguments to the general stack in a single table
- **call FileName (string), FunctionLineNumber (int), Arg1, Arg2, ...**
  - Pushes the instruction pointer to the IP stack, jumps execution to FunctionLineNumber in file FileName, and pushes all remaining arguments to the general stack in a single table
- **return**
  - Jumps execution to the value popped off of the IP stack. Errors if the IP stack is empty
- **return ReturnValue0, ReturnValue1, ...**
  - Pushes all arguments to the general stack in a single table and jumps execution to the value popped off of the IP stack. Errors if the IP stack is empty
- **returnIf Condition**
  - If Condition is truthy, jumps execution to the value popped off of the IP stack. Errors if the IP stack is empty
- **returnIf Condition, ReturnValue0, ReturnValue1, ...**
  - If Condition is truthy, pushes all remaining arguments to the general stack in a single table and jumps execution to the value popped off of the IP stack. Errors if the IP stack is empty

<br>

## If Statements

- **if Condition**
  - If Condition is truthy, executes the next statement (otherwise skips it)
- **if Condition, Invert**
  - If Condition is truthy xor Invert is truthy, executes the next statement (otherwise skips it)
- **skip**
  - Jumps execution to after the first 'end' statement it can find that is on the same code block level. Errors if no suitable 'end' statement is found
- **end**
  - Effectively nop; only useful because of 'skip' statements

<br>

## Loops

- **loop**
  - Effectively nop; only useful because of repeat
- **loop VarName, End (int or float)**
  - Same as statement `loop VarName, 0, End, 1`
- **loop VarName, Start (int or float), End (int or float)**
  - Same as statement `loop VarName, Start, End, 1`
- **loop VarName, Start (int or float), End (int or float), Increment (int or float)**
  - If VarName is null:   Sets VarName to Start
  - If VarName plus Increment is less than or equal to End:   Increments VarName by Increment
  - If VarName plus Increment is greater than End:   Jumps execution to after the first 'repeat' statement it can find that is on the same code block level. Errors if no suitable 'repeat' statement is found
- **forEach ValueVarName, TableToLoop (table)**
  - Same as statement `forEach ValueVarName, TableToLoop, IncrementVarName` but with IncrementVarName being ValueVarName Proceeded by an underscore
- **forEach ValueVarName, TableToLoop (table), IndexVarName**
  - If IndexVarName is null:  Sets IndexVarName to 0 and ValueVarName to TableToLoop indexed with IndexVarName. Errors if TableToLoop is not a table
  - If IncrementVarName plus 2 is less than the length of TableToLoop:  Increments IndexVarName and sets ValueVarName to TableToLoop indexed with IndexVarName
  - If IndexVarName plus 2 is not less than the length of TableToLoop:  Jumps execution to after the first 'repeat' statement it can find that is on the same code block level. Errors if no suitable 'repeat' statement is found
- **while Condition**
  - If Condition is truthy:  Effectively nop; only useful because of the other while conditions
  - If Condition is falsey:  Jumps execution to after the first 'repeat' statement it can find that is on the same code block level. Errors if no suitable 'repeat' statement is found
- **repeat**
  - Jumps execution to the first 'loop', 'while', or 'forEach' statement it can find proceeding this repeat statement that is on the same code block level. Errors if no suitable 'loop' or 'while' statement is found
- **repeatIf Condition**
  - If Condition is truthy, jumps execution to the first 'loop' or 'while' statement it can find proceeding this repeat statement that is on the same code block level. Errors if no suitable 'loop' or 'while' statement is found
- **continue**
  - Jumps execution to the next 'repeat' statement
- **continueIf Condition**
  - If Condition is truthy, jumps execution to the next 'repeat' statement'
- **break**
  - Jumps execution to after the first 'repeat' statement it can find that is on the same code block level. Errors if no suitable 'repeat' statement is found
- **breakIf Condition**
  - If Condition is truthy, jumps execution to after the first 'repeat' statement it can find that is on the same code block level. Errors if no suitable 'repeat' statement is found

<br>

## Error Throwing

- **error ErrorMessage (string)**
  - Stops execution with the interpreter in an error state and with ErrorMessage as the error message. Overrides this error with a new error if ErrorMessage is not a string
- **error ErrorMessage (string), ErrorTypeTags (table {string, ...})**
  - Stops execution with the interpreter in an error state, with ErrorMessage as the error message, and with ErrorTypeTags as the tags for the error. Overrides this error with a new error if ErrorMessage is not a string or if ErrorTypeTags is not a table
- **errorIf Condition, ErrorMessage (string)**
  - If Condition is truthy, stops execution with the interpreter in an error state and with ErrorMessage as the error message. Overrides this error with a new error if ErrorMessage is not a string
- **errorIf Condition, ErrorMessage (string), ErrorTypeTags (table {string, ...})**
  - If Condition is truthy, stops execution with the interpreter in an error state, with ErrorMessage as the error message, and with ErrorTypeTags as the tags for the error. Overrides this error with a new error if ErrorMessage is not a string or if ErrorTypeTags is not a table
- **setPassedErrors ErrorTypesToPass (table {string, ...})**
  - When any error occurs with at least one tag that is in ErrorTypesToPass, the error's call stack will be cut off so that it does not include the function that this statement is in (or any following functions)

<br>

## Error Handling

- **try FunctionLineNumber (int), ErrorTypesToCatch (table {string, ...})**
  - Pushes the instruction pointer to the IP stack and jumps execution to FunctionLineNumber. When any error occurs with at least one tag that is in ErrorTypesToCatch, execution is taken back to the statement after this
- **try FileName (string), FunctionLineNumber (int), ErrorTypesToCatch (table {string, ...})**
  - Pushes the instruction pointer to the IP stack and jumps execution to FunctionLineNumber in the file FileName. When any error occurs with at least one tag that is in ErrorTypesToCatch, execution is taken back to the statement after this
- **try FunctionLineNumber (int), ErrorTypesToCatch (table {string, ...}), Arg1, Arg2, ...**
  - Pushes the instruction pointer to the IP stack, jumps execution to FunctionLineNumber, and pushes all remaining arguments (except ErrorTypesToCatch) to the general stack in a single table. When any error occurs with at least one tag that is in ErrorTypesToCatch, execution is taken back to the statement after this
- **try FileName (string), FunctionLineNumber (int), ErrorTypesToCatch (table {string, ...}), Arg1, Arg2, ...**
  - Pushes the instruction pointer to the IP stack, jumps execution to FunctionLineNumber in the file FileName, and pushes all remaining arguments (except ErrorTypesToCatch) to the general stack in a single table. When any error occurs with at least one tag that is in ErrorTypesToCatch, execution is taken back to the statement after this

(this can be represented with `try (optional) FileName (string), FunctionLineNumber (int), ErrorTypesToCatch (table {string, ...}), (optional) Arg1, (optional) Arg2, ...`)

<br>

## Interacting with external code

- **callOutside ModuleName (string), Arg1, Arg2, ...**
  - Calls the module ModuleName with the remaining arguments as arguments for the module