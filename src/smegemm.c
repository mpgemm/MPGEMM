#include <math.h>
#include <string.h>
#include <assert.h>
#include <dispatch/dispatch.h>
#include "smegemm.h"


void row_sgemm(
         int    m,
         int    n,
         int    k,
         float *XA,
         float *XB,
         float *XC
         )
{   //lda, ldb, ldc are assumed to be equal to k, n, n respectively
    float * restrict btilde_sys;
    float * restrict atilde_sys;
    posix_memalign((void **)&btilde_sys, SME_CACHELINE_SIZE, ROW_KC * ROW_NC * sizeof(float));
    posix_memalign((void **)&atilde_sys, SME_CACHELINE_SIZE, ROW_MC * ROW_KC * sizeof(float));

    int NC = ( n / ROW_NC) * ROW_NC;
    int jb = n - NC;

    int NR = (jb / ROW_NR) * ROW_NR;
    int jbr = jb - NR;
    
    for (int ic = 0; ic < m; ic += ROW_MC) {
        int ib = min(ROW_MC, m - ic);

        for (int pc = 0; pc < k; pc += ROW_KC) {
            int pb = min(ROW_KC, k - pc);

            row_packa(ib, pb, &XA[ic * k + pc], k, atilde_sys);


            for (int jc = 0; jc < NC; jc += ROW_NC) 
            { 
                row_kernel_16x64(ib, pb, ROW_NC, &XB[pc * n + jc], atilde_sys, btilde_sys, &XC[ic * n + jc], ROW_KC, n, pc);
            } 

            if( jb!=0 )
            {
                if( NR !=0 )
                {  
                    row_kernel_16x64(ib, pb, NR, &XB[pc * n + NC], atilde_sys, btilde_sys, &XC[ic * n + NC], ROW_KC, n, pc);
                }

                if( jbr != 0)
                {  
                    row_kernel_64x16(ib, pb, jbr, &XB[pc * n + NC + NR], atilde_sys, btilde_sys, &XC[ic * n + NC + NR], ROW_KC, n, pc);
                }
            }

        }
    }

    free(btilde_sys);
    free(atilde_sys);
}

void col_sgemm(
         int    m,
         int    n,
         int    k,
         float *XA,
         float *XB,
         float *XC   
         )
 {
    //lda, ldb, ldc are assumed to be equal to m, k, m respectively
    float * restrict btilde_sys; 
    float * restrict atilde_sys; 
    posix_memalign( ( void **)&btilde_sys, SME_CACHELINE_SIZE, COL_KC * COL_NC * sizeof( float ) ); 
    posix_memalign( ( void **)&atilde_sys, SME_CACHELINE_SIZE, COL_MC * COL_KC * sizeof( float ) ); 
    
    int MC = ( m / COL_MC) * COL_MC;
    int ib = m - MC;

    int MR = (ib / COL_MR) * COL_MR;
    int ibr = ib - MR;

    for ( int jc=0; jc<n; jc+=COL_NC ) 
    { 
        int jb = min( COL_NC, n-jc ); 
        
        for ( int pc=0; pc<k; pc+=COL_KC ) 
        { 

            int pb = min( COL_KC, k-pc ); 

            col_packb(pb, jb, &XB[pc + jc * k], k, btilde_sys);

            for ( int ic=0; ic < MC; ic+=COL_MC ) 
            { 
                col_kernel_64x16(COL_MC, pb, jb, &XA[ic + pc * m], atilde_sys, btilde_sys, &XC[ic + jc * m], COL_KC, m, pc);
            } 
            if( ib!=0 )
            {
                if( MR !=0 )
                {  
                    col_kernel_64x16(MR, pb, jb, &XA[MC + pc * m], atilde_sys, btilde_sys, &XC[MC + jc * m], COL_KC, m, pc);
                }

                if( ibr != 0)
                {  
                    col_kernel_16x64(ibr, pb, jb, &XA[MC + MR + pc * m], atilde_sys, btilde_sys, &XC[MC + MR + jc * m], COL_KC, m, pc);
                }
            }
  
        } 
      
    } 

    free(btilde_sys); 
    free(atilde_sys); 
}


void row_shgemm(
         int    m,
         int    n,
         int    k,
         __fp16 *XA, 
         __fp16 *XB,
         float *XC   
         )
 {
    //lda, ldb, ldc are assumed to be equal to k, n, n respectively
    __fp16 * restrict btilde_sys; 
    __fp16 * restrict atilde_sys; 
    posix_memalign( ( void **)&btilde_sys, SME_CACHELINE_SIZE, ROWSH_KC * ROWSH_NC * sizeof( __fp16 ) ); 
    posix_memalign( ( void **)&atilde_sys, SME_CACHELINE_SIZE, ROWSH_MC * ROWSH_KC * sizeof( __fp16 ) ); 
    
    for ( int ic=0; ic<m; ic+=ROWSH_MC ) 
    { 
        int ib = min( ROWSH_MC, m-ic ); 
        
        for ( int pc=0; pc<k; pc+=ROWSH_KC ) 
        { 
            int pb = min( ROWSH_KC, k-pc ); 

            row_shpacka(ib, pb, &XA[pc + ic * k], k, atilde_sys);  

            for ( int jc=0; jc < n; jc+=ROWSH_NC ) 
            { 
                
                int jb = min( ROWSH_NC, n-jc ); 

                row_shpackb( pb, jb, &XB[jc + pc * n], n, btilde_sys );  

                row_shkernel_16x64(ib, pb, jb, atilde_sys, &XB[jc + pc * n], btilde_sys, &XC[jc + ic * n], ROWSH_KC, n, pc);
            } 

        } 
      
    } 

    free(btilde_sys); 
    free(atilde_sys); 
}
 
 
void row_bgemm(
         int    m,
         int    n,
         int    k,
         int8_t *XA,
         int8_t *XB,
         int   *XC    
         )
 {
    //lda, ldb, ldc are assumed to be equal to k, n, n respectively
    int8_t * restrict btilde_sys; 
    int8_t * restrict atilde_sys; 
    posix_memalign( ( void **)&btilde_sys, SME_CACHELINE_SIZE, ROWB_KC * ROWB_NC * sizeof( int8_t ) ); 
    posix_memalign( ( void **)&atilde_sys, SME_CACHELINE_SIZE, ROWB_MC * ROWB_KC * sizeof( int8_t ) ); 
    
    for ( int ic=0; ic<m; ic+=ROWB_MC ) 
    { 
        int ib = min( ROWB_MC, m-ic ); 
        
        for ( int pc=0; pc<k; pc+=ROWB_KC ) 
        { 
            int pb = min( ROWB_KC, k-pc ); 

            row_bpacka(ib, pb, &XA[pc + ic * k], k, atilde_sys);  

            for ( int jc=0; jc < n; jc+=ROWB_NC ) 
            { 
                
                int jb = min( ROWB_NC, n-jc ); 

                row_bpackb( pb, jb, &XB[jc + pc * n], n, btilde_sys );  

                row_bkernel_16x64(ib, pb, jb, atilde_sys, &XB[jc + pc * n], btilde_sys, &XC[jc + ic * n], ROWB_KC, n, pc);
            } 

        } 
      
    } 

    free(btilde_sys); 
    free(atilde_sys); 
}
 
 
void row_dgemm(
         int    m,
         int    n,
         int    k,
         double *XA,
         double *XB,
         double *XC
         )
{
    //lda, ldb, ldc are assumed to be equal to k, n, n respectively
    double * restrict btilde_sys;
    double * restrict atilde_sys;
    posix_memalign((void **)&btilde_sys, SME_CACHELINE_SIZE, ROWD_KC * ROWD_NC * sizeof(double));
    posix_memalign((void **)&atilde_sys, SME_CACHELINE_SIZE, ROWD_MC * ROWD_KC * sizeof(double));

    int NC = ( n / ROWD_NC) * ROWD_NC;
    int jb = n - NC;

    int NR = (jb / ROWD_NR) * ROWD_NR;
    int jbr = jb - NR;
    
    for (int ic = 0; ic < m; ic += ROWD_MC) {
        int ib = min(ROWD_MC, m - ic);

        for (int pc = 0; pc < k; pc += ROWD_KC) {
            int pb = min(ROWD_KC, k - pc);

            row_dpacka(ib, pb, &XA[ic * k + pc], k, atilde_sys);


            for (int jc = 0; jc < NC; jc += ROWD_NC) 
            { 
                row_dkernel_8x32(ib, pb, ROWD_NC, &XB[pc * n + jc], atilde_sys, btilde_sys, &XC[ic * n + jc], ROWD_KC, n, pc);
            } 

            if( jb!=0 )
            {
                if( NR !=0 )
                {  
                    row_dkernel_8x32(ib, pb, NR, &XB[pc * n + NC], atilde_sys, btilde_sys, &XC[ic * n + NC], ROWD_KC, n, pc);
                }

                if( jbr != 0)
                {  
                    row_dkernel_32x8(ib, pb, jbr, &XB[pc * n + NC + NR], atilde_sys, btilde_sys, &XC[ic * n + NC + NR], ROWD_KC, n, pc);
                }
            }

        }
    }

    free(btilde_sys);
    free(atilde_sys);
}



void dispatch_row_sgemm(int m, int n, int k,
                       float* XA,
                       float* XB,
                       float* XC)
{
    //lda, ldb, ldc are assumed to be equal to k, n, n respectively
    const int max_tiles = 4;

    int mt = (m + ROW_MC - 1) / ROW_MC;
    int nt = (n + ROW_NC - 1) / ROW_NC;
    int total_tiles = mt * nt;

    if(total_tiles == 1){
        //small gemm
        row_sgemm(m, n, k, XA, XB, XC);
        return;
    }

    int actual_tiles = min(total_tiles, max_tiles);

    dispatch_queue_t queue = dispatch_queue_create("rowsgemm", QUEUE_QOS(QOS_CLASS_USER_INTERACTIVE));

    dispatch_apply(actual_tiles, queue, ^(size_t tid) {
        float *btilde_sys = NULL;
        float *atilde_sys = NULL;
        posix_memalign((void**)&btilde_sys, SME_CACHELINE_SIZE, ROW_KC * ROW_NC * sizeof(float));
        posix_memalign((void**)&atilde_sys, SME_CACHELINE_SIZE, ROW_MC * ROW_KC * sizeof(float));

        for (int tile_id = tid; tile_id < total_tiles; tile_id += actual_tiles) {
            int nt_id = tile_id % nt;
            int mt_id = tile_id / nt;

            int jc = nt_id * ROW_NC;
            int ic = mt_id * ROW_MC;

            int jb = min(ROW_NC, n - jc);
            int ib = min(ROW_MC, m - ic);

            int NC_aligned = (jb / ROW_NR) * ROW_NR;
            int jbr = jb - NC_aligned;

            for (int pc = 0; pc < k; pc += ROW_KC) {
                int pb = min(ROW_KC, k - pc);
                
                row_packa(ib, pb, &XA[ic * k + pc], k, atilde_sys);

                if (NC_aligned > 0) {
                    row_kernel_16x64(ib, pb, NC_aligned,
                        &XB[pc * n + jc], atilde_sys, btilde_sys,
                        &XC[ic * n + jc], ROW_KC, n, pc);
                }

                if (jbr > 0) {
                    row_kernel_64x16(ib, pb, jbr,
                        &XB[pc * n + jc + NC_aligned], atilde_sys, btilde_sys,
                        &XC[ic * n + jc + NC_aligned], ROW_KC, n, pc);
                }
            }
        }

        free(btilde_sys);
        free(atilde_sys);
    });

}

void dispatch_col_sgemm(int m, int n, int k,
                       float* XA,
                       float* XB,
                       float* XC)
{
    //lda, ldb, ldc are assumed to be equal to m, k, m respectively
    const int max_tiles = 4;

    int mt = (m + COL_MC - 1) / COL_MC;
    int nt = (n + COL_NC - 1) / COL_NC;
    int total_tiles = mt * nt;

    if(total_tiles == 1){
        //small gemm
        col_sgemm(m, n, k, XA, XB, XC);
        return;
    }

    int actual_tiles = min(total_tiles, max_tiles);

    dispatch_queue_t queue = dispatch_queue_create("colsgemm", QUEUE_QOS(QOS_CLASS_USER_INTERACTIVE));

    dispatch_apply(actual_tiles, queue, ^(size_t tid) {
        float *btilde_sys = NULL;
        float *atilde_sys = NULL;
        posix_memalign((void**)&btilde_sys, SME_CACHELINE_SIZE, COL_KC * COL_NC * sizeof(float));
        posix_memalign((void**)&atilde_sys, SME_CACHELINE_SIZE, COL_MC * COL_KC * sizeof(float));

        for (int tile_id = tid; tile_id < total_tiles; tile_id += actual_tiles) {
            int nt_id = tile_id % nt;
            int mt_id = tile_id / nt;

            int jc = nt_id * COL_NC;
            int ic = mt_id * COL_MC;

            int jb = min(COL_NC, n - jc);
            int ib = min(COL_MC, m - ic);

            int MC_aligned = (ib / COL_MR) * COL_MR;
            int ibr = ib - MC_aligned;

            for (int pc = 0; pc < k; pc += COL_KC) {
                int pb = min(COL_KC, k - pc);

                col_packb(pb, jb, &XB[pc + jc * k], k, btilde_sys);

                if (MC_aligned > 0) {
                    col_kernel_64x16(MC_aligned, pb, jb,
                        &XA[ic + pc * m], atilde_sys, btilde_sys,
                        &XC[ic + jc * m], COL_KC, m, pc);
                }

                if (ibr > 0) {
                    col_kernel_16x64(ibr, pb, jb,
                        &XA[ic + MC_aligned + pc * m], atilde_sys, btilde_sys,
                        &XC[ic + MC_aligned + jc * m], COL_KC, m, pc);
                }
            }
        }

        free(btilde_sys);
        free(atilde_sys);
    });

}


void dispatch_row_shgemm(int m, int n, int k,
                       __fp16* XA,
                       __fp16* XB,
                       float* XC)
{
    //lda, ldb, ldc are assumed to be equal to k, n, n respectively
    const int max_tiles = 4;

    int mt = (m + ROWSH_MC - 1) / ROWSH_MC;
    int nt = (n + ROWSH_NC - 1) / ROWSH_NC;
    int total_tiles = mt * nt;

    if(total_tiles == 1){
        //small gemm
        row_shgemm(m, n, k, XA, XB, XC);
        return;
    }

    int actual_tiles = min(total_tiles, max_tiles);

    dispatch_queue_t queue = dispatch_queue_create("rowshgemm", QUEUE_QOS(QOS_CLASS_USER_INTERACTIVE));

    dispatch_apply(actual_tiles, queue, ^(size_t tid) {
        __fp16 * atilde = NULL;
        __fp16 * btilde = NULL;
        posix_memalign((void**)&atilde, SME_CACHELINE_SIZE, ROWSH_MC * ROWSH_KC * sizeof(__fp16));
        posix_memalign((void**)&btilde, SME_CACHELINE_SIZE, ROWSH_KC * ROWSH_NC * sizeof(__fp16));

        for (int tile_id = tid; tile_id < total_tiles; tile_id += actual_tiles) {
            int mt_id = tile_id % mt;
            int nt_id = tile_id / mt;

            int ic = mt_id * ROWSH_MC;
            int jc = nt_id * ROWSH_NC;

            int ib = min(ROWSH_MC, m - ic);
            int jb = min(ROWSH_NC, n - jc);

            for (int pc = 0; pc < k; pc += ROWSH_KC) {
                int pb = min(ROWSH_KC, k - pc);

                row_shpacka(ib, pb, &XA[pc + ic * k], k, atilde);
 
                row_shpackb(pb, jb, &XB[jc + pc * n], n, btilde); 

                row_shkernel_16x64(
                    ib, pb, jb,
                    atilde,
                    &XB[jc + pc * n], 
                    btilde,
                    &XC[jc + ic * n],
                    ROWSH_KC, n, pc
                );
            }
        }

        free(atilde);
        free(btilde);
    });
}


void dispatch_row_bgemm(int m, int n, int k,
                       int8_t* XA,
                       int8_t* XB,
                       int* XC)
{
    //lda, ldb, ldc are assumed to be equal to k, n, n respectively
    const int max_tiles = 4;

    int mt = (m + ROWB_MC - 1) / ROWB_MC;
    int nt = (n + ROWB_NC - 1) / ROWB_NC;
    int total_tiles = mt * nt;

    if(total_tiles == 1){
        //small gemm
        row_bgemm(m, n, k, XA, XB, XC);
        return;
    }

    int actual_tiles = min(total_tiles, max_tiles);

    dispatch_queue_t queue = dispatch_queue_create("rowbgemm", QUEUE_QOS(QOS_CLASS_USER_INTERACTIVE));

    dispatch_apply(actual_tiles, queue, ^(size_t tid) {
        int8_t * atilde = NULL;
        int8_t * btilde = NULL;
        posix_memalign((void**)&atilde, SME_CACHELINE_SIZE, ROWB_MC * ROWB_KC * sizeof(int8_t));
        posix_memalign((void**)&btilde, SME_CACHELINE_SIZE, ROWB_KC * ROWB_NC * sizeof(int8_t));

        for (int tile_id = tid; tile_id < total_tiles; tile_id += actual_tiles) {
            int mt_id = tile_id % mt;
            int nt_id = tile_id / mt;

            int ic = mt_id * ROWB_MC;
            int jc = nt_id * ROWB_NC;

            int ib = min(ROWB_MC, m - ic);
            int jb = min(ROWB_NC, n - jc);

            for (int pc = 0; pc < k; pc += ROWB_KC) {
                int pb = min(ROWB_KC, k - pc);

                row_bpacka(ib, pb, &XA[pc + ic * k], k, atilde);
 
                row_bpackb(pb, jb, &XB[jc + pc * n], n, btilde); 

                row_bkernel_16x64(
                    ib, pb, jb,
                    atilde,
                    &XB[jc + pc * n], 
                    btilde,
                    &XC[jc + ic * n],
                    ROWB_KC, n, pc
                );
            }
        }

        free(atilde);
        free(btilde);
    });
}

void dispatch_row_dgemm(int m, int n, int k,
                       double* XA,
                       double* XB,
                       double* XC)
{
    //lda, ldb, ldc are assumed to be equal to k, n, n respectively
    const int max_tiles = 4;

    int mt = (m + ROWD_MC - 1) / ROWD_MC;
    int nt = (n + ROWD_NC - 1) / ROWD_NC;
    int total_tiles = mt * nt;

    if(total_tiles == 1){
        //small gemm
        row_dgemm(m, n, k, XA, XB, XC);
        return;
    }

    int actual_tiles = min(total_tiles, max_tiles);

    dispatch_queue_t queue = dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0);


    dispatch_apply(actual_tiles, queue, ^(size_t tid) {
        double *btilde_sys = NULL;
        double *atilde_sys = NULL;
        posix_memalign((void **)&btilde_sys, SME_CACHELINE_SIZE, ROWD_KC * ROWD_NC * sizeof(double));
        posix_memalign((void **)&atilde_sys, SME_CACHELINE_SIZE, ROWD_MC * ROWD_KC * sizeof(double));

        for (int tile_id = tid; tile_id < total_tiles; tile_id += actual_tiles) {
            int nt_id = tile_id % nt;
            int mt_id = tile_id / nt;

            int jc = nt_id * ROWD_NC;
            int ic = mt_id * ROWD_MC;

            int jb = min(ROWD_NC, n - jc);
            int ib = min(ROWD_MC, m - ic);

            int NC_aligned = (jb / ROWD_NR) * ROWD_NR;
            int jbr = jb - NC_aligned;

            for (int pc = 0; pc < k; pc += ROWD_KC) {
                int pb = min(ROWD_KC, k - pc);
                
                row_dpacka(ib, pb, &XA[ic * k + pc], k, atilde_sys);

                if (NC_aligned > 0) {
                    row_dkernel_8x32(ib, pb, NC_aligned,
                        &XB[pc * n + jc], atilde_sys, btilde_sys,
                        &XC[ic * n + jc], ROWD_KC, n, pc);
                }

                if (jbr > 0) {
                    row_dkernel_32x8(ib, pb, jbr,
                        &XB[pc * n + jc + NC_aligned], atilde_sys, btilde_sys,
                        &XC[ic * n + jc + NC_aligned], ROWD_KC, n, pc);
                }
            }
        }

        free(btilde_sys);
        free(atilde_sys);
    });

}
