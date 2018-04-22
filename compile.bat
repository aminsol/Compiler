flex++.exe .\amin.l
yacc -d .\amin.y
g++ .\lex.yy.c .\amin.tab.c -o amin.exe
.\amin.exe