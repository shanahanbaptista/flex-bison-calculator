%{
#include <stdio.h>
#include "calc.tab.h"
#include "valType.h"
%}

digit	([0-9])

/* 
	Grammar Rules
	[\t] - Match spaces or tabs
	[\n] - Match new lines
	{digit}+ - Match integers
	{digit}+\.{digit}+ - Match combination of numbers including decimals
	. - Match any remaining character
	
*/

%%
[ \t]	{}
[ \n]   {}

"main()"	{
	return(TOK_MAIN); //?? Don't know what to do  with the main. so for now just returning main 				  //token
	}

"{"	{
	return(TOK_LB);	
	}
"}"	{
	return(TOK_RB);
	}
"="	{
	return(TOK_ASSIGN);
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
					return INT;
				}
"float"	{
				return FLOAT;
				}
"printID"	{
				return TOK_PRINTID;
				}
				
"printExp"	{
				return TOK_PRINTEXP;
				}
[a-zA-Z]	{
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

.	{
	printf("Invalid character '%c', ignored\n", 
			yytext[0]);
	}

%%



