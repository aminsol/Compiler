%{
#include <iostream>
#include <string>
using namespace std;
 
extern int yylex();
extern int yyparse();
 
void yyerror(const char *str)
{
        cout << "error: " << str << endl;
}

int yywrap()
{
        return 1;
} 
  
int main(){
        yyparse();
} 

%}

%token PROGRAM VARIABLE VARKEYWORD LISTVARIABLE TYPE CODEBEGIN OPERATOR END PRINT OUTPUT COLON COMMA SEMICOLON OPAREN CPAREN DIGIT STRING

%%

commands: /* empty */
        | commands command
        ;

command:
        program_start
        |
        variable_define
        |
        program_begin
        |
        operation
        |
        print
        |
        end
        ;
		
variablelist:
        VARIABLE COMMA variablelist
        |
        VARIABLE
        ;

program_start:
        PROGRAM VARIABLE
        {
                cout << "Program Name!" << endl;
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
        VARIABLE OPERATOR VARIABLE
        {
                cout << "operation" << endl;
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
		
		
end:
        END
        {
                cout << "End of the program" << endl;
        }
        ;