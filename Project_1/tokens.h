// Compiler Theory and Design
// Dr. Duane J. Jarc

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
	EXEOP,
	REAL_LITERAL,
	BOOL_LITERAL
};
