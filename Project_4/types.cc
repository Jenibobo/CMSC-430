// Compiler Theory and Design
// Duane J. Jarc

// This file contains the bodies of the type checking functions

// Code edited by: Jennifer McClintock
// Date: 02 August 2022
// This file was edited to add additional functions that will 
// identify mis-matched types for our course language. These functions 
// will be used in conjuction with the parser.y file when reading 
// the different vars, params, and statements. 

#include <string>
#include <vector>

using namespace std;

#include "types.h"
#include "listing.h"

bool case_is_int = false;
Types saved_case;
Types returnVal;

void checkAssignment(Types lValue, Types rValue, string message)
{
	if (lValue != MISMATCH && rValue != MISMATCH && lValue != rValue) {
		appendError(GENERAL_SEMANTIC, "Type Mismatch on " + message);
	}
}

void duplicate_var(string iden_var) {
	appendError(GENERAL_SEMANTIC, "Duplicate Indentifier: " + iden_var);
}

void set_returnVal(Types initial_return) {
	returnVal = initial_return;
	// printf("%4d", returnVal);
}

void check_return(Types end_returnVal) {
	// printf("%4d", end_returnVal);
	// printf("%4d", returnVal);
	if (returnVal != end_returnVal) {
		if (returnVal == INT_TYPE && end_returnVal == REAL_TYPE) {
			// printf("%4d", end_returnVal);
			appendError(GENERAL_SEMANTIC, "Narrowing Variable Initialization: REAL is forced into INT");
		}
		if (returnVal == BOOL_TYPE && (end_returnVal == REAL_TYPE || end_returnVal == INT_TYPE)) {
			// printf("%4d", end_returnVal);
			appendError(GENERAL_SEMANTIC, "Return Type Mismatch: INT or REAL is not BOOL Type");
		}
		if ((returnVal == INT_TYPE || returnVal == REAL_TYPE) && end_returnVal == BOOL_TYPE) {
			appendError(GENERAL_SEMANTIC, "Return Type Mismatch:  BOOL is not INT or REAL Types");
		}
	}
}

void check_ifExpr(Types expr) {
	if (expr != BOOL_TYPE) {
		appendError(GENERAL_SEMANTIC, "If expresstion must be a Boolean.");
	}
}

Types check_ifStatemant(Types ifStat, Types elseStat) {

	if (ifStat != elseStat){
		// printf("%4d", ifStat);
		// printf("%4d", elseStat);
		appendError(GENERAL_SEMANTIC, "IF type and ELSE types are mis-matched");
		return MISMATCH;
	}
	return BOOL_TYPE;
}

void check_caseExpr(Types expr) {
	if (expr != INT_TYPE) {
		appendError(GENERAL_SEMANTIC, "Case expression must be an INT");
	}
}

void store_prev_case(Types caseType) {
	saved_case = caseType;
	// printf("%4d", saved_case);
}

void check_caseStatment(Types caseAssin) {
	// printf("%4d", caseAssin);

	if (saved_case == BOOL_TYPE && (caseAssin == INT_TYPE || caseAssin == REAL_TYPE)) {
		appendError(GENERAL_SEMANTIC, "Case Type Mis-Match: Previous case BOOL is not same Type as current");
			case_is_int = false;
	}
	if ((saved_case == INT_TYPE || saved_case == REAL_TYPE) && caseAssin == BOOL_TYPE ) {
		appendError(GENERAL_SEMANTIC, "Case Type Mis-Match: Previous case INT or REAL is not same Type as current");
			case_is_int = false;
	}
	
}

Types checkArithmetic(Types left, Types right) {
	if (left == MISMATCH || right == MISMATCH) {
		return MISMATCH;
	}
	if (left == BOOL_TYPE || right == BOOL_TYPE) {
		appendError(GENERAL_SEMANTIC, "INT Type Required: Boolean Expression cannot be used with Arithmetic Operators");
		return MISMATCH;
	}
	if (left == REAL_TYPE || right == REAL_TYPE){
			return REAL_TYPE;
	}
	return INT_TYPE;
}

void check_remOP(Types l_val, Types r_val) {
	if (l_val != INT_TYPE || r_val != INT_TYPE) {
		appendError(GENERAL_SEMANTIC, "Only INT types can only be used with Remainder operator.");
	}
}


Types checkLogical(Types left, Types right)
{
	if (left == MISMATCH || right == MISMATCH) {
		return MISMATCH;
	}
	if (left != BOOL_TYPE || right != BOOL_TYPE) {
		appendError(GENERAL_SEMANTIC, "BOOL Type Required: Arithmatic expressions cannot be used with Logical operators.");
		return MISMATCH;
	}	
	return BOOL_TYPE;
	// return MISMATCH;
}

Types checkRelational(Types left, Types right)
{
	if (checkArithmetic(left, right) == MISMATCH) {
		appendError(GENERAL_SEMANTIC, "INT Type Required: Boolean Expression cannot be used with Relational Operators");
		return MISMATCH;	
	}
	return BOOL_TYPE;
}
