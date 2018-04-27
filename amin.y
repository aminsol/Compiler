%{
#include <iostream>
#include <fstream>
#include <string>
#define YYSTYPE std::string
#include <stdio.h>
using namespace std;
 
extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern FILE *yyout;
 
void yyerror(const char *str)
{
        cout << "error: " << str << endl;
}

int yywrap()
{
        return 1;
} 
  
int main(int argc, char *argv[]) {
	ifstream input;
	FILE *yyout;
	if (argc == 1) {
		yyparse();
	}
	else if(argc == 2){
		yyin = fopen(argv[1], "r");
		yyout = fopen("out.cpp","w");
		yyparse();
		fclose(yyout);
	}
} 

%}

%token PROGRAM VARIABLE VARKEYWORD LISTVARIABLE TYPE CODEBEGIN  
%token PLUS MINUS DEVIDE MULTIPLY EQUAL
%token END PRINT OUTPUT COLON COMMA SEMICOLON OPAREN CPAREN DIGIT STRING

%%

commands: /* empty */
		| commands command
        ;

command:
        variable_define SEMICOLON
        |
        program_start SEMICOLON
        |
        operation SEMICOLON
        |
		equal SEMICOLON
		|
        print SEMICOLON
		| 
		program_end
		| 
		program_begin
        ;
		
variablelist:
        VARIABLE COMMA variablelist
        |
        VARIABLE
        ;

program_start:
        PROGRAM VARIABLE
        {
                cout << "Program Name is: " << $2 << endl;
        }
        ;

variable_define:
        VARKEYWORD variablelist COLON TYPE
        {
                cout << "Variables defined" << endl;
        }
        ;
		
program_begin:
        CODEBEGIN
        {
                cout << "Program begins" << endl;
        }
        ;	
		
operation:
        addition
		|
		division
		|
		subtraction
		|
		multiplication
		|
		value
        ;
	
equal:
        VARIABLE EQUAL operation{
			cout << $1 << " Equal to " <<  $3 << endl;
		}
        ;
	
addition:
        value PLUS operation
        {
                cout << $1 << " Addition " <<  $3 << endl;
        }
        ;
		
subtraction:
        value MINUS operation
        {
                cout << $1 << " Subtraction " <<  $3 << endl;
        }
        ;
		
multiplication:
        value MULTIPLY operation
        {
                cout << $1 << " Multiplication " << $3 << endl;
        }
        ;
		
division:
        value DEVIDE operation
        {
                cout << $1 << " Division " <<  $3 << endl;
        }
        ;
		
print:
        PRINT OPAREN list CPAREN
        {
                cout << "Printing output" << endl;
        }
        ;

		
list:
        VARIABLE COMMA list
		|
		STRING COMMA list
		|
		DIGIT COMMA list
		|
		VARIABLE
		|
		STRING
		|
		DIGIT
		
		
value:
        DIGIT
		|
		STRING
		|
		VARIABLE
		
program_end:
        END
        {
                cout << "End of the program" << endl;
        }
        ;
%%
