#include <stdio.h>
#include <sys/time.h>
#include <stdlib.h>
#include <dispatch/dispatch.h>
#include "smegemm.h"
#include "util.h"
#include <Accelerate/Accelerate.h>

void random_matrix( int m, int n, float *a)
{
    for(int i =0 ; i < m * n; i ++)
    {
        a[i]= 2.0 * (float)drand48( );
    }
}

double run_kernel_row(int nreps, int m, int n, int k)
{
    double start,end;
    double best = 1e9;
    float *A_row = (float*)malloc(m * k * sizeof(float));
    float *B_row = (float*)malloc(k * n * sizeof(float));
    float *C_row = (float*)malloc(m * n * sizeof(float));
  
    random_matrix(m, k, A_row);
    random_matrix(k, n, B_row);

    row_sgemm(m, n, k, A_row, B_row, C_row);
    //cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, m, n, k, 1.0, A_row, k, B_row, n, 0.0, C_row, n);
    for(int i = 0; i < nreps; i++)
    {
        start = dClock();
        row_sgemm(m, n, k, A_row, B_row, C_row);
        //cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, m, n, k, 1.0, A_row, k, B_row, n, 0.0, C_row, n);
        
        end = dClock() - start;
        best = min(best, end);
    }

    free(A_row);
    free(B_row);
    free(C_row);

    return best;
}

double run_kernel_col(int nreps, int m, int n, int k)
{
    double start,end;
    double best = 1e9;

    float *A_col = (float*)malloc(m * k * sizeof(float));
    float *B_col = (float*)malloc(k * n * sizeof(float));
    float *C_col = (float*)malloc(m * n * sizeof(float));

    random_matrix(m, k, A_col);
    random_matrix(k, n, B_col);

    col_sgemm(m, n, k, A_col, B_col, C_col);
    //cblas_sgemm(CblasColMajor, CblasNoTrans, CblasNoTrans, m, n, k, 1.0, A_col, m, B_col, k, 1.0, C_col, m);

    for(int i = 0; i < nreps; i++)
    {
        start = dClock();
        col_sgemm(m, n, k, A_col, B_col, C_col);
        //cblas_sgemm(CblasColMajor, CblasNoTrans, CblasNoTrans, m, n, k, 1.0, A_col, m, B_col, k, 1.0, C_col, m);

        end = dClock() - start;
        best = min(best, end);
    }

    free(A_col);
    free(B_col);
    free(C_col);

    return best;
}

void print_perf_data(int m, int n, int k, double best_time)
{
    double GFLOPS = (2.0 * m * n * k) / (1e9 * best_time);
    printf("%d, %d, %d, %.2f\n", m, n, k, GFLOPS);
}

void get_perf_row(int nreps)
{
    printf("RowMajor FP32 GEMM m, n, k, GFLOPS\n");

    int m,n,k;

 
    long Me[] = {80,110,140,170,200};
    long Ne[] = {80,110,140,170,200};
    long Ke[] = {25600,25600,25600,25600,25600};

    for (int i = 0; i < 5; i++)
    {
        m = Me[i];
        n = Ne[i];
        k = Ke[i];

        double best_run_time = run_kernel_row(nreps, m, n, k);
        print_perf_data(m, n, k, best_run_time);
    }
}


void get_perf_col(int nreps)
{
    printf("ColMajor FP32 GEMM m, n, k, GFLOPS\n");

    int m,n,k;

 
    long Me[] = {80,110,140,170,200};
    long Ne[] = {80,110,140,170,200};
    long Ke[] = {25600,25600,25600,25600,25600};

    for (int i = 0; i < 5; i++)
    {
        m = Me[i];
        n = Ne[i];
        k = Ke[i];

        double best_run_time = run_kernel_col(nreps, m, n, k);
        print_perf_data(m, n, k, best_run_time);
    }
}


int main(int argc, char *argv[])
{
    BLASSetThreading(BLAS_THREADING_SINGLE_THREADED);
    get_perf_col(1100);
    
    get_perf_row(1100);

    return 0;
}

