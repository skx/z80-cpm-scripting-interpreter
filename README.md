# scripting

This is a trivial REPL-based "scripting thing", designed to run on Z80-based CP/M systems.

The REPL allows arbitrary I/O to ports, and RAM, but little else - for usefulness the currently-selected I/O port is displayed in the REPL prompt.

All-told the interpreter, when compiled as REPL, takes about 700 bytes.



## Overview

This is like a stack-based language, using single-characters to define operations.  However there is not actually a stack - just a single location which can be used to store a value, and two storage-areas for dedicated port and memory-based I/O:

* There is a "variable" which is used to set the port number to use for all port-based I/O (set with "`#`").,
* There is a variable which is used to specify which address to read/write to in RAM (set with "`M`").

The storage-location is used for almost all instructions, and might be considered like an accumulator-register.


### Instructions

The following instructions are available:

* `[0-9]`
  * Build up a number, which is stored in the temporary area.
* `[ \t\n]`
  * Ignored.
* `#`
  * Set I/O to use the port in the storage-area.
* `c`
  * Clear the number in the storage-area.  (i.e. Set to zero).
* `g`
  * Perform a CALL instruction to the currently selected RAM address.
* `i`
  * Read a byte of input, from the currently selected I/O port, and place it in the storage-area
* `m`
  * Write the contents of the storage-area to the currently selected RAM address.
* `o`
  * Write the contents of the storage-area to the currently selected I/O port.
* `p`
  * Print the number in the storage-area.
* `r`
  * Read the contents of the currently selected RAM address, and save in the storage-area.  Increment the RAM address.
* `q`
  * Quit, if we're in REPL-mode.
* `w`
  * Write the contents of the storage-area (lower byte only) to the currently selected RAM address. Increment the RAM address.
* `x`
  * Print the character whos ASCII code is stored in the storage-area


### Sample "Programs"

> Note: In these examples I've prefixed "c" to the input, this clears the state of the temporary storage area - which isn't necessary if you run them immediately upon startup, but will avoid surprises otherwise.

Also note that I broke up the "programs" with whitespace to aid readability.  This still works, spaces, TABs, and newlines are skipped over by the interpreter.

Store the value 42 in the temporary storage area, and print it:

```
c 42 p
```


Store the value "201" (opcode for RET) at address 20000, and JMP to it, this will call RET which will exit to CP/M:

```
20000 m 201 w 20000 m g
```


Store the value 42 in the temporary storage area, then print that as if it were the ASCII code of a character (output "`*`"):

```
c 42 x
```

Configure the I/O port to be port 0x01, read a byte from it to the temporary storage area, then print that value:

```
c 1 # i p
```

Write the byte 32, then the byte 77, to the I/O port 3.

```
c 3 # c 32 o c 77 o
```

To be more explicit that last example could have been written as:

* `c3#c32oc77o`
  * `c3` - Clear the storage area, and write the number 3 to it.
  * `#` - Set the I/O port to be used for (i)nput and (o)utput to be the value in the temporary storage-area, i.e. 3.
  * `c32` - Clear the storage area, and write the number 32 to it.
  * `o` - Output the byte in the storage area (32) to the currently selected I/O port (3)
  * `c77` - Clear the storage area, and write the number 77 to it.
  * `o` - Output the byte in the storage area (77) to the currently selected I/O port (3)



## Porting

We use the CP/M BIOS calls for simplicity, if you wished to port this code to a single-board Z80-based system, without CP/M, that would not be hard:

* Add your UART initialization.
* Update the code to read/write to the console.
  * We currently use the BIOS to read input.
  * We currently use the BIOS to write output.

TODO: Better instructions for this, and make the routines easier to replace.



## Inspiration

https://blog.steve.fi/simple_toy_languages.html
