// Compiler Theory and Design
// Dr. Duane J. Jarc

// This file contains the bodies of the functions that produces the compilation
// listing

#include <cstdio>
#include <string>
#include <queue>


using namespace std;

#include "listing.h"

static int lineNumber;
// static string error = "";
static int totalErrors = 0;
static queue<string> error;
static int error_arr[] = {0, 0, 0}; // index_0=lex_err, index_1=syntax_err, index_2=sem_err

// static int lex_err = 0; // Added var for lexical error count
// static int syntax_err = 0; // Added var for syntax error count
// static int sem_err = 0; // Added var for semantic error count

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
	}

	printf("%4d", totalErrors);
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
	error.push(messages[errorCategory] + message+"\n");
	error_arr[errorCategory]++;

}

void displayErrors() {
	while (!error.empty()){
		printf("%s\n", error.front().c_str());
		error.pop();
	}
}
