# TP TLA

- YACC
```sh
make 1
```
- LEX
```sh
make 2
```
- Crear el main
```sh
make 3
```
- Para compilar todo junto
```sh
make all
```
- Para probar
```sh
./main < ejemplo
```
- Para compilar y generar un ejecutable de un programa en este lenguaje

| Parametro | Descripcion  |
| :-----: | :-: |
| input_program | Archivo de texto donde se desarrollo el programa en nuestro lenguaje |
| output_executable | Nombre deseado del ejecutable de salida |

```sh
./grammar_compiler.sh input_program output_executable
```
