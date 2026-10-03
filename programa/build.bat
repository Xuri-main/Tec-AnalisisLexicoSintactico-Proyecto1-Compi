@echo off
echo =========================================
echo  Construyendo Proyecto 1 - Compiladores
echo =========================================

:: 1. Generar el Lexer con JFlex
echo.
echo [1/3] Generando analizador lexico (JFlex)...
call jflex -d src\compilador src\compilador\Lexer.flex

:: 2. Generar el Parser indicando la clase principal java_cup.Main
echo.
echo [2/3] Generando analizador sintactico (CUP)...
java -cp lib\java-cup-11b.jar java_cup.Main -destdir src\compilador -parser Parser -symbols sym src\compilador\Parser.cup

:: 3. Compilar todos los archivos .java
echo.
echo [3/3] Compilando archivos Java...
javac -cp "lib\java-cup-11b.jar;src" src\compilador\*.java

echo.
echo =========================================
echo  ¡Construccion completada con exito!
echo =========================================
pause