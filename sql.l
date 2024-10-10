%{
#include "sql.tab.h"
%}

%option noyywrap

%%
"CREATE"            { return CREATE; }
"TABLE"             { return TABLE; }
"INT"               { return INT_TYPE; }
"VARCHAR"           { return VARCHAR_TYPE; }
"("                 { return LPAREN; }
")"                 { return RPAREN; }
","                 { return COMMA; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.str = strdup(yytext); return IDENTIFIER; }
[0-9]+              { yylval.num = atoi(yytext); return NUMBER; }
[ \t\n]+            { /* skip whitespace */ }
.                   { return yytext[0]; }

%%

