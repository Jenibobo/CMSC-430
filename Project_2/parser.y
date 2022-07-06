/* Compiler Theory and Design
   	// Dr. Duane J. Jarc 

   	// Code edited by: Jennifer McClintock
	// Date: 2 July 2022
	// Code edited to reflect parsing instructions in order to create the synyax for out course languange.
	// Comments put in to explain each syntax rule.

*/

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
%token ADDOP MULOP RELOP ANDOP OROP NOTOP REMOP EXPOP
%token BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER IS REDUCE RETURNS
%token REAL IF THEN ELSE ENDIF CASE OTHERS ARROW ENDCASE WHEN 

%%

// function: Outline of the function/program.
function:	
	function_header optional_variable body 
	;

// function_header: the first line to the function/program where the creator
// names the function/program, and/or allows for commandline inputs from the user.
function_header: 
	FUNCTION IDENTIFIER parameters RETURNS type ';' 
	| error ';' 
	;
	
// parameters: allows the user to add multiple command line inputs 
// as parameters for the program in the function declaration line.
parameters:
	/* empty */ 
	| parameters ',' parameter 
	| parameter 
	;

// parameter: declaration of a single parameter.
parameter:
	IDENTIFIER ':' type 
	;

// type: the identifying type of a declared variable.
type:
	INTEGER 
	| REAL 
	| BOOLEAN 
	;

// are the variable that are/can-be declared before the 
// body of the function/program.
optional_variable:
	/* empty */ 
	| optional_variable variable 
	| error ';' 
	;
	
// variable: syntax for the declaration of a single varible.
variable:
	IDENTIFIER ':' type IS statement_ 
	;

// statement_: either a statement_ is a statment or it will be an error.
statement_:
	statement ';' 
	| error ';' 
	;

// body: outline of the body of the fubtion/program. Where the meat
// of the code will go. The body will have a 'begin' and an 'end'. If 
// not it should produce a syntax error.
body:
	BEGIN_ statement_ END ';' 
	;

// statement: defining what a statement entails. It could be an expression,
// a reduce statment, if statement or switch statement.
//	- expression would be an relational condition, or a mathmatic operation (details below).
//	- Reduce statement reduces the passed var by claiming mathmatic ops, and an integer/real.
//	- If statement, begins with 'if', followed by an expression and 'then', an else
//	  condition, and finally ending with endif. 
//	- Case statement allows the creator to add cases that is similar to using an if statment. 
//	  It begins with 'case' and is followed by an expression, additional case staments (mult_cases), 
//	  and then ending with the last case by 'others =>'. The case statement is eneded with 'endcase'
statement:
	expression 
	| REDUCE operator reductions ENDREDUCE
	| IF expression THEN statement_ ELSE statement_ ENDIF
	| CASE expression IS mult_cases OTHERS ARROW statement_ ENDCASE 
	;
	
// operator: mathmatical operator used by the language 
// (addop = '+' or '-', mul_op = '*' or '/').
operator:
	ADDOP 
	| MULOP 
	;

// mult_cases: optional cases that can be added to the case/switch statement
mult_cases:
	/* empty */
	| mult_cases case
	;

// case: outline of each case condition by using 'when (integer) => (statment)'.
case:
	WHEN INT_LITERAL ARROW statement_ 
	;
	
// TO-DO: get the reduction statement working properly by allowing for
// multiple reductions to happen
// reductions: outlines the reduction syntax 
reductions:
	/* empty */ 
	| reductions statement_ 
	;

// *************** Below is defining expression, and how all relational and/or mathmatical operators can
// *************** be used in the expression. Starting with expression, I have allowed the creator the 
// *************** ability to use all relational and/or mathmatical operators in each expression.

expression:
	expression OROP and_op 
	| and_op 
	;

and_op:
	and_op ANDOP rel_op 
	| rel_op 
	;

rel_op:
	rel_op RELOP add_op 
	| add_op
	;

add_op:
	add_op ADDOP mul_op 
	| mul_op 
	;
      
mul_op:
	mul_op MULOP exp_op 
	| mul_op REMOP exp_op
	| exp_op 
	;

exp_op:
	primary EXPOP exp_op 
	| not_op 
	;

not_op:
	NOTOP primary
	| primary 
	;

// Basically defines each line in the fuction/program
// primary:
	'(' expression ')' 
	| INT_LITERAL 
	| REAL_LITERAL 
	| BOOL_LITERAL 
	| IDENTIFIER ;
    
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
