%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "list.h"
#define MAX_READEABLE_LENGTH 1024
static void yyerror(char *s);
int yylex();
extern char *yytext;
extern int yylineno;
int i = 0;
%}

%union{
        char texto[256];
        int numero;
}

%token INICIO DEF FIN NUM ASIGN_VAR FIN_LINEA INICIO_CONDICIONAL FIN_CONDICIONAL IF_VAR ELSE_VAR
%token IGUAL MENOR MAYOR MAYOR_IGUAL MENOR_IGUAL OR AND WHILE_VAR IMPRIMIR_VAR_LINEA MULTIPLICACION
%token SUMA RESTA DIVISION MODULO MAS_IGUAL MENOS_IGUAL MULTIPLICACION_IGUAL DIVISION_IGUAL MODULO_IGUAL
%token DISTINTO IMPRIMIR_VAR LETRAS ASIGNACION_IGUAL CONCAT_VAR COMA PARENTESIS_ABRE
%token PARENTESIS_CIERRA LEER_VAR ERROR_COMENTARIO

%token <texto> NOMBRE
%token <texto> TEXTO
%token <numero> INTEGER
%token <texto> NOMBRE_CONST

%left SUMA RESTA DIVISION MODULO MAS_IGUAL MENOS_IGUAL MULTIPLICACION_IGUAL DIVISION_IGUAL

%type<numero> F_INT
%type<texto> F_CHAR

%start S /* simbolo sentencial */

%%

S:
        INICIO_PROGRAMA PROGRAMA FIN_PROGRAMA
        | DEF DEFINICION INICIO_PROGRAMA PROGRAMA FIN_PROGRAMA
        ;

INICIO_PROGRAMA:
        INICIO {printf("//Las librerias a usar se incluyen en esta seccion de la siguiente manera:\n");
                printf("#include <stdio.h> \n#include <stdlib.h> \n#include \"list.h\" \n#include \"stdio.h\" \n#include \"string.h\" \n\n");
                printf("//El main es lo que se va a ejecutar, y se define de la siguiente manera:\n");
                printf("int main(){ \n");}
        ;

FIN_PROGRAMA:
        FIN {printf("}");
             printf(" //Una vez finalizado el main, finaliza el programa\n");}
        ;

PROGRAMA: 
        lista_sentencias
        ;

DEFINICION:
        definicion_cons 
        | definicion_cons definicion_cons
        ;

definicion_cons:
        nombre_const ASIGNACION_CONS F_INT {printf("\n");}
        ;

lista_sentencias: 
        sentencia fin_sentencia
        | sentencia fin_sentencia lista_sentencias
        | condicional lista_sentencias 
        | condicional
        | ERROR_COMENTARIO {yyerror("comentario sin cerrar");}
        ;

lista_sentencias_bloques: 
        sentencia_bloques fin_sentencia
        | sentencia_bloques fin_sentencia lista_sentencias_bloques
        | condicional lista_sentencias_bloques 
        | condicional
        ;

fin_sentencia:
        FIN_LINEA {printf(";\n");}
        | ERROR_COMENTARIO {yyerror("comentario sin cerrar");}
        ;

sentencia:
        nueva_variable
        | operacion_sobre_variable
        | operacion_sobre_variable_igual
        | imprimir
        | concat
        | leer
        ;

sentencia_bloques:
         operacion_sobre_variable
        | operacion_sobre_variable_igual
        | imprimir
        | concat
        | leer
        ;

operacion_sobre_variable_igual:
        variable_int operador_igual F_INT 
        | variable_int operador_igual variable_int
        | variable_int operador_igual const_var
         ;
                        
variable_int:
        NOMBRE {struct node * aux = find($1);  if(aux == NULL || aux->is_char){yyerror("tipo de argumento invalido");}else{printf("%s",$1);}}
        ;

const_var:
        NOMBRE_CONST {struct node * aux = find($1); if(aux == NULL){yyerror("tipo de argumento invalido");}else{printf("%s",$1);}}
        ;

multiple_operadores:
        operador variable_int
        | operador variable_int multiple_operadores
        | operador F_INT
        | operador F_INT multiple_operadores
        | operador const_var
        | operador const_var multiple_operadores
        ;
                            
operacion_sobre_variable:
        variable_int ASIGNACION variable_int  multiple_operadores
        | variable_int ASIGNACION F_INT  multiple_operadores
        | variable_int ASIGNACION const_var multiple_operadores 
        ;

operador:
        MULTIPLICACION {printf("*");}
        | SUMA {printf("+");}
        | RESTA {printf("-");}   
        | DIVISION {printf("/");}
        | MODULO {printf("%%");}
        ;

operador_igual:
        MAS_IGUAL {printf("+=");}
        | MENOS_IGUAL {printf("-=");}
        | MULTIPLICACION_IGUAL {printf("*=");}
        | DIVISION_IGUAL {printf("/=");}
        | MODULO_IGUAL {printf("%%=");}
        | ASIGNACION_IGUAL {printf("=");}
        ;

nueva_variable:
        tipo_int nombre_int ASIGNACION F_INT
        | tipo_int nombre_int ASIGNACION NOMBRE_CONST {if(find($4)!=NULL)printf("%s",$4);else{yyerror("constante no existe");};}
        | tipo_char nombre_char ASIGNACION F_CHAR
        ;

tipo_int:
        NUM {printf("//Las variables de tipo int se definen de la siguiente manera:\n"); printf("int ");}
        ;

tipo_char:
        LETRAS {printf("//Las variables de tipo string se definen de la siguiente manera:\n"); printf("char *");}
        ;

concat:
        CONCAT_VAR PARENTESIS_ABRE NOMBRE COMA NOMBRE PARENTESIS_CIERRA {
                struct node * first =find($3);
                struct node * second =find($5);

                if(first == NULL || second == NULL || (!first->is_char || !second->is_char)){
                        yyerror("argumento invalido");
                }else{
                        printf("//Para concatenar dos strings:\n");
                        printf("char * aux%d = calloc(sizeof(char), (strlen(%s)+strlen(%s)));\nstrcat(aux%d,%s);\nstrcat(aux%d,%s);\n%s = aux%d",i,first->name_var, second->name_var,i,first->name_var,i, second->name_var,first->name_var,i);
                        i+=1;
                }
        } 
        | CONCAT_VAR PARENTESIS_ABRE NOMBRE COMA TEXTO PARENTESIS_CIERRA {
                struct node * first =find($3);
        
                if(first == NULL || (!first->is_char)){
                        yyerror("argumento invalido");
                }else{
                        char *auxSTR = malloc(sizeof(char)* (strlen($5)+1));
                        strcpy(auxSTR,$5);
                        if(auxSTR == NULL){
                                yyerror("Error al allocar memoria en concat");
                        }
                        printf("//Para concatenar dos strings:\n");
                        printf("char * aux%d = calloc(sizeof(char),(strlen(%s)+strlen(%s)));\nstrcat(aux%d,%s);\nstrcat(aux%d,%s);\n%s = aux%d",i,first->name_var, auxSTR,i,first->name_var,i, auxSTR,first->name_var,i);
                        i+=1;
                        free(auxSTR);
                }
        }  

leer:
        LEER_VAR PARENTESIS_ABRE NOMBRE PARENTESIS_CIERRA{
                struct node * aux=find($3);
        
                if(aux == NULL ){
                        yyerror("la variable no esta definida");
                }
                if(aux->is_char){
                        printf("//Para ingresar datos por consola:\n");
                        printf("char * aux%d = calloc(sizeof(char),%d);\nscanf(\"%%s\",aux%d);\n%s = aux%d",i,MAX_READEABLE_LENGTH,i,aux->name_var,i);
                        i+=1;
                }else{
                        printf("//Para ingresar datos por consola:\n");
                        printf("int aux%d = 0;;\nscanf(\"%%d\",&aux%d);\n%s = aux%d",i,i,aux->name_var,i);
                        i+=1;
                }
        }

imprimir:
        IMPRIMIR_VAR TEXTO { printf("printf(%s)", $2) ; }
        | IMPRIMIR_VAR_LINEA TEXTO {
                char * aux = malloc(sizeof(char)*strlen($2)+10);
                strncpy(aux,$2,strlen($2));
                char * to_concat = "\\n";
                strncpy(aux+strlen($2)-1,to_concat,strlen(to_concat));
                aux[strlen($2)+1]='\0';
                printf("//Para imprimir por consola:\n");
                printf("printf(%s\")", aux);
                free(aux); 
        }
        | IMPRIMIR_VAR PARENTESIS_ABRE TEXTO PARENTESIS_CIERRA { printf("printf(%s)", $3) ; }
        | IMPRIMIR_VAR_LINEA PARENTESIS_ABRE TEXTO PARENTESIS_CIERRA { 
                char * aux = malloc(sizeof(char)*strlen($3)+10);
                strncpy(aux,$3,strlen($3));
                char * to_concat = "\\n";
                strncpy(aux+strlen($3)-1,to_concat,strlen(to_concat));
                aux[strlen($3)+1]='\0';
                printf("//Para imprimir por consola:\n");
                printf("printf(%s\")", aux);
                free(aux); 
        }
        | IMPRIMIR_VAR NOMBRE {
                struct node * node = find($2);
                if(node == NULL){
                        yyerror("variable invalida");
                }else{
                   if(node->is_char){
                        printf("//Para imprimir por consola:\n");
                        printf("printf(\"%%s\", %s)", (char *)node->name_var);
                    }
                    else{
                        printf("//Para imprimir por consola:\n");
                        printf("printf(\"%%d\", %s)", (char *)node->name_var);
                        } 
                }
        }
        | IMPRIMIR_VAR PARENTESIS_ABRE NOMBRE PARENTESIS_CIERRA {
                struct node * node = find($3);
                if(node == NULL){
                        yyerror("variable invalida");
                }else{
                   if(node->is_char){
                        printf("//Para imprimir por consola:\n");
                        printf("printf(\"%%s\", %s)", (char *)node->name_var);
                    }
                    else{
                        printf("//Para imprimir por consola:\n");
                        printf("printf(\"%%d\", %s)", (char *)node->name_var);
                        } 
                }
        }
        | IMPRIMIR_VAR_LINEA NOMBRE {
                struct node * node = find($2);
                if(node == NULL){
                        yyerror("variable invalida");
                }else{
                   if(node->is_char){
                        printf("//Para imprimir por consola:\n");
                        printf("printf(\"%%s \\n\", %s)", (char *)node->name_var);
                    }
                    else{
                        printf("//Para imprimir por consola:\n");
                        printf("printf(\"%%d \\n\", %s)", (char *)node->name_var);
                        } 
                }
        }
        | IMPRIMIR_VAR_LINEA PARENTESIS_ABRE NOMBRE PARENTESIS_CIERRA {
                struct node * node = find($3);
                if(node == NULL){
                        yyerror("variable invalida");
                }else{
                   if(node->is_char){
                        printf("//Para imprimir por consola:\n");
                        printf("printf(\"%%s \\n\", %s)", (char *)node->name_var);
                    }
                    else{
                        printf("//Para imprimir por consola:\n");
                        printf("printf(\"%%d \\n\", %s)", (char *)node->name_var);
                        } 
                }
        }
        | error {yyerror("en compilacion");}
        ;

ASIGNACION:
        ASIGN_VAR {printf("=");}
        ;

ASIGNACION_CONS:
        ASIGN_VAR {printf(" ");}
        ;
        
F_INT:
        INTEGER {printf("%d",$1);}
        ;

F_CHAR:
        TEXTO {printf("%s",$1);}
        ;

nombre_int:
        NOMBRE { if(find($1) == NULL){insertFirst($1,0); printf("%s",$1);} else{yyerror("variable duplicada");}}
        ;

nombre_char:
        NOMBRE {if(find($1) == NULL){insertFirst($1,1); printf("%s",$1);} else{yyerror("variable duplicada");}}
        ;

nombre_const:
        NOMBRE_CONST {if(find($1) == NULL){
                                insertFirst($1,0); printf("//Las constantes se definen de la siguiente manera:\n"); printf("#define %s ",$1);
                        } else{
                                yyerror("variable duplicada");
                        }}
        ;

condicional:
        estructura_if 
        | estructura_if estructura_else
        | estructura_while 
        ;

estructura_if:
        definicion_if condicion inicio_condicional lista_sentencias_bloques fin_condicional
        | definicion_if PARENTESIS_ABRE condicion PARENTESIS_CIERRA inicio_condicional lista_sentencias_bloques fin_condicional
        ;

estructura_while:
        definicion_while condicion inicio_condicional lista_sentencias_bloques fin_condicional 
        | definicion_while PARENTESIS_ABRE condicion PARENTESIS_CIERRA inicio_condicional lista_sentencias_bloques fin_condicional
        ;


estructura_else:
        definicion_else lista_sentencias fin_condicional 
        ;

definicion_if:
        IF_VAR {printf("//Las condiciones del tipo if se definen de la siguiente manera:\n");printf("if(");}
        ;

definicion_while:
        WHILE_VAR {printf("//Los ciclos while se definen de la siguiente manera:\n");printf("while(");}
        ;

definicion_else:
        ELSE_VAR {printf("else{\n");}
        ;

inicio_condicional:
        INICIO_CONDICIONAL {printf("){\n");}
        ;

fin_condicional:
        FIN_CONDICIONAL {printf("}\n");}
        ;

condicion:
        F_INT
        | condicion_logica or condicion
        | condicion_logica and condicion
        | condicion_logica
        ;
  
or:
        OR {printf(" || ");}
        ;

and:
        AND {printf(" && ");}
        ;

comparador:
        IGUAL {printf("==");}
        | MENOR {printf("<");}
        | MAYOR {printf(">");}   
        | MENOR_IGUAL {printf("<=");}
        | MAYOR_IGUAL {printf(">=");}
        | DISTINTO {printf("!=");}
        ;

condicion_logica:
        variable_int comparador variable_int
        | F_INT comparador F_INT
        | variable_int comparador F_INT
        | F_INT comparador variable_int
        ;      
%%


int main(){
        yyparse();
        return 0;
}

static void yyerror(char* s){
        if (!strcmp("syntax error", s)){
                s= "error de sintaxis";
        }
        fprintf(stderr, "---------------------ERROR---------------------\n");
        fprintf(stderr, "Error: %s en linea %d\n", s, yylineno);
        fprintf(stderr, "-----------------------------------------------\n");
        exit(-1);
}