all: yacc lex
	gcc lex.yy.c y.tab.c -o proje

yacc: proje.y
	yacc -d proje.y

lex: proje.l
	lex proje.l


