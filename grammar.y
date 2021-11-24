/* Gramatica: {Vt, Vn, P, S}
 * Vt = {INTEGER, NEWLINE, BOOLEAN +, -, *, /, (, ), >, <}
 * Vn = {line, term, expr}
 * P = {
 *      line -> epsilon
 *      line -> term
 *      term -> newline
 *      term -> expr newline
 *      expr -> intnumer
 *      expr -> expr + expr
 *      expr -> expr - expr
 *      expr -> expr * expr
 *      expr -> expr / expr
 *      expr -> (expr)
 *      expr -> -expr
 *      bool -> expr > expr
 *      bool -> expr < expr
 *     }
 * S = line
 */

%{
#include <stdio.h>
#include <stdbool.h>
#include "parser.h"
int intval;
bool boolval;
//char[] stringval;
int yylex();
extern char *yytext;
extern int *yylineno;
%}

%token INTEGER NEWLINE BOOLEAN IF THEN EOB PRINT STRING

%left '+' '-'
%left '*' '/'
%left '>' '<'
%left '='
%left EQ GE LE
%nonassoc UMINUS

%start line   /* simbolo sentencial */

%%
line:
    | line term
    ;

term: NEWLINE
    | expr ';' NEWLINE  {printf("%d\n", $1);}
    | error NEWLINE  {yyerror;}
    ;

expr: INTEGER {$$ = intval;}
    | expr '+' expr  {$$ = $1 + $3;}
    | expr '-' expr  {$$ = $1 - $3;}
    | expr '*' expr  {$$ = $1 * $3;}
    | expr '/' expr  {if($3) $$ = $1 / $3; 
                        else {
                            yyerror("division por cero");
                        }
                     }
    | '(' expr ')' {$$ = $2;}
    | '-' expr %prec UMINUS {$$ = - $2;}
    ;

expr: BOOLEAN {$$ = boolval;}
    | expr '>' expr  {$$ = $1 > $3;}
    | expr GE expr  {$$ = $1 >= $3;}
    | expr '<' expr  {$$ = $1 < $3;}
    | expr LE expr  {$$ = $1 <= $3;}
    | expr EQ expr  {$$ = $1 == $3;}
    ;

expr: IF '(' expr ')' THEN '{' line EOB //{if($1) $$ = $3;}
    ;

//expr: PRINT '(' '\"' sentence '\"' ')' {printf("%s"), stringval;}
//    ;

//sentence: STRING {$$ = stringval}
//    ;


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