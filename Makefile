inter: inter.z80
	pasmo --equ REPL=0 inter.z80 inter.com

repl: inter.z80
	pasmo --equ REPL=1 inter.z80 inter.com

test:
	~/cpm/cpm inter
