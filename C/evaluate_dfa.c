#include "mex.h"
#include <math.h>
#include <stdio.h>
#include <memory.h>

void linear_fit_precomputed(double *X, double *P1, double *P2, double *Y, double *U, int nWLen, int nWInd);

void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[]) {
  
  #define m_RMS   plhs[0]
  
  #define m_DATA  prhs[0]
  #define m_X     prhs[1]
  #define m_P1    prhs[2]
  #define m_P2    prhs[3]
  #define m_Y     prhs[4]
  #define m_U     prhs[5]
  #define m_WNUM  prhs[6]
  #define m_WLEN  prhs[7]
  #define m_WMAX  prhs[8]
  #define m_WN    prhs[9]
  
  double *data, *X, *P1, *P2, *Y, *U; 
  int *pWLen, *pWNum;
  int i, n, nWNum, nWLen, nWMax, nWN, count, index;
  double mu;
  double *RMS;
  

  data = mxGetPr(m_DATA);
  X  = mxGetPr(m_X);
  P1 = mxGetPr(m_P1);
  P2 = mxGetPr(m_P2);
  pWNum = mxGetPr(m_WNUM);
  pWLen = mxGetPr(m_WLEN);
  nWMax = mxGetScalar(m_WMAX);
  nWN = mxGetScalar(m_WN);
  

  m_Y = mxCreateDoubleMatrix(1, nWMax, mxREAL);
  m_U = mxCreateDoubleMatrix(1, nWMax, mxREAL);
  Y = mxGetPr(m_Y);
  U = mxGetPr(m_U);
  m_RMS = mxCreateDoubleMatrix(1, nWN, mxREAL);
  RMS = mxGetPr(m_RMS);
 

  for (index = 0; index < nWN; index++) {

    nWLen = pWLen[index];
    nWNum = pWNum[index];

    RMS[index] = 0.0;
    for (count = 0; count < nWNum; count++) {

      for (i = nWLen * count, n = 0; i < nWLen * (count + 1); i++, n++) {
        Y[n] = data[i];
      }

      linear_fit_precomputed(X, P1, P2, Y, U, nWLen, (nWMax * index));

      mu = 0.0;
      for (i = 0; i < nWLen; i++) {
        mu += ((Y[i] - U[i]) * (Y[i] - U[i])) / nWLen;
      }
      RMS[index] += sqrt(mu) / nWNum; 
    }
  }
}

void linear_fit_precomputed(double *X, double *P1, double *P2, double *Y, double *U, int nWLen, int nWInd)
{
  int i;
  double p1 = 0.0, p2 = 0.0;
	for (i = 0; i < nWLen; i++) {
    p1 += P1[nWInd + i] * Y[i];
    p2 += P2[nWInd + i] * Y[i];
	}
	for (i = 0; i < nWLen; i++) {
    U[i] = p2 * X[nWInd + i] + p1;
	}
}

