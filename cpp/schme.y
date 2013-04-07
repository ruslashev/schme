%{
	#include <fstream>
	#include <string>
	#include <cstdlib>
	
	using namespace std;

	void yyerror(const char* s) { fprintf(stderr, "Error: %s", s); exit(1); }

	extern int yylex();
	extern int yyparse();
	extern FILE *yyin;
%}

%token <sval> INDENT
%token <ival> INTEGR
%token <fval> DOUBLE
%left '-' '+' '*' '/'

%union {
	char* sval;
	int ival;
	float fval;
}

%%

program:
	program statement '\n'
	|
	;

statement:
	INDENT expr { printf("String!: %s\n", $1); }
	| INTEGR expr { printf("Integer!: %d\n", $1); }
	| DOUBLE expr { printf("Double!: %f\n", $1); }
	;

expr:
	INTEGR
	| DOUBLE
	;
// 	| expr '+' expr { $$ = $1 + $3; }
// 	| expr '-' expr { $$ = $1 - $3; }
// 	| expr '*' expr { $$ = $1 * $3; }
// 	| expr '/' expr { $$ = $1 / $3; }
// 	| '(' expr ')' { $$ = $2; }
// 	;

%%

int main()
{
	FILE* ifile = fopen("testfile.shm", "r");
	if (!ifile) {
		fprintf(stderr, "No file %s found!\n", "testfile.shm");
		return 1;
	}
	// let flex read from a file instead of STDIN:
	yyin = ifile;

	while (!feof(yyin))
		yyparse();
}

