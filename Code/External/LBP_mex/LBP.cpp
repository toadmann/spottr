/* Gurman Gil & Mitchel Benovoy*/

#include "LBP.h"

integerpoint points[bits];
doublepoint offsets[bits];



// Matlab wrapper function
void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray*prhs[])
     
{ 
    /* Declare output and input pointers for roc subroutine */
    double *mximg, *mxresult;
    int *intimg;
    int intresult[256];
    int nrows,ncols,cnt;
    
    mximg = mxGetPr(prhs[0]);
    nrows = mxGetM(prhs[0]);
    ncols = mxGetN(prhs[0]);
    
    intimg = (int*)malloc(sizeof(int)*nrows*ncols);
    
    //convert input matrix to ints for LBP code
    cnt = 0;
    for (int r=0;r<nrows;r++) {
    	for (int c=0;c<ncols;c++) {
    		intimg[cnt] = int(mximg[cnt]);
    		cnt++;
    	}
	}

    
    //do processing
    lbp_histogram(intimg, nrows, ncols, intresult, false, false);
    
    // create output matrix
    plhs[0] = mxCreateDoubleMatrix(1, 256, mxREAL);
    mxresult = mxGetPr(plhs[0]);
    
    for (int i=0;i<256;i++) {
    	mxresult[i] = double(intresult[i]);
    }

	free(intimg);
    return;
}


/*
* Get a bilinearly interpolated value for a pixel.
*/
double interpolate_at_ptr(int* upperLeft, int i, int columns)
{
	double dx = 1-offsets[i].x;
	double dy = 1-offsets[i].y;
	return
		*upperLeft*dx*dy +
		*(upperLeft+1)*offsets[i].x*dy +
		*(upperLeft+columns)*dx*offsets[i].y +
		*(upperLeft+columns+1)*offsets[i].x*offsets[i].y;
}

/*
* Calculate the point coordinates for circular sampling of the neighborhood.
*/
void calculate_points(void)
{
	double step = 2 * PI / bits, tmpX, tmpY;
	int i;
	for (i=0;i<bits;i++)
	{
		tmpX = predicate * cos(i * step);
		tmpY = predicate * sin(i * step);
		points[i].x = (int)tmpX;
		points[i].y = (int)tmpY;
		offsets[i].x = tmpX - points[i].x;
		offsets[i].y = tmpY - points[i].y;
		if (offsets[i].x < 1.0e-10 && offsets[i].x > -1.0e-10) /* rounding error */
			offsets[i].x = 0;
		if (offsets[i].y < 1.0e-10 && offsets[i].y > -1.0e-10) /* rounding error */
			offsets[i].y = 0;

		if (tmpX < 0 && offsets[i].x != 0)
		{
			points[i].x -= 1;
			offsets[i].x += 1;
		}
		if (tmpY < 0 && offsets[i].y != 0)
		{
			points[i].y -= 1;
			offsets[i].y += 1;
		}
	}
}

/*
 * Calculate the LBP histogram for an integer-valued image. This is an
 * optimized version of the basic 8-bit LBP operator. Note that this
 * assumes 4-byte integers. In some architectures, one must modify the
 * code to reflect a different integer size.
 * 
 * img: the image data, an array of rows*columns integers arranged in
 * a horizontal raster-scan order
 * rows: the number of rows in the image
 * columns: the number of columns in the image
 * result: an array of 256 integers. Will hold the 256-bin LBP histogram.
 * interpolated: if != 0, a circular sampling of the neighborhood is
 * performed. Each pixel value not matching the discrete image grid
 * exactly is obtained using a bilinear interpolation. You must call
 * calculate_points (only once) prior to using the interpolated version.
 * return value: nonH (the non-histogrammed array) ; result contains the histogram
 */
void lbp_histogram(int* img, int rows, int columns, int* result, bool interpolated, bool rotation)
{
	int leap = columns*predicate;
	int i, j, m;



	/*Set up a circularly indexed neighborhood using nine pointers.*/
	int
		*p0 = img,
		*p1 = p0 + predicate,
		*p2 = p1 + predicate,
		*p3 = p2 + leap,
		*p4 = p3 + leap,
		*p5 = p4 - predicate,
		*p6 = p5 - predicate,
		*p7 = p6 - leap,
		*center = p7 + predicate;

	unsigned int value;
	int pred2 = predicate << 1;
	int r,c;

	int nEle = (rows-pred2)*(columns-pred2);	//Number of elements in the non-histogrammed array

	int *nonH;	//The non-histogrammed array
	nonH = (int *)malloc(nEle * sizeof(int));

	int cnt=0;	//Counter set to 0

	memset(result,0,sizeof(int)*256);	//Clear result histogram

	//fprintf(stderr, "Pred = %d\n", pred2);
	m = 0;
	if (!interpolated)
	{
		for (r=0;r<rows-pred2;r++)
		{
			for (c=0;c<columns-pred2;c++)
			{
				value = 0;

				/* Unrolled loop */
				compab_mask_inc(p0,0);
				compab_mask_inc(p1,1);
				compab_mask_inc(p2,2);
				compab_mask_inc(p3,3);
				compab_mask_inc(p4,4);
				compab_mask_inc(p5,5);
				compab_mask_inc(p6,6);
				compab_mask_inc(p7,7);
				center++;

				if (rotation)
					value=rotationInv(value);

				result[value]++; 
				nonH[cnt]=value;
			}

			p0 += pred2;
			p1 += pred2;
			p2 += pred2;
			p3 += pred2;
			p4 += pred2;
			p5 += pred2;
			p6 += pred2;
			p7 += pred2;
			center += pred2;
		}
	}
	else	//Use interpolation
	{
		p0 = center + points[5].x + points[5].y * columns;
		p2 = center + points[7].x + points[7].y * columns;
		p4 = center + points[1].x + points[1].y * columns;
		p6 = center + points[3].x + points[3].y * columns;

		for (r=0; r<rows-pred2; r++)
		{
			for (c=0; c<columns-pred2; c++)
			{
				value = 0;

				/* Unrolled loop */
				compab_mask_inc(p1,1);
				compab_mask_inc(p3,3);
				compab_mask_inc(p5,5);
				compab_mask_inc(p7,7);

				/* Interpolate corner pixels */
				compab_mask((int)(interpolate_at_ptr(p0,5,columns)+0.5),0);
				compab_mask((int)(interpolate_at_ptr(p2,7,columns)+0.5),2);
				compab_mask((int)(interpolate_at_ptr(p4,1,columns)+0.5),4);
				compab_mask((int)(interpolate_at_ptr(p6,3,columns)+0.5),6);
				p0++;
				p2++;
				p4++;
				p6++;
				center++;

				if (rotation)
					value=rotationInv(value);

				result[value]++;
				nonH[cnt++]=value;
			}

			p0 += pred2;
			p1 += pred2;
			p2 += pred2;
			p3 += pred2;
			p4 += pred2;
			p5 += pred2;
			p6 += pred2;
			p7 += pred2;
			center += pred2;
		}
	}

}
