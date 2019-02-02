%{
void yyerror (char *s);
int yylex();
#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <ctype.h>
int symbols[52];
int symbolVal(char symbol);
void updateSymbolVal(char symbol, int val);
%}

%union {int num; char id;}         /* Yacc definitions */
%start line


%token exit_command
%token plus
%token minus
%token mal
%token durch
%token <num> number
%token <id> identifier 

%left "PLUS" "MINUS"
%left "MAL" "DURCH"
%right UMINUS

%type <num> line exp term 
%type <id> assignment

%%

/*  descriptions of expected inputs     corresponding actions (in C) */

line    : assignment ';'		{;}
		| exit_command ';'		{exit(0);}
		| line identifier ';'	{printf("Der Wert von \"%c\" ist %d\n", $1 ,symbolVal($2));}
		| exp ';'				{printf("Das Ergebnis ist %d\n", $1);}
		| line assignment ';'	{;}
		| line exp ';'			{printf("Das Ergebnis ist %d\n", $2);}
		| line exit_command ';'	{exit(0);}
        ;


assignment : identifier '=' exp {updateSymbolVal($1,$3);};


exp    	: term                  {$$ = $1;}
       	| exp plus exp	        {$$ = $1 + $3;}
       	| exp minus exp         {$$ = $1 - $3;}
		| exp mal exp			{$$ = $1 * $3;}
		| exp durch exp			{$$ = $1 / $3;}
		| '(' exp ')'			{$$ = $2;}
		| '-' exp				{$$ = -$2;}
       	;



term   	: number                {$$ = $1;}
		| identifier			{$$ = symbolVal($1);} 
        ;

%%                     /* C code  compila*/
/*
do this: separa le exp  example:
R -> E G | E L
G -> > E 
L -> < E
pero spe così puoi avere una cosa che non vogliamo  del tipo 5>5<7>5
*/

int computeSymbolIndex(char token)
{
	int idx = -1;
	if(islower(token)) {
		idx = token - 'a' + 26;
	} else if(isupper(token)) {
		idx = token - 'A';
	}
	return idx;
} 

/* returns the value of a given symbol */
int symbolVal(char symbol)
{
	int bucket = computeSymbolIndex(symbol);
	return symbols[bucket];
}

/* updates the value of a given symbol */
void updateSymbolVal(char symbol, int val)
{
	int bucket = computeSymbolIndex(symbol);
	symbols[bucket] = val;
}

int main (void) {
	/* init symbol table */
	int i;
	for(i=0; i<52; i++) {
		symbols[i] = 0;
	}

	return yyparse ( );
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 