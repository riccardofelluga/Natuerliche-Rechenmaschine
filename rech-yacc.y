%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define LIMIT 50


struct Item
{
	char* id;
	float val;
};

struct Item* symbolTable[LIMIT];

struct Item* fetch(char* identifier);
void insert(char* identifier, float value);
void update(char* identifier, float newValue);
void yyerror (char *s);
int yylex();

%}

%union {
	float f;
	char* id;
}         
%start line

%token exit_command
%token plus
%token minus
%token mal
%token durch
%token <f> num
%token <id> VARIABLE 

%left "PLUS" "MINUS"
%left "MAL" "DURCH"
%right UMINUS
%type <f> line E 
%type <id> relop


%%

/*  descriptions of Eected inputs     corresponding actions (in C) */

line    : VARIABLE '=' E ';'    		{printf("%s => %5.2f\n", $1, $3); insert($1, $3);}
		| exit_command ';'				{exit(0);}
		| line VARIABLE ';'	    		{printf("Der Wert von \"%s\" ist %5.2f\n", $2 , fetch($2)->val);}
		| relop '?'						{;}
		| E ';'							{printf("Das Ergebnis ist %5.2f\n", $1);}
		| line VARIABLE '=' E ';'    	{printf("%s => %5.2f\n", $2, $4); insert($2, $4);}
		| line exit_command ';'			{exit(0);}
		| line relop '?'				{;}
		| line E ';'					{printf("Das Ergebnis ist %5.2f\n", $2);}
        ;

relop 	: E '>' E 						{if($1 > $3) printf("Ja, %5.2f ist grosser als %5.2f\n",$1,$3); else printf("Nein, %5.2f ist nicht grosser als %5.2f\n",$1,$3);}
	 	| E '<' E 						{if($1 < $3) printf("Ja, %5.2f ist kleiner als %5.2f\n",$1,$3); else printf("Nein, %5.2f ist nicht kleiner als %5.2f\n",$1,$3);}
		;

E    	: num                			{$$ = $1;}
		| VARIABLE			    		{$$ = fetch($1)->val;} 
       	| E plus E	        			{$$ = $1 + $3;}
       	| E minus E         			{$$ = $1 - $3;}
		| E mal E						{$$ = $1 * $3;}
		| E durch E						{$$ = $1 / $3;}
		| '(' E ')'						{$$ = $2;}
		| '-' E							{$$ = -$2;}
       	;


%%  /* C code here */
struct Item *fetch(char *identifier)
{
	for (int i = 0; i < LIMIT; i++)
	{
		if (symbolTable[i] != NULL && strcmp(symbolTable[i]->id, identifier) == 0)
			return symbolTable[i];
	}
	return NULL;
}

void insert(char *identifier, float value)
{
	if (fetch(identifier) == NULL)
	{
		struct Item *in = (struct Item *)malloc(sizeof(struct Item));
		in->id = identifier;
		in->val = value;

		for (int i = 0; i < LIMIT; i++)
		{
			if (symbolTable[i] == NULL)
			{
				symbolTable[i] = in;
				return;
			}
		}
	}
	else
	{
		update(identifier, value);
	}
}

void update(char *identifier, float newValue)
{
	struct Item *out = fetch(identifier);
	if (out != NULL)
	{
		out->val = newValue;
	}
	return;
}

int main (void)
{
	return yyparse();
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 