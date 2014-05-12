#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <errno.h>
#include <string.h>
#include <time.h>

#define ROT_LEFT 0x00
#define ROT_RIGHT !ROT_LEFT

int rotationInv(int);

char* dec2bin(long);

void dec2bin2(long , char *);

int rotate(int , int , int);
