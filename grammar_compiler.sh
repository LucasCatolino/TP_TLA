#!/bin/bash

# 1. archivo en nuestro lenguaje pasado como parametro
# 2. .out compilado despues de YACC y LEX (parser)
# 3. archivo salida en C tras su transofrmacion

# 1.      2.        3.
$1 > ./main.out > aux.c 

# 4. nombre de ejecutable final pasado como parametro

#               4.
gcc -w aux.c -o $2

rm aux.c