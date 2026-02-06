all : correct.x irregular.x singlePerformance.x multiPerformance.x
CC := clang
INCLUDE := -I../src ../src/libmatmul.a
LIBS := -framework Accelerate -DACCELERATE_NEW_LAPACK -DACCELERATE_LAPACK_ILP64

correct.x: correct.c
	$(CC) $<  $(INCLUDE) $(LIBS) -o $@
irregular.x: irregular.c
	$(CC) $<  $(INCLUDE) $(LIBS) -o $@
singlePerformance.x: singlePerformance.c
	$(CC) $<  $(INCLUDE) $(LIBS) -o $@
multiPerformance.x: multiPerformance.c 
	$(CC) $<  $(INCLUDE) $(LIBS) -o $@
	
.PYTHON: all clean
clean:
	rm -f *.x

