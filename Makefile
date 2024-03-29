CC=gcc
CFLAGS=-Wall -c
LDFLAGS=-I ./include/

SRC_DIR=./src
OBJ_DIR=./obj
INC_DIR=./include
BIN_DIR=./bin
DOC_DIR=./doc
GCOV_DIR=./gcov

GCOVFLAGS=-O0 --coverage -lgcov -Wall -g

LCOV_REPORT=report.info

SRC=$(wildcard $(SRC_DIR)/*.c)
OBJ=$(SRC:.c=.o)
OBJ2= $(patsubst %.c, $(OBJ_DIR)/%.o, $(notdir $(SRC)))
EXEC=shellter
RM=rm

GEXEC=$(EXEC).cov

AR_NAME=archive_$(EXEC).tar.gz


all: $(SRC) $(EXEC)
    
%.o:%.c
	@mkdir -p $(OBJ_DIR)
	$(CC) $(CFLAGS) $< $(LDFLAGS) -o $(OBJ_DIR)/$(notdir $@)

$(EXEC): $(OBJ)
	@mkdir -p $(BIN_DIR)
	$(CC) -o $(BIN_DIR)/$@ -Wall $(LDFLAGS) $(OBJ2)

$(GEXEC):
	$(CC) $(GCOVFLAGS) -o $(GCOV_DIR)/$@ -Wall $(LDFLAGS) $(SRC)

doc:
	doxygen $(DOC_DIR)/doxygen.conf

gcov: $(GEXEC)
	@mkdir -p $(GCOV_DIR)
	
	#Shellter help
	$(GCOV_DIR)/$(GEXEC) -h

	#Shellter batch mode
	$(GCOV_DIR)/$(GEXEC) -c "ls -al | grep bin" 
	
	#Shellter shell mode
	$(GCOV_DIR)/$(GEXEC)

	find ./ -maxdepth 1 -name '*.gcno' -exec mv {} $(GCOV_DIR) \;
	find ./ -maxdepth 1 -name '*.gcda' -exec mv {} $(GCOV_DIR) \;

	gcov -o $(GCOV_DIR) $(GEXEC)
	lcov -o $(GCOV_DIR)/$(LCOV_REPORT) -c -f -d $(GCOV_DIR)
	genhtml -o $(GCOV_DIR)/report $(GCOV_DIR)/$(LCOV_REPORT)

package: all gcov doc
	$(RM) -rf $(AR_NAME)
	tar cvfz $(AR_NAME) ./*

man:
	sudo mkdir -p /usr/local/man/man1
	sudo cp ./ShellterMan /usr/local/man/man1/shellter.1
	sudo gzip /usr/local/man/man1/shellter.1
	@echo "You can now use 'man shellter'"

install: 
	sudo apt-get update
	sudo apt-get install lcov doxygen graphviz groff

clean:	
	$(RM) -rf $(OBJ2)

mrproper: clean
	$(RM) -rf $(BIN_DIR)/*
	$(RM) -rf $(DOC_DIR)/latex/
	$(RM) -rf $(DOC_DIR)/html/
	$(RM) -rf $(GCOV_DIR)/*

.PHONY: doc
