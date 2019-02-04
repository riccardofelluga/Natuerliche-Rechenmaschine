%{
// Import all the libraries needed by the project
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
// Define a number that is the max number of declarable variables in the same runtime
#define LIMIT 50

// Declare the structure that stores the name and value of a variable
struct Item
{
	char id;
	float val;
};
// Initialize an array that would store all the variables and their relative values
struct Item* symbolTable[LIMIT];
// Declare methods used by the compiler to store variables
struct Item* fetch(char identifier);
void insert(char identifier, float value);
void update(char identifier, float newValue);
// Default delcarations
void yyerror (char* s);
int yylex();

%}
// Declare two types for the grammar
%union {
	float f;
	char id;
}         
%start line //Sets the line production to be the starting point
//  Delares all the tokens
%token exit_command
%token plus
%token minus
%token mal
%token durch
%token gleich
%token groesser
%token kleiner
%token <f> num 
%token <id> variable 
// Sets the precedences
%left "plus" "minus"
%left "mal" "durch"
%right UMINUS
// Define the type of tokens
%type <f> line E term
%type <id> relop


%%

/*  descriptions of Eected inputs     corresponding actions (in C) */

line    : assignment ';'				{;}
		| exit_command ';'				{exit(0);}
		| relop '?'						{;}
		| E ';'							{printf("Das Ergebnis ist %5.2f\n", $1);}
		| line assignment ';'			{;}
		| line exit_command ';'			{exit(0);}
		| line relop '?'				{;}
		| line E ';'					{printf("Das Ergebnis ist %5.2f\n", $2);}
        ;

assignment : variable gleich E			{insert($1, $3);}
			;

relop 	: E groesser E 					{if($1 > $3) printf("Ja, %5.2f ist groesser als %5.2f\n",$1,$3); else printf("Nein, %5.2f ist nicht groesser als %5.2f\n",$1,$3);}
	 	| E kleiner E 					{if($1 < $3) printf("Ja, %5.2f ist kleiner als %5.2f\n",$1,$3); else printf("Nein, %5.2f ist nicht kleiner als %5.2f\n",$1,$3);}
		;

E    	: term                			{$$ = $1;}
       	| E plus E	        			{$$ = $1 + $3;}
       	| E minus E         			{$$ = $1 - $3;}
		| E mal E						{$$ = $1 * $3;}
		| E durch E						{$$ = $1 / $3;}
		| '(' E ')'						{$$ = $2;}
		| '-' E							{$$ = -$2;}
       	;

term	: num							{$$ = $1;}
		| variable						{$$ = fetch($1)->val;} 
		;

%%  /* C code with the implementation of a symbol table for the variables */
// Fetch method takes the name of the variable and returns its entry from the array
struct Item *fetch(char identifier)
{
	for (int i = 0; i < LIMIT; i++)
	{
		if (symbolTable[i] != NULL && symbolTable[i]->id == identifier)
			return symbolTable[i];
	}
	return NULL;
}
// This method stores a new wariable if it didn't existed or updates it
void insert(char identifier, float value)
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
// This method updates the value of a variable
void update(char identifier, float newValue)
{
	struct Item *out = fetch(identifier);
	if (out != NULL)
	{
		out->val = newValue;
	}
	return;
}
// Main method to run the compiler
int main (void)
{
	return yyparse();
}
// Default error handling method
void yyerror (char* s) {fprintf (stderr, "%s\n", s);} 