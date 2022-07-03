/* Compiler Theory and Design
   // Dr. Duane J. Jarc

	// Code edited by: Jennifer McClintock
	// Date: 25 June 2022
	// Code edited in order to add the additional lexemes need for our course language.

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
comment		(\-\-.*{line})|(\/\/.*{line}) 
id			[A-Za-z]([_]?[A-Za-z0-9])*
digit		[0-9]
int			[+-]?{digit}+
punc		[\(\),:;]

real_lit	{digit}*\.?{digit}+([eE][+-]?{digit}+)?
bool_lit 	true|false
relop		"<"|">"|"<="|">="|"/="|"="
addop		"+"|"-"
mulop		"*"|"/"
expop		"**"

arrow		"=>"
%%

{ws}		{ ECHO; }
{comment}	{ ECHO; nextLine(); }
{line}		{ ECHO; nextLine(); }
{relop}		{ ECHO; return(RELOP); }
{addop}		{ ECHO; return(ADDOP); }
{mulop}		{ ECHO; return(MULOP); }
{expop}		{ ECHO; return(EXPOP); }
{bool_lit}	{ ECHO; return(BOOL_LITERAL); }
{real_lit}	{ ECHO; return(REAL_LITERAL); }

begin		{ ECHO; return(BEGIN_); }
end			{ ECHO; return(END); }
function	{ ECHO; return(FUNCTION); }
is			{ ECHO; return(IS); }
returns		{ ECHO; return(RETURNS); }

reduce		{ ECHO; return(REDUCE); }
endreduce	{ ECHO; return(ENDREDUCE); }

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
{arrow}		{ ECHO; return(ARROW); }
then		{ ECHO; return(THEN); }
when		{ ECHO; return(WHEN); }

real		{ ECHO; return(REAL); }
boolean		{ ECHO; return(BOOLEAN); }
integer		{ ECHO; return(INTEGER); }

{id}		{ ECHO; return(IDENTIFIER); }
{int}		{ ECHO; return(INT_LITERAL); }
{punc}		{ ECHO; return(yytext[0]); }
.			{ ECHO; appendError(LEXICAL, yytext); }
%%

// int main() {
// 	firstLine();
	
// 	FILE *file = fopen("lexemes.txt", "wa"); 
// 	int token = yylex();
// 	while (token) {
// 		fprintf(file, "%d %s\n", token, yytext);
// 		token = yylex();
// 	}
// 	lastLine();
// 	fclose(file);
// 	return 0;
// }