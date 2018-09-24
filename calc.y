%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <math.h>
	struct s s;
	extern int line_no;
%}
%{
	int yylex();
	int yyerror(const char *s);
	int typeerror(const char *s);
%}

%union {
	struct s{
		int id_type;
		int expr_type;
		double value;
	} s;
	int int_val;
	float float_val;
	float result_val;
	char name_val;
}

%token TOK_SEMICOLON TOK_SUB TOK_MUL TOK_PRINTID TOK_PRINTEXP TOK_MAIN TOK_LB TOK_RB TOK_ASSIGN TOK_ID

%token TOK_TYPEINT TOK_TYPEFLOAT

%token<int_val> INT
%token<float_val> FLOAT

%type <result_val> expr
%type <int_val> TOK_ID

%left TOK_SUB
%left TOK_MUL

%%
Prog:	/*Null condition*/
		|
		TOK_MAIN TOK_LB Vardefs Stmts TOK_RB;
;

Vardefs:
		/*No variables defined*/
		|
		Vardef TOK_SEMICOLON Vardefs;
;

Vardef:	TOK_TYPEINT TOK_ID
		{
			s.id_type = 1;
		}
		|
		TOK_TYPEFLOAT TOK_ID
		{
			s.id_type = 2;
		}
;

Stmts:
		/*No statements defined*/
		|
		Stmt TOK_SEMICOLON Stmts
;

Stmt:
		TOK_ID TOK_ASSIGN expr
		{
			if(s.id_type != 1 && s.id_type != 2)
			{
				return typeerror("Variable is used but not declared");
			}
			if(s.id_type != s.expr_type)
			{
				fprintf(stdout, "Type error EXP: %d ID: %d\n", s.expr_type, s.id_type);
				return typeerror("Type error");
			}

		}
		|
		TOK_PRINTID TOK_ID
		{
			fprintf(stdout, "The value is: %.2f \n", s.value);
		}
		|
		TOK_PRINTEXP expr
		{
			fprintf(stdout, "The value is %.2f\n",s.value);
		}
		|
		{
			fprintf(stdout, "Unable to read statement\n");
		}

;
expr:
		INT
		{
			s.expr_type = s.id_type;
			$<result_val>$ = (float)$1;
			s.value = (float)$1;
		}
		|
		FLOAT
		{
			s.expr_type = s.id_type;
			$<result_val>$ = (float)$1;
			s.value = (float)$1;
		}
		|
		TOK_ID
		{
			s.expr_type = s.id_type;
			$<result_val>$ = s.value;
		}
		|
		expr TOK_MUL expr
	  	{
			$<result_val>$ = (float)$1 * (float)$3;
			s.value = (float)$1 * (float)$3;
		}
		|
		expr TOK_SUB expr
	  	{
			s.value = (float)$1 - (float)$3;
			$<result_val>$ = s.value;
		}
		|
		{
			fprintf(stdout, "Unable to find a match\n");
		}
;

%%

int typeerror(const char *s)
{
	printf("Line %d: %s\n", line_no, s);
	return 0;
}

int yyerror(const char *s)
{
	printf("Parsing error: Line %d\n", line_no);
	return 0;
}


int main()
{
   yyparse();
   return 0;
}
