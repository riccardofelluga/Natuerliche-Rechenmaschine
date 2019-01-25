%{
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
%}


%union {
       char* lexeme;			//name of an identifier
       float value;			//attribute of a token of type NUM
       }

%token <value>  NUM
%token IF
%token <lexeme> ID

%type <value> expr
 /* %type <value> line */

%left '-' '+'
%left '*' '/'
%right UMINUS

%start line

%%
line  : expr '\n'      {printf("Result: %5.2f\n", $1); exit(0);}
      | ID             {printf("Result: %s\n", $1); exit(0);}
      ;
expr  : expr '+' expr  {$$ = $1 + $3;}
      | expr '-' expr  {$$ = $1 - $3;}
      | expr '*' expr  {$$ = $1 * $3;}
      | expr '/' expr  {$$ = $1 / $3;}
      | NUM            {$$ = $1;}
      | '-' expr       {$$ = -$2;} 
      ;

%%

#include "lex.yy.c"

int yyerror (char const *message)
{
  return fprintf (stderr, "%s\n", message);
  fputs (message, stderr);
  fputc ('\n', stderr);
  return 0;
}

int main(void)
{
  return yyparse();}
