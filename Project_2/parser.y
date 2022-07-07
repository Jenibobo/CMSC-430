/* Compiler Theory and Design
   Dr. Duane J. Jarc */

// Code edited by: Jennifer McClintock
// Date: 6 July 2022
// Code edited to reflect parsing instructions in order to create the synyax for out course languange.
// Comments put in to explain each syntax rule.

%{

#include <string>

using namespace std;

#include "listing.h"

int yylex();
void yyerror(const char* message);

%}

%define parse.error verbose

%token IDENTIFIER
%token INT_LITERAL REAL_LITERAL BOOL_LITERAL
%token ADDOP MULOP REMOP EXPOP 
%token OROP ANDOP RELOP NOTOP
%token INTEGER REAL BOOLEAN
%token BEGIN_ END FUNCTION IS RETURNS
%token REDUCE ENDREDUCE IF THEN ELSE ENDIF CASE WHEN ARROW OTHERS ENDCASE

%%

function:	
	function_header optional_variable body 
;
	
function_header:	
	FUNCTION IDENTIFIER parameter_ RETURNS type ';' |
	error ';'
;

optional_variable:
	optional_variable variable |
	error  ';' |
;

variable:
	IDENTIFIER ':' type IS statement_ 
;

parameter_:
	parameter_ ',' parameter |
	parameter |
;

parameter:
	IDENTIFIER ':' type
;

type:
	INTEGER |
	REAL |
	BOOLEAN 
;

body:
	BEGIN_ statement_ END ';' 
;
    
statement_:
	statement ';' |
	error ';' 
;
	
statement:
	expression |
	REDUCE operator reduction_ ENDREDUCE |
	IF expression THEN statement_ ELSE statement_ ENDIF |
	CASE expression IS case_ OTHERS ARROW statement_ ENDCASE
;

operator:
	ADDOP |
	MULOP 
;

case_:
	case_ case |
;

case:
	WHEN INT_LITERAL ARROW statement_
;

reduction_:
	reduction_ statement_ |
;

// OROP has the lowest precedence		    
expression:
	expression OROP binary_op |
	binary_op 
;

// ANDOP has the next to lowest precedence
binary_op:
	binary_op ANDOP relation |
	relation
;

// All RELOP's have the same precedence
relation:
	relation RELOP term |
	term
;

// ******************** Math Ops *************************
// Precedence of mathmatical operators:
// 		lowest => ADDOP
// 		       => MULOP
//		       => REMOP
// 	   Highest => EXEOP (right-associative.)
term:
	term ADDOP factor |
	factor 
;
 
// Adding REMOP as an option for 'factor'
factor:
	factor MULOP exp_op |
	factor REMOP exp_op |
	exp_op 
;

exp_op:
	primary EXPOP exp_op |
	unary_op
;

// NOTOP has highest precedence
unary_op:
	unary_op NOTOP primary |
	primary
;

primary:
	'(' expression ')' |
	INT_LITERAL | 
	REAL_LITERAL |
	BOOL_LITERAL |
	IDENTIFIER 
;
    
%%

void yyerror(const char* message) {
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[]) {
	firstLine();
	yyparse();
	lastLine();
	return 0;
} 