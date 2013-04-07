all:
	bison -d schme.y
	flex schme.l
	clang++ schme.tab.c lex.yy.c -lfl -o schme
	@printf "\n----------\n\n"
	@./schme
