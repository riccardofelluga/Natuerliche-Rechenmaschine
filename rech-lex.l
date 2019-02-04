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
"groesser als"         {return groesser;}
"kleiner als"          {return kleiner;}

[a-zA-Z]     	       {yylval.id = yytext[0]; return variable;}
[0-9]+[.]?[0-9]*       {yylval.f = atof(yytext); return num;}
[ \t\n]                ;
[-+=*/()<>?;]          {return yytext[0];}
.                      {ECHO; yyerror ("unexpected character");}
%%
int yywrap (void) {return 1;}
