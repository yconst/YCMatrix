//
//  Matrix.h
//  Matrix
//
//  Created by Yan Const on 11/7/13.
//  Copyright (c) 2013 Ioannis Chatzikonstantinou. All rights reserved.
//

#import "YCMatrix+Advanced.h"

@implementation YCMatrix (Advanced)
- (YCMatrix *)inverse {
    @throw [NSException exceptionWithName:@"NotImplementedException" 
                                    reason:@"Not Implemented" 
                                    userInfo:nil];
    return nil;
}
/*
 * Pseudo-inverse
 */
- (YCMatrix *)pseudoInverse {
    YCMatrix *ret = [YCMatrix matrixOfRows:self->columns Columns:self->rows];
    [YCMatrix getPinvOf:self->matrix Rows:self->rows Columns:self->columns Out:ret->matrix];
    return ret;
}
/*
 * QR Decomposition
 */
- (NSDictionary *)QR
{
    YCMatrix *A = [self matrixByTransposing];
    
    // Here initialize Q and R placeholders with TRANSPOSED rows/columns values, 
    // so that we can transpose back to normal row-major later.
    // with k = min(m, n)
    // Q is m x k => here it should be k x m
    // R is k x n => here it should be n x k
    int k = MIN(rows, columns);
    YCMatrix *Q = [YCMatrix matrixOfRows:k Columns:rows];
    YCMatrix *R = [YCMatrix matrixOfRows:columns Columns:k]; 
    
    // Perform QR calling LAPACK
    [YCMatrix getQROf:A->matrix Rows:rows Columns:columns OutQ:Q->matrix OutR:R->matrix];
    
    // Now transpose Q and R to get row-major matrices
    Q = [Q matrixByTransposing]; // -> m x k
    R = [R matrixByTransposing]; // -> k x n
    return [NSDictionary dictionaryWithObjectsAndKeys:Q, @"Q", R, @"R", nil];
}
- (YCMatrix *)RowMean
{
    YCMatrix *means = [YCMatrix matrixOfRows:self->rows Columns:1];
    for (int i=0; i<rows; i++)
    {
        double rowMean = 0;
        for (int j=0; j<columns; j++)
        {
            rowMean += matrix[i*columns + j];
        }
        rowMean /= columns;
        means->matrix[i] = rowMean;
    }
    return means;
    
}
- (YCMatrix *)ColumnMean
{
    YCMatrix *means = [YCMatrix matrixOfRows:self->columns Columns:1];
    for (int i=0; i<columns; i++)
    {
        double columnMean = 0;
        for (int j=0; j<rows; j++)
        {
            columnMean += matrix[j*columns + i];
        }
        columnMean /= rows;
        means->matrix[i] = columnMean;
    }
    return means;

}
+ (void)getPinvOf:(double *)A Rows:(int)rows Columns:(int)columns Out:(double *)Aplus
    /*
      
          float8[] *pseudoinverse(float8[])
      
          Compute the pseudo inverse of matrix A
      
          Author:  Luke Lonergan
          Date:    5/31/08
          License: Use pfreely
      
          We use the approach from here:
             http://en.wikipedia.org/wiki/Moore-Penrose_pseudoinverse#Finding_the_\
      pseudoinverse_of_a_matrix
      
          Synopsis:
             A computationally simpler and more accurate way to get the pseudoinverse 
             is by using the singular value decomposition.[1][5][6] If A = U Σ V* is 
             the singular value decomposition of A, then A+ = V Σ+ U* . For a diagonal
             matrix such as Σ, we get the pseudoinverse by taking the reciprocal of 
             each non-zero element on the diagonal, and leaving the zeros in place. 
             In numerical computation, only elements larger than some small tolerance 
             are taken to be nonzero, and the others are replaced by zeros. For 
             example, in the Matlab function pinv, the tolerance is taken to be
             t = ε•max(rows,columns)•max(Σ), where ε is the machine epsilon.
      
          Input:  the matrix A with "rows" rows and "columns" columns, in column 
                  values consecutive order (row-major)
          Output: the matrix A+ with "columns" rows and "rows" columns, the 
                  Moore-Penrose pseudo inverse of A
      
          The approach is summarized:
          - Compute the SVD (diagonalization) of A, yielding the U, S and V 
            factors of A
          - Compute the pseudo inverse A+ = U x S+ x Vt
      
          S+ is the pseudo inverse of the diagonal matrix S, which is gained by 
          inverting the non zero diagonals 
      
          Vt is the transpose of V
      
          Note that there is some fancy index rework in this implementation to deal 
          with the row values consecutive order used by the FORTRAN dgesdd_ routine.
      */
{
    long int    minmn;
    int    i, j, k, ii;
    int    lwork, *iwork;
    double     *work, *Atemp;
    double      epsilon, tolerance, maxeigen;
    double     *S, *U, *Vt;
    double     *Splus, *Splus_times_Ut;
    char        achar='A';   /* ? */
    
    /* 
     * Calculate the tolerance for "zero" values in the SVD 
     *    t = ε•max(rows,columns)•max(Σ) 
     *  (Need to multiply tolerance by max of the eigenvalues when they're 
     *   available)
     */
    epsilon = pow(2,1-56); 
    tolerance = epsilon * MAX(rows,columns); 
    maxeigen=-1.;
    
    /*
     * The factors of A: S, U and Vt
     * U, Sdiag and Vt are the factors of the pseudo inverse of A, the 
     * components of the singular value decomposition of A
     */
    S = (double *) malloc(sizeof(double)*MIN(rows,columns));
    U = (double *) malloc(sizeof(double)*rows*rows);
    Vt = (double *) malloc(sizeof(double)*columns*columns);
    
    /* Working matrices for the pseudo inverse calculation: */
    /*  1) The pseudo inverse of S: S+ */
    Splus = (double *) malloc(sizeof(double)*columns*rows);
    /*  2) An intermediate result: S+ Ut */
    Splus_times_Ut = (double *) malloc(sizeof(double)*columns*rows);
    
    /*
     * Here we transpose A for entry into the FORTRAN dgesdd_ routine in row 
     * order. Note that dgesdd_ is destructive to the entry array, so we'd 
     * need to make this copy anyway.
     */
    Atemp = (double *) malloc(sizeof(double)*columns*rows);
    for ( j = 0; j < rows; j++ ) {
        for ( i = 0; i < columns; i++ ) {
            Atemp[j+i*rows] = A[i+j*columns];
        } 
    }
    
    /* 
     * First call of dgesdd is with lwork=-1 to calculate an optimal value of 
     * lwork 
     */
    iwork = (int *) malloc(sizeof(long int)*8*MIN(rows,columns));
    lwork=-1;
    
    /* Need a single location in work to store the recommended value of lwork */
    work = (double *) malloc(sizeof(double)*1);

    dgesdd_( &achar, &rows, &columns, Atemp, &rows, S, U, &rows, Vt, &columns, 
            work, &lwork, iwork, &i );
    
    if (i != 0) {
        return;
    } else {
        lwork = (int) work[0];
        free(work);
    }
    
    
    /*
     * Allocate the space needed for the work array using the value of lwork 
     * obtained in the first call of dgesdd_ 
     */
    work = (double *) malloc(sizeof(double)*lwork);
    dgesdd_( &achar, &rows, &columns, Atemp, &rows, S, U, &rows, Vt, &columns, 
            work, &lwork, iwork, &i );
    
    free(work);
    free(iwork);
    free(Atemp);
    
    /* Use the max of the eigenvalues to normalize the zero tolerance */
    minmn = MIN(rows,columns); // The dimensions of S are min(rows,columns)
    for ( i = 0; i < minmn; i++ ) {
        maxeigen = MAX(maxeigen,S[i]);
    }
    tolerance *= maxeigen;
    
    /*
     * Calculate the pseudo inverse of the eigenvalue matrix, Splus
     * Use a tolerance to evaluate elements that are close to zero
     */
    for ( j = 0; j < rows; j++ ) {
        for ( i = 0; i < columns; i++ ) {
            if (minmn == columns) {
                ii = i;
            } else {
                ii = j;
            }
            if ( i == j && S[ii] > tolerance ) {
                Splus[i+j*columns] = 1.0 / S[ii];
            } else {
                Splus[i+j*columns] = 0.0;
            } 
        } 
    }
    
    for ( i = 0; i < columns; i++ ) {
        for ( j = 0; j < rows; j++ ) {
            Splus_times_Ut[i+j*columns] = 0.0;
            for ( k = 0; k < rows; k++ ) {
                Splus_times_Ut[i+j*columns] = 
                Splus_times_Ut[i+j*columns] + 
                Splus[i+k*columns] * U[j+k*rows];
            } 
        } 
    }
    
    for ( i = 0; i < columns; i++ ) {
        for ( j = 0; j < rows; j++ ) {
            Aplus[j+i*rows] = 0.0;
            for ( k = 0; k < columns; k++ ) {
                Aplus[j+i*rows] =
                Aplus[j+i*rows] + 
                Vt[k+i*columns] * Splus_times_Ut[k+j*columns];
            } 
        } 
    }
    
    free(Splus);
    free(Splus_times_Ut);
    free(U);
    free(Vt);
    free(S);
    
    return;
}
/*
 * Calculate QR decomposition of Matrix A.
 *
 * This function works with column-major matrix arrays.
 */
+ (void)getQROf:(double *)A Rows:(int)rows Columns:(int)columns OutQ:(double *)Q OutR:(double *)R
{
    // Prepare variables
    int m = rows;
    int n = columns;
    double *a = A;
    int lda = MAX(1, m);
    int k = MIN(m, n);
    double* tau = malloc(MIN(m, n) * sizeof(double));
    int lwork = MAX(1, n);
    double* work = malloc(MAX(1, lwork) * sizeof (double));
    int info;
    
    // Perform QR using dgeqrf
    dgeqrf_(&m, &n, a, &lda, tau, work, &lwork, &info);
    if (info != 0) return;
    
    // Here derive R(kxn) from tau; R should be malloc'd already.
    
    for (int i = 0; i < k; i++) // rows
    {
        for (int j = 0; j < n; j++) // columns
        {
            if (j >= i)
            {
                R[j*k + i] = a[j*lda + i];
            }
            else
            {
                R[j*k + i] = 0;
            }
        }
    }
    
    // Then, use dorgqr to derive Q; Q should be malloc'd already.
    dorgqr_(&m, &k, &k, a, &lda, tau, work, &lwork, &info);
    if (info != 0) return;
    
    // Copy result to output Q
    memcpy(Q, a, m*k * sizeof(double));
    
    free(work);
    free(tau);
}

@end
