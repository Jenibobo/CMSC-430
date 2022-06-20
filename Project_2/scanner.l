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

ws			[ \t\r]+
line		[\n]
comment	(\-\-.*{line})|(\/\/.*{line}) 
id			[A-Za-z]([_]?[A-Za-z0-9])*
digit		[0-9]
int		-?{digit}+
punc		[\(\),:;]
real_lit	{int}*\.?{digit}+([eE][+-]?{digit}+)?
%%

{ws}		{ ECHO; }
{comment}	{ ECHO; nextLine(); }
{line}		{ ECHO; nextLine(); }

"<"			{ ECHO; return(RELOP); }
"="			{ ECHO; return(RELOP); }
"/="		{ ECHO; return(RELOP); }
">"			{ ECHO; return(RELOP); }
">="		{ ECHO; return(RELOP); }
"<="		{ ECHO; return(RELOP); }

"+"			{ ECHO; return(ADDOP); }
"-"			{ ECHO; return(ADDOP); }

"*"			{ ECHO; return(MULOP); }
"/"			{ ECHO; return(MULOP); }

"**"		{ ECHO; return(EXPOP); }  

begin		{ ECHO; return(BEGIN_); }
end			{ ECHO; return(END); }
function	{ ECHO; return(FUNCTION); }
is			{ ECHO; return(IS); }
returns		{ ECHO; return(RETURNS); }

reduce		{ ECHO; return(REDUCE); }
endreduce	{ ECHO; return(ENDREDUCE); }

real		{ ECHO; return(REAL); }
boolean		{ ECHO; return(BOOLEAN); }
integer		{ ECHO; return(INTEGER); }

true		{ ECHO; return(BOOL_LITERAL); }
false		{ ECHO; return(BOOL_LITERAL); }

rem			{ ECHO; return(REMOP); }

and			{ ECHO; return(ANDOP); }
or			{ ECHO; return(OROP); }
not			{ ECHO; return(NOTOP); }

case		{ ECHO; return(CASE); }
endcase		{ ECHO; return(ENDCASE); }
if			{ ECHO; return(IF); }
else		{ ECHO; return(ELSE); }
endif		{ ECHO; return(ENDIF); }
others		{ ECHO; return(OTHERS); }
"=>"		{ ECHO; return(ARROW); }
then		{ ECHO; return(THEN); }
when		{ ECHO; return(WHEN); }

{id}		{ ECHO; return(IDENTIFIER); }
{int}		{ ECHO; return(INT_LITERAL); }
{real_lit}	{ ECHO; return(REAL_LITERAL); }
{punc}		{ ECHO; return(yytext[0]); }
.			{ ECHO; appendError(LEXICAL, yytext); }
%%

int main() {
	firstLine();
	
	FILE *file = fopen("lexemes.txt", "wa"); 
	int token = yylex();
	while (token) {
		fprintf(file, "%d %s\n", token, yytext);
		token = yylex();
	}
	lastLine();
	fclose(file);
	return 0;
}