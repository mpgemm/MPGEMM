INCLUDE := -I ./

CC      := clang
CXX	    := clang++
AS      := clang
LINKER  := $(CC)
CFLAGS  := -ftree-vectorize -march=armv9-a+sme2+sme+sme-f64f64 -O3
LDFLAGS := -fPIC -shared 

Objects := smegemm.o row_dkernel_8x32.o row_dkernel_32x8.o row_dpackA.o col_kernel_16x64.o col_kernel_64x16.o  col_packb.o row_kernel_16x64.o row_kernel_64x16.o row_packa.o \
		   row_shkernel_16x64.o row_shpacka.o row_shpackb.o  row_bkernel_16x64.o row_bpacka.o row_bpackb.o 

all: libmatmul.a

libmatmul.a: $(Objects)
	$(LINKER) $^ -o libmatmul.so $(LDFLAGS) 
	ar rcs libmatmul.a $^

%.o: %.c
	$(CC) -c $< -o $@ $(CFLAGS) $(INCLUDE)

%.o: %.S
	$(AS) -c $< -o $@ $(CFLAGS) $(INCLUDE) 

.PHONY: all clean lib

clean:
	rm -f *.o *.x *.a *.so
