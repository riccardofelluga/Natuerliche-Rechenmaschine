# GesprocheneRechner
Project for the Formal Languages and Compilers course
## How to run
In you terminal, paste:
```(bash)
flex rech-lex.l
yacc -vd rech-yacc.y
gcc -ll y.tab.c lex.yy.c 
```
