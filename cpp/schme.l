%{
	#include "schme.tab.hpp"
	#include "main.hpp"

	int yylex();
	void yyerror(const char* s);
%}

identifier		[_a-zA-Z][_a-zA-Z0-9]*
integer			[\+\-]?[0-9]+
float			[\+\-]?[0-9]+\.[0-9]*

%%

[ \t]+					;
identifier				{ yylval.sval = new string(yytext, yyleng); return INDENT; }
integer					{ yylval.ival = atoi(yytext); return INTEGER; }
float					{ yylval.fval = atof(yytext); return FLOAT; }
\n						{ yylineno++; }
[+\-*/(){}<>.,]|!=|==|=	{ yylval.sym = strdup(yytext); return *yytext; }
.+						{ yyerror("unrecognized token"); } 	

%%

