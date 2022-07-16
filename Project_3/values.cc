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
double matched_condition;
bool met_condition = false;

double evaluate_caseStat(double case_list, double other_stat) {
	if (met_condition == true) {
		met_condition = false;
		return matched_condition;
	} else {
		return other_stat;
	}
}

void find_matched_case(int num, double case_stat) {
	if (case_condition == num) {
		met_condition = true;
		matched_condition = case_stat;
	}
}

void set_condition(double condition) {
	case_condition = condition;
}


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
			}
			break;
		case MODULUS:
			if (left == 0 and right == 0) {
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
