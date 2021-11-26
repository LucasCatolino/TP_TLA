%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "list.h"
static void yyerror(char *s);
int yylex();
extern char *yytext;
extern int yylineno;
int i = 0;
int intval; //TODO: ver si sigue andando todo sin esta linea adentro del %{ %}
%}

%union{
    char texto[256];
    int numero;
}

%token INICIO DEF FIN NUM ASIGN_VAR FIN_LINEA INICIO_CONDICIONAL FIN_CONDICIONAL IF_VAR ELSE_VAR
%token IGUAL MENOR MAYOR MAYOR_IGUAL MENOR_IGUAL OR AND WHILE_VAR IMPRIMIR IMPRIMIR_VAR_LINEA MULTIPLICACION
%token SUMA RESTA DIVISION MODULO MAS_IGUAL MENOS_IGUAL MULTIPLICACION_IGUAL DIVISION_IGUAL MODULO_IGUAL
%token IMPRIMIR_VAR IMPRIMIR_VAR_LN LETRAS ASIGNACION_IGUAL CONCAT_VAR COMA PARENTESIS_ABRE PARENTESIS_CIERRA

%token <texto> NOMBRE
%token <texto> TEXTO
%token <numero> INTEGER
%token <texto> NOMBRE_CONST

%left SUMA RESTA DIVISION MODULO MAS_IGUAL MENOS_IGUAL MULTPLICACION_IGUAL DIVISION_IGUAL

%type<numero> F_INT
%type<texto> F_CHAR


/*
%left '+' '-'
%left '*' '/'
%left '>' '<'
%left '='
%left EQ GE LE NOTEQ
%nonassoc UMINUS
*/
%start S /* simbolo sentencial */

%%

// S → INICIO_PROGRAMA PROGRAMA FIN_PROGRAMA
S:
        INICIO_PROGRAMA PROGRAMA FIN_PROGRAMA
        | DEF DEFINICION INICIO_PROGRAMA PROGRAMA FIN_PROGRAMA
        ;

//INICIO_PROGRAMA → INICIO
INICIO_PROGRAMA:
        INICIO {printf("#include <stdio.h> \n #include <stdlib.h> \n #include \"list.h\" \n #include \"stdio.h\" \n #include \"string.h\" \n int main(){ ");}
        ;

//FIN_PROGRAMA → FIN
FIN_PROGRAMA:
        FIN {printf("}\n");}
        ;

// PROGRAMA → lista_sentencias
PROGRAMA: 
        lista_sentencias
        ;

DEFINICION:
        definicion_cons 
        | definicion_cons definicion_cons
        ;

definicion_cons:
        nombre_const ASIGNACION_CONS F_INT
        ;

// lista_sentencias → sentencia fin_sentencia | sentencia fin_sentencia lista_sentencias | condicional lista_sentencias | condicional
lista_sentencias: 
        sentencia fin_sentencia
        | sentencia fin_sentencia lista_sentencias
        | condicional lista_sentencias 
        | condicional
        ;

lista_sentencias_bloques: 
        sentencia_bloques fin_sentencia
        | sentencia_bloques fin_sentencia lista_sentencias_bloques
        | condicional lista_sentencias_bloques 
        | condicional
        ;

// fin_sentencia → FIN_LINEA
fin_sentencia:
        FIN_LINEA {printf(";");}
        ;

// sentencia → nueva_variable | operacion_sobre_variable //| WHILE | IF_ELSE | SWITCH_CASE
sentencia:
        nueva_variable
        | operacion_sobre_variable
        | operacion_sobre_variable_igual
        | imprimir
        | concat
        ;

sentencia_bloques:
         operacion_sobre_variable
        | operacion_sobre_variable_igual
        | imprimir
        | concat
        ;

operacion_sobre_variable_igual:
        variable_int operador_igual F_INT 
        |variable_int operador_igual variable_int
         ;
                        
variable_int: NOMBRE {struct node * aux = find($1); if(aux == NULL || aux->is_char){yyerror("Tipo de argumento invalido");}else{printf("%s",$1);}}
                ;

multiple_operadores:
        operador variable_int
        | operador variable_int multiple_operadores
        | operador F_INT
        | operador F_INT multiple_operadores
        ;
                            
operacion_sobre_variable: // Puede haber un tema con la paridad en los parametros
        variable_int ASIGNACION variable_int  multiple_operadores
        |variable_int ASIGNACION F_INT  multiple_operadores
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
        | tipo_char nombre_char ASIGNACION F_CHAR
        ;

// cons: CONSTANTE {printf("#define ");}

tipo_int:
        NUM {printf("int ");}
        ;

tipo_char:
        LETRAS {printf("char *");}
        ;

concat:
        CONCAT_VAR PARENTESIS_ABRE NOMBRE COMA NOMBRE PARENTESIS_CIERRA {
                struct node * first =find($3);
                struct node * second =find($5);

                if(first == NULL || second == NULL || (!first->is_char || !second->is_char)){
                        yyerror("Argumento invalido");
                }else{
                        printf("char * aux%d = calloc(sizeof(char),(strlen(%s)+strlen(%s)));strcat(aux%d,%s);strcat(aux%d,%s); %s = aux%d",i,first->name_var, second->name_var,i,first->name_var,i, second->name_var,first->name_var,i);
                        i+=1;
                }
        } 
        |CONCAT_VAR PARENTESIS_ABRE NOMBRE COMA TEXTO PARENTESIS_CIERRA {
                struct node * first =find($3);
        

                if(first == NULL || (!first->is_char)){
                        yyerror("Argumento invalido");
                }else{
                        char *auxSTR = malloc(sizeof(char)* (strlen($5)+1));
                        strcpy(auxSTR,$5);
                        if(auxSTR == NULL){
                        printf("ERROR MALLOC");
                        }
                        printf("char * aux%d = calloc(sizeof(char),(strlen(%s)+strlen(%s)));strcat(aux%d,%s);strcat(aux%d,%s);%s = aux%d",i,first->name_var, auxSTR,i,first->name_var,i, auxSTR,first->name_var,i);
                        i+=1;
                        free(auxSTR);
                }
               
        }  

// reverse:
//         REVERSE_VAR '(' NOMBRE ')' {
//             struct node * var =find($3);
            
//             if( var != NULL && var->is_char ){

//                 int i, j, count = 0;
//                 while (str[count] != '\0')
//                 {
//                     count++;
//                 }
//                 j = count - 1;

//                 //reversing the string by swapping
//                 for (i = 0; i < count; i++)
//                 {
//                     rev[i] = str[j];
//                     j--;
//                 }

//                 printf("\nString After Reverse: %s", rev);



//                 printf("printf(\"%%s\",%s)",strrev(var->name_var));
//             }else{
//                 yyerror("Argumento invalido en funcion \"reverse\"");
//             }
//         }

imprimir:
        IMPRIMIR_VAR TEXTO { printf("printf(%s)", $2) ; }
        |IMPRIMIR_VAR_LINEA TEXTO {
                char * aux = malloc(sizeof(char)*strlen($2)+10);
                strncpy(aux,$2,strlen($2));
                char * to_concat = "\\n";
                strncpy(aux+strlen($2)-1,to_concat,strlen(to_concat));
                aux[strlen($2)+1]='\0';
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
            printf("printf(%s\")", aux);
            free(aux); 
            }
        | IMPRIMIR_VAR NOMBRE {
                struct node * node = find($2);
                if(node == NULL){
                        yyerror("Error, variable invalida");
                }else{
                   if(node->is_char){
                         printf("printf(\"%%s\", %s)", (char *)node->name_var);
                    }
                    else{
                         printf("printf(\"%%d\", %s)", (char *)node->name_var);
                        } 
                }
        }
        | IMPRIMIR_VAR PARENTESIS_ABRE NOMBRE PARENTESIS_CIERRA {
                struct node * node = find($3);
                if(node == NULL){
                        yyerror("Error, variable invalida");
                }else{
                   if(node->is_char){
                         printf("printf(\"%%s\", %s)", (char *)node->name_var);
                    }
                    else{
                         printf("printf(\"%%d\", %s)", (char *)node->name_var);
                        } 
                }
        }
        | IMPRIMIR_VAR_LINEA NOMBRE {
                struct node * node = find($2);
                if(node == NULL){
                        yyerror("Error, variable invalida");
                }else{
                   if(node->is_char){
                         printf("printf(\"%%s \\n\", %s)", (char *)node->name_var);
                    }
                    else{
                         printf("printf(\"%%d \\n\", %s)", (char *)node->name_var);
                        } 
                }
        }
        | IMPRIMIR_VAR_LINEA PARENTESIS_ABRE NOMBRE PARENTESIS_CIERRA {
                struct node * node = find($3);
                if(node == NULL){
                        yyerror("Error, variable invalida");
                }else{
                   if(node->is_char){
                         printf("printf(\"%%s \\n\", %s)", (char *)node->name_var);
                    }
                    else{
                         printf("printf(\"%%d \\n\", %s)", (char *)node->name_var);
                        } 
                }
        }
        // | IMPRIMIR_VAR PARENTESIS_ABRE NOMBRE PARENTESIS_CIERRA {printf("printf(%s)", $3) ;}
        | error  {yyerror("en compilacion");}
        ;

// asignacion --> TIPO_INT NOMBRE = INTEGER; | TIPO_CHAR NOMBRE = CHAR | NOMBRE = CHAR | NOMBRE = INTEGER;
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
        NOMBRE { if(find($1) == NULL){insertFirst($1,0); printf("%s",$1);} else{yyerror("duplicated");}}
        ;

nombre_char:
        NOMBRE {if(find($1) == NULL){insertFirst($1,1); printf("%s",$1);} else{yyerror("duplicated");}}
        ;

nombre_const:
        NOMBRE_CONST {if(find($1) == NULL){
                                insertFirst($1,0); printf("#define %s",$1);
                        } else{
                                yyerror("duplicated");
                        }}
        ;

condicional:
        estructura_if 
        | estructura_if estructura_else
        | estructura_while 
        // | SWITCH_CASE
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
        IF_VAR {printf("if(");}
        ;

definicion_while:
        WHILE_VAR {printf("while(");}
        ;

definicion_else:
        ELSE_VAR {printf("else{");}
        ;

inicio_condicional:
        INICIO_CONDICIONAL {printf("){");}
        ;

fin_condicional:
        FIN_CONDICIONAL {printf("}");}
        ;


// condicion → condicion_logica | condicion_AND | condicion_OR
condicion:
        F_INT
        | condicion_logica or condicion_logica
        | condicion_logica and condicion_logica
        | condicion_logica
        ;
        
or:
        OR {printf(" || ");}
        ;

and:
        AND {printf(" && ");}
        ;

// variable: UNUSED TYPE
//         NOMBRE  {if(find($1)!=NULL){printf("%s",$1);} else {yyerror("variable not found");}}
//         //| F_INT
//         //| F_CHAR
        ;

comparador:
        IGUAL {printf("==");}
        | MENOR {printf("<");}
        | MAYOR {printf(">");}   
        | MENOR_IGUAL {printf("<=");}
        | MAYOR_IGUAL {printf(">=");}
        ;

condicion_logica:
        variable_int comparador variable_int
        | F_INT comparador F_INT
        | variable_int comparador F_INT
        | F_INT comparador variable_int
        ;
                   

// // lista_CASE → CASE | lista_CASE CASE
// lista_CASE:
//            CASE 
//            | lista_CASE CASE
//            ;

// // SWITCH_CASE → switch ( i ) { lista_CASE } | switch ( i ) { lista_CASE DEFAULT}
// SWITCH_CASE:
//             switch '(' i ')' '{' lista_CASE '}' 
//             | switch '(' i ')' '{' lista_CASE DEFAULT'}'
//             ;

// // CASE → case c: sentencia | case c: {lista_sentencias}
// CASE:
//     case c ':' sentencia
//     | case c ':' '{' lista_sentencias '}'
//     ;

// // DEFAULT → default: sentencia | default: {lista_sentencias}
// DEFAULT:
//         default ':' sentencia 
//         | default ':' '{' lista_sentencias '}'
//         ;

//     INTEGER {$$ = intval;}
//     | CHAR
//     ;
%%


int main(){
  yyparse();
  return 0;
}


static void yyerror(char* s){

        fprintf(stderr, "---------------------ERROR---------------------\n");
        fprintf(stderr, "Error: %s\n", s);
        fprintf(stderr, "Error: %s en linea %d\n", s, yylineno);
        //fprintf(stderr, "Error: %s en linea %d, simbolo %c\n", s, yylineno, yytext[0]);
        exit(-1);
}
