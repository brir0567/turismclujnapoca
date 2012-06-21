# basic makefile for D language
DCC = dmd
DCCFLAGS = -gc -J/usr/bin -J/usr/local/bin -J.
LIBS = #-L-lcurl
SRC = $(wildcard *.d)
OBJ = $(SRC:.d=.o)
OUT = index

.PHONY: all clean

all: $(OUT)

$(OUT): $(OBJ)
	$(DCC) $(DCCFLAGS) -of$@ $(OBJ) $(LIBS)

clean:
	rm -f *~ $(OBJ) $(OUT)

%.o: %.d
	$(DCC) $(DCCFLAGS) -c $<