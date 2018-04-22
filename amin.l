%{
#include <iostream>
#include "amin.tab.h"
using namespace std;
%}

%%
PROGRAM										return PROGRAM;
VAR													return VARKEYWORD;
INTEGER											return TYPE;
BEGIN												return CODEBEGIN;
END													return END;
PRINT												return PRINT;
\+|\-|\/|\*											return OPERATOR;
:														return COLON;
;														return SEMICOLON;
,														return COMMA;
\(														return OPAREN;
\)														return CPAREN;
[A-Za-z][A-Za-z0-9]*						return VARIABLE;
[0-9]+												return DIGIT;
\".*\"												return STRING;
\n 													/* ignore end of line */;
[ \t]+												/* ignore whitespace */;
%%


int yywrap(){
	return 1;
}
