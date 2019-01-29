
all: lex.yy.c y.output y.tab.c y.tab.h
	cc -ll -o rech y.tab.c lex.yy.c 
lex.yy.c : rech-lex.l
	flex rech-lex.l
y.output y.tab.c y.tab.h : rech-yacc.y
	yacc -vd rech-yacc.y
clean:
	-@rm lex.yy.c y.output y.tab.c y.tab.h rech 2>/dev/null || true
run: all
	chmod +x rech && ./rech