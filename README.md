# Natürliche Rechenmaschine

Project for the Formal Languages and Compilers course

## How to run short

In terminal, paste:

```(bash)
make run
```

## How to run long version

In your terminal, paste:

```(bash)
flex rech-lex.l
yacc -vd rech-yacc.y
gcc -ll y.tab.c lex.yy.c
```
