// CMSC 430
// Duane J. Jarc

// This file contains the bodies of the evaluation functions

// Edited by: Jennifer McClintock
// Date: 18 July 2022
// Added funtions that allow evaluation of case, and if statements. Along with added the remaining 
// logic, arithmetic, and relation operators. 


#include <string>
#include <vector>
#include <cmath>

using namespace std;

#include "values.h"
#include "listing.h"

int case_condition;
double matched_condition;
bool met_condition = false;

// This function will return either the matching case staement or the others statement. 
// If met_condition is true, then a condition has been found and met_condition is set 
// back to false, and matched_condition is returned. Otherwise, the others statement is
// returned.
double evaluate_caseStat(double case_list, double other_stat) {
	if (met_condition == true) {
		met_condition = false;
		return matched_condition;
	} else {
		return other_stat;
	}
}

// Attempts to find a matching case to the case condtion. If one is found 
// then met_condtion is set to true and the case statement is assigned to 
// matched condition.
void find_matched_case(int num, double case_stat) {
	if (case_condition == num) {
		met_condition = true;
		matched_condition = case_stat;
	}
}

// Sets the case condition that needs to be met for case statement
void set_condition(double condition) {
	case_condition = condition;
}

// Checks to see if the if statement is true, if true then return if statement.
// Otherwise, return else statement.
double evaluate_ifThen(int expr, double if_stat, double else_stat) {
	if (expr == 1) {
		return if_stat;
	} else {
		return else_stat;
	}
}

double evaluateReduction(Operators operator_, double head, double tail) {
	if (operator_ == PLUS)
		return head + tail;
	return head * tail;
}


double evaluateRelational(double left, Operators operator_, double right) {
	double result;
	switch (operator_)
	{
		case LESS:
			result = left < right;
			break;
		case GREATER:
			result = left > right;
			break;
		case LESS_EQUAL:
			result = left <= right;
			break;
		case GREATER_EQUAL:
			result = left >= right;
			break;
		case EQUAL:
			result = left == right;
			break;
		case NOT_EQUAL:
			result = left != right;
			break;
	}
	return result;
}

double evaluateArithmetic(double left, Operators operator_, double right) {
	double result;
	switch (operator_)
	{
		case PLUS:
			result = left + right;
			break;
		case MULTIPLY:
			result = left * right;
			break;
		case MINUS:
			result = left - right;
			break;
		case DIVIDE:
			if (right != 0) {
				result = left / right;
			} else{
				printf("ZeroDivisionError"); // ZeroDivisionError. Won't error, but it will notify
			}
			break;
		case MODULUS:
			if (left == 0 and right == 0) {// Condition so program doesn't error.
				result = 0;
			} else {
				result = fmod(left, right);
			}
			break;
		case POWER:
			result = pow(left, right);
			break;
	}
	return result;
}
