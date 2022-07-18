// CMSC 430
// Duane J. Jarc

// This file contains function definitions for the evaluation functions

// Edited by: Jennifer McClintock
// Date: 18 July 2022
// Declaring the four new functions added to the value.cc file, and the additional tokens
//      - double evaluate_ifThen
//      - double evaluate_caseStat
//      - void find_matched_case
//      - void set_condition


typedef char* CharPtr;
enum Operators {LESS, GREATER, LESS_EQUAL, GREATER_EQUAL, EQUAL, NOT_EQUAL, MULTIPLY, PLUS, MINUS, DIVIDE, MODULUS, POWER, CASE_ARROW};

double evaluateReduction(Operators operator_, double head, double tail);
double evaluateRelational(double left, Operators operator_, double right);
double evaluateArithmetic(double left, Operators operator_, double right);
double evaluate_ifThen(int expr, double if_stat, double else_stat);
double evaluate_caseStat(double total_cases, double other_stat);
void find_matched_case(int num, double case_stat);
void set_condition(double condition);
