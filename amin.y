%{
#include <iostream>
#include <fstream>
#include <string>
#include <stdio.h>
#include <cctype>
#include <algorithm>
#include <vector>

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

		// Check for beginning of comments and set the appropriate flags
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
/*-----------------------------------------------------------------*/
string& trim(std::string& s, const char* t = " \t\n\r\f\v")
{
	s.erase(0, s.find_first_not_of(t));
	s.erase(s.find_last_not_of(t) + 1);
	return s;
}

void split(const string& s, char delim, vector<string>& v) {
    auto i = 0;
    auto pos = s.find(delim);
	string var;
    while (pos != string::npos) {
		var = trim(s.substr(i, pos-i));
		v.push_back(var);
		i = ++pos;
		pos = s.find(delim, pos);

      if (pos == string::npos){
			var = trim(s.substr(i, s.length()));
			v.push_back(var);
	  }
    }
}
/*-----------------------------------------------------------------*/
ofstream output;
int PROGRAMflag = 0;
int UNKNOWNIDEN ; 
int VARKEYflag=0;
int BEGINflag=0;
int ENDflag=0;
bool UNKNOWNflag = false;
bool ERROR = false;
vector<string> vars;


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
		if (ERROR){
			cout << "********Program is NOT accepted!!!********" << endl;
		}
		else{
			cout << "********Program is accepted :)********" << endl;
		}
	}
	return 0;
} 

%}

%token PROGRAM VARIABLE VARKEYWORD LISTVARIABLE TYPE CODEBEGIN  
%token PLUS MINUS DEVIDE MULTIPLY EQUAL
%token END PERIOD PRINT OUTPUT COLON COMMA SEMICOLON OPAREN CPAREN DIGIT STRING MISQL MISQR

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
					ERROR = true;
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
		ERROR = true;
			}
		}
		| 
		program_name { yyerror ("; is missing.");
		ERROR = true;}
		|
		program_end 
		|  
		program_begin
        ;
		
realcode:
		variable_define
		|
        operation
        |
		equal
		|
        print
		;
		
variablelist:
        variable COMMA variablelist{
			$$ = $1 + ", " + $3;
		}
        |
        variable
	| 
	variable variablelist { yyerror(", is missing.");
		ERROR = true;}

        ;

program_name:
        PROGRAM VARIABLE{
				$$ = $2 + ".cpp";
		
        }
        ;

variable_define:
        VARKEYWORD variablelist COLON type{
				$$ = $4 + " " + $2;
				string s($2);
				split(s,',', vars );
			VARKEYflag = 1;
			if(BEGINflag=0){cout<< "BEGIN is missing."<<endl;}
			ENDflag=0;
        }
	| 
	variablelist COLON type{ 
		if(VARKEYflag==0) { 
			cout<< "VAR is expected." << endl;
		} 
	}
	
        ;
type:
	TYPE{
		$$ = $1;
	}
	;	
program_begin:
        CODEBEGIN {
		
		BEGINflag = 1;
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
        variable EQUAL operation{
			$$ = $1 + " = " + $3;
			
		}
	
	| variable operation { yyerror("= is missing.");
		ERROR = true;}	
        ;
	
addition:
        value PLUS operation{
				$$ = $1 + " + " + $3;
        }
        ;
		
subtraction:
        value MINUS operation{
				$$ = $1 + " - " + $3;
        }
        ;
		
multiplication:
        value MULTIPLY operation{
				$$ = $1 + " * " + $3;
        }
        ;
		
division:
        value DEVIDE operation{
				$$ = $1 + " / " + $3;
        }
        ;
		
print:
        PRINT OPAREN  list CPAREN {
				$$ = "cout" + $3;
        }
	| PRINT list CPAREN { yyerror("( is missing.");
		ERROR = true;		}
	| PRINT OPAREN list { yyerror(" ) is missing.");
		ERROR = true;}
	
        ;

		
list:
        variable COMMA list{
			$$ = " <<  " + $1 + $3;
		}
		|
		string COMMA list{
			$$ = " << \"" + $1 + "\"" + $3;
		}
		|
		DIGIT COMMA list{
			$$ = " << " + $1 + $3;
		}
		|
		variable{
			$$ = " << " + $1;
		}
		|
		string{
			$$ = " << \"" + $1 + "\"";
		}


		|
		DIGIT{
			$$ = " << " + $1;
		}
		| variable list {yyerror(", is missing.");
		ERROR = true;}
		| STRING list {yyerror(", is missing.");
		ERROR = true;}
		| DIGIT list {yyerror(", is missing.");
		ERROR = true;}
		;
		

value:
        DIGIT
		|
		string
		|
		variable
		;
		
string:
		STRING
		|
		MISQL{
			yyerror("Missing left `");
		ERROR = true;
		}
		|
		MISQR{
			yyerror("Missing right `");
		ERROR = true;
		}
		;
		
program_end :
        END PERIOD{
				if ( BEGINflag ==1){
					cout << "End of the program" << endl;
				}
			
				else{
					yyerror("BEGIN is missing");
		ERROR = true;
				}
				ENDflag =0;
        }
		|
		END  {
			yyerror(". is missing");
		ERROR = true;
		}
		| PERIOD { yyerror("END is expected.");
		ERROR = true;
		}
        ;
variable:
	VARIABLE{
		string s($1);
		split(s, ',', vars);
		for(vector<string>::iterator it = vars.begin(); it != vars.end(); ++it) {
			if( *it != s){
				UNKNOWNflag = true;
			}
			else{
				UNKNOWNflag = false;
				break;
			}
		}
		if (UNKNOWNflag){
			string err = "Unknown identifier " + $1 + " !";
			yyerror(err.c_str());
			ERROR = true;
		}
	}

%%

