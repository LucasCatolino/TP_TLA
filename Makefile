clean: 
	rm -f lex.yy.c y.tab.c y.tab.h main2

1: 
	yacc -d -Wcounterexamples grammar2.y

2: 
	lex main2.l

3: 
	gcc -o main2 lex.yy.c y.tab.c

all: 1 2 3
