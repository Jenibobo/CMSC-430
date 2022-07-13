// CMSC 430
// Duane J. Jarc

// This file contains the bodies of the evaluation functions

#include <string>
#include <vector>
#include <cmath>

using namespace std;

#include "values.h"
#include "listing.h"

int evaluateIf(){

}

int evaluateCase(){

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
				printf("Zero_Division_Error: Cannot divide by zero.");
			}
			break;
		case MODULUS:
			result = left % right;
			break;
		case POWER:
			result = pow(right, left);
			break;
	}
	return result;
}
