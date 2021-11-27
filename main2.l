%option noyywrap
%option nounput

%{
    #include "y.tab.h"
    #include <string.h>
    static void yyerror(char* s);
    static int buen_comentario(void);
    int intval;
%}

INICIO "inicio:\n"
FIN "fin"
NUM "num "
LETRAS "letras "
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
TEXTO ["][^\n]*["]
IMPRIMIR_VAR "imprimir"
LEER_VAR "leer"
IMPRIMIR_VAR_LINEA "imprimirln"
NOMBRE_CONST const_[a-z|A-Z|0-9|_]+
DEF "definicion:"
CONCAT_VAR "concatenar"
PARENTESIS_ABRE "("
PARENTESIS_CIERRA ")"
COMA ","
nl  "\n"

%%
{nl}                    {yylineno++; ;}
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
{LEER_VAR}              return LEER_VAR;
{IMPRIMIR_VAR_LINEA}    return IMPRIMIR_VAR_LINEA;
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
{CONCAT_VAR}            return CONCAT_VAR;
{PARENTESIS_ABRE}       return PARENTESIS_ABRE;
{PARENTESIS_CIERRA}     return PARENTESIS_CIERRA;
{COMA}                  return COMA;
"/*"                    { if (!buen_comentario()) return ERROR_COMENTARIO;}
"//".*                  { /* consume //-comment */ }
.                       ;
%%


static int buen_comentario(void)
{
    int c;
    int first= yylineno + 1;
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
                return 1;
            }
            if (c == 0) {
                break;
            }
        }
    }
    fprintf(stderr, "---------------------ERROR---------------------\n");
    fprintf(stderr, "Error: abre comentario en linea %d\n", first);
    fprintf(stderr, "-----------------------------------------------\n");
    yyerror("comentario sin terminar");
    return 0;
}

static void yyerror(char* s){
    {
        if (yytext[0] == '\n'){
            yytext[0] = '\\';
        }
        fprintf(stderr, "---------------------ERROR---------------------\n");
        fprintf(stderr, "Error: %s en linea %d\n", s, yylineno);
        fprintf(stderr, "-----------------------------------------------\n");
        exit(-1);
    }
}