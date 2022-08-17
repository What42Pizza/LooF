# Assignments

<br>

- **VarName = Value**
  - Sets VarName to Value
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
- **VarName ..= Value**
  - Casts Value to a string and concatenates it to the end of VarName
- **VarName <<defaultsTo Value**
  - If VarName is null, sets VarName to Value
- **VarName <<addItem Value**
  - Adds Value to the end of VarName
  - Errors if VarName is not a table
- **VarName <<addAtIndex Input (table {Index (int), Item (any)})**
  - Shifts all values past Index and sets Index to Item
  - Errors if VarName is not a table
- **VarName <<addAll Value (table)**
  - Adds all the items in the array part and hashmap part of Value to VarName
  - Errors if VarName is not a table
- **VarName <<removeIndex Index (int)**
  - Removes the value at Index and shifts the remaining values
  - Errors if VarName is not a table

<br>

- **VarName ++**
  - Increments VarName
- **VarName --**
  - Decrements VarName
- **VarName !!**
  - Toggles VarName
- **VarName <<clone**
  - Sets VarName to a clone of VarName

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
  - Pops the first value of the general stack into VarName. Errors if the general stack is empty or if no more values have been pushed to the stack since the function started
- **pop TableVarName, Item0, Item1, ...**
  - Pops the first value of the general stack into TableVarName, then sets the var Item0 to index 0 of TableVarName, sets the var Item0 to index 1 of TableVarName, etc. If the number of items in TableVarName runs out, all remaining arguments will be set to null
- **popImmutable TableVarName, Item0, Item1, ...**
  - Same as `pop`, but if the variable name does not start with "mut_", the value's lock level will be increased, meaning it is made immutable until the current function ends. If the variable name does start with "mut_", the lock level is not increased and the first four characters of the var name are ignored

<br>

## Functions

- **call Function**
  - Pushes the instruction pointer and file name to the IP stack and jumps execution to Function
- **call Function, Arg1, Arg2, ...**
  - Pushes the instruction pointer and file name to the IP stack, jumps execution to Function, and pushes all remaining arguments to the general stack in a single table
- **return**
  - Jumps execution to the value popped off of the IP stack. Errors if the IP stack is empty
- **return ReturnValue0, ReturnValue1, ...**
  - Pushes all arguments to the general stack in a single table and jumps execution to the value popped off of the IP stack. Errors if the IP stack is empty or if the size of the general stack is not the same as when the function was called
- **returnIf Condition**
  - If Condition is truthy, jumps execution to the value popped off of the IP stack. Errors if the IP stack is empty or if the size of the general stack is not the same as when the function was called
- **returnIf Condition, ReturnValue0, ReturnValue1, ...**
  - If Condition is truthy, pushes all remaining arguments to the general stack in a single table and jumps execution to the value popped off of the IP stack. Errors if the IP stack is empty or if the size of the general stack is not the same as when the function was called
- **returnRaw ReturnValue**
  - Pushes ReturnValue to the general stack and jumps execution to the value popped off of the IP stack. Errors if the IP stack is empty or if the size of the general stack is not the same as when the function was called
- **returnRawIf Condition, ReturnValue**
  - If Condition is truthy, pushes ReturnValue to the general stack and jumps execution to the value popped off of the IP stack. Errors if the IP stack is empty or if the size of the general stack is not the same as when the function was called

**NOTE:** remember that 'call' and 'try' statements have to take in values of type 'function', which can only be created with the 'createFunction' evaluator function. (more info in 'Language Basics.md')

<br>

## General Control Flow

- **if Condition**
  - If Condition is truthy, executes the next statement (otherwise skips it)
- **if Condition, Invert**
  - If Condition is truthy xor Invert is truthy, executes the next statement (otherwise skips it)
- **skip**
  - Jumps execution to just after the first 'end' statement it can find that is on the same code block level. Errors if no suitable 'end' statement is found
- **skip IsFunction**
  - Jumps execution to just after the first 'end' statement it can find that is on the same code block level. If IsFunction is true, the matching 'end' statement will throw an error if executed to make sure you make the function return. Errors if no suitable 'end' statement is found
- **end**
  - Effectively nop; only useful because of 'skip' statements
- **skipTo LabelName**
  - Jumps execution to just after the next label named LabelName
- **skipToIf Condition, LabelName**
  - If Condition is truthy, jumps execution to just after the next label named LabelName
- **Label LabelName**
  - Effectively nop; only useful because of 'skipTo' statements

<br>

## Loops

- **loop**
  - Effectively nop; only useful because of repeat
- **loop ValueVarName, End (int or float)**
  - Same as statement `loop IndexVarName, 0, End, 1`
- **loop ValueVarName, Start (int or float), End (int or float)**
  - Same as statement `loop IndexVarName, Start, End, 1`
- **loop ValueVarName, Start (int or float), End (int or float), Increment (int or float)**
  - If ValueVarName is null and End >= Start:   Sets ValueVarName to Start
  - If ValueVarName is null amd End < Start:   Jumps execution to after the first 'repeat' statement it can find that is on the same code block level. Errors if no suitable 'repeat' statement is found
  - If ValueVarName plus Increment is less than or equal to End:   Increments ValueVarName by Increment
  - If ValueVarName plus Increment is greater than End:   Jumps execution to after the first 'repeat' statement it can find that is on the same code block level and sets ValueVarName to null. Errors if no suitable 'repeat' statement is found
  - Errors if VarName is neither null, int, nor float
- **forEach ValueVarName, TableToLoop (table)**
  - Same as statement `forEach ValueVarName, TableToLoop, IncrementVarName` but with IncrementVarName being ValueVarName follow by an "_INDEX"
- **forEach ValueVarName, TableToLoop (table), IndexVarName**
  - If IndexVarName is null:  Sets IndexVarName to 0 and ValueVarName to TableToLoop indexed with IndexVarName. Errors if TableToLoop is not a table or byteArray
  - If IncrementVarName plus 1 is less than the length of TableToLoop:  Increments IndexVarName and sets ValueVarName to TableToLoop indexed with IndexVarName
  - If IndexVarName plus 1 is not less than the length of TableToLoop:  Jumps execution to after the first 'repeat' statement it can find that is on the same code block level and sets IndexVarName to null. Errors if no suitable 'repeat' statement is found
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

- **try Function, ErrorTypesToCatch (table {string, ...})**
  - Pushes the instruction pointer and file name to the IP stack and jumps execution to Function. When any error occurs with at least one tag that is in ErrorTypesToCatch (or if ErrorTypesToCatch starts with "all"), execution is taken back to the statement after this, and a table containing details and return values is pushed to the general stack
- **try Function, ErrorTypesToCatch (table {string, ...}), Arg1, Arg2, ...**
  - Pushes the instruction pointer and file name to the IP stack, jumps execution to Function, and pushes all remaining arguments (except ErrorTypesToCatch) to the general stack in a single table. When any error occurs with at least one tag that is in ErrorTypesToCatch (or if ErrorTypesToCatch starts with "all"), execution is taken back to the statement after this, and a table containing details and return values is pushed to the general stack


**Note:** Value pushed to the stack by 'try' statements:

```
{
	Success (bool),
	ErrorData (table {
		ErrorTypeTags (table {string, ...})
		CallStack (table {
			table {string FileName, int LineNumber}
			...
		})
	}),
	ReturnValue1,
	ReturnValue2,
	...
}
```

<br>

## Mics

- **callOutside ModuleName (string), Arg1, Arg2, ...**
  - Calls the module ModuleName with the remaining arguments as arguments for the module
- **TODO: Details (string)** (this is a statement, not something I need to add)
  - Errors with Details as the error message.
- **assert Condition**
  - Same as statement `errorIf Condition, "assertion failed", {"AssertionFail"}`
- **getGlobal**
  - Pushes the global value to the general stack.
- **setGobal NewValue**
  - Sets the global value to NewValue.