/*********************
**  Mandelbrot fractal
** clang -Xpreprocessor -fopenmp -lomp -o Mandelbrot Mandelbrot.c
** by Dan Garcia <ddgarcia@cs.berkeley.edu>
** Modified for this class by Justin Yokota and Chenyu Shi
**********************/

#include <stdio.h>
#include <stdlib.h>
#include "ComplexNumber.h"
#include "Mandelbrot.h"
#include <sys/types.h>

/*
This function returns the number of iterations before the initial point >= the threshold.
If the threshold is not exceeded after maxiters, the function returns 0.
*/
u_int64_t MandelbrotIterations(u_int64_t maxiters, ComplexNumber * point, double threshold)
{
    //YOUR CODE HERE
  ComplexNumber* Z = newComplexNumber(0.0, 0.0);
  u_int64_t iterations = 0;
  // ComplexNumber* curr = newComplexNumber(Re(point), Im(point));
  while (ComplexAbs(Z) < threshold && iterations < maxiters)
  {
    iterations++;
    ComplexNumber* temp = ComplexProduct(Z, Z);
    free(Z);
    Z = ComplexSum(temp, point);
    free(temp);
  }
  free(Z);
  iterations %= maxiters;
  return iterations;
}

/*
This function calculates the Mandelbrot plot and stores the result in output.
The number of pixels in the image is resolution * 2 + 1 in one row/column. It's a square image.
Scale is the the distance between center and the top pixel in one dimension.
*/
void Mandelbrot(double threshold, u_int64_t max_iterations, ComplexNumber* center, double scale, u_int64_t resolution, u_int64_t * output){
    //YOUR CODE HERE
    double dis = scale / resolution;
    u_int64_t m,n,count = 0;
    double res = (double)resolution;
    double re, im;
    re = im = 0;
    for(m = 0; m < 2*resolution+1; m++){
      for(n = 0; n < 2*resolution+1; n++){
            re = Re(center) + dis * (n - res);
            im = Im(center) - dis * (m - res);
            ComplexNumber* out = newComplexNumber(re, im);
            output[count++] = MandelbrotIterations(max_iterations, out, threshold);
            freeComplexNumber(out);
      }
    }
}


