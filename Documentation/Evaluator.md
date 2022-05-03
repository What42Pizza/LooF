## Evaluator operators:

+
-
*
/
^
%
..
==
>
<
!=
>=
<=
and
or
not
xor

## Evaluator functions:

round VALUE

floor VALUE

ceiling VALUE

sqrt VALUE



min VALUE (table)

max VALUE (table)



random VALUE (number)
	returns a random number in the range [0, VALUE)

randomInt VALUE (number (int))
	returns a random integer in the range [0, VALUE]

chance VALUE
	returns true VALUE % of the time



typeOf VALUE

lengthOf VALUE (table)

endOf VALUE (table)
	returns lengthOf VALUE - 1

keysOf VALUE (table)
	returns a table containing all of the keys of VALUE

valuesOf VALUE (table)
	returns a table containing all of the values of VALUE

randomItem VALUE (table)



toNumber VALUE (string or bool)

toString VALUE

toChars VALUE (string)

toBool VALUE



timeSince VALUE (number)
	returns the number of seconds since VALUE

## Order of operations:

(if not specified, right to left; evaluates parenthesis and tables as (and if) needed)

- 1: Index queries
- 2: Evaluator functions (left to right)
- 3: ^
- 4: %
- 5: * and /
- 6: + and -
- 7: ==, >, < !=, >=, and <=
- 8: and, or, not, and xor