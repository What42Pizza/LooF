# LooF

<br>

# THIS IS STILL A WORK IN PROGRESS AND IS NOT MEANT TO BE USED YET

<br>

### This is a language that is loosely functional. It's interpreted, loosely typed, and has (mostly) mutable data.

<br>
<br>
<br>

## Example code:

<br>

### Factorial:

```
#include Basics.LOOF



function Factorial  -> In
	if In == 1
		return 1
	call Factorial, In - 1  -> NextProduct
	return In * NextProduct
end



call Factorial, 10  -> FactorialResult
:print FactorialResult
:exit
```

<br>

### Linking example:

```
// in GeneralFunctions.LOOF

#include Basics.LOOF

function ConvertTableToString  -> TableIn, Seperator
	returnIf typeOf TableIn != "table"
	Seperator defaultsTo ", "
	
	StringOut = toString TableIn[i]
	loop i, 1, endOf TableIn
		StringOut = StringOut .. Sepeator .. toString TableIn[i]
	repeat
	
	return StringOut
end



// in Main.LOOF

#include Basics.LOOF
$link GeneralFunctions.LOOF as F

call F.ConvertTableToString, {10, 20, "Example"}  -> TableAsString
:print TableAsString
:exit
```

<br>
<br>
<br>

## License

[MIT License](LICENSE)