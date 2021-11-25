%option noyywrap
%{
    #include "y.tab.h"
    #include <string.h>
    static void yyerror(char* s);
    int intval;
%}


INICIO "inicio:"
FIN "fin"
NUM "num"
ASIGN_VAR "="
INTEGER [-]?[0-9]+
FIN_LINEA ";"
FIN_CONDICIONAL "terminar."
ELSE_VAR "sino:"
INICIO_IF "inicio sentencia:"
IF_VAR "si:"

NOMBRE [a-z|A-Z|0-9|_]+

%%
{INICIO}                return INICIO;
{FIN}                   return FIN;
{INTEGER}               {yylval.numero = atoi(yytext); return INTEGER;}
{NUM}                   return NUM;
{ASIGN_VAR}             return ASIGN_VAR;
{NOMBRE}                {strcpy(yylval.texto, yytext); return NOMBRE;}
{INICIO_IF}             return INICIO_IF;
{FIN_CONDICIONAL}       return FIN_CONDICIONAL;
{IF_VAR}                return IF_VAR;
{FIN_LINEA}             return FIN_LINEA;
{ELSE_VAR}              return ELSE_VAR;

.                                       ;
%%

// static void yyerror(char* s){
//     {
//         if (yytext[0] == '\n'){
//             yytext[0] = '\\';
//         }
//       //  printf("Error: %s en linea %d, simbolo %c\n", s, yylineno, yytext[0]);
//     }
// }
// int yywrap(){return(1);}

static void comment(void)
{
    int c;
    int first= yylineno;
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
    yyerror("comentario sin terminar");
}

static void yyerror(char* s){
    {
        if (yytext[0] == '\n'){
            yytext[0] = '\\';
        }
        printf("Error: %s en linea %d, simbolo %c\n", s, yylineno, yytext[0]);
    }
}