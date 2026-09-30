@echo off
cd src\compilador

echo 1. Generando Lexer.java con JFlex...
jflex Lexer.flex

echo 2. Generando Parser.java y sym.java con Cup...
java -jar ..\..\lib\java-cup-11b.jar -parser Parser -symbols sym Parser.cup

echo 3. Compilando archivos Java...
cd ..\..
javac -cp ".;lib\java-cup-11b.jar" src\compilador\*.java

echo Compilacion completada.
pause