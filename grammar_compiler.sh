#!/bin/bash

# 1. .out compilado despues de YACC y LEX (parser)
# 2. archivo en nuestro lenguaje pasado como parametro
# 3. archivo salida en C tras su transofrmacion

# 1.      2.                3.
 ./main < $1 > tu_codigo_en.c 

# 4. nombre de ejecutable final pasado como parametro


if [ $? -ne 255 ] 
then

    #                      4.
    gcc tu_codigo_en.c -o $2

else
    echo "Aviso: falta corregir errores para compilar sin problemas"
fi