%{
	#include "schme.tab.hpp"
	#include "main.hpp"

	int yylex();
	void yyerror(const char* s);
	
//identifier		[_a-zA-Z][_a-zA-Z0-9]*
//integer			[\+\-]?[0-9]+
//double			[\+\-]?[0-9]+\.[0-9]*

//[-+*/()]				{ return *yytext; }
%}

%%

[ \t]+					;
[0-9]+					{ yylval.ival = atoi(yytext); return INTEGER; }
[\n]					{ yylineno++; }
"+"						{ yylval.sym = '+'; return PLUS; }
"-"						{ yylval.sym = '-'; return MINUS; }
"*"						{ yylval.sym = '*'; return MULT; }
"/"						{ yylval.sym = '/'; return DIV; }
.						{ yyerror("unrecognized token"); } 	

%%

