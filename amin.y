%{
#include <iostream>
#include <fstream>
#include <string>
#include <stdio.h>
#include <cctype>
#include <algorithm>

#define YYSTYPE string
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


/*--------------------------PART ONE-------------------------*/

/*---------------Helper Functions for Part One---------------*/
// string trim for easy identifying a blank line.
inline string trim(const string &s)
{
	auto wsfront = find_if_not(s.begin(), s.end(), [](int c) {return isspace(c); });
	auto wsback = find_if_not(s.rbegin(), s.rend(), [](int c) {return isspace(c); }).base();
	return (wsback <= wsfront ? string() : string(wsfront, wsback));
}

//return true if there are 2 consecutive spaces
bool bothAreSpaces(char lhs, char rhs)
{
	return ((lhs == rhs) && ((lhs == ' ') || (lhs == '\t')))
		|| ((lhs == '\t') && (rhs == ' '))
		|| ((lhs == ' ') && (rhs == '\t'));
}

string removeComments(const string& str)
{
	int n = str.length();
	string res;	// result string

				// Flags to indicate that comments have started or not.
	bool comment = false;

	//char prevChar = '\n';
	for (int i = 0; i < n-1; i++) //(n-1) to prevent from going beyond the length of the string hence illegal memory reference.
	{
		// If comment is on, then check for end of it
		if (comment == true && str[i] == '*' && str[i + 1] == ')')
		{
			comment = false;
			i++;
		}
		// If this character is in a comment, ignore it
		else if (comment)
			continue;

		// Check for beginning of comments and set the approproate flags
		else if (str[i] == '(' && str[i + 1] == '*')
		{
			comment = true;
			i++;
		}

		// If current character is a non-comment character, append it to result string
		else {
			// Only write one new line to prevent a blank line condition.
			//if (prevChar != '\n' || (prevChar == '\n' && str[i] != '\n'))
			res += str[i];
			//prevChar = str[i];
		} // else
	}
	return res;
}

string removeExtraSpaces( const string &str)
{
	int n = str.length();
	string res;	// result string
	for (int i = 0; i < n; i++) {
		if (str[i] != ' ' && str[i] != '\t')
			res += str[i];
		else if ((str[i] == ' ' || str[i] == '\t')
				&& (i > 0 && (str[i - 1] != ' ' && str[i - 1] != '\t' && str[i - 1] != '\n'))
			)
			res += str[i];
	} // for
	return res;
}
string removeBlankLines(const string &str)
{
	int n = str.length();
	string res;	// result string
	for (int i = 0; i < n; i++) {
		if (str[i] != '\n')
			res += str[i];
		else if (i > 0 && str[i] == '\n'  && str[i-1] != '\n')
			res += str[i];
	} // for
	return res;
}


bool isOperand(char & a)
{
	return (isalnum(a) || a == '_');
}

// Add space before and after each token
void addSpaceToken(string & str)
{
	int i = 1;
	while (i < str.length())
	{
		// if we found an operator, excluding '.' since 
		// "END." does not have space in between
		if (!isOperand(str[i]) && str[i] != '.')
		{
			// we insert space before and after it
			str.insert(i, " ");
			str.insert(i + 2, " ");
			i += 2;
		}
		++i;
	}
}

/*-------------------Function for Part One-------------------*/

void partOne(string filename)
{
	ifstream infile;
	ofstream outfile;
	string outFilename = "final2.txt";

	string str, tempStr1, tempStr2;

	infile.open(filename.c_str());
	if (infile.fail()) {
		cout << "\nInvaild file name.\n";
		return;
	}
	//outfile.open(tempFilename.c_str());
	outfile.open(outFilename.c_str());

	if (infile.is_open())
	{
		while (getline(infile, str))
		{
			// copy content of file to tempStr1 line by line
			tempStr1 += str;
			// add a new line at the end of each line
			tempStr1 += "\n";
		}
		// remove comments from tempStr1 and put the rest into tempStr2
		
		tempStr2 = removeBlankLines(removeExtraSpaces(removeComments(tempStr1)));

		
		// write tempStr2 into a temporary file
		outfile << tempStr2;
		// close the original input file
		infile.close();
	}
	outfile.close();

	
}

/*------------------------END PART ONE-----------------------*/
ofstream output;
int PROGRAMflag = 0;
int UNKNOWNIDEN ; 
int VARKEYflag=0;
int BEGINflag=0;
int ENDflag=0;


int main(int argc, char *argv[]) {
	FILE *yyout;
	if (argc == 1) {
		yyparse();
	}
	else if(argc == 2){
		partOne(argv[1]);
		yyin = fopen("final2.txt", "r");
		yyparse();
		output << "return 0; \n}" << endl;
		output.close();
	}
	return 0;
} 

%}

%token PROGRAM VARIABLE VARKEYWORD LISTVARIABLE TYPE CODEBEGIN  
%token PLUS MINUS DEVIDE MULTIPLY EQUAL
%token END PERIOD PRINT OUTPUT COLON COMMA SEMICOLON OPAREN CPAREN DIGIT STRING LQUOTATION RQUOTATION

%%


	
commands: /* empty */
		| commands command
        ;
command:
	
        program_name SEMICOLON{
			PROGRAMflag = 1;
			output.open($1);
			output << "#include <iostream>" << endl;
			output << "using namespace std;" << endl;
			output << "int main()\n{" << endl;
		}
		|
		realcode SEMICOLON{
			if($1 != ""){
				if(PROGRAMflag == 0){ 
					yyerror("PROGRAM is expected.");
				}
				
				else 
				{ 
					cout << $1  << ";"<< endl;
					output << $1  << ";"<< endl;
				}
				
				//fprintf(yyout, "%s;\n", $1);
			}
		}
		|
		realcode{
			if($1 != ""){
				yyerror("; is missing.");
			}
			

		}
		| variable_define SEMICOLON
		| 
		program_name { yyerror ("; is missing.");}
		|
		program_end 
		|  
		program_begin
        ;
		
realcode:
	
        operation
        |
		equal
		|
        print
		;
		
variablelist:
        VARIABLE COMMA variablelist{
			$$ = $1 + ", " + $3;
		}
        |
        VARIABLE
	| VARIABLE variablelist { yyerror(", is missing.");}
	| COMMA variablelist {yyerror("UNKNOWN IDENTIFIER");}

        ;

program_name:
        PROGRAM VARIABLE{
				$$ = $2 + ".cpp";
                cout << "Info: Program Name is: " << $2 << endl;
		
        }
	| PROGRAM {yyerror("UNKNOWN IDENTIFIER.");}
	
	
	
        ;

variable_define:
        VARKEYWORD variablelist COLON type{
				$$ = $4 + " " + $2;
                cout << "Info: Variables defined " << $1 << endl;
		VARKEYflag = 1;
		if(BEGINflag=0){cout<< "BEGIN is missing."<<endl;}
		ENDflag=0;
		
        }
	| error variablelist COLON type{ if(VARKEYflag==0) { cout<< "VAR is expected."<<endl;} }
	
        ;
type:
	TYPE{
		$$ = $1;
	}
	| {yyerror("UNKNOWN IDENTIFIER");}
		
program_begin:
        CODEBEGIN {
		
		BEGINflag = 1;
                cout << "Info: Program begins" << endl;	
		ENDflag =0;
		
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
			$$ = $1 + " = " + $3;
			cout << "Info: " << $1 << " = " <<  $3 << endl;
			
		}
	
	| VARIABLE operation { yyerror("= is missing.");}
	| EQUAL operation { yyerror("UNKNOWN IDENTIFIER");}	
        ;
	
addition:
        value PLUS operation{
				$$ = $1 + " + " + $3;
                cout << "Info: " << $1 << " + " <<  $3 << endl;
        }
        ;
		
subtraction:
        value MINUS operation{
				$$ = $1 + " - " + $3;
                cout << "Info: " << $1 << " - " <<  $3 << endl;
        }
        ;
		
multiplication:
        value MULTIPLY operation{
				$$ = $1 + " * " + $3;
                cout << "Info: " << $1 << " * " << $3 << endl;
        }
        ;
		
division:
        value DEVIDE operation{
				$$ = $1 + " / " + $3;
                cout << "Info: " << $1 << " / " <<  $3 << endl;
        }
        ;
		
print:
        PRINT OPAREN  list CPAREN {
				$$ = "cout" + $3;
                cout << "Info: " << "Printing output" << endl;
        }
	| PRINT list CPAREN { yyerror("( is missing.");		}
	| PRINT OPAREN list { yyerror(" ) is missing.");}
	
        ;

		
list:
        VARIABLE COMMA list{
			$$ = " <<  " + $1 + $3;
		}
		|
		STRING COMMA list{
			$$ = " << \'" + $1 + "\'" + $3;
		}
		|
		DIGIT COMMA list{
			$$ = " << " + $1 + $3;
		}
		|
		VARIABLE{
			cout << "print VAR" << endl;
			$$ = " << " + $1;
		}
		|
		STRING{
			cout << "print STRING" << endl;
			$$ = " << \"" + $1 + "\"";
		}


		|
		DIGIT{
			cout << "print DIGIT"  << endl;
			$$ = " << " + $1;
		}
		| VARIABLE list {yyerror(", is missing.");}
		| STRING list {yyerror(", is missing.");}
		| DIGIT list {yyerror(", is missing.");}

		| COMMA list {yyerror("UNKNOWN IDENTIFIER.");}
		;
		

value:
        DIGIT
		|
		STRING
		|
		VARIABLE
		
program_end :
        END PERIOD{
				if ( BEGINflag ==1){
					cout << "End of the program" << endl;
				}
			
				else{
					yyerror("BEGIN is missing");
				}
				ENDflag =0;
        }
		|
		END  {
			yyerror(". is missing");
		}
		| PERIOD { yyerror("END is expected.");}
		
        ;

%%

