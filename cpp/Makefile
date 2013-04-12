all: schme
	@printf "\n----------\n\n"
	./schme

schme.tab.cpp schme.tab.hpp: schme.y
	bison -d -o schme.tab.cpp schme.y

lex.yy.cpp: schme.l schme.tab.hpp
	flex -o lex.yy.cpp schme.l

schme: lex.yy.cpp schme.tab.cpp schme.tab.hpp
	clang++ schme.tab.cpp lex.yy.cpp -o schme -lfl 

clean:
	@rm lex.yy.* schme.tab.* schme 
