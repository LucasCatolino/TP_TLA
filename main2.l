%option noyywrap
%{
    #include "y.tab.h"
    #include <string.h>
    static void yyerror(char* s);
    static void comment(void);
    int intval;
%}

INICIO "inicio:"
FIN "fin"
NUM "num"
LETRAS "letras"
ASIGN_VAR "="
ASIGNACION_IGUAL ":="
IGUAL "=="
MAYOR ">"
MAYOR_IGUAL ">="
MENOR "<"
MENOR_IGUAL "<="
INTEGER [-]?[0-9]+
FIN_LINEA ";"
FIN_CONDICIONAL "terminar"
ELSE_VAR "sino"
INICIO_CONDICIONAL "inicio sentencia"
IF_VAR "si"
WHILE_VAR "mientras"
AND "y"
OR "o"
MULTIPLICACION "*"
SUMA "+"
RESTA "-"
DIVISION "/"
MODULO "%"
MAS_IGUAL "+="
MENOS_IGUAL "-="
MULTPLICACION_IGUAL "*="
DIVISION_IGUAL "/="
MODULO_IGUAL "%="
NOMBRE var_[a-z|A-Z|0-9|_]+
TEXTO ["][a-z|A-Z|0-9|_| ]+["]
IMPRIMIR_VAR "imprimir"
NOMBRE_CONST const_[a-z|A-Z|0-9|_]+
DEF "definicion:"

%%
[ \t]+                  ;
{INICIO}                return INICIO;
{DEF}                   return DEF;
{FIN}                   return FIN;
{INTEGER}               {yylval.numero = atoi(yytext); return INTEGER;}
{NUM}                   return NUM;
{LETRAS}                return LETRAS;
{ASIGN_VAR}             return ASIGN_VAR;
{NOMBRE}                {strcpy(yylval.texto, yytext); return NOMBRE;}
{NOMBRE_CONST}          {strcpy(yylval.texto, yytext); return NOMBRE_CONST;}
{INICIO_CONDICIONAL}    return INICIO_CONDICIONAL;
{FIN_CONDICIONAL}       return FIN_CONDICIONAL;
{IF_VAR}                return IF_VAR;
{FIN_LINEA}             return FIN_LINEA;
{ELSE_VAR}              return ELSE_VAR;
{IGUAL}                 return IGUAL;
{MENOR}                 return MENOR;
{MAYOR}                 return MAYOR;
{MAYOR_IGUAL}           return MAYOR_IGUAL;
{MENOR_IGUAL}           return MENOR_IGUAL;
{AND}                   return AND;
{OR}                    return OR;
{WHILE_VAR}             return WHILE_VAR;
{IMPRIMIR_VAR}          return IMPRIMIR_VAR;
{MULTIPLICACION}        return MULTIPLICACION;
{SUMA}                  return SUMA;
{RESTA}                 return RESTA;
{DIVISION}              return DIVISION;
{MODULO}                return MODULO;
{MAS_IGUAL}             return MAS_IGUAL;
{MENOS_IGUAL}           return MENOS_IGUAL;
{MULTPLICACION_IGUAL}   return MULTPLICACION_IGUAL;
{DIVISION_IGUAL}        return DIVISION_IGUAL;
{MODULO_IGUAL}          return MODULO_IGUAL;
{ASIGNACION_IGUAL}      return ASIGNACION_IGUAL;
{TEXTO}                 {strcpy(yylval.texto, yytext); return TEXTO;}
"/*"                    { comment(); }
"//".*                  { /* consume //-comment */ }
.                       ;
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