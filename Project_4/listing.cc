// Compiler Theory and Design
// Dr. Duane J. Jarc

// This file contains the bodies of the functions that produces the compilation
// listing

// Code edited by: Jennifer McClintock
// Date: 25 June 2022
// Code edited to be able to tally the number of lex, syn, and sem errors found in 
// the course's made up language. The error type is added to the error array and then
// incrmented if additionals are found before being displayed in the print statment.

#include <cstdio>
#include <string>
#include <queue>
#include <iostream>

using namespace std;

#include "listing.h"

static int lineNumber;
static int totalErrors = 0;
static queue<string> errors;
static int error_arr[] = {0, 0, 0, 0, 0}; // index_0=lex_err, index_1=syntax_err, indexs_2,3,4=sem_err

static void displayErrors();

void firstLine() {
	lineNumber = 1;
	printf("\n%4d  ",lineNumber);
}

void nextLine() {
	displayErrors();
	lineNumber++;
	printf("%4d  ",lineNumber);
}

int lastLine() {
	printf("\r");
	displayErrors();
	printf("     \n");

	totalErrors = error_arr[0] + error_arr[1] + error_arr[2];

	if (totalErrors == 0) {
		printf("Compiled Sucessfully!\n");
	} else {
		printf(" Lexical Errors: %4d\n", error_arr[0]);
		printf(" Sytax Errors: %4d\n", error_arr[1]);
		printf(" Semantic Errors: %4d\n", error_arr[2]);
		printf(" Total num. of errors: %4d\n", totalErrors);
	}

	return totalErrors;
}
    
void appendError(ErrorCategories errorCategory, string message) {
	string messages[] = { 
		"Lexical Error, Invalid Character ", 
		"Syntax Error, ",
		"Semantic Error, ",
		"Semantic Error, Duplicate Identifier: ",
		"Semantic Error, Undeclared " 
		};

	errors.push(messages[errorCategory] + message + "\n");

	if (errorCategory >= 2) {
		error_arr[2]++;
	} else {
		error_arr[errorCategory]++;
	}
}

void displayErrors() {
	while (!errors.empty()){
		printf("%s", errors.front().c_str());
		errors.pop();
	}
}