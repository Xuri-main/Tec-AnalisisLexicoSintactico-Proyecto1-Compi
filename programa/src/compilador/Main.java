/**
 * Archivo: Main.java
 * Descripcion: Clase principal que orquesta el funcionamiento del compilador. 
 *              Ejecuta el analisis lexico para generar el archivo de salida con los 
 *              tokens reconocidos y su respectiva tabla de simbolos, seguido del 
 *              analisis sintactico para validar si el archivo fuente pertenece a la gramatica.
 * Autores: Emilio Funes R. & Ginger Rodriguez G.
 * Fecha: 03/10/2026
 */

package compilador;

import java.io.FileReader;
import java.io.FileWriter;
import java.io.PrintWriter;
import java_cup.runtime.Symbol;

public class Main {
    public static void main(String[] args) {
        // Archivo a probar
        String archivoPrueba = "prueba.txt"; 
        
        try {
            System.out.println("=========================================");
            System.out.println(" INICIANDO COMPILADOR - FASE LÉXICA");
            System.out.println("=========================================");
            generarArchivoTokens(archivoPrueba);
            
            System.out.println("\n=========================================");
            System.out.println(" INICIANDO COMPILADOR - FASE SINTÁCTICA");
            System.out.println("=========================================");
            
            // Instancia un nuevo lexer para el parser
            Lexer lexerSintactico = new Lexer(new FileReader(archivoPrueba));
            Parser parser = new Parser(lexerSintactico);
            
            // Ejecuta el análisis sintáctico
            parser.parse();
            
            // Indica si el archivo fuente puede ser generado por la gramática
            System.out.println("\n[ÉXITO] El archivo fuente puede ser generado por la gramatica correctamente.");
            
        } catch (Exception e) {
            System.err.println("\n[ERROR FATAL] La ejecucion se detuvo: " + e.getMessage());
        }
    }

    private static void generarArchivoTokens(String rutaArchivo) throws Exception {
        Lexer lexer = new Lexer(new FileReader(rutaArchivo));
        FileWriter fichero = new FileWriter("salida_tokens.txt");
        PrintWriter pw = new PrintWriter(fichero);
        
        pw.println("--- RESULTADOS DEL ANALISIS LEXICO ---");
        
        while (true) {
            Symbol token = lexer.next_token();
            if (token.sym == sym.EOF) {
                break;
            }
            
            String nombreToken = sym.terminalNames[token.sym];
            String lexema = token.value != null ? token.value.toString() : nombreToken;
            
            // Escribe en un archivo todos los tokens encontrados y el identificador asociado
            pw.println("Token: " + nombreToken + " | Lexema: " + lexema);
            
            // Indica en cuál tabla de símbolos va y la información almacenada
            if (nombreToken.equals("ID")) {
                pw.println("    -> Va a Tabla de Simbolos: VARIABLES/FUNCIONES | Info a almacenar: Nombre de identificador");
            } else if (nombreToken.equals("NUM_INT") || nombreToken.equals("NUM_FLOAT")) {
                pw.println("    -> Va a Tabla de Simbolos: LITERALES NUMERICOS | Info a almacenar: Valor constante");
            } else if (nombreToken.equals("STRING_LITERAL") || nombreToken.equals("CHAR_LITERAL")) {
                pw.println("    -> Va a Tabla de Simbolos: LITERALES TEXTO | Info a almacenar: Cadena de caracteres");
            }
        }
        fichero.close();
        System.out.println("[ÉXITO] Analisis lexico completado. Se genero el archivo 'salida_tokens.txt'");
    }
}