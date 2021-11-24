%option noyywrap
%{
    #include "y.tab.h"
    extern int intval;
    extern int boolval;
%}

integer [0-9]+
bool    ["true","false"]
nl      \n

%%
[ \t]+  ;
{integer}    {sscanf(yytext, "%d", &intval);  return INTEGER;}
{bool}       {sscanf(yytext, "%s", &boolval);  return BOOLEAN;}
{nl}         {yylineno++; return NEWLINE;}
.            {return yytext[0];}
%%