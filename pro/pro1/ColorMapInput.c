/*********************
**  Color Map generator
** Skeleton by Justin Yokota
**********************/

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>
#include <string.h>
#include "ColorMapInput.h"


/**************
**This function reads in a file name colorfile.
**It then uses the information in colorfile to create a color array, with each color represented by an int[3].
***************/
uint8_t** FileToColorMap(char* colorfile, int* colorcount)
{
	//YOUR CODE HERE
	FILE* color_file = fopen(colorfile, "r");
	if(color_file == NULL){
		fclose(color_file);
		return NULL;
	}
	fscanf(color_file, "%d", colorcount);
	uint8_t** array = (uint8_t**)malloc(*colorcount*sizeof(uint8_t*));
	for(int i = 0; i < *colorcount; i++){
		array[i] = (uint8_t*)malloc(3*sizeof(uint8_t));
		fscanf(color_file, "%d %d %d", &array[i][0], &array[i][1], &array[i][2]);
	}
	fclose(color_file);
	return array;
}


