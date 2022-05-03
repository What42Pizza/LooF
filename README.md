# LooF

\

### This is a language that is loosely functional. It's interpreted, loosely typed, and has (mostly) mutable data.



## Example code:

### Factorial:

```
#include Basics.LOOF



function Factorial  -> In
	if (In == 1)
		return {1}
	call Factorial, (In - 1)  -> NextProduct
	return In * NextProduct
end



call Factorial, 10
:print
:exit
```

### Linking example:

```
// in Functions.LOOF

#include Basics.LOOF

function ConvertTableToString  -> TableIn, Seperator
	returnIf (typeOf TableIn ~= "table")
	default Seperator = ", "
	
	StringOut = toString TableIn[i]
	loop i, 1, lengthOf TableIn - 1
		StringOut = StringOut .. Sepeator .. (toString TableIn[i])
	repeat
	
	return StringOut
end



// in Main.LOOF

#include Basics.LOOF
$link Functions.LOOF as F

ExampleTable = {10, 20, "Example"}
call F.ConvertTableToString, ExampleTable
:print
:exit
```
