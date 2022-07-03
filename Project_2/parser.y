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
	function_header optional_variable body ;
	
function_header:	
	FUNCTION IDENTIFIER parameters RETURNS type ';' |
	error ';' ;

optional_variable:
	/* empty */ |
	variable |
	error ';' ;

variable:
	IDENTIFIER ':' type IS statement_ ;

parameters:
	/* empty */ |
	parameters ',' parameter |
	parameter ;

parameter:
	IDENTIFIER ':' type ;

type:
	INTEGER | 
	REAL |
	BOOLEAN ;

body:
	BEGIN_ statement_ END ';' ;
    
statement_:
	statement ';' |
	error ';' ;
	
statement:
	expression |
	REDUCE operator reductions ENDREDUCE |
	IF expression THEN statement_ ELSE statement_ ENDIF |
	CASE expression IS case OTHERS ARROW statement_ ENDCASE ;

operator:
	ADDOP |
	MULOP ;

case:
	WHEN INT_LITERAL ARROW statement_ ;

reductions:
	reductions statement_ |
	;
		    
expression:
	expression ANDOP relation |
	or_op ;

or_op:
	expression OROP relation |
	relation ;

relation:
	relation RELOP term |
	term;

term:
	term ADDOP rem_op |
	rem_op ;
      
factor:
	factor MULOP exp_op |
	exp_op ;

rem_op:
	rem_op REMOP factor |
	factor ;

exp_op:
	primary EXPOP exp_op |
	primary ;

primary:
	'(' expression ')' |
	INT_LITERAL | 
	REAL_LITERAL |
	BOOL_LITERAL |
	IDENTIFIER ;
    
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
