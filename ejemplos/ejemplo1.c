//Las constantes se definen de la siguiente manera:
#define const_segundos_en_min  60
//Las librerias a usar se incluyen en esta seccion de la siguiente manera:
#include <stdio.h> 
#include <stdlib.h> 
#include "list.h" 
#include "stdio.h" 
#include "string.h" 

//El main es lo que se va a ejecutar, y se define de la siguiente manera:
int main(){ 
//Las variables de tipo int se definen de la siguiente manera:
int var_segundos=0;
//Para imprimir por consola:
printf("Ingrese una cantidad de segundos y te dire cuantos minutos son.\n");
//Para ingresar datos por consola:
int aux0 = 0;;
scanf("%d",&aux0);
var_segundos = aux0;
//Los ciclos while se definen de la siguiente manera:
while(var_segundos<0){
//Para imprimir por consola:
printf("Ingrese una cantidad de segundos mayor que 0 y te dire cuantos minutos son.\n");
//Para ingresar datos por consola:
int aux1 = 0;;
scanf("%d",&aux1);
var_segundos = aux1;
}
//Las variables de tipo int se definen de la siguiente manera:
int var_minutos=0;
var_minutos=var_segundos/const_segundos_en_min;
printf("La cantidad de minutos son: ");
//Para imprimir por consola:
printf("%d \n", var_minutos);
} //Una vez finalizado el main, finaliza el programa
