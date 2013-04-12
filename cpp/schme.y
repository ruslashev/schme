%{
	#include "main.hpp"

	extern FILE *yyin;
	
	int yyparse();
	int yylex();
	void yyerror(const char* s);
%}

%union {
	int ival;
	char sym;
}

%start program
%token <ival> INTEGER
%type <ival> exp
%left PLUS
%left MINUS
%left MULT
%left DIV

%%

program:	
			| exp { cout << "Result: " << $1 << endl; }
			;

exp: 	INTEGER { $$ = $1; }
		| exp PLUS exp	{ $$ = $1 + $3; }
		| exp MINUS exp	{ $$ = $1 - $3; }
		| exp MULT exp	{ $$ = $1 * $3; }
		| exp DIV exp	{ $$ = $1 / $3; }
		;

%%

void yyerror(const char *s)
{
	int yylineno;
	char* yytext;

	fprintf(stderr, "Error: %s at line %i at symbol %s\n", s, yylineno, yytext);
	
	exit(1);
}

int main(int argc, char **argv)
{
	if (argc > 0)
	{
		FILE* ifile = freopen("testfile.shm", "r", stdin);
		yyin = ifile;

		while (!feof(yyin))
			yyparse();
	} else {
		yyin = stdin;
	}
	return 0;
}

