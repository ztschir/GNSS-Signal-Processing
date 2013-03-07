#include "mex.h"
#include "matrix.h"

/*
 * convertBitPackedData.c
 *
 * By Todd Humphreys based on code written by Brent Ledvina.
 *
 * Input data format:
 *
 * single:  [m0 m1 ... m15| s0 s1 ... s15] 
 *
 * dual:  [m0 m1 ... m8 | m0 m1 ... m8 | s0 s1 ... s8 | s0 s1 ... s8] 
 *        where in the dual-frequency format the magnitude and sign data
 *        are organized in bytes as [L1 mag | L2 mag | L1 sign | L2 sign] 
 *
 * Usage:  
 *         For single-frequency data:
 *         [yL1] = convertBitPackedData(rawSingleFreqData)
 *
 *         For dual-frequency data:
 *         [yL1,yL2] = convertBitPackedData(rawDualFreqData)
 *

 */
 

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
  unsigned int *x; 
  double *yL1,*yL2;
  int s1,m1,s2,m2;
  int ii,jj,idx,comb1,comb2;
  int mrows,ncols;
  
  /* Check for proper number of arguments. */
  if(nrhs!=1) {
    mexErrMsgTxt("One input expected.");
  } 
  if(nlhs!=1 && nlhs!=2) {
    mexErrMsgTxt("One (single frequency) or two (dual-frequency) outputs expected");
  }
  
  /* The input must be a noncomplex vector uint32.*/
  mrows = mxGetM(prhs[0]);
  ncols = mxGetN(prhs[0]);
  if( !mxIsClass(prhs[0],"uint32") || mxIsComplex(prhs[0]) || ncols!=1) {
    mexErrMsgTxt("Input must be a noncomplex vector uint32.");
  }
  
  /* Create matrix (matrices) for the return argument(s). */
  if(nlhs==1)
    plhs[0] = mxCreateDoubleMatrix(16*mrows,ncols,mxREAL);
  else{
    plhs[0] = mxCreateDoubleMatrix(8*mrows,ncols,mxREAL);
    plhs[1] = mxCreateDoubleMatrix(8*mrows,ncols,mxREAL);
  }
  
  /* Assign pointers to each input and output. */
  x = (unsigned int*)mxGetData(prhs[0]);
  yL1 = mxGetPr(plhs[0]);
  if(nlhs==2)
    yL2 = mxGetPr(plhs[1]);
  
  /* Unpack the bit-packed data. */
  idx=0;
  for(ii=0;ii<mrows;ii++) {
    if(nlhs==1){
      /* Single frequency */
      s1 = (x[ii])&0xffff;
      m1 = ((x[ii])>>16)&0xffff;
      for(jj=15;jj>=0;jj--) {
        comb1 = (2*((s1>>jj)&0x1) - 1)*(1 + 2*((m1>>jj)&0x1));
        yL1[idx]=(double)comb1;
        idx++;
      }
    }
    else{
      /* Dual frequency */
      s1 = (x[ii]>>8)&0xff;
      s2 = (x[ii])&0xff;
      m1 = (x[ii]>>24)&0xff;
      m2 = (x[ii]>>16)&0xff;
      for(jj=7;jj>=0;jj--) {
        comb1 = (2*((s1>>jj)&0x1) - 1)*(1 + 2*((m1>>jj)&0x1));
        yL1[idx]=(double)comb1;
        comb2 = (2*((s2>>jj)&0x1) - 1)*(1 + 2*((m2>>jj)&0x1));
        yL2[idx]=(double)comb2;
        idx++;
      }
    }
  }
}
