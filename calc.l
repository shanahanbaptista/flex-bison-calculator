%option noyywrap
%{
#include <stdio.h>
#include <math.h>
#include "calc.tab.h"
int line_no = 1;
%}

digit	([0-9])

/*// [0-9]+|[0-9]*\.[0-9]+
	Grammar Rules
	[\t] - Match spaces or tabs
	[\n] - Match new lines
	{digit}+ - Match integers
	{digit}+\.{digit}+ - Match combination of numbers including decimals
	. - Match any remaining character

*/

%%
[ \t]	{}
[ \n]   {line_no++;}

"main()"	{
	return(TOK_MAIN);
	}

"{"	{
	return(TOK_LB);
	}
"}"	{
	return(TOK_RB);
	}


{digit}+	{
		sscanf(yytext, "%d", &yylval.int_val);
		return(INT);
		}

{digit}+\.{digit}+	{
			sscanf(yytext, "%f", &yylval.float_val);
			return(FLOAT);
			}

{digit}+[eE]{digit}+	{
			sscanf(yytext, "%f", &yylval.float_val);
			return(FLOAT);
			}

{digit}+\.{digit}+[E]{digit}+	{
				sscanf(yytext, "%f", &yylval.float_val);
				return(FLOAT);
				}

"int"	{
					return TOK_TYPEINT;
				}

"float"	{
				return TOK_TYPEFLOAT;
				}

"printID"	{
				return TOK_PRINTID;
				}

"printExp"	{
				return TOK_PRINTEXP;
				}
[a-zA-Z]	{
					sscanf(yytext, "%c", &yylval.name_val);
					return TOK_ID;
					}

";"	{
	return(TOK_SEMICOLON);
	}

"-"	{
	return(TOK_SUB);
	}

"*"	{
	return(TOK_MUL);
	}

"="	{
	return(TOK_ASSIGN);
	}

[0-9][a-zA-Z0-9]*	{fprintf(stderr,"Lexical Error: '%s'\n",yytext);}
[A-Z][a-zA-Z0-9]*	{fprintf(stderr,"Lexical Error: '%s'\n",yytext);}

.	{
	printf("Lexical Error: '%c'\n", yytext[0]);
	}

%%
