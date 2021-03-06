
VPATH = AdsLib
LIBS = -lpthread
CC = g++
LIB_NAME = AdsLib-$(shell uname).a
INSTALL_DIR=example

ifeq ($(shell uname),Darwin)
	CC = clang
	LIBS += -lc++
endif


.cpp.o:
	$(CC) -Wall -pedantic -c -g -std=c++11 $< -o $@ -I AdsLib/

$(LIB_NAME): AdsDef.o AdsLib.o AmsConnection.o AmsPort.o AmsRouter.o Log.o NotificationDispatcher.o Sockets.o Frame.o
	ar rvs $@ $?

AdsLibTest.bin: $(LIB_NAME)
	$(CC) AdsLibTest/main.cpp $< -I AdsLib/ -I ../ -std=c++11 $(LIBS) -o $@
	
test: AdsLibTest.bin
	./$<

install: $(LIB_NAME) AdsLib.h AdsDef.h
	cp $? $(INSTALL_DIR)/

clean:
	rm -f *.a *.o *.bin

uncrustify:
	uncrustify --no-backup -c tools/uncrustify.cfg AdsLib*/*.h AdsLib*/*.cpp example/*.cpp

prepare-hooks:
	rm -f .git/hooks/pre-commit
	ln -Fv tools/pre-commit.uncrustify .git/hooks/pre-commit
	chmod a+x .git/hooks/pre-commit

.PHONY: clean uncrustify prepare-hooks
