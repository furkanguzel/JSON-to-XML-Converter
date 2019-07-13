%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
int linenum = 1;
%}
%%	

"true"                  {yylval.string = strdup(yytext);return TR;}
"false"                 {yylval.string = strdup(yytext);return FLS;}

\"(\\.|[^\\"])*\"	{yylval.string = strdup(yytext);return VAR;}

-?[0-9]+                {yylval.string = strdup(yytext);return INT;}
-?[0-9]+[\.0-9+]*       {yylval.string = strdup(yytext);return DOUBLE;}        

\=  	return ASSIGNOP;
\[  	return OPB;
\]  	return CLB;
\.	return DOT;
\,  	return CMM;
\{ 	return OPENBRACES;
\: 	return COLON;
\}  	return CLOSEBRACES;
\+	return PLUS;
\-	return MINUS;
\"	return NAIL;
\n	{linenum++;}
[ \t]+
.	return CHARR;
%%
