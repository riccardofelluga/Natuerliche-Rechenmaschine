%{
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>

extern int yylex();
void yyerror(char *msg);
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

line  : expr '\n'      {printf("Risultato %5.2f\n", $1); exit(0);}
      | ID             {printf("Risultato %s\n", $1); exit(0);}
      ;
expr  : expr '+' expr  {$$ = $1 + $3;}
      | expr '-' expr  {$$ = $1 - $3;}
      | expr '*' expr  {$$ = $1 * $3;}
      | expr '/' expr  {$$ = $1 / $3;}
      | NUM            {$$ = $1;}
      | '-' expr       {$$ = -$2;} 
      ;

%%

void yyerror (char *msg)
{
  fprintf (stderr, "%s\n", msg);
  fputs (msg, stderr);
  fputc ('\n', stderr);
  exit(1);
}

int main(void)
{
  return yyparse();
}
