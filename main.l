%option noyywrap
%{
    #include "y.tab.h"

    extern int intval;
    extern int boolval;
    //extern char[] stringval;
    
    static void comment(void);
%}

integer [0-9]+
bool    ["true","false"]
nl      \n
SP  (u8|u|U|L)
ES  (\\(['"\?\\abfnrtv]|[0-7]{1,3}|x[a-fA-F0-9]+))
WS  [ \t\v\n\f]



%%
[ \t]+  ;
{integer}    {sscanf(yytext, "%d", &intval);  return INTEGER;}
{bool}       {sscanf(yytext, "%s", &boolval);  return BOOLEAN;}
{nl}         {yylineno++; return NEWLINE;}
"=="        return EQ;
">="        return GE;
"<="        return LE;
"si"        return IF;
"entonces"  return THEN;
"}"         return EOB;
"imprimir"  {return PRINT;}
"alfabeto" 	printf("de la ‘a’ a la 'z' \n");
.            {return yytext[0];}
"/*"        { comment(); }
"//".*      { /* consume //-comment */ }
%%

static void comment(void)
{
    int c;
    while ((c = input()) != 0){
        if (c == '\n') {
            yylineno++;
        }
        if (c == '*') {
            while ((c = input()) == '*'){
                ;
            }
            if (c == '\n') {
                yylineno++;
            }
            if (c == '/') {
                return;
            }
            if (c == 0) {
                break;
            }
        }
    }
    printf("unterminated comment");
}
