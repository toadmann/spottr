#include "utilLBP.h"

#define LENGTH 80

int rotationInv(int v)
{
	int n; int u,val; char binary[80];
	u=v;
	val=256;
	//dec2bin2(u,binary);
	//printf("%s: %d\n",binary,u);
	val = (val > u) ? u : val;
	for (n=1;n<=7;n++)
	{		
		u= (v >> n) | (  (v << (8-n)) & 0x000000FF );		
		val = (val > u) ? u : val;//val=min(val,u);
		//dec2bin2(u,binary);
		//printf("%s: %d\n",binary,u);
	}

	return val;
}

char * dec2bin(long i)
{
	char* str; char* p;

	str = (char*)malloc( sizeof(long)*8*sizeof(char) );
	p = str;

	while( i > 0 )
	{
		/* bitwise AND operation with the last bit */
		(i & 0x1) ? (*p++='1') : (*p++='0'); 
		/* bit shift to the right, when there are no
		bits left the value is 0, so the loop ends */
		i >>= 1; 
	}
	//while( p-- != str ) /* print out the result backwards */
	//printf("%c",*p);

	*p=0; //end with NULL
	p=str;//Pointer to the beginning
	
	//free(str);
	return(p);
}

//
// Accepts a decimal integer and returns a binary coded string
//
void dec2bin2(long decimal, char *binary)
{
	int  k = 0, n = 0;
	int  neg_flag = 0;
	int  remain;
	int  old_decimal;  // for test
	char temp[80];

	// take care of negative input
	if (decimal < 0)
	{      
		decimal = -decimal;
		neg_flag = 1;
	}
	do 
	{
		old_decimal = decimal;   // for test
		remain    = decimal % 2;
		// whittle down the decimal number
		decimal   = decimal / 2;
		// this is a test to show the action
		//printf("%d/2 = %d  remainder = %d\n", old_decimal, decimal, remain);
		// converts digit 0 or 1 to character '0' or '1'
		temp[k++] = remain + '0';
	} while (decimal > 0);

	if (neg_flag)
		temp[k++] = '-';       // add - sign
	else
		temp[k++] = ' ';       // space

	// reverse the spelling
	while (k >= 0)
		binary[n++] = temp[--k];

	binary[n-1] = 0;         // end with NULL
}


int rotate(int invalue, int places, int direction)
{
	int outvalue;

	/*	Rotating left or right?	*/
	if(direction == ROT_LEFT)
	{
		/*	First a normal shift	*/
		outvalue = invalue << (places % 8 );
		outvalue |= invalue >> (8 - places % 8);
	}
	else
	{
		/*	First a normal shift	*/
		outvalue = invalue >> (places % (8 * sizeof(int)));
		/*	Then place the part that's shifted off the screen at the end	*/
		outvalue |= invalue << ((8 * sizeof(int)) - places % (8 * sizeof(int)));
	}
	return outvalue;
}
