%{

#include<iostream>
using namespace std;
int var=0;
int number=0;
%}

%%
[A-Za-z][A-Za-z0-9]+ { cout << "Variable\t"; var++;}
[0-9]+ { cout << "Number\t"; number++;}
%%

int yywrap()
{
return 1;
}

int main()
{
printf("Enter a string\n");
yylex();

cout << "Variable=" << var << " and Number=" << number;
return 0;
}
