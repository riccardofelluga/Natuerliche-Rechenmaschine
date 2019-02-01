%{
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>

extern int yylex();
void yyerror(char *msg);
void quitting();
%}


%union {
       char* lexeme;			//name of an identifier
       float value;			//attribute of a token of type NUM
       }

%token exit_command
%token <value>  NUM
%token IF
%token <lexeme> ID

%type <value> expr
%type <value> line
%left '-' '+'
%left '*' '/'
%right UMINUS

%start line

%%

line  : exit_command      {quitting();}
      | expr '\n'         {printf("Das Ergebnis ist %5.2f\n", $1);}
      | line exit_command {quitting();}
      | line expr '\n'    {printf("Das Ergebnis ist %5.2f\n", $2);}
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

void quitting (){
  exit(0);
  /*
  char answer;
  printf ("Bist du sicher den Rechner zu verlassen? (press 'y' for yes or 'n' for no)\n");
  scanf ("%c",&answer);
  
  if (answer == 'y'){
    exit(0);
  } else if (answer == 'n'){
    return;
  }
  */
}

int main(void)
{
  return yyparse();
}
