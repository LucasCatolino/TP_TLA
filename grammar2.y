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

%token INICIO FIN NUM ASIGN_VAR FIN_LINEA INICIO_IF FIN_IF IF_VAR 
%token <texto> NOMBRE;
%token <numero> INTEGER;

%type<numero> F_INT;



%left '+' '-'
%left '*' '/'
%left '>' '<'
%left '='
%left EQ GE LE NOTEQ
%nonassoc UMINUS

%start S /* simbolo sentencial */

%%

// S -> INICIO_PROGRAMA PROGRAMA FIN_PROGRAMA
S:
    INICIO_PROGRAMA PROGRAMA FIN_PROGRAMA
    ;

//INICIO_PROGRAMA -> 
INICIO_PROGRAMA:
                INICIO {printf("int main(){ ");}
                ;

FIN_PROGRAMA:
                FIN {printf("}");}
                ;

// // PROGRAMA → lista_sentencias
PROGRAMA: 
        lista_sentencias
        ;

// // lista_sentencias → sentencia | lista_sentencias sentencia
lista_sentencias: 
                sentencia fin_sentencia
                |sentencia fin_sentencia lista_sentencias
                | condicional
                // |condicional lista_sentencias
                ;
    
fin_sentencia: FIN_LINEA {printf(";");}
                ;

// // sentencia → E; | WHILE | IF_ELSE | SWITCH_CASE
 sentencia:
           nueva_variable
            // |condicional
//         E ';' 
//         | ASIGNACION
        ;

nueva_variable:
            tipo_int nombre_int ASIGNACION F_INT
            // | tipo_char nombre_char ASIGNACION CHAR
            ;

tipo_int: NUM {printf("int ");}


// asignacion --> TIPO_INT NOMBRE = INTEGER; | TIPO_CHAR NOMBRE = CHAR | NOMBRE = CHAR | NOMBRE = INTEGER;
ASIGNACION:
            ASIGN_VAR {printf("=");}
            ;
        
F_INT: INTEGER {$$ = intval; printf("%d",$1);}
            ;

nombre_int: NOMBRE {printf("%s",$1);}
            ;

condicional:
        estructura_if 
        // | WHILE 
        // | SWITCH_CASE
        ;

estructura_if:
            definicion_if condicion comienzo_if lista_sentencias fin_if 
            // | if '(' condicion ')' '{' lista_sentencias '}'
    ;

definicion_if: IF_VAR {printf("if(");}
            ;

comienzo_if: INICIO_IF {printf("){\n");}
            ;


fin_if: FIN_IF {printf("}");}
        ;

// condicion → condicion_logica | condicion_AND | condicion_OR
condicion:
        F_INT
        //condicion_logica
        //| condicion_AND
        //| condicion_OR
        ;

// // WHILE → while ( condicion ) sentencia | while (condicion ) { lista_sentencias }
// WHILE:
//     while '(' condicion ')' sentencia 
//     | while '(' condicion ')' '{' lista_sentencias '}'
//     ;

// // IF → if (condicion) sentencia | if (condicion) {lista_sentencias}


// // IF_ELSE → IF else sentencia | IF else {lista_sentencias }
// IF_ELSE:
//         IF else sentencia
//         | IF else '{'lista_sentencias'}'
//         ;

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


// // condicion_AND → condicion_logica && condicion_logica
// condicion_AND:
//             condicion_logica '&' '&' condicion_logica
//             ;

// // condicion_OR → condicion_logica | | condicion_logica
// condicion_OR:
//             condicion_logica '|' '|' condicion_logica
//             ;

// // condicion_logica → E > E | E < E | E >= E | E <= E | E == E | E != E
// condicion_logica:
//                 E '>' E 
//                 | E '<' E 
//                 | E GE E 
//                 | E LE E 
//                 | E '=''=' E 
//                 | E '!''=' E
//                 ;

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
        printf("Error: %s en linea %d, simbolo %c\n", s, yylineno, yytext[0]);
    }
}
