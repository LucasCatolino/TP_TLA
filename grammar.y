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
        bool -> expr > expr
        bool -> expr < expr
 *     }
 * S = line
 */

%{
#include <stdio.h>
#include <stdbool.h>
#include "parser.h"
int intval;
bool boolval;
int yylex();
extern char *yytext;
extern int *yylineno;
%}

%token INTEGER NEWLINE BOOLEAN

%left '+' '-'
%left '*' '/'
%left '>' '<'
%left '='
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
                             printf("Error: divide by zero in line %d\n", yylineno);
                             yyerror;
                            }
                      }
     | '(' expr ')' {$$ = $2;}
     | '-' expr %prec UMINUS {$$ = - $2;}
     ;

expr: BOOLEAN {$$ = boolval;}
    | expr '>' expr  {$$ = $1 > $3;}
    | expr '<' expr  {$$ = $1 < $3;}
    | expr '=' expr  {$$ = $1 == $3;}
    ;


%%

int main(){

  yyparse();
  return 0;
}

static void yyerror(char* s){
    {
    printf("Error: %s in line %d at symbol %c\n", s, yylineno, yytext[0]);
    }
}