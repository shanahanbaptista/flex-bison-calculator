%{
#include <stdio.h>
#include <stdlib.h>

%}
%{
	int yylex();
	int yyerror(const char *s);
%}

%union { 
struct {
	char name[50];
	int type;
	float value;
} s;
int int_val;
float float_val;
}

%token TOK_SEMICOLON TOK_SUB TOK_MUL TOK_PRINTID TOK_PRINTEXP TOK_MAIN TOK_LB TOK_RB TOK_ASSIGN INT FLOAT

%token <s> TOK_ID
%type <s> Stmt
%type <s> Expr 
%left TOK_SUB
%left TOK_MUL 


//%start Main

%%
Prog:
		TOK_MAIN TOK_LB Vardefs Stmts TOK_RB;
;
Vardefs:
		/*No variable defined*/
		|
		Vardef TOK_SEMICOLON Vardefs;
;
Vardef:		INT TOK_ID 
		{
			//TOK_ID.type = 1;
			fprintf(stdout, "type int: \n");
		}
		|
		FLOAT TOK_ID
		{
			//TOK_ID.type = 2;
			fprintf(stdout, "type float: %f \n", $2);
		}
		
;
Stmts: 
| Stmt Stmts
;
Stmt:
		
		{
			fprintf(stdout, "unable to read\n");
		}
		/*FLOAT TOK_ID TOK_ASSIGN Expr
		| 
		{
			fprintf(stdout, "statement assignment \n");
			//if(TOK_ID.type != Expr.type) then type-error;
		}
		|*/			
		TOK_PRINTID TOK_ID
		{
			fprintf(stdout, "PrintId: The value is \n");			
		}
		|
		TOK_PRINTEXP Expr 
		{
			fprintf(stdout, "PrintExpr: The value is %f\n",$<s.value>2);
		}
					
;
Expr:	TOK_ID
		{
			fprintf(stdout, "in tok id:\n");
			$<s.value>$ = $<s.value>1;
		}
		|
		Expr TOK_SUB Expr
	  	{		
			fprintf(stdout, "in tok sub:\n");
			$<s.value>$ = $<s.value>1 - $<s.value>3;  		
		}
		| 
		Expr TOK_MUL Expr
	  	{
			fprintf(stdout, "in tok mul:\n");
			$<s.value>$ = $<s.value>1 * $<s.value>3;			
		}
		
		
;				

%%

int yyerror(const char *s)
{
	printf("syntax error: %c\n", *s);
;
	return 0;
}


int main()
{
   yyparse();
   return 0;
}

