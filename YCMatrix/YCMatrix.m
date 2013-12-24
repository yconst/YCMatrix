//
//  YCMatrix.m
//  YCMatrix
//
//  Created by Yan Const on 11/7/13.
//  Copyright (c) 2013 Ioannis Chatzikonstantinou. All rights reserved.
//

#import "YCMatrix.h"

@implementation YCMatrix

#pragma mark Factory Methods

+ (instancetype)matrixOfRows:(int)m Columns:(int)n
{
    YCMatrix *mt = [[YCMatrix alloc] init];
    double *new_m = calloc(m*n, sizeof(double));
    mt->rows = m;
    mt->columns = n;
    mt->matrix = new_m;
    return mt;
}

+ (instancetype)dirtyMatrixOfRows:(int)m Columns:(int)n
{
    YCMatrix *mt = [[YCMatrix alloc] init];
    double *new_m = malloc(m*n * sizeof(double));
    mt->rows = m;
    mt->columns = n;
    mt->matrix = new_m;
    return mt;
}

+ (instancetype)matrixOfRows:(int)m Columns:(int)n WithValue:(double)val
{
    YCMatrix *mt = [YCMatrix matrixOfRows:m Columns:n];
    int len = m*n;
    for (int i=0; i<len; i++)
    {
        mt->matrix[i] = val;
    }
    return mt;
}

+ (instancetype)matrixFromArray:(double *)arr Rows:(int)m Columns:(int)n
{
    YCMatrix *mt = [[YCMatrix alloc] init];
    double *new_m = malloc(m*n*sizeof(double));
    memcpy(new_m, arr, m*n*sizeof(double));
    mt->matrix = new_m;
    mt->rows = m;
    mt->columns = n;
    return mt;
}

+ (instancetype)matrixFromNSArray:(NSArray *)arr Rows:(int)m Columns:(int)n
{
    if([arr count] != m*n)
        @throw [NSException exceptionWithName:@"MatrixSizeException"
                                       reason:@"Matrix size does not match that of the input array."
                                     userInfo:nil];
    YCMatrix *newMatrix = [YCMatrix matrixOfRows:m Columns:n];
    double *cArray = newMatrix->matrix;
    int i = 0;
    for (id item in arr) {
        cArray[i] = [[arr objectAtIndex:i] doubleValue];
        i++;
    }
    return newMatrix;
}

+ (instancetype) matrixFromMatrix:(YCMatrix *)other
{
    YCMatrix *mt = [YCMatrix matrixFromArray:other->matrix Rows:other->rows Columns:other->columns];
    return mt;
}

+ (instancetype)identityOfRows:(int)m Columns:(int)n
{
    double *new_m = calloc(m*n, sizeof(double));
    int minsize = m;
    if (n < m) minsize = n;
    for(int i=0; i<minsize; i++) {
        new_m[(n + 1)*i] = 1.0;
    }
    return [YCMatrix matrixFromArray:new_m Rows:m Columns:n];
}

#pragma mark Instance Methods

- (double)getValueAtRow:(long)row Column:(long)column
{
    [self checkBoundsForRow:row Column:column];
    return matrix[row*columns + column];
}

- (void)setValue:(double)vl Row:(long)row Column:(long)column
{
    [self checkBoundsForRow:row Column:column];
    matrix[row*columns + column] = vl;
}

- (void)checkBoundsForRow:(long)row Column:(long)column
{
    if(column >= columns)
        @throw [NSException exceptionWithName:@"IndexOutOfBoundsException"
                                       reason:@"Column index input is out of bounds."
                                     userInfo:nil];
    if(row >= rows)
        @throw [NSException exceptionWithName:@"IndexOutOfBoundsException"
                                       reason:@"Rows index input is out of bounds."
                                     userInfo:nil];
}
- (void)checkMultiplicationRows:(long)mrows Columns:(long)mcolumns
{
    if(mcolumns != mrows)
    {
        @throw [NSException exceptionWithName:@"MatrixSizeException"
                                       reason:@"Matrix size unsuitable for multiplication."
                                     userInfo:nil];
    }
}

- (YCMatrix *)matrixByAdding:(YCMatrix *)addend
{
    return [self matrixByMultiplyingWithScalar:1 AndAdding:addend];
}

- (YCMatrix *)matrixBySubtracting:(YCMatrix *)subtrahend
{
    return [subtrahend matrixByMultiplyingWithScalar:-1 AndAdding:self];
}

- (YCMatrix *)matrixByMultiplyingWithRight:(YCMatrix *)mt
{
    return [self matrixByMultiplyingWithRight:mt AndFactor:1];
}

- (YCMatrix *)matrixByMultiplyingWithRight:(YCMatrix *)mt AndTransposing:(bool)trans
{
    // OK, seriously, FUCK BLAS. This cost me a full day of debugging and I'm still
    // not sure its fully functional. FUCK YOU.
    if (!trans) return [self matrixByMultiplyingWithRight:mt];
    [self checkMultiplicationRows:mt->rows Columns:columns];
    YCMatrix *A = mt;
    YCMatrix *B = self;
    YCMatrix *C = [YCMatrix matrixOfRows:A->columns Columns:B->rows];
    cblas_dgemm(CblasRowMajor, CblasTrans, CblasTrans, A->columns, B->rows, A->rows, 1, A->matrix, A->columns, B->matrix, B->columns, 1, C->matrix, C->columns);
    return C;
}

- (YCMatrix *)matrixByMultiplyingWithRight:(YCMatrix *)mt AndAdding:(YCMatrix *)ma
{
    [self checkMultiplicationRows:mt->rows Columns:columns];
    YCMatrix *result = [YCMatrix matrixFromMatrix:ma];
    cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, rows, mt->columns, columns, 1, matrix, columns, mt->matrix, mt->columns, 1, result->matrix, result->columns);
    return result;
}

- (YCMatrix *)matrixByMultiplyingWithRight:(YCMatrix *)mt AndFactor:(double)sf
{
    [self checkMultiplicationRows:mt->rows Columns:columns];
    YCMatrix *result = [YCMatrix matrixOfRows:rows Columns:mt->columns];
    cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, rows, mt->columns, columns, sf, matrix, columns, mt->matrix, mt->columns, 1, result->matrix, result->columns);
    return result;
}

- (YCMatrix *)matrixByMultiplyingWithScalar:(double)ms
{
    YCMatrix *product = [YCMatrix matrixFromMatrix:self];
    cblas_dscal(rows*columns, ms, product->matrix, 1);
    return product;
}

- (YCMatrix *)matrixByMultiplyingWithScalar:(double)ms AndAdding:(YCMatrix *)addend
{
    if(columns != addend->columns || rows != addend->rows || sizeof(matrix) != sizeof(addend->matrix))
        @throw [NSException exceptionWithName:@"MatrixSizeException"
                                       reason:@"Matrix size mismatch."
                                     userInfo:nil];
    YCMatrix *sum = [YCMatrix matrixFromMatrix:addend];
    cblas_daxpy(rows*columns, ms, self->matrix, 1, sum->matrix, 1);
    return sum;
}

- (YCMatrix *)matrixByNegating
{
    return [self matrixByMultiplyingWithScalar:-1];
}

- (YCMatrix *)matrixByTransposing
{
    YCMatrix *trans = [YCMatrix dirtyMatrixOfRows:columns Columns:rows];
    vDSP_mtransD(self->matrix, 1, trans->matrix, 1, trans->rows, trans->columns);
    return trans;
}


- (void)add:(YCMatrix *)addend
{
    if(columns != addend->columns || rows != addend->rows || sizeof(matrix) != sizeof(addend->matrix))
        @throw [NSException exceptionWithName:@"MatrixSizeException"
                                       reason:@"Matrix size mismatch."
                                     userInfo:nil];
    cblas_daxpy(rows*columns, 1, addend->matrix, 1, self->matrix, 1);
}

- (void)subtract:(YCMatrix *)subtrahend
{
    if(columns != subtrahend->columns || rows != subtrahend->rows || sizeof(matrix) != sizeof(subtrahend->matrix))
        @throw [NSException exceptionWithName:@"MatrixSizeException"
                                       reason:@"Matrix size mismatch."
                                     userInfo:nil];
    cblas_daxpy(rows*columns, 1, subtrahend->matrix, -1, self->matrix, 1);
}

- (void)multiplyWithScalar:(double)ms
{
    cblas_dscal(rows*columns, ms, matrix, 1);
}

- (void)negate
{
    [self multiplyWithScalar:-1];
}

- (double)trace
{
    if(columns != rows)
        @throw [NSException exceptionWithName:@"MatrixSizeException"
                                       reason:@"Matrix should be square for trace."
                                     userInfo:nil];
    double trace = 0;
    for (int i=0; i<rows; i++)
    {
        trace += matrix[i*(columns + 1)];
    }
    return trace;
}

- (double)determinant
{
//    /* Lapack routines with a convenient Matrix wrapper.
//     */
//    
//#include <malloc.h>
//#include <math.h>
//#include "matrix.h"
//#include <tpm/memcheck.h>
//    
//    /* The Fortran routines expect column-major matrices, but our Matrices are
//     * row-major. These functions try to hide this difference as much as possible.
//     */
//    
//    /* Returns the determinant of A. */
//    Real MatrixDeterminant(Matrix A)
//    {
//        int   *ipvt;
//        int    info;
//        Real   det = 1.0;
//        int    c1, neg = 0;
//        Matrix tmp;
//        
//        tmp = MatrixCopy(A);
//        ipvt = Allocate(tmp->height, int);
//        /* Note width and height are reversed */
//        F77_FCN(dgetrf)(&tmp->width, &tmp->height, tmp->data[0],
//                        &tmp->height, ipvt, &info);
//        if(info > 0) {
//            /* singular matrix */
//            return 0.0;
//        }
//        
//        /* Take the product of the diagonal elements */
//        for (c1 = 0; c1 < tmp->height; c1++) {
//            det *= tmp->data[c1][c1];
//            if (ipvt[c1] != (c1+1)) neg = !neg;
//        }
//        free(ipvt);
//        MatrixFree(tmp);
//        
//        /* Since tmp is an LU decomposition of a rowwise permutation of A,
//         multiply by appropriate sign */
//        return neg?-det:det;
//    }
}

- (double)dotWith:(YCMatrix *)other
{
    // A few more checks need to be made here.
    if(sizeof(matrix) != sizeof(other->matrix))
        @throw [NSException exceptionWithName:@"MatrixSizeException"
                                       reason:@"Matrix size mismatch."
                                     userInfo:nil];
    if(columns != 1 && rows != 1)
        @throw [NSException exceptionWithName:@"MatrixSizeException"
                                       reason:@"Dot can only be performed on vectors."
                                     userInfo:nil];
    return cblas_ddot(self->rows * self->columns, self->matrix, 1, other->matrix, 1);
}

- (YCMatrix *)matrixByUnitizing
{
    if(columns != 1 && rows != 1)
        @throw [NSException exceptionWithName:@"MatrixSizeException"
                                       reason:@"Unit can only be performed on vectors."
                                     userInfo:nil];
    int len = rows * columns;
    double sqsum = 0;
    for (int i=0; i<len; i++)
    {
        double v = matrix[i];
        sqsum += v*v;
    }
    double invmag = 1/sqrt(sqsum);
    YCMatrix *norm = [YCMatrix matrixOfRows:rows Columns:columns];
    double *normMatrix = norm->matrix;
    for (int i=0; i<len; i++)
    {
        normMatrix[i] = matrix[i] * invmag;
    }
    return norm;
}

- (double *)getArray
{
    return matrix;
}

- (double *)getArrayCopy
{
    double *resArr = calloc(self->rows*self->columns, sizeof(double));
    memcpy(resArr, matrix, self->rows*self->columns*sizeof(double));
    return resArr;
}

- (BOOL)isSquare
{
    return self->rows == self->columns;
}

- (BOOL)isEqual:(id)anObject {
    if (![anObject isKindOfClass:[self class]]) return false;
    YCMatrix *other = (YCMatrix *)anObject;
    if (rows != other->rows || columns != other->columns) return false;
    if (sizeof(other->matrix) != sizeof(matrix)) return false;
    int arr_length = sizeof(matrix) / sizeof(double);
    for (int i=0; i<arr_length;i++) {
        if (matrix[i] != other->matrix[i]) return false;
    }
    return true;
}

- (NSString *)description {
    NSString *s = @"\n";
    for ( int i=0; i<rows*columns; ++i ) {
        s = [NSString stringWithFormat:@"%@\t%f,", s, matrix[i]];
        if (i % columns == columns - 1) s = [NSString stringWithFormat:@"%@\n", s];
    }
    return s;
}

#pragma mark Object Destruction

- (void)dealloc {
    free(self->matrix);
}

#pragma mark NSCoding Implementation

- (void)encodeWithCoder:(NSCoder *)encoder
{
    long len = self->rows * self->columns;
    NSMutableArray *matrixContent = [NSMutableArray arrayWithCapacity:len];
    for (int i=0; i<len; i++)
    {
        matrixContent[i] = @(self->matrix[i]);
    }
    [encoder encodeObject:matrixContent forKey:@"matrixContent"];
    [encoder encodeObject:@(self->rows) forKey:@"rows"];
    [encoder encodeObject:@(self->columns) forKey:@"columns"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init])
    {
        self->rows = [[decoder decodeObjectForKey:@"rows"] intValue];
        self->columns = [[decoder decodeObjectForKey:@"columns"] intValue];
        NSArray *matrixContent = [decoder decodeObjectForKey:@"matrixContent"];
        long len = self->rows*self->columns;
        self->matrix = malloc(len*sizeof(double));
        for (int i=0; i<len; i++)
        {
            self->matrix[i] = [matrixContent[i] doubleValue];
        }
    }
    return self;
}

@end
