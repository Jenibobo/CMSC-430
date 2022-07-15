// CMSC 430
// Duane J. Jarc

// This file contains the bodies of the evaluation functions

#include <string>
#include <vector>
#include <cmath>

using namespace std;

#include "values.h"
#include "listing.h"

int case_condition;
int total_cases;

bool met_condition = false;

int evaluate_ifThen(int expr, int if_stat, int else_stat) {
	if (expr == 1) {
		return if_stat;
	} else {
		return else_stat;
	}
}

void set_condition(int condition) {
	case_condition = condition;
}

int evaluate_caseStat(int case_list, int other_stat) {
	// case_condition = expr;
	printf("%4d\n", case_condition);
	if (met_condition == true) {
		met_condition = false;
		return total_cases;
	} else {
		return other_stat;
	}
}

int eval_cases(int case_head, int case_tail) {
	total_cases = case_head + case_tail;
	return total_cases;
}

int find_matched_case(int num, int case_stat) {
	if (case_condition == num) {
		met_condition = true;
		return case_stat;
	} else {
		return 0;
	}
}

int evaluateReduction(Operators operator_, int head, int tail) {
	if (operator_ == PLUS)
		return head + tail;
	return head * tail;
}


int evaluateRelational(int left, Operators operator_, int right) {
	int result;
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

int evaluateArithmetic(int left, Operators operator_, int right) {
	int result;
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
			} else {
				printf("\nZero_Division_Error: Cannot divide by zero.");
			}
			break;
		case MODULUS:
			result = left % right;
			break;
		case POWER:
			result = pow(left, right);
			break;
	}
	return result;
}
