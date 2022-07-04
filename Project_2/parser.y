/* Compiler Theory and Design
   	// Dr. Duane J. Jarc 

   	// Code edited by: Jennifer McClintock
	// Date: 26 June 2022
	//

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

function:	
	function_header optional_variable body 
	;
	
function_header:	
	FUNCTION IDENTIFIER parameters RETURNS type ';' 
	| error ';' 
	;

parameters:
	/* empty */ 
	| parameters ',' parameter 
	| parameter 
	;

parameter:
	IDENTIFIER ':' type 
	;

type:
	INTEGER 
	| REAL 
	| BOOLEAN 
	;

optional_variable:
	/* empty */ 
	| optional_variable variable 
	| error ';' 
	;

variable:
	IDENTIFIER ':' type IS statement_ 
	;

statement_:
	statement ';' 
	| error ';' 
	;

body:
	BEGIN_ statement_ END ';' 
	;
	
statement:
	expression 
	| REDUCE operator reductions ENDREDUCE
	| IF expression THEN statement_ ELSE statement_ ENDIF
	| CASE expression IS mult_cases OTHERS ARROW statement_ ENDCASE 
	;

operator:
	ADDOP 
	| MULOP 
	;

mult_cases:
	/* empty */
	| mult_cases case
	;

case:
	WHEN INT_LITERAL ARROW statement_ 
	;

reductions:
	/* empty */ 
	| reductions statement_ 
	;
		    
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

primary:
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
