all: schme
	@printf "\n----------\n\n"
	./schme testfile.shm

OBJS = parser.o codegen.o main.o tokens.o

CPPFLAGS = `llvm-config --cppflags`
LDFLAGS = `llvm-config --ldflags`
LIBS = `llvm-config --libs`
 
clean:
	@rm -i parser.{c,h}pp schme lexer.cpp $(OBJS)

parser.cpp: parser.y
	bison -d -o $@ $^

parser.hpp: parser.cpp

lexer.cpp: lexer.l parser.hpp
	flex -o $@ $^

%.o: %.cpp
	g++ -c $(CPPFLAGS) -o $@ $<

schme: $(OBJS)
	g++ -o $@ $(OBJS) $(LIBS) $(LDFLAGS)

