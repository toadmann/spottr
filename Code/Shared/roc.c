//
//  Matlab function call [auc bc] = roc(failed_dist,correct_dist)
//
//  Given two distributions of type double calculate area under receiver
//  operating characteristic curve as well as best discriminative
//  criterion. NaN values are ignored. Inf values are sorted accordingly.
//
//  Written by Jackson Smith, May 18th 2008
//  Dr. Erik Cook Lab - Physiology - Medicine - McGill
//

/* Include block */
#include <math.h>
#include "mex.h"

/* Input Arguments */

#define	faildistIN prhs[0]
#define	corrdistIN prhs[1]


/* Output Arguments */

#define	aucOUT plhs[0]
#define  bcOUT plhs[1]

/* Macro defenitions for MIN and MAX*/

#if !defined(MAX)
#define	MAX(A, B) ((A) >= (B) ? (A) : (B))
#endif

#if !defined(MIN)
#define	MIN(A, B) ((A) <= (B) ? (A) : (B))
#endif

#define ABSDIF(n1,n2) (MAX(n1,n2)-MIN(n1,n2))
#define TRIAREA(x1,y1,x2,y2) (ABSDIF(x1,x2)*ABSDIF(y1,y2)/2)
#define RECAREA(x1,y1,x2,y2) (MIN(y1,y2)*ABSDIF(x1,x2))

#define numelFail mxGetNumberOfElements(faildistIN)
#define numelCorr mxGetNumberOfElements(corrdistIN)

#define isfaildist(P) (faildist <= P && P < faildist + nF ? 1 : 0)
#define iscorrdist(P) (corrdist <= P && P < corrdist + nC ? 1 : 0)
#define     distID(P) (!isfaildist(P) || iscorrdist(P))

#define mdiv(i,j) ((i+j)/2)

#define NON_OVERLAPPING(D1,D2) (((char)D1&&D2==0)||(D1==0&&(char)D2))


/* Constant declaration block*/
static double infr;
static double PId4 = 3.141592653589793/4;


/* Function Declaration Block */

/* Merge Function */
static void rocmerge(double **pd, long i, long m, long j)
{
    //Variable Declarations.
    long p,q,r;
    p = i, q = m+1, r = 0;
    
    double **temp;
    if ( (temp = malloc((j-i+1)*sizeof(double *)) ) == NULL)
    {
        mexErrMsgTxt("ERROR: Malloc failed");
    }
    
    //Merge data.
    while (p <= m && q <= j)
    {
        
        //Deal with NaN values, these are always considered biggest.
        if (mxIsNaN(*(pd[p])) && !mxIsNaN(*(pd[q])))
        {
            temp[r] = pd[q];
            q++;
        }
        else if (!mxIsNaN(*(pd[p])) && mxIsNaN(*(pd[q])))
        {
            temp[r] = pd[p];
            p++;
        }
        else if (mxIsNaN(*(pd[p])) && mxIsNaN(*(pd[q])))
            break;
                
        //Now it's safe to perform real number comparisons.
        else if (*(pd[p]) <= *(pd[q]))
        {
            temp[r] = pd[p];
            p++;
        }
        else
        {
            temp[r] = pd[q];
            q++;
        }
        
        r++;
    }
    
    //Copy any remainder of first or second half to temp.
    while (p <= m)
    {
        temp[r] = pd[p];
        p++;
        r++;
    }
    while (q <= j)
    {
        temp[r] = pd[q];
        q++;
        r++;
    }
    
    //Copy sorted temp back to pd.
    for (p=i, r=0;  p <= j;  p++, r++)
        pd[p] = temp[r];
    
    //Memory cleanup.
    free(temp);
}

/*Mergesort function*/
static void rocmergesort(double **p, long i, long j)
{   
    //One element.
    if (i == j) return;
    
    //Sort each half of p
    rocmergesort(p,i,mdiv(i,j));
    rocmergesort(p,mdiv(i,j)+1,j);
    
    //Merge halves.
    rocmerge(p,i,mdiv(i,j),j);
    
    return;
}



/* Actual function
 *
 * Input parameters faildist & corrdist are pointers to the double arrays
 * of real data from the failed and correct input distributions.
 *
 * nF and nC are the number of elements in the failed and 
 *
 */
static void roc(double *auc,
                double *bc,
                double *faildist,
                double *corrdist,
                long nF,
                long nC,
                int *nlhs)
{   
    long i,j,nP,fp,tp,nnF,nnC;
    double x,y,prevx,prevy,bcdist,dist,r;

    //Initialise infr.
    infr = mxGetInf();
    
    //Initialise variables.
    r = dist = bcdist = x = y = prevx = prevy = fp = tp = nnF = nnC = 0;
    nP = nF+nC;
    
    //Initialise output parameters to 0.
    *auc = 0;
    *bc = infr;
    
    //Dynamically allocate pointer to pointers to double. Essentially, each
    //element of p is faildist+i or corrdist+j for some i<nF or j<nC.
    double **p;
    if ( (p = malloc((nP)*sizeof(double *)) ) == NULL)
    {
        mexErrMsgTxt("ERROR: Malloc failed");
    }
    
    //Initialise array.
    j = 0;
    for (i = 0; i < nF; i++)
    {
        p[j] = faildist+i;
        nnF += !mxIsNaN(*(p[j]));
        j++;
    }
    for (i = 0; i < nC; i++)
    {
        p[j] = corrdist+i;
        nnC += !mxIsNaN(*(p[j]));
        j++;
    }
    
    
    //If any all NaN distributions were given then return NaN.
    if (nnF == 0 || nnC == 0)
    {
        free(p);
        *auc = *bc = mxGetNaN();
        return;
    }
    
    //Sort newly initialised array in descending order according to
    //dereferenced doubles.
    rocmergesort(p,0,nP-1);
    

    //Now calculate area under ROC curve and best criterion. Loop through
    //sorted pointers.
    //for (i = 0;  i <= nnF+nnC ;  i++)
    for (i = 0;  i < nnF+nnC ;  i++)
    {

        //Check first to see if we've reached the end of non-NaN values
        //plus one OR to see if we've run through all instances of one
        //value and have moved into a block of new values; either way, the
        //effect is to detect when all instances of a value have been
        //tallied before...
        //if (i == nnF+nnC || (0<i && *(p[i-1]) != *(p[i])))
        if (0<i && *(p[i-1]) != *(p[i]))
        {

            //Updating the cumulative probability distributions. y - failed
            //cpd, x - correct cpd.
            y = (double)fp/nnF;
            x = (double)tp/nnC;

            //Calculate area of triangle with hypotenuse between the
            //previous and current cpd's. Then calculate the rectangle area
            //underneath.
            *auc += TRIAREA(prevx,prevy,x,y) + RECAREA(prevx,prevy,x,y);
            
            prevx = x;
            prevy = y;
            
            //Skip the rest if best criterion is not being asked for.
            //Note that this is not performed for the last iteration.
            if (*nlhs >= 2)
            {
                //This value can be tested as best criterion. Calculate its
                //distance to the chance line. First, project the current
                //point onto the chance line and obtain the projection's x
                //and y coordinates. Then calculate linear distance as the
                //test criterion.
                r = cos(PId4)*x + sin(PId4)*y;
                x = r*cos(PId4);
                y = r*sin(PId4);
                dist = sqrt(pow(prevx-x,2) + pow(prevy-y,2));

                if (bcdist < dist)
                {
                    *bc = *(p[i-1]);
                    bcdist = dist;
                }
            }
            
        }//End If
     
        //Update false/true positive count. Careful to avoid
        //segmentation errors.
        //if (i < nnF+nnC && distID(p[i])) tp++; else fp++;
        if (distID(p[i])) tp++; else fp++;
        
    }//End Calc Area loop
    
    //Final AUC accumulation when i == nnF+nnC
    y = (double)fp/nnF;
    x = (double)tp/nnC;
    *auc += TRIAREA(prevx,prevy,x,y) + RECAREA(prevx,prevy,x,y);
    
    //Free allocated memory and finish function execution.
    free(p);
    return;
}


/* Matlab's function */

void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray*prhs[])
     
{ 
    /* Declare output and input pointers for roc subroutine */
    double *auc, *bc;
    double *faildist,*corrdist;
    
    /* Check for proper number of arguments */
    if (nrhs != 2)
    { 
        mexErrMsgTxt("Two input arguments required."); 
    }
    else if (nlhs > 2)
    {
        mexErrMsgTxt("Only two output parameters allowed."); 
    } 
    
    /* Make sure input distributions are non-empty of type double. */
    int i;
    for (i = 0; i < nrhs; i++)
    {
        if (!mxIsDouble(prhs[i]) || mxGetNumberOfElements(prhs[i]) < 1)
        {
            mexErrMsgTxt(
                "roc requires that inputs are non-empty double vectors."); 
        }
    }
    
    /* Create matrices for the return arguments */ 
    //TESTING MERGESORT
    aucOUT = mxCreateDoubleMatrix(1, 1, mxREAL);
     bcOUT = mxCreateDoubleMatrix(1, 1, mxREAL);
    
    /* Assign pointers to the output parameters for roc subroutine */ 
    auc = mxGetPr(aucOUT);
     bc = mxGetPr(bcOUT);
    
    /* Assign pointers to the input parameters for roc subroutine */
    faildist = mxGetPr(faildistIN); 
    corrdist = mxGetPr(corrdistIN);
    
    /* Do the actual computations in a subroutine */
    roc(auc,bc,faildist,corrdist,numelFail,numelCorr,&nlhs);
    
    return;
}


