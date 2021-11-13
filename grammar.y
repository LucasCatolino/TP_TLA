/* Gramatica: {Vt, Vn, P, S}
 * Vt = {INTEGER, NEWLINE, +, -, *, /, (, )}
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
 *     }
 * S = line
 */

%{
#include <stdio.h>
#include "parser.h"
int intval;
int yylex();
extern char *yytext;
%}

%token INTEGER NEWLINE

%left '+' '-'
%left '*' '/'
%nonassoc UMINUS

%start line   /* simbolo sentencial */

%%
line:
    | line term
    ;

term: NEWLINE
    | expr NEWLINE   {printf("%d\n", $1);}
    | error NEWLINE  {yyerror;}
    ;

expr: INTEGER {$$ = intval;}
     | expr '+' expr  {$$ = $1 + $3;}
     | expr '-' expr  {$$ = $1 - $3;}
     | expr '*' expr  {$$ = $1 * $3;}
     | expr '/' expr  {if($3) $$ = $1 / $3; 
                       else {
                             printf("Divide by zero");
                             yyerror;
                            }
                      }
     | '(' expr ')' {$$ = $2;}
     | '-' expr %prec UMINUS {$$ = - $2;}
     ;

%%

int main(){

  yyparse();
  return 0;
}

static void yyerror(char* s){
    {
    printf("Oops: %s at symbol %c\n", s, yytext[0]);
    }
}