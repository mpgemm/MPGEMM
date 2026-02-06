#ifndef SGEMM_H
#define SGEMM_H

#include "utils.h"

#ifdef __cplusplus
	extern "C" {
#endif

#define SME_CACHELINE_SIZE 128


#define ROW_MC 512  
#define ROW_KC 1021   
#define ROW_NC 256

#define ROWSH_MC 512  
#define ROWSH_KC 2041 
#define ROWSH_NC 256

#define ROWB_MC 512
#define ROWB_KC 2041
#define ROWB_NC 512

#define ROW_MR 16
#define ROW_NR 64

#define COL_MC 512  
#define COL_KC 1024
#define COL_NC 256

#define COL_MR 64
#define COL_NR 16

#define ROWD_MC 512
#define ROWD_KC 1024    
#define ROWD_NC 256

#define ROWD_MR 8
#define ROWD_NR 32


extern void row_dpacka(
	int    mc,
	int    kc,
	double *a,
	int    lda,
	double *packA
);

extern void row_packa(
	int    mc,
	int    kc,
	float *a,
	int    lda,
	float *packA
);

extern void col_packb(
	int    kc,
	int    nc,
	float *b,
	int    ldb,
	float *packB
);

extern void row_shpacka(
	int    mc,
	int    kc,
	__fp16 *a,
	int    lda,
	__fp16 *packA
);


extern void row_shpackb(
	int    kc,
	int    nc,
	__fp16 *b,
	int    ldb,
	__fp16 *packB
);

extern void row_bpacka(
	int    mc,
	int    kc,
	int8_t *a,
	int    lda, // M
	int8_t *packA
);


extern void row_bpackb(
	int    kc,
	int    nc,
	int8_t *b,
	int    ldb, // K
	int8_t *packB
);


extern void row_kernel_16x64(
	int		mc, 
	int 	kc,
	int 	nc,
	float  *XB, 
	float  *packa, 
	float  *packb, 
	float  *c, 
	int 	KC,
	int 	ldc,
	int 	pc
);

extern void row_kernel_64x16(
	int		mc, 
	int 	kc,
	int 	nc,
	float  *XB, 
	float  *packa, 
	float  *packb, 
	float  *c, 
	int 	KC,
	int 	ldc,
	int 	pc
);

extern void col_kernel_16x64(
	int		mc, 
	int 	kc,
	int 	nc,
	float  *XA, 
	float  *packa, 
	float  *packb, 
	float  *c, 
	int 	KC,
	int 	ldc,
	int 	pc
);

extern void col_kernel_64x16(
	int		mc, 
	int 	kc,
	int 	nc,
	float  *XA, 
	float  *packa, 
	float  *packb, 
	float  *c, 
	int 	KC,
	int 	ldc,
	int 	pc
);


extern void row_shkernel_16x64(
	int		mc, 
	int 	kc,
	int 	nc,
	__fp16  *packa, 
	__fp16  *XB,
	__fp16  *packb, 
	float  *c, 
	int 	KC,
	int 	ldc,
	int 	pc
);

extern void row_bkernel_16x64(
	int		mc, 
	int 	kc,
	int 	nc,
	int8_t  *packa, 
	int8_t  *XB,
	int8_t  *packb, 
	int   *c, 
	int 	KC,
	int 	ldc,
	int 	pc
);


extern void row_dkernel_8x32(
	int		mc, 
	int 	kc,
	int 	nc,
	double  *XB, 
	double  *packa, 
	double  *packb, 
	double  *c, 
	int 	KC,
	int 	ldc,
	int 	pc
);

extern void row_dkernel_32x8(
	int		mc, 
	int 	kc,
	int 	nc,
	double  *XB, 
	double  *packa, 
	double  *packb, 
	double  *c, 
	int 	KC,
	int 	ldc,
	int 	pc
);



void row_dgemm(int m,int n,int k,double *XA,double *XB, double *XC);
void row_sgemm(int m,int n,int k,float *XA,float *XB, float *XC);
void row_shgemm(int m,int n,int k, __fp16 *XA, __fp16 *XB, float *XC);
void col_sgemm(int m,int n,int k,float *XA,float *XB,float *XC);
void row_bgemm(int m,int n,int k, int8_t *XA, int8_t *XB,int *XC);

void dispatch_row_dgemm(int m,int n,int k,double *XA,double *XB,double *XC);
void dispatch_row_sgemm(int m,int n,int k,float *XA,float *XB,float *XC);
void dispatch_row_shgemm(int m,int n,int k,__fp16 *XA,__fp16 *XB,float *XC);
void dispatch_col_sgemm(int m,int n,int k,float *XA,float *XB,float *XC);
void dispatch_row_bgemm(int m,int n,int k,int8_t *XA,int8_t *XB,int *XC);

#ifdef __cplusplus
	}
#endif

#endif