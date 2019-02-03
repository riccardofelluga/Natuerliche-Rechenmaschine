%{
#include "y.tab.h"
void yyerror (char *s);
int yylex();
%}
%%
"fertig"			   {return exit_command;}
"PLUS"                 {return plus;}
"MINUS"                {return minus;}
"MAL"                  {return mal;}
"DURCH"                {return durch;}
[A-Z][a-z]*			   {yylval.id = yytext; return VARIABLE;}
[0-9]+[.]?[0-9]*       {yylval.f = atof(yytext); return num;}
[ \t\n]                ;
[-+=;*/()<>?]           {return yytext[0];}
.                      {ECHO; yyerror ("unexpected character");}

%%
int yywrap (void) {return 1;}
