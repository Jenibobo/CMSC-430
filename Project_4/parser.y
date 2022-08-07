/* Compiler Theory and Design
   Duane J. Jarc */

// Code edited by: Jennifer McClintock
// Date: 6 July 2022
// Code edited to reflect parsing instructions in order to create the synyax for
// out course languange. Comments put in to explain each syntax rule.

// Date: 18 July 2022
// Code edited in order add an interpreter in teh parser.y file to interpret
// the program. Added features that will accept command line arguments, and 
// added statement features, like nested if/else staements.


%{

#include <string>
#include <vector>
#include <map>
#include <iostream>

using namespace std;

#include "types.h"
#include "listing.h"
#include "symbols.h"

int yylex();
void yyerror(const char* message);

Symbols<Types> symbols;
bool startFunc = false;

%}

%define parse.error verbose

%union
{
	CharPtr iden;
	Types type;
}

%token <iden> IDENTIFIER
%token <type> INT_LITERAL BOOL_LITERAL REAL_LITERAL

%token ADDOP MULOP REMOP EXPOP 
%token OROP ANDOP RELOP NOTOP
%token INTEGER REAL BOOLEAN
%token BEGIN_ END FUNCTION IS RETURNS
%token REDUCE ENDREDUCE IF THEN ELSE ENDIF CASE WHEN ARROW OTHERS ENDCASE

%type <type> type statement_ statement reduction_ expression relation term factor primary binary_op exp_op unary_op case_ case

%%

function:	
	function_header optional_variable body 
;
	
function_header:	
	FUNCTION IDENTIFIER parameter_ RETURNS type ';' { set_returnVal($5); } |
	error ';'
;

optional_variable:
	optional_variable variable |
	error  ';' |
;

variable:	
	IDENTIFIER ':' type IS statement_ { 
		checkAssignment($3, $5, "Variable Initialization");
		// cout << $3 << "    " << $5;
		if (symbols.find($1, $3)) {
			duplicate_var($1);
		}
		symbols.insert($1, $3); 
	} 
;

parameter_:
	parameter_ ',' parameter |
	parameter |
;

parameter:
	IDENTIFIER ':' type { symbols.insert($1, $3); }
;

type:
	INTEGER { $$ = INT_TYPE; } |
	BOOLEAN { $$ = BOOL_TYPE; } |
	REAL { $$ = REAL_TYPE; }
;

body:
	BEGIN_ { startFunc = true; } statement_ END ';' 
;
    
statement_:
	statement ';' {
		if (startFunc) {
			check_return($1);
		}
	 } |
	error ';' { $$ = MISMATCH; } 
;

//TODO	
statement:
	expression |
	REDUCE operator reduction_ ENDREDUCE { $$ = $3; } |
	IF expression { check_ifExpr($2); } THEN statement_ ELSE statement_ ENDIF { check_ifStatemant($5, $7); } |
	CASE expression { check_caseExpr($2); } IS case_ OTHERS ARROW statement_{ check_caseStatment($8); } ENDCASE {}
;

operator:
	ADDOP |
	MULOP 
;

case_:
	case_ case |
	{  }
;

case:
	WHEN INT_LITERAL ARROW statement_ {
		check_caseStatment($4);
		store_prev_case($2);
	}
;

reduction_:
	reduction_ statement_ { $$ = checkArithmetic($1, $2); } |
	{ $$ = INT_TYPE; } 
;

// OROP has the lowest precedence		    
expression:
	expression OROP relation { $$ = checkLogical($1, $3); } |
	binary_op 
;

// ANDOP has the next to lowest precedence
binary_op:
	binary_op ANDOP relation { $$ = checkLogical($1, $3); } |
	relation
;

// All RELOP's have the same precedence
relation:
	relation RELOP term { $$ = checkRelational($1, $3); }|
	term 
;

// ******************** Math Ops *************************
// Precedence of mathmatical operators:
// 		lowest => ADDOP
// 		       => MULOP
//		       => REMOP
// 	   Highest => EXEOP (right-associative)
term:
	term ADDOP factor { $$ = checkArithmetic($1, $3); } |
	factor 
;

// Adding REMOP as an option for 'factor'
factor:
	factor MULOP exp_op  { $$ = checkArithmetic($1, $3); } |
	factor REMOP exp_op { $$ = checkArithmetic($1, $3); check_remOP($1, $3); } |
	exp_op  
;

// Right-recursive/right-associative rule
exp_op:
	unary_op EXPOP exp_op { $$ = checkArithmetic($1, $3); } |
	unary_op
;

// NOTOP has highest precedence
//TODO
unary_op:
	NOTOP primary { $$ = $2; } |
	primary 
;

primary:
	'(' expression ')' { $$ = $2; } |
	INT_LITERAL |
	REAL_LITERAL |
	BOOL_LITERAL |
	IDENTIFIER {if (!symbols.find($1, $$)) appendError(UNDECLARED, $1); } ;
    
%%

void yyerror(const char* message)
{
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[])    
{
	firstLine();
	yyparse();
	lastLine();
	return 0;
} 
