/* Compiler Theory and Design
   Duane J. Jarc */

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

Symbols<int> symbols;

int result;
queue<int> param_list;

%}

%define parse.error verbose

%union
{
	CharPtr iden;
	Operators oper;
	int value;
}

%token <iden> IDENTIFIER
%token <value> INT_LITERAL
%token <value> REAL_LITERAL
%token <value> BOOL_LITERAL

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

parameter:
	IDENTIFIER ':' type {
        symbols.insert($1, param_list.front());
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
	
statement:
	expression |
	REDUCE operator reduction_ ENDREDUCE { $$ = $3; } |
	IF expression THEN statement_ { $$ = evaluate_ifThen($2, $4, 0); } |
	IF expression THEN statement_ ELSE statement_ ENDIF { $$ = evaluate_ifThen($2, $4, $6); } |
	CASE expression { set_condition($2); } IS case_ OTHERS ARROW statement_ ENDCASE { $$ == evaluate_caseStat($5, $8); }
;

operator:
	ADDOP |
	MULOP 
;

case_:
	case_ case { $$ = eval_cases($1, $2); } |
	{}
;

case:
	WHEN INT_LITERAL ARROW statement_ { $$ = find_matched_case($2, $4); }
;

reduction_:
	reduction_ statement_ { $$ = evaluateReduction($<oper>0, $1, $2); } |
    { $$ = $<oper>0 == PLUS ? 0 : 1; }
;

// OROP has the lowest precedence		    
expression:
	expression OROP binary_op relation { $$ = $1 || $3; } |
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
