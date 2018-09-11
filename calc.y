%{
#include <stdio.h>
%}

%{
int yylex();
void yyerror(char *s);
%}

%token TOK_SEMICOLON TOK_SUB TOK_MUL TOK_NUM TOK_PRINTLN

%union{
        int int_val;
}

%type <int_val> expr TOK_NUM

%left TOK_SUB
%left TOK_MUL

%%

expr_stmt:
	   expr TOK_SEMICOLON
	   | TOK_PRINTLN expr TOK_SEMICOLON
		{
			fprintf(stdout, "the value is %d\n", $2);
		}
;

expr:
	 expr TOK_SUB expr
	  {
		$$ = $1 - $3;
	  }
	| expr TOK_MUL expr
	  {
		$$ = $1 * $3;
	  }
	| TOK_NUM
	  {
		$$ = $1;
	  }
;


%%

void yyerror(char *s)
{
	printf("syntax error\n");

}

int main()
{
   yyparse();
   return 0;
}
