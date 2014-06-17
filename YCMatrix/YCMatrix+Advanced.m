//
//  Matrix.h
//  Matrix
//
//  Created by Yan Const on 11/7/13.
//  Copyright (c) 2013 Ioannis Chatzikonstantinou. All rights reserved.
//
// References for this document:
// http://jira.madlib.net/secure/attachment/10019/matrixpinv.cpp
// http://vismod.media.mit.edu/pub/tpminka/MRSAR/lapack.c
//

#import "YCMatrix+Advanced.h"

@implementation YCMatrix (Advanced)

- (YCMatrix *)pseudoInverse
{
    YCMatrix *ret = [YCMatrix matrixOfRows:self->columns Columns:self->rows];
    [YCMatrix getPinvOf:self->matrix Rows:self->rows Columns:self->columns Out:ret->matrix];
    return ret;
}

- (NSDictionary *)QR
{
}

- (NSDictionary *)SVD
{
    double *ua = NULL;
    double *sa = NULL;
    double *vta = NULL;
    
    [[self class] getSVDOf:self->matrix Rows:rows Columns:columns S:&sa U:&ua Vt:&vta];
    
    YCMatrix *U = [YCMatrix matrixFromArray:ua Rows:self->rows Columns:self->rows Copy:NO]; // mxm
    YCMatrix *S = [YCMatrix matrixFromArray:sa Rows:self->rows Columns:self->columns Copy:NO]; // mxn
    YCMatrix *Vt = [YCMatrix matrixFromArray:vta Rows:self->columns Columns:self->columns Copy:NO]; // nxn

    return @{@"U" : U, @"S" : S, @"Vt" : Vt};
}

/* Makes lower triangular R such that R * R' = self.
 * Modifies self.
 * Returns 0 if an error occurred.
 */
- (void)cholesky
{
    char uplo = 'U';
    int rank = self->rows;
    int info;
    int i,j;

    dpotrf_(&uplo, &rank, self->matrix, &self->rows, &info);
    if(info > 0)
    {
        @throw [NSException exceptionWithName:@"YCMatrixException"
                                       reason:@"Matrix is not positive definite."
                                     userInfo:nil];
    }
    /* clear out the upper triangular */
    for(i=0; i<self->rows; i++)
    {
        for(j=i+1; j<self->columns; j++)
        {
            self->matrix[i*self->columns + j] = 0.0;
        }
    }
}

- (YCMatrix *)matrixByCholesky
{
    YCMatrix *newMatrix = [self copy];
    [newMatrix cholesky];
    return newMatrix;
}

- (YCMatrix *)eigenvalues
{
    if (self->rows != self->columns)
    {
        @throw [NSException exceptionWithName:@"YCMatrixException"
                                       reason:@"Matrix is not square."
                                     userInfo:nil];
    }
    double *evArray = malloc(self->rows * sizeof(double));
    [self getMatrixEigenvaluesOf:self->matrix Rows:self->rows Columns:self->columns Vr:evArray Vi:nil];
    return [YCMatrix matrixFromArray:evArray Rows:1 Columns:self->columns];
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

+ (void)getSVDOf:(double *)A Rows:(int)rows Columns:(int)columns S:(double **)s U:(double **)u Vt:(double **)vt
{
    /*
     
     Compute the Singular Value Decomposition of matrix A
     
     Author:  Luke Lonergan
     Date:    5/31/08
     License: Use pfreely
     
    */
    
    int    i, j;
    int    lwork, *iwork;
    double     *work, *Atemp;
    double     *S, *U, *Vt;
    char        achar='A';   /* ? */
    
    /*
     * The factors of A: S, U and Vt
     * U, Sdiag and Vt are the factors of the pseudo inverse of A, the
     * components of the singular value decomposition of A
     */
    S = (double *) malloc(sizeof(double)*MIN(rows,columns));
    U = (double *) malloc(sizeof(double)*rows*rows);
    Vt = (double *) malloc(sizeof(double)*columns*columns);
    
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
        free(Atemp);
        free(S);
        free(U);
        free(Vt);
        free(iwork);
        free(work);
        @throw [NSException exceptionWithName:@"YCMatrixException"
                                       reason:@"Error while performing SVD."
                                     userInfo:nil];
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
    if (i == 0)
    {
        *s = S;
        *u = U;
        *vt = Vt;
    }
    else
    {
        free(S);
        free(U);
        free(Vt);
        @throw [NSException exceptionWithName:@"YCMatrixException"
                                       reason:@"Error while performing SVD."
                                     userInfo:nil];
    }
}

+ (void)getPinvOf:(double *)A Rows:(int)rows Columns:(int)columns Out:(double *)Aplus
    /*
      
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
    double      epsilon, tolerance, maxeigen;
    double     *S = NULL, *U = NULL, *Vt = NULL;
    double     *Splus, *Splus_times_Ut;
    
    /* 
     * Calculate the tolerance for "zero" values in the SVD 
     *    t = ε•max(rows,columns)•max(Σ) 
     *  (Need to multiply tolerance by max of the eigenvalues when they're 
     *   available)
     */
    epsilon = pow(2,1-56); 
    tolerance = epsilon * MAX(rows,columns); 
    maxeigen=-1.;
    
    [self getSVDOf:A Rows:rows Columns:columns S:&S U:&U Vt:&Vt];
    
    /* Use the max of the eigenvalues to normalize the zero tolerance */
    minmn = MIN(rows,columns); // The dimensions of S are min(rows,columns)
    for ( i = 0; i < minmn; i++ ) {
        maxeigen = MAX(maxeigen,S[i]);
    }
    tolerance *= maxeigen;
    
    /* Working matrices for the pseudo inverse calculation: */
    /*  1) The pseudo inverse of S: S+ */
    Splus = (double *) malloc(sizeof(double)*columns*rows);
    /*  2) An intermediate result: S+ Ut */
    Splus_times_Ut = (double *) malloc(sizeof(double)*columns*rows);

    
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

/* Modifies B to have the solution x to A * x = B.
 * Returns 0 if an error occurred.
 */
//int MatrixSolve(Matrix A, Real *B)
//{
//    int *ipvt;
//    int info;
//    Matrix tmp;
//    char job;
//    int nrhs;
//
//    tmp = MatrixCopy(A);
//    ipvt = Allocate(tmp->height, int);
//    /* Note width and height are reversed */
//    F77_FCN(dgetrf)(&tmp->width, &tmp->height, tmp->data[0],
//                    &tmp->height, ipvt, &info);
//    if(info > 0) {
//        fprintf(stderr, "MatrixSolve: dgetrf reports singular matrix\n");
//        return 0;
//    }
//    else {
//        job = 'T';
//        nrhs = 1;
//        F77_FCN(dgetrs)(&job, &tmp->width, &nrhs, tmp->data[0], &tmp->height,
//                        ipvt, B, &tmp->height, &info);
//    }
//    free(ipvt);
//    MatrixFree(tmp);
//    return 1;
//}

/* Fills vr and vi with the real and imaginary parts of the eigenvalues of A.
 * If vr or vi is NULL, that part of the result will not be returned.
 * Returns 0 if an error occurred.
 */
- (void)getMatrixEigenvaluesOf:(double *)A Rows:(int)m Columns:(int)n Vr:(double *)vr Vi:(double *)vi
{
    char jobvl = 'N', jobvr = 'N';
    int rank = m;
    double *dup;
    int one = 1;
    int lwork;
    double *work;
    int info;
    double *wr, *wi;

    if (vr == nil)
    {
        wr = malloc(rank * sizeof(double));
    }
    else
    {
        wr = vr;
    }
    if (vi == nil)
    {
        wi = malloc(rank * sizeof(double));
    }
    else
    {
        wi = vi;
    }

    /* make a copy since dgeev clobbers A */
    dup = malloc(rows * columns * sizeof(double));
    memcpy(dup, A, rows * columns * sizeof(double));

    lwork = 3 * rank;
    work = malloc(lwork *sizeof(double));

    dgeev_(&jobvl, &jobvr, &rank, dup, &rank,
                   wr, wi, NULL, &one, NULL, &one, work, &lwork, &info);
    free(dup);
    free(work);
    if(vr == NULL) free(wr);
    if(vi == NULL) free(wi);
    if(info > 0)
    {
        @throw [NSException exceptionWithName:@"YCMatrixException"
                                       reason:@"Error while calculating Eigenvalues."
                                     userInfo:nil];
    }
}

@end
