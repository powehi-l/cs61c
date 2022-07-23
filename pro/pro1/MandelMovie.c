/*********************
**  Mandelbrot fractal movie generator
** clang -Xpreprocessor -fopenmp -lomp -o Mandelbrot Mandelbrot.c
** by Dan Garcia <ddgarcia@cs.berkeley.edu>
** Modified for this class by Justin Yokota and Chenyu Shi
**********************/

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>
#include "ComplexNumber.h"
#include "Mandelbrot.h"
#include "ColorMapInput.h"
#include <sys/types.h>

void printUsage(char* argv[])
{
  printf("Usage: %s <threshold> <maxiterations> <center_real> <center_imaginary> <initialscale> <finalscale> <framecount> <resolution> <output_folder> <colorfile>\n", argv[0]);
  printf("    This program simulates the Mandelbrot Fractal, and creates an iteration map of the given center, scale, and resolution, then saves it in output_file\n");
}


/*
This function calculates the threshold values of every spot on a sequence of frames. The center stays the same throughout the zoom. First frame is at initialscale, and last frame is at finalscale scale.
The remaining frames form a geometric sequence of scales, so 
if initialscale=1024, finalscale=1, framecount=11, then your frames will have scales of 1024, 512, 256, 128, 64, 32, 16, 8, 4, 2, 1.
As another example, if initialscale=10, finalscale=0.01, framecount=5, then your frames will have scale 10, 10 * (0.01/10)^(1/4), 10 * (0.01/10)^(2/4), 10 * (0.01/10)^(3/4), 0.01 .
*/
void MandelMovie(double threshold, u_int64_t max_iterations, ComplexNumber* center, double initialscale, double finalscale, int framecount, u_int64_t resolution, u_int64_t ** output){
    //YOUR CODE HERE
	double bi = pow(finalscale/initialscale, 1.0/(framecount-2));
	for(int i = 0; i < framecount; i++){ 
		Mandelbrot(threshold, max_iterations, center, initialscale*pow(bi,i-0), resolution, output[i]);
	}
}

/**************
**This main function converts command line inputs into the format needed to run MandelMovie.
**It then uses the color array from FileToColorMap to create PPM images for each frame, and stores it in output_folder
***************/
int main(int argc, char* argv[])
{
	//Tips on how to get started on main function: 
	//MandelFrame also follows a similar sequence of steps; it may be useful to reference that.
	//Mayke you complete the steps below in order. 

	//STEP 1: Convert command line inputs to local variables, and ensure that inputs are valid.
	/*
	Check the spec for examples of invalid inputs.
	Remember to use your solution to B.1.1 to process colorfile.
	*/

	//YOUR CODE HERE 
	if(argc != 11){
		printf("%s, wrong number of auguments, expecting 11", argv[0]);
		printUsage(argv);
		return 1;
	}
	double threshold, center_real, center_imaginary, initialscale, finalscale;
	u_int64_t max_iterations, resolution;
	int framecount;
	char buffer[100];

	threshold = atof(argv[1]);
	max_iterations = (u_int64_t)atoi(argv[2]);
	ComplexNumber* center = newComplexNumber(atof(argv[3]), atof(argv[4]));
	initialscale = atof(argv[5]);
	finalscale = atof(argv[6]);
	framecount = atoi(argv[7]);
	resolution = (u_int64_t)atoi(argv[8]);
	if(threshold <= 0 || max_iterations <= 0 || initialscale <= 0 || finalscale <= 0 ||
		(framecount <=0 || framecount > 10000) || resolution < 0){
		printf("The threshold, max_iterations, scale should be more than 0\nframe should between 0 and 10000\
				resolution should grater or equle than 0");
		printUsage(argv);
		return 1;
	}
	int *colorcount = (int*)malloc(sizeof(int));
	u_int8_t **colormap = FileToColorMap(argv[10], colorcount);

	int len = 2 * resolution + 1;

	//STEP 2: Run MandelMovie on the correct arguments.
	/*
	MandelMovie requires an output array, so make sure you allocate the proper amount of space. 
	If allocation fails, free all the space you have already allocated (including colormap), then return with exit code 1.
	*/

	//YOUR CODE HERE 
	u_int64_t** output = (u_int64_t**)malloc(sizeof(u_int64_t*) * framecount);
	if(output == NULL){
		printf("unable to allocate %lu bytes space\n", sizeof(u_int64_t*)*framecount);
	}
	for(int i = 0; i < framecount; i++){
		output[i] = (u_int64_t*)malloc(sizeof(u_int64_t)*len*len);
		if(output[i] == NULL){
			printf("Unable to allocate enough space!");
			return 1;
		}
	}
	MandelMovie(threshold, max_iterations, center, initialscale, finalscale, framecount, resolution, output);


	//STEP 3: Output the results of MandelMovie to .ppm files.
	/*
	Convert from iteration count to colors, and output the results into output files.
	Use what we showed you in Part B.1.2, create a seqeunce of ppm files in the output folder.
	Feel free to create your own helper function to complete this step.
	As a reminder, we are using P6 format, not P3.
	*/

	//YOUR CODE HERE 
	for(int i = 0; i < framecount; i++){
		char filepath[30];
		sprintf(filepath, "%s/frame%05d.ppm" ,argv[9], i);
		FILE* outfile = fopen(filepath, "w");
		fprintf(outfile, "P6 %d %d %d\n", 2*resolution+1, 2*resolution+1, 255);
		for(int m = 0; m < pow(2*resolution+1, 2); m++){
			if(output[i][m] == 0)
				fprintf(outfile, "%c%c%c", 0,0,0);
			else{
				int temp = (output[i][m]-1)%*colorcount;
				fwrite(colormap[temp], 1, 3, outfile);
			}
		}
		fclose(outfile);
	}



	//STEP 4: Free all allocated memory
	/*
	Make sure there's no memory leak.
	*/
	//YOUR CODE HERE 
	free(center);
	for(int i = 0; i < *colorcount; i++){
		free(colormap[i]);
	}
	free(colormap);
	free(colorcount);

	for(int i = 0; i < framecount; i++){
		free(output[i]);
	}
	free(output);
	return 0;
}

