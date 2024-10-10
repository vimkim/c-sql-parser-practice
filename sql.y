%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex(void);

typedef struct Column {
    char *name;
    char *type;
    struct Column *next;
} Column;

Column *column_list = NULL;

void add_column(char *name, char *type);
void print_columns();

%}

%union {
    char *str;
    int num;
}

%token CREATE TABLE INT_TYPE VARCHAR_TYPE LPAREN RPAREN COMMA
%token <str> IDENTIFIER
%token <num> NUMBER

%type <str> type

%%
stmt: 
    CREATE TABLE IDENTIFIER LPAREN column_list RPAREN { printf("Table '%s' created.\n", $3); print_columns(); }
    ;

column_list: 
    column_list COMMA column 
    | column 
    ;

column: 
    IDENTIFIER type { add_column($1, $2); }
    ;

type: 
    INT_TYPE { $$ = "INT"; } 
    | VARCHAR_TYPE LPAREN NUMBER RPAREN { 
        $$ = (char *)malloc(20); 
        sprintf($$, "VARCHAR(%d)", $3); 
    } 
    ;
%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

void add_column(char *name, char *type) {
    Column *col = (Column *)malloc(sizeof(Column));
    col->name = name;
    col->type = type;
    col->next = column_list;
    column_list = col;
}

void print_columns() {
    Column *col = column_list;
    while (col != NULL) {
        printf("Column: %s, Type: %s\n", col->name, col->type);
        col = col->next;
    }
}

