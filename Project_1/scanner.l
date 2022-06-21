/* Compiler Theory and Design
   Dr. Duane J. Jarc */

/* This file contains flex input file */

%{
#include <cstdio>
#include <string>

using namespace std;

#include "listing.h"
#include "tokens.h"

%}

%option noyywrap

ws		[ \t\r]+
comment		\-\-.*\n
line		[\n]
id		[A-Za-z_][A-Za-z_0-9]* // Adding underscores to the id --> [A-Za-z]([A-Za-z0-9][_]?[A-Za-z0-9])*
digit		[0-9]
int		[+-]?{digit}+
punc		[\(\),:;]
real_lit	{int}(.{digit}*)?|.{digit}+)([eE]{digit}+)?)

bool_lit 	true|flase
relop		<|>|<=|>=|/=|=
addop		+|-
mulop		*|/
exeop		**

arrow		=>
%%

{ws}		{ ECHO; }
{comment}	{ ECHO; nextLine();}
{line}		{ ECHO; nextLine();}
{relop}		{ ECHO; return(RELOP); }
{addop}		{ ECHO; return(ADDOP); }
{mulop}		{ ECHO; return(MULOP); }
{exeop}		{ ECHO; return(EXEOP); }
{bool_lit}	{ ECHO; return(BOOL_LITERAL); }
{real_lit}	{ ECHO; return(REAL_LITERAL); }

begin		{ ECHO; return(BEGIN_); }
end		{ ECHO; return(END); }
function	{ ECHO; return(FUNCTION); }
is		{ ECHO; return(IS); }
reduce		{ ECHO; return REDUCE; }
endreduce	{ ECHO; return(ENDREDUCE); }
returns		{ ECHO; return(RETURNS); }

and		{ ECHO; return(ANDOP); }
or		{ ECHO; return(OROP); }
not		{ ECHO; return(NOTOP); }

case		{ ECHO; return(CASE); }
endcase		{ ECHO; return(ENDCASE); }
if		{ ECHO; return(IF); }
else		{ ECHO; return(ELSE); }
endif		{ ECHO; return(ENDIF); }
others		{ ECHO; return(OTHERS); }
{arrow}		{ ECHO; return(ARROW); }
then		{ ECHO; return(THEN); }
when		{ ECHO; return(WHEN); }

boolean		{ ECHO; return(BOOLEAN); }
integer		{ ECHO; return(INTEGER); }

{id}		{ ECHO; return(IDENTIFIER);}
{int}		{ ECHO; return(INT_LITERAL); }
{punc}		{ ECHO; return(yytext[0]); }
.		{ ECHO; appendError(LEXICAL, yytext); }
%%

int main()
{
	firstLine();
	
	FILE *file = fopen("lexemes.txt", "wa"); 
	int token = yylex();
	while (token)
	{
		fprintf(file, "%d %s\n", token, yytext);
		token = yylex();
	}
	lastLine();
	fclose(file);
	return 0;
}
