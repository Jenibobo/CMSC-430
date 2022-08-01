// Compiler Theory and Design
// Duane J. Jarc

// This file contains the bodies of the type checking functions

#include <string>
#include <vector>

using namespace std;

#include "types.h"
#include "listing.h"

bool case_is_int = false;
int saved_case;

void checkAssignment(Types lValue, Types rValue, string message)
{
	if (lValue != MISMATCH && rValue != MISMATCH && lValue != rValue) {
		appendError(GENERAL_SEMANTIC, "Type Mismatch on " + message);
	}
}

Types set_returnVal(Types returnType) {
	if (returnType == INT_TYPE) {
		return INT_TYPE;
	}else if (returnType == BOOL_TYPE) {
		return BOOL_TYPE;
	} else {
		return REAL_TYPE;
	}
}

Types check_ifStatemant(Types expr, Types ifStat, Types elseStat) {
	if (expr != BOOL_TYPE) {
		appendError(GENERAL_SEMANTIC, "If expresstion must be a Boolean.");
		return MISMATCH;
	}
	if ((ifStat != BOOL_TYPE) || (elseStat != BOOL_TYPE)){
		printf("%4d", ifStat);
		printf("%4d", elseStat);
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
	printf("%4d", saved_case);
}

void check_caseStatment(Types caseAssin) {
	if (case_is_int == true) {
		if (saved_case != caseAssin) {
			appendError(GENERAL_SEMANTIC, "Case Types do not match.");
			case_is_int = false;
		}
	}
	printf("%4d", caseAssin);
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
	return MISMATCH;
}

Types checkRelational(Types left, Types right)
{
	if (checkArithmetic(left, right) == MISMATCH) {
		return MISMATCH;	
	}
	return BOOL_TYPE;
}
