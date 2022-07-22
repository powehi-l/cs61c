/*********************
**  Complex Numbers
**  This file contains a few functions that will be useful when performing computations with complex numbers
**  It is advised that you work on this part first.
**********************/

#include "ComplexNumber.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>


typedef struct ComplexNumber
{
	double real;
	double imaginary;
}ComplexNumber;

//Returns a pointer to a new Complex Number with the given real and imaginary components
ComplexNumber* newComplexNumber(double real_component, double imaginary_component)
{
    //YOUR CODE HERE
    ComplexNumber* new_point = (ComplexNumber* )malloc(sizeof(double)*2);
	new_point->real = real_component;
	new_point->imaginary = imaginary_component;
	return new_point;
}

//Returns a pointer to a new Complex Number equal to a*b
ComplexNumber* ComplexProduct(ComplexNumber* a, ComplexNumber* b)
{
    //YOUR CODE HERE
    	double real = Re(a) * Re(b) - Im(a) * Im(b);
        double imag = Re(a) * Im(b) + Re(b) * Im(a);	
	return newComplexNumber(real, imag);
}

//Returns a pointer to a new Complex Number equal to a+b
ComplexNumber* ComplexSum(ComplexNumber* a, ComplexNumber* b)
{
    //YOUR CODE HERE
    double real = Re(a) + Re(b);
	double imag = Im(a) + Im(b);
	return newComplexNumber(real, imag);
}

//Returns the absolute value of Complex Number a
double ComplexAbs(ComplexNumber* a)
{
	double pro = Re(a)*Re(a) + Im(a)*Im(a);	
    //YOUR CODE HERE
	return sqrt(pro);
}

void freeComplexNumber(ComplexNumber* a)
{
	free(a);
	return;
	//YOUR CODE HERE
}

double Re(ComplexNumber* a)
{
	//YOUR CODE HERE
	return a->real;
}
double Im(ComplexNumber* a)
{
	//YOUR CODE HERE
	return a->imaginary;
}


//Contains a few tests.
int test_complex_number()
{
	ComplexNumber* a = newComplexNumber(2.0, 1.0);
	if (a == NULL)
	{
		printf("Creation of complex numbers not implemented\n");
		return 0;
	}
	ComplexNumber* b = ComplexProduct(a, a);
	if (b == NULL)
	{
		printf("Multiplication of complex numbers not implemented\n");
		free(a);
		return 0;
	}
	ComplexNumber* c = ComplexSum(b, b);
	if (c == NULL)
	{
		printf("Addition of complex numbers not implemented\n");
		free(a);
		free(b);
		return 0;
	}
	float d = ComplexAbs(c);
	if (d == 0)
	{
		printf("Absolute Value of complex numbers not implemented\n");
		free(a);
		free(b);
		free(c);
		return 0;
	}
	else if (fabsf(d - 10) < 0.0001)
	{
		printf("Sample tests for complex numbers all passed\n");
	}
	else
	{
		printf("At least one of your functions is incorrect\n");
	}
	free(a);
	free(b);
	free(c);
	return 0;
}
