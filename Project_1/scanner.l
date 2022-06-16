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
comment		\-\-.*\n
line		[\n]
second_comment	"//"(.){line}
id			[A-Za-z][A-Za-z0-9]*
digit		[0-9]
int			{digit}+
punc		[\(\),:;]
real_lit	{int}(.){digit}*([eE][+-]?{int})?

%%

{ws}		{ ECHO; }
{comment}	{ ECHO; nextLine(); }
{second_comment}	{ ECHO; nextLine(); }
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
boolean		{ ECHO; return(BOOLEAN); }
end			{ ECHO; return(END); }
endreduce	{ ECHO; return(ENDREDUCE); }
function	{ ECHO; return(FUNCTION); }
integer		{ ECHO; return(INTEGER); }
is			{ ECHO; return(IS); }
reduce		{ ECHO; return REDUCE; }
returns		{ ECHO; return(RETURNS); }

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
real		{ ECHO; return(REAL); }
then		{ ECHO; return(THEN); }
when		{ ECHO; return(WHEN); }

true		{ ECHO; return(BOOL_LITERAL); }
false		{ ECHO; return(BOOL_LITERAL); }

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