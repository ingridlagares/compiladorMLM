%{
#include <stdio.h>
#define YYSTYPE char*
%}

%start code

  /* reserved words */
%token PROGRAM
%token INTEGER
%token REAL
%token BOOLEAN
%token CHAR
%token VAZIO
%token VALUE
%token REFERENCE
%token BEGIN_
%token END
%token IF
%token THEN
%token ELSE
%token REPEAT
%token UNTIL
%token READ
%token WRITE
%token FALSE
%token TRUE
%token PROCEDURE
%token NOT

  /* tokens from lex */
%token IDENTIFIER
%token INTEGER_CONSTANT
%token REAL_CONSTANT
%token CHAR_CONSTANT
%token RELOP
%token ADDOP
%token MULOP
%token ATTRIB
%token COLON
%token SEMI
%token COMMA
%token LPAREN
%token RPAREN

  /* solve the dangling else */
%nonassoc THEN
%nonassoc ELSE

%%
code            : PROGRAM IDENTIFIER SEMI decl_list compound_stmt ;

decl_list       : decl_list SEMI decl 
                | decl ;

decl            : dcl_var
                | dcl_proc ;
                         
dcl_var         : ident_list COLON type ;

ident_list      : ident_list COMMA IDENTIFIER
                | IDENTIFIER ;

type            : INTEGER
                | REAL
                | BOOLEAN
                | CHAR ;

dcl_proc        : tipo_retornado PROCEDURE IDENTIFIER espec_parametros corpo
                | PROCEDURE IDENTIFIER espec_parametros corpo 
                | tipo_retornado PROCEDURE IDENTIFIER espec_parametros 
                | PROCEDURE IDENTIFIER espec_parametros ;
                        
tipo_retornado  : INTEGER
                | REAL
                | BOOLEAN
                        | CHAR ;

corpo                   : COLON decl_list SEMI compound_stmt id_return
                        | COLON decl_list SEMI compound_stmt ;

id_return               : IDENTIFIER ;

espec_parametros        : LPAREN lista_de_parametros RPAREN ;

lista_de_parametros     : parametro
                        | lista_de_parametros COMMA parametro ;

parametro               : modo type COLON IDENTIFIER ;

modo                    : VALUE
                        | REFERENCE ;

compound_stmt           : BEGIN_ stmt_list END ;

stmt_list               : stmt_list SEMI stmt
                        | stmt ;

stmt                    : assign_stmt
                        | if_stmt
                        | repeat_stmt
                        | read_stmt
                        | write_stmt
                        | compound_stmt
                        | function_ref_par ;

assign_stmt             : IDENTIFIER ATTRIB expr ;

if_stmt                 : IF expr THEN stmt
                        | IF expr THEN stmt ELSE stmt ;

repeat_stmt             : REPEAT stmt_list UNTIL expr ;

read_stmt               : READ LPAREN ident_list RPAREN ;

write_stmt              : WRITE LPAREN expr_list RPAREN ;

expr_list               : expr
                        | expr_list COMMA expr ;

expr                    : Simple_expr
                        | Simple_expr RELOP Simple_expr ;

Simple_expr             : term
                        | Simple_expr ADDOP term ;

term                    : factor_a
                        | term MULOP factor_a ;

factor_a                : '-' factor
                        | factor ;

factor                  : IDENTIFIER
                        | constant
                        | LPAREN expr RPAREN
                        | NOT factor
                        | function_ref_par ;

function_ref_par        : variable LPAREN expr_list RPAREN ;

variable                : IDENTIFIER ;

constant                : INTEGER_CONSTANT
                        | REAL_CONSTANT
                        | CHAR_CONSTANT
                        | boolean_constant ;

boolean_constant        : FALSE
                        | TRUE ;
                        

%%
#include "lex.yy.c"

int main() {
    return yyparse();
}

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}
