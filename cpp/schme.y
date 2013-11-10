%{
	#include "main.hpp"
	#include <fstream>
	#include <iostream>
	#include <string>
	#include <cstdio>

	using namespace std;

	extern FILE *yyin;
	
	int yyparse();
	int yylex();
	void yyerror(const char* s);
%}

%union {
	int ival;
	float fval;
	char *sym;
	std::string *sval;
}

%token <sval> INDENT
%token <ival> INTEGER
%token <fval> FLOAT
%type <ival> exp
%left '+'
%left '-'
%left '*'
%left '/'

%start program

%%

program:	
		| exp { cout << "Result: " << $1 << endl; }
		;

exp: 	INTEGER { $$ = $1; }
		| exp '+' exp	{ $$ = $1 + $3; }
		| exp '-' exp	{ $$ = $1 - $3; }
		| exp '*' exp	{ $$ = $1 * $3; }
		| exp '/' exp	{ $$ = $1 / $3; }
		;

%%

void yyerror(const char *s)
{
	extern int yylineno;
	extern char *yytext;

	fprintf(stderr, "Error: %s at line %i at symbol \"%s\"\n", s, yylineno, yytext);
	
	exit(1);
}

int main(int argc, char **argv)
{
	if (argc > 1)
	{
		FILE* ifile = freopen(argv[1], "r", stdin);
		yyin = ifile;

		while (!feof(yyin))
			yyparse();
	} else {
		yyin = stdin;
		yyparse();
	}
	return 0;
}

