clean: 
	rm -f lex.yy.c y.tab.c y.tab.h main

1: 
	yacc -d grammar.y

2: 
	lex main.l

3: 
	gcc -o main lex.yy.c y.tab.c