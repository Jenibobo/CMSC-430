/* Compiler Theory and Design
   Duane J. Jarc */

   // Code edited by: Jennifer McClintock
	// Date: 25 June 2022
	// Code edited in order to add the additional lexemes need for our course language.

   // Date: 18 July 2022
   // File edited in order at add individual oper tokens to operators, and value types to 
   // INT_LIT, BOOL_LIT, and REAL_LIT

/* This file contains flex input file */

%{

#include <string>

using namespace std;

#include "values.h"
#include "listing.h"
#include "tokens.h"

%}

%option noyywrap

ws			   [ \t\r]+
line		   [\n]
comment		(\-\-.*{line})|(\/\/.*{line}) 
id			   [A-Za-z]([_]?[A-Za-z0-9])*
digit		   [0-9]
punc		   [\(\),:;]

int_lit		[0-9]+
real_lit	   [0-9]*\.?[0-9]+([eE][+-]?[0-9]+)?

%%

{ws}		   { ECHO; }
{comment}	{ ECHO; nextLine(); }
{line}		{ ECHO; nextLine(); }

"<"		   { ECHO; yylval.oper = LESS; return(RELOP); }
">"         { ECHO; yylval.oper = GREATER; return(RELOP); }
"<="        { ECHO; yylval.oper = LESS_EQUAL; return(RELOP); }
">="        { ECHO; yylval.oper = GREATER_EQUAL; return(RELOP); }
"/="        { ECHO; yylval.oper = NOT_EQUAL; return(RELOP); }
"="         { ECHO; yylval.oper = EQUAL; return(RELOP); }

"+"		   { ECHO; yylval.oper = PLUS; return(ADDOP); }
"*"		   { ECHO; yylval.oper = MULTIPLY; return(MULOP); }
"-"         { ECHO; yylval.oper = MINUS; return(ADDOP); }
"/"         { ECHO; yylval.oper = DIVIDE; return(MULOP); }    
"**"        { ECHO; yylval.oper = POWER; return(EXPOP); }
rem         { ECHO; yylval.oper = MODULUS; return(REMOP); }

"=>"        { ECHO; return(ARROW); }

begin		   { ECHO; return(BEGIN_); }
end			{ ECHO; return(END); }
function	   { ECHO; return(FUNCTION); }
is			   { ECHO; return(IS); }
returns		{ ECHO; return(RETURNS); }

reduce		{ ECHO; return(REDUCE); }
endreduce	{ ECHO; return(ENDREDUCE); }

and			{ ECHO; return(ANDOP); }
or			   { ECHO; return(OROP); }
not			{ ECHO; return(NOTOP); }

if			   { ECHO; return(IF); }
else		   { ECHO; return(ELSE); }
endif		   { ECHO; return(ENDIF); }
then		   { ECHO; return(THEN); }

case		   { ECHO; return(CASE); }
endcase		{ ECHO; return(ENDCASE); }
others		{ ECHO; return(OTHERS); }
when		   { ECHO; return(WHEN); }

real		   { ECHO; return(REAL); }
boolean		{ ECHO; return(BOOLEAN); }
integer		{ ECHO; return(INTEGER); }

true        { ECHO; yylval.value = true; return(BOOL_LITERAL); }
false       { ECHO; yylval.value = false; return(BOOL_LITERAL); }

{id}		   { 
               ECHO; yylval.iden = (CharPtr)malloc(yyleng + 1); 
			      strcpy(yylval.iden, yytext); return(IDENTIFIER);
            }

{int_lit}   { ECHO; yylval.value = atoi(yytext); return(INT_LITERAL); }
{real_lit}  { ECHO; yylval.value = atof(yytext); return(REAL_LITERAL); }

{punc}		{ ECHO; return(yytext[0]); }
.		      { ECHO; appendError(LEXICAL, yytext); }

%%