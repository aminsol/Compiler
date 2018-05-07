%{
#include <iostream>
#include <string>
#define YYSTYPE std::string
#define YYSTYPE std::string
#include "amin.tab.h"
using namespace std;



string only_string(char* input){
	string s(input);
	
	return s.substr(3, s.size() - 6);
}
%}

%%
PROGRAM										return PROGRAM;
VAR													return VARKEYWORD;
INTEGER										yylval = "int"; return TYPE;
BEGIN 												return CODEBEGIN;
END												return END;
PRINT												return PRINT;


\+														return PLUS;
\-														return MINUS;
\/														return DEVIDE;
\*														return MULTIPLY;
=														return EQUAL;
:														return COLON;
;														return SEMICOLON;
,														return COMMA;
\(														return OPAREN;
\)														return CPAREN;
\.														return PERIOD;

												
[A-Za-z][A-Za-z0-9]*												yylval = yytext; return VARIABLE;

[0-9]+												yylval = yytext; return DIGIT;

\‘[^\‘\’]*\’										yylval = only_string(yytext); return STRING;
\n 													/* ignore end of line */;
[ \t]+													/* ignore whitespace */;
%%

int yywrap(){
	return 1;
}

