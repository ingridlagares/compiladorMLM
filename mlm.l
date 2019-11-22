%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
#define DEBUG_ECHO(symbol) printf ("<%s, %s>\n", symbol, yytext)

extern YYSTYPE yylval;

char* caps_lock(char *str){
  uint8_t i;
  while(str[i]){
    str[i] -= 32;
    i++;
  }
    return str;
}
%}

digit [0-9]
letter [A-Za-z]
scale_factor E[+-]?[0-9]+
sign [+-]?

relop ([<>!]=?|=)
addop ([+-]|or)
mulop ([*/]|div|mod|and)

identifier {letter}({digit}|{letter}){0,63}

unsigned_real {unsigned_integer}(("."{digit}*)?)({scale_factor}?)
unsigned_integer {digit}+
integer_constant {unsigned_integer}
real_constant {unsigned_real}
char_constant '([\0-\x26]|[\x28-\x7f])+'
%%

[ \r\t] { }
    
(PROCEDURE)        { DEBUG_ECHO("PROCEDURE"); return PROCEDURE; }
(NOT)              { DEBUG_ECHO("NOT");       return NOT; }
    
":="               { DEBUG_ECHO("ATTRIB");    return ATTRIB; }
"("                { DEBUG_ECHO("LPAREN");    return LPAREN; }
")"                { DEBUG_ECHO("RPAREN");    return RPAREN; }
","                { DEBUG_ECHO("COMMA");     return COMMA; }
":"                { DEBUG_ECHO("COLON");     return COLON; }
";"                { DEBUG_ECHO("SEMI");      return SEMI; }

{relop}            { DEBUG_ECHO("RELOP");     return RELOP; }
{addop}            { DEBUG_ECHO("ADDOP");     return ADDOP; }
{mulop}            { DEBUG_ECHO("MULOP");     return MULOP; }

(program)          { DEBUG_ECHO("PROGRAM");   return PROGRAM; }
(begin)            { DEBUG_ECHO("BEGIN");     return BEGIN_; }
(end)              { DEBUG_ECHO("END");       return END; }
(if)               { DEBUG_ECHO("IF");        return IF; }
(then)             { DEBUG_ECHO("THEN");      return THEN; }
(else)             { DEBUG_ECHO("ELSE");      return ELSE; }
(repeat)           { DEBUG_ECHO("REPEAT");    return REPEAT; }
(until)            { DEBUG_ECHO("UNTIL");     return UNTIL; }
(read)             { DEBUG_ECHO("READ");      return READ; }
(write)            { DEBUG_ECHO("WRITE");     return WRITE; }
(value)            { DEBUG_ECHO("VALUE");     return VALUE; }
(reference)        { DEBUG_ECHO("REFERENCE"); return REFERENCE; }
(integer)          { DEBUG_ECHO("INTEGER");   return INTEGER; }
(real)             { DEBUG_ECHO("REAL");      return REAL; }
(boolean)          { DEBUG_ECHO("BOOLEAN");   return BOOLEAN; }
(char)             { DEBUG_ECHO("CHAR");      return CHAR; }
(false)            { DEBUG_ECHO("FALSE");     return FALSE; }
(true)             { DEBUG_ECHO("TRUE");      return TRUE; }

{identifier}       { DEBUG_ECHO("IDENTIFIER");       return IDENTIFIER; }
{integer_constant} { DEBUG_ECHO("INTEGER_CONSTANT"); return INTEGER_CONSTANT; }
{real_constant}    { DEBUG_ECHO("REAL_CONSTANT");    return REAL_CONSTANT; }
{char_constant}    { DEBUG_ECHO("CHAR_CONSTANT");    return CHAR_CONSTANT; }

. {
    printf("\n[Error] Illegal character `%s`\n", yytext);
    exit(1);
}
%%
int yywrap(){
  return 1;
}
