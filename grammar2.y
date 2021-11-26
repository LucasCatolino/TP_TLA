/*
// PROGRAMA → lista_sentencias
// lista_sentencias → sentencia | lista_sentencias sentencia
// sentencia → asignacion | WHILE | IF_ELSE | SWITCH_CASE 
// asignacion → TIPO_INT NOMBRE = INTEGER; | TIPO_CHAR NOMBRE = CHAR | NOMBRE = CHAR | NOMBRE = INTEGER;
// WHILE → while ( Condicion ) sentencia | while (condicion ) { lista_sentencias }
// IF_ELSE → IF else sentencia | IF else {lista_sentencias } 
// IF → if (condicion) sentencia | if (condicion) {lista_sentencias}
// SWITCH_CASE → switch ( i ) { lista_CASE } | switch ( i ) { lista_CASE DEFAULT}
// lista_CASE → CASE | lista_CASE CASE
// CASE → case c: sentencia | case c: {lista_sentencias}
// DEFAULT → default: sentencia | default: {lista_sentencias}
// condicion → condicion_logica | condicion_AND | condicion_OR
// condicion_AND → condicion_logica && condicion_logica 
// condicion_OR → condicion_logica | | condicion_logica 
// condicion_logica → E > E | E < E | E >= E | E <= E | E == E | E != E
// E → E + T | E - T | T 
// T → T * F | T / F | F 
// F → i | c
*/

%{
#include <stdio.h>
static void yyerror(char *s);
int yylex();
int intval;
extern char *yytext;
extern int *yylineno;
%}


%union{
    char texto[256];
    int numero;
}

%token INICIO FIN NUM ASIGN_VAR FIN_LINEA INICIO_CONDICIONAL FIN_CONDICIONAL IF_VAR ELSE_VAR IGUAL MENOR MAYOR MAYOR_IGUAL MENOR_IGUAL OR AND WHILE_VAR IMPRIMIR MULTIPLICACION SUMA RESTA DIVISION MODULO MAS_IGUAL MENOS_IGUAL MULTIPLICACION_IGUAL DIVISION_IGUAL MODULO_IGUAL IMPRIMIR_VAR LETRAS

%token <texto> NOMBRE
%token <texto> TEXTO
%token <numero> INTEGER

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
    ;

//INICIO_PROGRAMA → INICIO
INICIO_PROGRAMA:
                INICIO {printf("#include <stdio.h> \n int main(){ ");}
                ;

//FIN_PROGRAMA → FIN
FIN_PROGRAMA:
                FIN {printf("}\n");}
                ;

// PROGRAMA → lista_sentencias
PROGRAMA: 
        lista_sentencias
        ;

// lista_sentencias → sentencia fin_sentencia | sentencia fin_sentencia lista_sentencias | condicional lista_sentencias | condicional
lista_sentencias: 
                sentencia fin_sentencia
                |sentencia fin_sentencia lista_sentencias
                |condicional lista_sentencias 
                |condicional
                ;

// fin_sentencia → FIN_LINEA
fin_sentencia: FIN_LINEA {printf(";");}
                ;

// sentencia → nueva_variable | operacion_sobre_variable //| WHILE | IF_ELSE | SWITCH_CASE
sentencia:
           nueva_variable
           |operacion_sobre_variable
           |operacion_sobre_variable_igual
           |imprimir
        ;

operacion_sobre_variable_igual: variable operador_igual variable

multiple_operadores: operador variable
                    | operador variable multiple_operadores
                    ;
                            
operacion_sobre_variable: // Puede haber un tema con la paridad en los parametros
                        variable ASIGNACION variable  multiple_operadores
                        ;

operador:
        MULTIPLICACION {printf("*");}
        |SUMA {printf("+");}
        |RESTA {printf("-");}   
        |DIVISION {printf("/");}
        |MODULO {printf("%%");}
        ;

operador_igual:
        |MAS_IGUAL {printf("+=");}
        |MENOS_IGUAL {printf("-=");}
        |MULTIPLICACION_IGUAL {printf("*=");}
        |DIVISION_IGUAL {printf("/=");}
        |MODULO_IGUAL {printf("%%=");}
        ;

nueva_variable:
            tipo_int nombre_int ASIGNACION F_INT
            |tipo_char nombre_char ASIGNACION F_CHAR
            ;

tipo_int: NUM {printf("int ");}
         ;

tipo_char: LETRAS {printf("char *");}
         ;

imprimir :
        IMPRIMIR_VAR TEXTO { printf("printf(%s)", $2) ; }
        | IMPRIMIR_VAR '(' TEXTO ')' { printf("printf(%s)", $3) ; }
        | error  {yyerror("ERROR EN COMPILACION");}
        ;

// asignacion --> TIPO_INT NOMBRE = INTEGER; | TIPO_CHAR NOMBRE = CHAR | NOMBRE = CHAR | NOMBRE = INTEGER;
ASIGNACION:
            ASIGN_VAR {printf("=");}
            ;
        
F_INT: INTEGER {printf("%d",$1);}
            ;

F_CHAR: TEXTO {printf("%s",$1);}
            ;

nombre_int: NOMBRE {printf("%s",$1);}
            ;

nombre_char: NOMBRE {printf("%s",$1);}
            ;
condicional:
        estructura_if 
        | estructura_if estructura_else
        | estructura_while 
        // | SWITCH_CASE
        ;

estructura_if:
            definicion_if condicion inicio_condicional lista_sentencias fin_condicional
            | definicion_if '(' condicion ')' inicio_condicional lista_sentencias fin_condicional
            ;

estructura_while:
            definicion_while condicion inicio_condicional lista_sentencias fin_condicional 
            | definicion_while '(' condicion ')' inicio_condicional lista_sentencias fin_condicional
            ;


estructura_else:
            definicion_else lista_sentencias fin_condicional 
            ;

definicion_if: IF_VAR {printf("if(");}
            ;

definicion_while: WHILE_VAR {printf("while(");}
            ;

definicion_else: ELSE_VAR {printf("else{");}
        ;

inicio_condicional: INICIO_CONDICIONAL {printf("){");}
            ;

fin_condicional: FIN_CONDICIONAL {printf("}");}
        ;


// condicion → condicion_logica | condicion_AND | condicion_OR
condicion:
        F_INT
        |condicion_logica or condicion_logica
        |condicion_logica and condicion_logica
        |condicion_logica
        ;
        
or : OR {printf(" || ");}
    ;

and: AND {printf(" && ");}
    ;

variable:
            NOMBRE  {printf("%s",$1);}
            |F_INT
            // | nombre_char
            ;

comparador:
            IGUAL {printf("==");}
            |MENOR {printf("<");}
            |MAYOR {printf(">");}   
            |MENOR_IGUAL {printf("<=");}
            |MAYOR_IGUAL {printf(">=");}
            ;

condicion_logica:
                variable comparador variable
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


// // E → E + T | E - T | T
// E:
//     E '+' T
//     | E '-' T
//     | T
//     ;

// // T → T * F | T / F | F
// T:
//     T '*' F
//     | T '/' F
//     | F
//     ;

// // F → i | c
// F:
//     INTEGER {$$ = intval;}
//     | CHAR
//     ;
%%


int main(){

  yyparse();
  return 0;
}


static void yyerror(char* s){
    {
        if (yytext[0] == '\n'){
            yytext[0] = '\\';
        }
        printf("Error: %s en linea %d, simbolo %c\n", s, *yylineno, yytext[0]);
    }
}
