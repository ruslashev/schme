%{
	#include "schme.tab.h"
%}

identifier		[_a-zA-Z][_a-zA-Z0-9]*
integer			[\+\-]?[0-9]+
double			[\+\-]?[0-9]+\.[0-9]*

%option noyywrap

%%
[ \t\n\r]+				;
indentifier				{ yylval.sval = strdup(yytext);	return INDENT; }
integer					{ yylval.ival = atoi(yytext); 	return INTEGR; }
double					{ yylval.fval = atof(yytext); 	return DOUBLE; }
[-+*/()=]				{ return *yytext; }

%%

