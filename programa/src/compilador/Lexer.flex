package compilador; 

import java_cup.runtime.*;
import java.io.FileWriter;
import java.io.IOException;

%%

// Opciones y declaraciones de JFlex
%class Lexer
%unicode
%cup
%line
%column
%public

%{
    // Método auxiliar para crear tokens (Symbols) para CUP
    private Symbol symbol(int type) {
        return new Symbol(type, yyline + 1, yycolumn + 1);
    }

    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline + 1, yycolumn + 1, value);
    }
    
    // Método para escribir errores léxicos
    private void reportarErrorLexico(String lexema) {
        System.err.println("Error Léxico: Carácter no reconocido '" + lexema + 
                           "' en la línea " + (yyline + 1) + ", columna " + (yycolumn + 1));

    }
%}

/* Macros */
LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
WhiteSpace     = {LineTerminator} | [ \t\f]

Letra          = [a-zA-Z]
Digito         = [0-9]
Identificador  = {Letra} ({Letra} | {Digito})*
NumeroEntero   = {Digito}+
DecimalValido  = "0" | ({Digito}* [1-9])
NumeroFlotante = {NumeroEntero} \. {DecimalValido}



/* Comentarios */
ComentarioLinea = "\"\"" {InputCharacter}* "\"\""
ComentarioMulti = "¡" [^]* "y!"

/* Literales de texto */
CadenaTexto    = \" [^\"]* \"
Caracter       = ' [^'] '


%%

<YYINITIAL> {
    /* Ignorar espacios y comentarios */
    {WhiteSpace}       { /* ignorar */ }
    {ComentarioLinea}  { /* ignorar */ }
    {ComentarioMulti}  { /* ignorar */ }

    /* Palabras Reservadas */
    "void"             { return symbol(sym.VOID); }
    "main"             { return symbol(sym.MAIN); }
    "int"              { return symbol(sym.INT); }
    "float"            { return symbol(sym.FLOAT); }
    "boolean"          { return symbol(sym.BOOLEAN); }
    "char"             { return symbol(sym.CHAR); }
    "string"           { return symbol(sym.STRING); }
    "val"              { return symbol(sym.VAL); }
    "if"               { return symbol(sym.IF); }
    "elif"             { return symbol(sym.ELIF); }
    "else"             { return symbol(sym.ELSE); }
    "while"            { return symbol(sym.WHILE); }
    "for"              { return symbol(sym.FOR); }
    "return"           { return symbol(sym.RETURN); }
    "break"            { return symbol(sym.BREAK); }
    "read"             { return symbol(sym.READ); }
    "write"            { return symbol(sym.WRITE); }
    "true"             { return symbol(sym.TRUE); }
    "false"            { return symbol(sym.FALSE); }
    "mod"              { return symbol(sym.MOD); }
    "pot"              { return symbol(sym.POT); }

    /* Delimitadores y Símbolos de Agrupación */
    "∈:"               { return symbol(sym.LPAREN); }
    "y:∋"              { return symbol(sym.RPAREN); }
    "¿y:"              { return symbol(sym.LBLOCK); }
    ":?"               { return symbol(sym.RBLOCK); }
    "¿:"               { return symbol(sym.L_ARRAY_INIT); }
    "y:?"              { return symbol(sym.R_ARRAY_INIT); }
    "["                { return symbol(sym.LBRACKET); }
    "]"                { return symbol(sym.RBRACKET); }
    ":"                { return symbol(sym.COLON); }
    "y:Ƨ"              { return symbol(sym.R_ARRAY_IDX); }
    ";"                { return symbol(sym.SEMICOLON); }
    ","                { return symbol(sym.COMMA); }

    /* Operadores de Asignación y Finalización */
    "⊢"                { return symbol(sym.ASSIGN); }
    ">>"               { return symbol(sym.END_STMT); }

    /* Operadores Aritméticos */
    "+"                { return symbol(sym.PLUS); }
    "-"                { return symbol(sym.MINUS); }
    "*"                { return symbol(sym.MULT); }
    "/"                { return symbol(sym.DIV); }
    "//"               { return symbol(sym.INT_DIV); }
    "++"               { return symbol(sym.INC); }
    "--"               { return symbol(sym.DEC); }

    /* Operadores Relacionales */
    "<"                { return symbol(sym.LT); }
    "<="               { return symbol(sym.LTE); }
    ">"                { return symbol(sym.GT); }
    ">="               { return symbol(sym.GTE); }
    "=="               { return symbol(sym.EQ); }
    "!="               { return symbol(sym.NEQ); }

    /* Operadores Lógicos */
    "λ"                { return symbol(sym.AND); }
    "O"                { return symbol(sym.OR); }
    "Σ"                { return symbol(sym.NOT); }

    /* Identificadores y Literales */
    {Identificador}    { return symbol(sym.ID, yytext()); }
    {NumeroEntero}     { return symbol(sym.NUM_INT, Integer.parseInt(yytext())); }
    {NumeroFlotante}   { return symbol(sym.NUM_FLOAT, Float.parseFloat(yytext())); }
    {CadenaTexto}      { return symbol(sym.STRING_LITERAL, yytext()); }
    {Caracter}         { return symbol(sym.CHAR_LITERAL, yytext()); }

    [^]                { reportarErrorLexico(yytext()); }
}