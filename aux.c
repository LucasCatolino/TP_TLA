#define const_numero 4#define const_numero2 2asd#include <stdio.h> 
 #include <stdlib.h> 
 #include "list.h" 
 #include "stdio.h" 
 #include "string.h" 
 int main(){ int var_paulo=-100;int var_londro=3;int var_mientras=1;char *var_p="hila";var_londro=2+2;var_londro+=3;var_londro=var_paulo;var_londro=var_paulo+var_londro;if(var_paulo<2){var_londro+=1;printf("estoy adentro del if\n");}while(var_mientras<5){printf("adentro del mientras\n");var_mientras+=1;}char *var_txt="hola";char *var_txt2=" rey";printf("hola\n\n");printf("%d", var_londro);printf("%s \n", var_txt);printf("CONCANT");char *var_vacia="a";char * aux0 = calloc(sizeof(char),(strlen(var_vacia)+strlen("hola")));strcat(aux0,var_vacia);strcat(aux0,"hola");var_vacia = aux0;printf("%s \n", var_vacia);char * aux1 = calloc(sizeof(char),(strlen(var_txt)+strlen(var_txt2)));strcat(aux1,var_txt);strcat(aux1,var_txt2); var_txt = aux1;char * aux2 = calloc(sizeof(char),(strlen(var_txt)+strlen(var_txt2)));strcat(aux2,var_txt);strcat(aux2,var_txt2); var_txt = aux2;char * aux3 = calloc(sizeof(char),(strlen(var_txt)+strlen("chiao")));strcat(aux3,var_txt);strcat(aux3,"chiao");var_txt = aux3;printf("%s \n", var_txt);}
