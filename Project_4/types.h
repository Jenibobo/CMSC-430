// Compiler Theory and Design
// Duane J. Jarc

// This file contains type definitions and the function
// prototypes for the type checking functions

typedef char* CharPtr;

enum Types {MISMATCH, INT_TYPE, BOOL_TYPE, REAL_TYPE};

void checkAssignment(Types lValue, Types rValue, string message);
void duplicate_var(string iden_var);
void set_returnVal(Types initail_returnVal);
void check_return(Types end_returnVal);

Types checkArithmetic(Types left, Types right);
void check_remOP(Types l_val, Types r_val);
Types checkLogical(Types left, Types right);
Types checkRelational(Types left, Types right);

void check_ifExpr(Types expr);
Types check_ifStatemant(Types ifStat, Types elseStat);

void check_caseExpr(Types expr);
void check_caseStatment(Types caseAssin);
void store_prev_case(Types prev_caseStat);