# scripting

This is a trivial REPL-based "scripting thing", designed to run on Z80-based CP/M systems.

The REPL allows arbitrary I/O to ports, but little else - for usefulness the currently-selected I/O port is displayed in the REPL prompt.

All-told the interpreter, when compiled as REPL, takes about 500 bytes.



## Overview

This is like a stack-based language, using single-characters to define operations.  However there is not actually a stack - just a single location which can be used to store a value.

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
* `i`
  * Read a byte of input, from the currently selected I/O port, and place it in the storage-area
* `o`
  * Write the contents of the storage-area to the currently selected I/O port.
* `p`
  * Print the number in the storage-area.
* `q`
  * Quit, if we're in REPL-mode.
* `x`
  * Print the character whos ASCII code is stored in the storage-area


### Sample "Programs"

> Note: In these examples I've prefixed "c" to the input, this clears the state of the temporary storage area - which isn't necessary if you run them immediately upon startup, but will avoid surprises otherwise.

Store the value 42 in the temporary storage area, and print it:

```
c42p
```

Store the value 42 in the temporary storage area, then print that as a character:

```
c42x
```

Configure the I/O port to be port 0x01, read a byte from it, and print that value:

```
c1#ip
```

Write the byte 32, then the byte 77, to the I/O port 3.

```
c3#c32oc77o
```



## Inspiration

https://blog.steve.fi/simple_toy_languages.html
