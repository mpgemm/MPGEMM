#ifndef UTILS_H
#define UTILS_H


#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <sys/time.h>
#include <math.h>

#ifdef __cplusplus
	extern "C" {
#endif

#define min(a, b) ((a)<(b)?(a):(b))
#define max(a, b) ((a)>(b)?(a):(b))
#define QUEUE_QOS(qos) dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_CONCURRENT, qos, 0)



static double gtod_ref_time_sec=0.0;
static double dClock()
{
    double the_time, norm_sec;
    struct timeval tv;

    gettimeofday(&tv, NULL);
    if (gtod_ref_time_sec==0.0)
		gtod_ref_time_sec=(double)tv.tv_sec;

    norm_sec=(double)tv.tv_sec-gtod_ref_time_sec;
    the_time=norm_sec+tv.tv_usec*1.0e-6;

    return the_time;
}

#ifdef __cplusplus
	}
#endif

#endif