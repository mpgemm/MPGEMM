#include <stdio.h>
#include <sys/time.h>
#include <stdlib.h>
#include <Accelerate/Accelerate.h>
#include "smegemm.h"
#include "util.h"

#define FP64_ERROR_TOLERANCE 0.0002f
#define FP32_ERROR_TOLERANCE 0.002f
#define FP16_ERROR_TOLERANCE 0.02f

int main() {
  int M, N, K;

  BLASSetThreading(BLAS_THREADING_SINGLE_THREADED);

  M = 64;
  N = 2112;
  K = 7168;

  double *A_d = (double*)malloc(M * K * sizeof(double));
  double *B_d = (double*)malloc(K * N * sizeof(double));
  float *A = (float*)malloc(M * K * sizeof(float));
  float *B = (float*)malloc(K * N * sizeof(float));
  __fp16 *A_sh = (__fp16*)malloc(M * K * sizeof(__fp16));
  __fp16 *B_sh = (__fp16*)malloc(K * N * sizeof(__fp16));

  float *C_ref = (float*)malloc(M * N * sizeof(float));
  float *C_opt = (float*)malloc(M * N * sizeof(float));
  double *C_dref = (double*)malloc(M * N * sizeof(double));
  double *C_dopt = (double*)malloc(M * N * sizeof(double));

  int8_t  *A_b = (int8_t*)malloc(M * K * sizeof(int8_t));
  int8_t  *B_b = (int8_t*)malloc(K * N * sizeof(int8_t));
  float  *A_int_ref = (float*)malloc(M * K * sizeof(float));
  float  *B_int_ref = (float*)malloc(K * N * sizeof(float));
  int   *C_int = (int*)malloc(M * N * sizeof(int));
  float *C_int_ref = (float*)malloc(M * N * sizeof(float));

  for(int i =0 ; i < M * K; i ++)
  {
    A_d[i]= 2.0 * (double)drand48( );
  } 

  for(int i =0 ; i < M * K; i ++)
  {
    A_sh[i]= 2.0 * (float)drand48( );
    A[i]= (float)A_sh[i];
  } 

  for(int i =0 ; i < K * N; i ++)
  {
    B_d[i]= 0.5 * (double)drand48( );
  }

  for(int i =0 ; i < K * N; i ++)
  {
    B_sh[i]= 0.5 * (float)drand48( );
    B[i]= (float)B_sh[i];
  } 

  for(int i =0 ; i < M * K; i ++)
  {
    A_b[i]= (int8_t)(rand() % 256 - 128);
    A_int_ref[i] = (float)A_b[i];
  }

  for(int i =0 ; i < K * N; i ++)
  {
    B_b[i]= (int8_t)(rand() % 256 - 128);
    B_int_ref[i] = (float)B_b[i];
  }

  memset(C_int, 0, M * N * sizeof(int));
  memset(C_int_ref, 0, M * N * sizeof(float));
  memset(C_ref, 0, M * N * sizeof(float));
  memset(C_opt, 0, M * N * sizeof(float));
  memset(C_dopt, 0, M * N * sizeof(double));
  memset(C_dref, 0, M * N * sizeof(double));
  
  cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, M, N, K, 1.0, A_d, K, B_d, N, 0.0, C_dref, N);
  row_dgemm(M, N, K, A_d, B_d, C_dopt);
  

  printf("FP64_ERROR_TOLERANCE = %.4f%%\n", (double)FP64_ERROR_TOLERANCE);
  int error = 0;

  for (uint64_t i = 0; i < M * N; i++) {
    if (fabs(C_dref[i] - C_dopt[i]) > fabs((double)FP64_ERROR_TOLERANCE * C_dref[i])) {
        error = 1;
        printf("ERROR: %llu, %f, %f\n", i, C_dref[i],C_dopt[i]);
      }
  }

  if (!error) {
    printf("FP64 RowMajor GEMM: PASS\n");
  } 


  cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, M, N, K, 1.0, A, K, B, N, 0.0, C_ref, N);
  row_sgemm(M, N, K, A, B, C_opt);
  
  printf("FP32_ERROR_TOLERANCE = %.4f%%\n", (float)FP32_ERROR_TOLERANCE);
  error = 0;

  for (uint64_t i = 0; i < M * N; i++) {
    if (fabsf(C_ref[i] - C_opt[i]) > fabsf((float)FP32_ERROR_TOLERANCE * C_ref[i])) {
        error = 1;
        printf("ERROR: %llu, %f, %f\n", i, C_ref[i],C_opt[i]);
      }
  }

  if (!error) {
    printf("FP32 RowMajor GEMM: PASS\n");
  } 

  memset(C_ref, 0, M * N * sizeof(float));
  memset(C_opt, 0, M * N * sizeof(float));

  for(int iteration =0; iteration < 10; iteration++)
  {
    cblas_sgemm(CblasColMajor, CblasNoTrans, CblasNoTrans, M, N, K, 1.0, A, M, B, K, 1.0, C_ref, M);
    col_sgemm(M, N, K, A, B, C_opt);
  }
  
  printf("FP32_ERROR_TOLERANCE = %.4f%%\n", (float)FP32_ERROR_TOLERANCE);
  error = 0;

  for (uint64_t i = 0; i < M * N; i++) {
    if (fabsf(C_ref[i] - C_opt[i]) > fabsf((float)FP32_ERROR_TOLERANCE * C_ref[i])) {
        error = 1;
        printf("ERROR: %llu, %f, %f\n", i, C_ref[i],C_opt[i]);
    }
  }

  if (!error) {
    printf("FP32 ColMajor GEMM: PASS\n");
  } 


  memset(C_ref, 0, M * N * sizeof(float));
  memset(C_opt, 0, M * N * sizeof(float));

  cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, M, N, K, 1.0, A , K, B, N, 0.0, C_ref, N);
  row_shgemm(M, N, K, A_sh , B_sh, C_opt);
  
  printf("FP16_ERROR_TOLERANCE = %.4f%%\n", (float)FP16_ERROR_TOLERANCE);
  error = 0;

  for (int i = 0; i < M * N; i++) {
    if (fabsf(C_ref[i] - C_opt[i] ) > fabsf((float)FP16_ERROR_TOLERANCE * C_ref[i])) {
        error = 1;
        printf("%d, %f, %f\n", i, C_ref[i],C_opt[i]);
      }
  }

  if (!error) {
    printf("FP16 GEMM: PASS\n");
  } 

  memset(C_int_ref, 0, M * N * sizeof(float));
  memset(C_int, 0, M * N * sizeof(int));

  cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, M, N, K, 1.0, A_int_ref, K, B_int_ref, N, 0.0, C_int_ref, N);
  row_bgemm(M, N, K, A_b, B_b, C_int);
  
  error = 0;

  for (int i = 0; i < M * N; i++) {
    if (C_int_ref[i] != C_int[i]) {
        error = 1;
        printf("%d, %f, %d\n", i, C_int_ref[i],C_int[i]);
      }
  }

  if (!error) {
    printf("INT8 GEMM: PASS\n");
  } 



  free(A);
  free(B);
  free(A_sh);
  free(B_sh);
  free(C_ref);
  free(C_opt);
  
  return 0;
}