%{
#include "y.tab.h"
void yyerror (char *s);
int yylex();
%}
%%
"fertig"			   {return exit_command;}
"plus"                 {return plus;}
"minus"                {return minus;}
"mal"                  {return mal;}
"durch"                {return durch;}
"gleich"               {return gleich;}
"grosser als"          {return grosser;}
"kleiner als"          {return kleiner;}
[A-Z][a-z]*      	   {yylval.id = yytext; return VARIABLE;}
[0-9]+[.]?[0-9]*       {yylval.f = atof(yytext); return num;}
[ \t\n]                ;
[-+=*/()<>?;]          {return yytext[0];}
.                      {ECHO; yyerror ("unexpected character");}

%%
int yywrap (void) {return 1;}
