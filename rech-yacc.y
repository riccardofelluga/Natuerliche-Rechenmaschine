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
%token gleich
%token grosser
%token kleiner
%token <f> num
%token <id> VARIABLE 

%left "plus" "minus"
%left "mal" "durch"
%right UMINUS
%type <f> line E 
%type <id> relop A


%%

/*  descriptions of Eected inputs     corresponding actions (in C) */

line    : A ';'    						{;}
		| exit_command ';'				{exit(0);}
		| line VARIABLE ';'	    		{printf("Der Wert von \"%s\" ist %5.2f\n", $2 , fetch($2)->val);}
		| relop '?'						{;}
		| E ';'							{printf("Das Ergebnis ist %5.2f\n", $1);}
		| line A ';'    				{;}
		| line exit_command ';'			{exit(0);}
		| line relop '?'				{;}
		| line E ';'					{printf("Das Ergebnis ist %5.2f\n", $2);}
        ;

A 		: E gleich VARIABLE				{insert($3, $1);}

relop 	: E grosser E 					{if($1 > $3) printf("Ja, %5.2f ist grosser als %5.2f\n",$1,$3); else printf("Nein, %5.2f ist nicht grosser als %5.2f\n",$1,$3);}
	 	| E kleiner E 					{if($1 < $3) printf("Ja, %5.2f ist kleiner als %5.2f\n",$1,$3); else printf("Nein, %5.2f ist nicht kleiner als %5.2f\n",$1,$3);}
		;

E    	: num                			{$$ = $1;}
		| VARIABLE			    		{$$ = fetch($1)->val; printf("%s\n", $1);} 
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
		if (symbolTable[i] != NULL && strcmp(symbolTable[i]->id, identifier) == 0){
			//printf("FOUND %s at position %d\n", symbolTable[i]->id, i);			
			return symbolTable[i];
		}
		
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
				printf("inserted %s at position %d with value %f\n ", in->id, i, in->val);
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