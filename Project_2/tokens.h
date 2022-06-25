// Compiler Theory and Design
// Dr. Duane J. Jarc

// Code edited by: Jennifer McClintock
// Date: 25 June 2022
// Code edited to add the addition tokens used by the lex file.

enum Tokens {
	RELOP = 256, 
	ADDOP, 
	MULOP, 
	ANDOP, 
	BEGIN_, 
	BOOLEAN, 
	END, 
	ENDREDUCE,
	FUNCTION, 
	INTEGER, 
	IS, 
	REDUCE, 
	RETURNS, 
	IDENTIFIER, 
	INT_LITERAL,

	// Added 16 tokens by JM
	ARROW,
	CASE,
	ELSE,
	ENDCASE,
	ENDIF,
	IF,
	OTHERS,
	REAL,
	THEN,
	WHEN,
	OROP,
	NOTOP,
	REMOP,
	EXPOP,
	REAL_LITERAL,
	BOOL_LITERAL
};
