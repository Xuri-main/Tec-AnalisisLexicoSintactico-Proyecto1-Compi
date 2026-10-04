@echo off
echo Compilando Main.java...
javac -cp "lib\java-cup-11b.jar;src" src\compilador\Main.java
echo Ejecutando el compilador...
echo.
java -cp "lib\java-cup-11b.jar;src" compilador.Main
pause