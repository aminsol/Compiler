cls
flex++.exe .\amin.l
yacc -d .\amin.y --file-prefix=amin
g++ -std=gnu++0x .\lex.yy.c .\amin.tab.c -o amin.exe
.\amin.exe final.txt
g++ .\aba13.cpp -o output.exe
.\output.exe