#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "smegemm.h"
#include "util.h"
#include <Accelerate/Accelerate.h>

void fill_fp64(double *A, int M, int K) {
    for (int i = 0; i < M * K; i++) {
        A[i] = 2.0 * (double)drand48();
    }
}

void fill_fp32(float *A, int M, int K) {
    for (int i = 0; i < M * K; i++) {
        A[i] = 2.0 * (float)drand48();
    }
}

void fill_fp16(__fp16 *A, int M, int K) {
    for (int i = 0; i < M * K; i++) {
        A[i] = (__fp16)(2.0 * (float)drand48());
    }
}

void fill_int8(int8_t *A, int M, int K) {
    for (int i = 0; i < M * K; i++) {
        A[i] = (int8_t)(rand() % 256 - 128);
    }
}

void test_fp64_gemm(int M, int N, int K, int nreps) {
    double *A = (double*)malloc(M * K * sizeof(double));
    double *B = (double*)malloc(K * N * sizeof(double));
    double *C = (double*)malloc(M * N * sizeof(double));

    fill_fp64(A, M, K);
    fill_fp64(B, K, N);
    memset(C, 0, M * N * sizeof(double));

    double best, start, end, GFLOPS;

    // row_dgemm
    best = 1e9;
    for (int i = 0; i < nreps; i++) {
        start = dClock();
        dispatch_row_dgemm(M, N, K, A, B, C);
        //cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, M, N, K, 1.0, A, K, B, N, 0.0, C, N);
        end = dClock() - start;
        best = min(best, end);
    }
    GFLOPS = (2.0 * M * N * K) / (1e9 * best);
    printf("row_dgemm: %d, %d, %d, %.2f GFLOPS\n", M, N, K, GFLOPS);

    free(A);
    free(B);
    free(C);
}

void test_fp32_gemm(int M, int N, int K, int nreps) {
    float *A = (float*)malloc(M * K * sizeof(float));
    float *B = (float*)malloc(K * N * sizeof(float));
    float *C = (float*)malloc(M * N * sizeof(float));

    fill_fp32(A, M, K);
    fill_fp32(B, K, N);
    memset(C, 0, M * N * sizeof(float));

    double best, start, end, GFLOPS;

    // row_sgemm
    best = 1e9;
    for (int i = 0; i < nreps; i++) {
        start = dClock();
        dispatch_row_sgemm(M, N, K, A, B, C);
        //cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, M, N, K, 1.0, A, K, B, N, 0.0, C, N);
        end = dClock() - start;
        best = min(best, end);
    }
    GFLOPS = (2.0 * M * N * K) / (1e9 * best);
    printf("row_sgemm: %d, %d, %d, %.2f GFLOPS\n", M, N, K, GFLOPS);

    // col_sgemm
    memset(C, 0, M * N * sizeof(float));
    best = 1e9;
    for (int i = 0; i < nreps; i++) {
        start = dClock();
        dispatch_col_sgemm(M, N, K, A, B, C);
        //cblas_sgemm(CblasColMajor, CblasNoTrans, CblasNoTrans, M, N, K, 1.0, A, M, B, K, 1.0, C, M);
        end = dClock() - start;
        best = min(best, end);
    }
    GFLOPS = (2.0 * M * N * K) / (1e9 * best);
    printf("col_sgemm: %d, %d, %d, %.2f GFLOPS\n", M, N, K, GFLOPS);

    free(A);
    free(B);
    free(C);
}


void test_fp16_gemm(int M, int N, int K, int nreps) {
    __fp16 *A = (__fp16*)malloc(M * K * sizeof(__fp16));
    __fp16 *B = (__fp16*)malloc(K * N * sizeof(__fp16));
    float *C = (float*)malloc(M * N * sizeof(float));

    fill_fp16(A, M, K);
    fill_fp16(B, K, N);
    memset(C, 0, M * N * sizeof(float));

    double best = 1e9, start, end, GFLOPS;

    for (int i = 0; i < nreps; i++) {
        start = dClock();
        dispatch_row_shgemm(M, N, K, A, B, C);
        end = dClock() - start;
        best = min(best, end);
    }
    GFLOPS = (2.0 * M * N * K) / (1e9 * best);
    printf("row_shgemm: %d, %d, %d, %.2f GFLOPS\n", M, N, K, GFLOPS);

    free(A);
    free(B);
    free(C);
}


void test_int8_gemm(int M, int N, int K, int nreps) {
    int8_t *A = (int8_t*)malloc(M * K * sizeof(int8_t));
    int8_t *B = (int8_t*)malloc(K * N * sizeof(int8_t));
    int *C = (int*)malloc(M * N * sizeof(int));

    fill_int8(A, M, K);
    fill_int8(B, K, N);
    memset(C, 0, M * N * sizeof(int));

    double best = 1e9, start, end, GFLOPS;

    for (int i = 0; i < nreps; i++) {
        start = dClock();
        dispatch_row_bgemm(M, N, K, A, B, C);
        end = dClock() - start;
        best = min(best, end);
    }
    GFLOPS = (2.0 * M * N * K) / (1e9 * best);
    printf("row_bgemm: %d, %d, %d, %.2f GFLOPS\n", M, N, K, GFLOPS);

    free(A);
    free(B);
    free(C);
}


int main() {

  BLASSetThreading(BLAS_THREADING_MULTI_THREADED);

  int nreps = 500;
  long Me[] = {64,64,64,64,64,64};

//   int nreps = 200;
//   long Me[] = {128,128,128,128,128,128};

//   int nreps = 20;
//   long Me[] = {4096,4096,4096,4096,4096,4096};

  long Ne[] = {2112,24576,32768,7168,4096,7168};
  long Ke[] = {7168,1536,512,16384,7168,2048};
  
//   int nreps = 50;
//   long Me[] = {4096,11008,4096,5120,13824,5120};
//   long Ke[] = {4096,4096,11008,5120,5120,13824};
//   long Ne[] = {256,256,256,256,256,256};

// int nreps = 20;
// long Me[] = {4096,1024,1024,32768};

// long Ne[] = {4096,1024,32768,1024};
// long Ke[] = {4096,32768,1024,1024};

    for (int pc = 0; pc < 6; pc++) {
        int M = Me[pc];
        int N = Ne[pc];
        int K = Ke[pc];

        printf("\n m, n, k, GFLOPS \n");

        //test_fp64_gemm(M, N, K, nreps);
        test_fp32_gemm(M, N, K, nreps);
        //test_fp16_gemm(M, N, K, nreps);
        //test_int8_gemm(M, N, K, nreps);
    }

    return 0;
}
