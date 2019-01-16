all:
	bison -dy --report=all grammar.yy
	flex lexer.ll
	g++ -Wall lex.yy.c y.tab.c -o output