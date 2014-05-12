/* Gurman Gil & Mitchel Benovoy*/

#include <limits.h>
#include <float.h>
#include <math.h>
#include "utilLBP.h"
#include "mex.h"

//Matlab wrapper function
void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray*prhs[]);

/* Compare a value pointed to by 'ptr' to the 'center' value and
* increment pointer. Comparison is made by masking the most
* significant bit of an integer (the sign) and shifting it to an
* appropriate position. */
#define compab_mask_inc(ptr,shift) { value |= ((unsigned int)(*center - *ptr - 1) & 0x80000000) >> (31-shift); ptr++; }

/* Compare a value 'val' to the 'center' value. */
#define compab_mask(val,shift) { value |= ((unsigned int)(*center - (val) - 1) & 0x80000000) >> (31-shift); }

/* Predicate 1 for the 3x3 neighborhood */
#define predicate 1

/* The number of bits */
#define bits 8

/* PI */
#define PI 3.14159265

typedef struct
{
	int x,y;
} integerpoint;

typedef struct
{
	double x,y;
} doublepoint;


/* Main functions */
void calculate_points(void);

void lbp_histogram(int* image, int rows, int columns, int* result, bool interpolated, bool rotation);

double interpolate_at_ptr(int* upperLeft, int i, int columns);
