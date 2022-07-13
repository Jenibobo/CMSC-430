compile: scanner.o parser_test.o listing.o values.o
	g++ -o compile scanner.o parser_test.o listing.o values.o
	
scanner.o: scanner.c values.h listing.h tokens.h
	g++ -c scanner.c

scanner.c: scanner.l	
	flex scanner.l
	mv lex.yy.c scanner.c

parser_test.o: parser_test.c values.h listing.h symbols.h
	g++ -c parser_test.c

parser_test.c tokens.h: parser_test.y
	bison -d -v parser_test.y
	mv parser_test.tab.c parser_test.c
	cp parser_test.tab.h tokens.h

listing.o: listing.cc listing.h
	g++ -c listing.cc

values.o: values.cc values.h
	g++ -c values.cc