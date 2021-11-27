# PseudoC

- Para compilar el proyecto
```sh
make all
```
- Para probar
```sh
./main < ejemplo
```
Donde ejemplo tiene que estar en PseudoC

Nota: si el repositorio se está clonando por primera vez, se deben agregar permisos de ejecución al archivo ./grammar_compiler.sh
```sh
chmod +x grammar_compiler.sh
```
- Para compilar y generar un ejecutable de un programa en este lenguaje

| Parametro | Descripcion  |
| :-----: | :-: |
| input_program | Archivo de texto donde se desarrollo el programa en nuestro lenguaje |
| output_executable | Nombre deseado del ejecutable de salida |
```sh
./grammar_compiler.sh input_program output_executable
```
- Para probar el ejecutable
```sh
./output_executable
```