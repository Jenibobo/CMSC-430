// Compiler Theory and Design
// Duane J. Jarc

// This file contains the bodies of the type checking functions

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

void set_returnVal(Types initail_returnVal) {
	returnVal = initail_returnVal;
	// printf("%4d", returnVal);
}

void check_return(Types end_returnVal) {
	if (returnVal != end_returnVal) {
		if (returnVal == INT_TYPE && end_returnVal == REAL_TYPE) {
			// printf("%4d", end_returnVal);
			appendError(GENERAL_SEMANTIC, "Narrowing Variable Initialization: REAL is forced into INT");
		}
		if (returnVal == BOOL_TYPE && end_returnVal == REAL_TYPE) {
			// printf("%4d", end_returnVal);
			appendError(GENERAL_SEMANTIC, "Type Mismatch: BOOL is not REAL");
		}
		if (returnVal == BOOL_TYPE && end_returnVal == INT_TYPE) {
			// printf("%4d", end_returnVal);
			appendError(GENERAL_SEMANTIC, "Type Mismatch: BOOL is not INT");
		}
		if (returnVal == INT_TYPE && end_returnVal == BOOL_TYPE) {
			// printf("%4d", end_returnVal);
			appendError(GENERAL_SEMANTIC, "Type Mismatch: INT is not BOOL");
		}
		if (returnVal == REAL_TYPE && end_returnVal == BOOL_TYPE) {
			// printf("%4d", end_returnVal);
			appendError(GENERAL_SEMANTIC, "Type Mismatch: REAL is not BOOL");
		}
	}
}

Types check_ifStatemant(Types expr, Types ifStat, Types elseStat) {
	if (expr != BOOL_TYPE) {
		appendError(GENERAL_SEMANTIC, "If expresstion must be a Boolean.");
		return MISMATCH;
	}
	if ((ifStat != BOOL_TYPE) || (elseStat != BOOL_TYPE)){
		// printf("%4d", ifStat);
		// printf("%4d", elseStat);
		appendError(GENERAL_SEMANTIC, "IF type and ELSE type are mis-matched");
		return MISMATCH;
	}
	return BOOL_TYPE;
}

void check_caseExpr(Types expr) {
	if (expr != INT_TYPE) {
		appendError(GENERAL_SEMANTIC, "Case expression must be an Integer");
	}
	case_is_int = true;
}

void store_prev_case(Types prev_caseStat) {
	saved_case = prev_caseStat;
	// printf("%4d", saved_case);
}

void check_caseStatment(Types caseAssin) {
	// printf("%4d", caseAssin);

	if (case_is_int == true) {
		if (saved_case != caseAssin) {
			appendError(GENERAL_SEMANTIC, "Case Types do not match.");
			case_is_int = false;
		}
	}
}

Types checkArithmetic(Types left, Types right) {
	if (left == MISMATCH || right == MISMATCH) {
		return MISMATCH;
	}
	if (left == BOOL_TYPE || right == BOOL_TYPE) {
		appendError(GENERAL_SEMANTIC, "Integer Type Required");
		return MISMATCH;
	}
	if (left == REAL_TYPE || right == REAL_TYPE){
			return REAL_TYPE;
	}
	return INT_TYPE;
}


Types checkLogical(Types left, Types right)
{
	if (left == MISMATCH || right == MISMATCH) {
		return MISMATCH;
	}
	if (left != BOOL_TYPE || right != BOOL_TYPE) {
		appendError(GENERAL_SEMANTIC, "Boolean Type Required");
		return MISMATCH;
	}	
	return BOOL_TYPE;
	// return MISMATCH;
}

Types checkRelational(Types left, Types right)
{
	if (checkArithmetic(left, right) == MISMATCH) {
		return MISMATCH;	
	}
	return BOOL_TYPE;
}
