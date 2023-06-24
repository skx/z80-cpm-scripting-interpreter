# scripting

This is a trivial REPL-based "scripting thing", designed to run on Z80-based CP/M systems.

The REPL allows arbitrary I/O to ports, and RAM, along with string output and looping-support, but there is little else - for usefulness the currently-selected I/O port is displayed in the REPL prompt.

All-told the interpreter, when compiled as REPL, requires approximately 800 bytes.



## Overview

This repository contains a simple REPL-based interpreter which will run upon a CP/M host.  Although there is a FORTH-like flavour to the idea of using simple tokens to define actions this is actually not a stack-based language at all.

There are three registers which are used, internally:

* Any time a number is encountered it is moved into a scratch-area.
  * This is notionally known as the accumulator register.
* It is possible to move the accumulator value into the IO-register, U.
  * This register contains the port-number that any I/O read, or write, operation is applied to.
  * Not a great mnemonic, but close to both I&O on the keyboard.
* It is possible to move the accumulator value into the memory-register, M.
  * This register specifies the RAM address of any memory read/write operations.
* Finally you may move the contents of the accumulator into the K-register, which is used for operating loops.

TLDR:

* Numbers go to A-Register.
* Port I/O is controlled by the U-register.
* RAM read/write is controlled by the M-register.
* Loops are controlled by the K-register.


### Instructions

The following instructions are available:

* `[0-9]`
  * Build up a number, which is stored in the temporary area.
* `[ \t\n]`
  * Ignored.
* `{..}`
  * Looping construct, see below for details.
* `u`
  * Set the I/O-port to be the value of the accumulator.
* `U`
  * Set the accumulator to be the value of the I/O-port.
* `_`
  * Print the string wrapped by by "_" characters.
* `c`
  * Clear the number in the accumulator.  (i.e. Set to zero).
* `g`
  * Perform a CALL instruction to the currently selected RAM address in the M-register.
* `h`
  * HALT for the number of times specified in the accumulator.
  * This is used for running delay operations.
* `i`
  * Read a byte of input, from the currently selected I/O port (U-register), and place it in the accumulator.
* `k`
  * Copy the contents of the accumulator (lower half) into the K-register.
* `K`
  * Copy the contents of the K-register to the accumulator.
* `m`
  * Write the contents of the accumulator to the currently selected RAM address (in the M-register).
* `M`
  * Write the contents of the M-register to the accumulator.
* `n`
  * Write a newline character.
* `o`
  * Write the contents of the accumulator to the currently selected I/O port (held in the U-register).
* `p`
  * Print the value of the accumulator, as a four-digit hex number.
* `P`
  * Print the value of the lower half of the accumulator, as a two-digit hex number.
* `r`
  * Read the contents of the currently selected RAM address, held in the M-register), and save in the accumulator.
  * Then increment the RAM address held in the M-register (so that repeats will read from incrementing addresses).
* `q`
  * Quit, if we're in REPL-mode.
* `w`
  * Write the contents of the accumulator (lower byte only) to the currently selected RAM address held in the M-register.
  * Then increment the RAM address held in the M-register (so that repeats will write to incrementing addresses).
* `x`
  * Print the character whos ASCII code is stored in the accumulator.



## Looping

The special K-register can be used to control how many times a loop will be carried out.

Loops consist of code between `{` and `}` pairs.  For example the following program will show a countdown:

```
[00]>10k{Kp}
0009
0008
0007
0006
0005
0004
0003
0002
0001
0000
```

First of all the value 10 is loaded into the accumulator, then copied into the K-register.  The body of the loop is then:

```
Kp
```

K copies the contents of the loop-register back to the accumulator, which is then printed by the `p` command.


### Sample "Programs"

> Note: In these examples I've prefixed "c" to the input, this clears the state of the accumulator - which isn't necessary if you run them immediately upon startup, but will avoid surprises otherwise.

Also note that I broke up the "programs" with whitespace to aid readability.  This still works, spaces, TABs, and newlines are skipped over by the interpreter.

Show a greeting:

```
_Hello, world!_
```

Store the value 42 in the accumulator, and print it:

```
c 42 p
```


Store the value "201" (opcode for RET) at address 20000, and JMP to it, this will call RET which will exit to CP/M:

```
c 20000 m c 201 w 20000 m g
```


Store the value 42 in the accumulator, then print that as if it were the ASCII code of a character (output "`*`"):

```
c 42 x
```

Configure the I/O port to be port 0x01, read a byte from it to the accumulator, then print that value:

```
c 1 u i p
```

Write the byte 32, then the byte 77, to the I/O port 3.

```
c 3 u c 32 o c 77 o
```

To be more explicit that last example could have been written as:

* `c3uc32oc77o`
  * `c3` - Clear the accumulator, and write the number 3 to it.
  * `u` - Set the I/O port to be used for (i)nput and (o)utput to be the value in the accumulator, i.e. 3.
  * `c32` - Clear the accumulator, and write the number 32 to it.
  * `o` - Output the byte in the accumulator (32) to the currently selected I/O port (3)
  * `c77` - Clear the accumulator, and write the number 77 to it.
  * `o` - Output the byte in the accumulator (77) to the currently selected I/O port (3)



## Porting

We use the CP/M BIOS calls for simplicity, if you wished to port this code to a single-board Z80-based system, without CP/M, that would not be hard.

All the system-integration is contained within the file [bios.z80](bios.z80) so you could replace the functions appropriately:

* Add your UART initialization to `bios_init`.
* Update the code to read/write to the serial-console, or whatever, in the other I/O functions.



## Inspiration

https://blog.steve.fi/simple_toy_languages.html
