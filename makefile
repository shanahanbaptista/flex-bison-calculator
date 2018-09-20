calc: lex.yy.c calc.tab.c calc.tab.h
	gcc -o calc calc.tab.c lex.yy.c -lfl


