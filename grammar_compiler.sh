#!/bin/bash

# 1. .out compilado despues de YACC y LEX (parser)
# 2. archivo en nuestro lenguaje pasado como parametro
# 3. archivo salida en C tras su transofrmacion

# 1.      2.        3.
 ./main2 < $1 > aux.c 

# 4. nombre de ejecutable final pasado como parametro

#             4.
gcc aux.c -o $2

#rm aux.c