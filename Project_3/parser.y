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

#include <iostream>
#include <string>
#include <vector>
#include <map>
#include <queue>

using namespace std;

#include "values.h"
#include "listing.h"
#include "symbols.h"

int yylex();
void yyerror(const char* message);

Symbols<double> symbols;

double result;
queue<double> param_list;

%}

%define parse.error verbose

%union
{
	CharPtr iden;
	Operators oper;
	double value;
}

%token <iden> IDENTIFIER
%token <value> INT_LITERAL BOOL_LITERAL REAL_LITERAL
%token <oper> ADDOP MULOP REMOP EXPOP RELOP

%token OROP ANDOP NOTOP
%token INTEGER REAL BOOLEAN
%token BEGIN_ END FUNCTION IS RETURNS
%token REDUCE ENDREDUCE IF THEN ELSE ENDIF
%token CASE WHEN ARROW OTHERS ENDCASE

%type <value> body statement_ statement reduction_ expression relation term factor primary binary_op exp_op unary_op case_ case
%type <oper> operator 

%%

function:	
	function_header optional_variable body { result = $3; }
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
	IDENTIFIER ':' type IS statement_ { symbols.insert($1, $5); }
;

parameter_:
	parameter_ ',' parameter |
	parameter |
;

// Using insert() from symbols.h and passing the IDENTIFIER($1) and param_list.front(). 
// Param_list is a queue that will house all command line arguments. Using queue so that 
// it can be dymanic. The main() will push all arguments until none are left. Then the 
// param_list.front() will pass each node in the front of the queue then pop then out of
// queue.
parameter:
	IDENTIFIER ':' type {
        symbols.insert($1, param_list.front());
		// cout << " <--- " << param_list.front() ;
        param_list.pop();
    }
;

type:
	INTEGER |
	REAL |
	BOOLEAN 
;

body:
	BEGIN_ statement_ END ';' { $$ = $2; }
;
    
statement_:
	statement ';' |
	error ';' { $$ = 0; }
;

// I added the another IF statement rule in order to be able to have nested IF statements. The
// evaluate_ifThen($2, $4, $6) will pass the expression($2), statement_($4), and statement($6). 
// If the expression for the if condtion is true then if will return the if statement. Other wise
// it will return the else_statement
//
// For the Case statement, set_condition($2) will set the case condition to the expression($2). Then 
// evaluate_caseStat($5, $8) will take the case_($5) and (others)statement_($8)and try to match the
// condition to an IN_LITERAL. If one is found it will return that Case statement. Otherwise it will return 
// the others statement.
statement:
	expression |
	REDUCE operator reduction_ ENDREDUCE { $$ = $3; } |
	IF expression THEN statement_ { $$ = evaluate_ifThen($2, $4, 0); } |
	IF expression THEN statement_ ELSE statement_ ENDIF { $$ = evaluate_ifThen($2, $4, $6); } |
	CASE expression { set_condition($2); } IS case_ OTHERS ARROW statement_ ENDCASE { $$ = evaluate_caseStat($5, $8); }
;

operator:
	ADDOP |
	MULOP 
;

case_:
	case_ case |
	{}
;

// The find_matched_case($2, $4) will take the INT_LITERAL($2) and the statement_($4) and try to
// match the case condition to the INT_LITERAL. 
case:
	WHEN INT_LITERAL ARROW statement_ { find_matched_case($2, $4); } 
;

reduction_:
	reduction_ statement_ { $$ = evaluateReduction($<oper>0, $1, $2); } |
    { $$ = $<oper>0 == PLUS ? 0 : 1; }
;

// OROP has the lowest precedence		    
expression:
	expression OROP binary_op { $$ = $1 || $3; } |
	binary_op 
;

// ANDOP has the next to lowest precedence
binary_op:
	binary_op ANDOP relation { $$ = $1 && $3; } |
	relation
;

// All RELOP's have the same precedence
relation:
	relation RELOP term { $$ = evaluateRelational($1, $2, $3); } |
	term
;

// ******************** Math Ops *************************
// Precedence of mathmatical operators:
// 		lowest => ADDOP
// 		       => MULOP
//		       => REMOP
// 	   Highest => EXEOP (right-associative)
term:
	term ADDOP factor { $$ = evaluateArithmetic($1, $2, $3); } |
	factor 
;
 
// Adding REMOP as an option for 'factor'
factor:
	factor MULOP exp_op { $$ = evaluateArithmetic($1, $2, $3); } |
	factor REMOP exp_op { $$ = evaluateArithmetic($1, $2, $3); } |
	exp_op 
;

// Right-recursive/right-associative rule
exp_op:
	unary_op EXPOP exp_op { $$ = evaluateArithmetic($1, $2, $3); } |
	unary_op
;

// NOTOP has highest precedence
unary_op:
	NOTOP primary { $$ = ! $2; } |
	primary
;

primary:
	'(' expression ')' { $$ = $2; } |
	INT_LITERAL | 
	REAL_LITERAL |
	BOOL_LITERAL |
	IDENTIFIER { if (!symbols.find($1, $$)) appendError(UNDECLARED, $1); }
;
%%

void yyerror(const char* message)
{
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[]) {
    int i = 1;

    while(i < argc) {
		// cout << " ------> " << argv[i];
        param_list.push(atoi(argv[i]));
        i++;
    }

	firstLine();
	yyparse();
	if (lastLine() == 0) {
        cout << "Result = " << result << endl;
    }
	return 0;
} 
