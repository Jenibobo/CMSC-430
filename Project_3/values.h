// CMSC 430
// Duane J. Jarc

// This file contains function definitions for the evaluation functions

typedef char* CharPtr;
enum Operators {LESS, GREATER, LESS_EQUAL, GREATER_EQUAL, EQUAL, NOT_EQUAL, MULTIPLY, PLUS, MINUS, DIVIDE, MODULUS, POWER, CASE_ARROW};

int evaluateReduction(Operators operator_, int head, int tail);
int evaluateRelational(int left, Operators operator_, int right);
int evaluateArithmetic(int left, Operators operator_, int right);
int evaluate_ifThen(int expr, int if_stat, int else_stat);
int evaluate_caseStat(int case_list, int other_stat);
int eval_cases(int case_head, int case_tail);
int find_matched_case(int num, int case_stat);
void set_condition(int condition);
