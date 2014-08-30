//
//  YCMatrix.m
//  YCMatrix
//
//  Created by Yan Const on 11/7/13.
//  Copyright (c) 2013, 2014 Ioannis Chatzikonstantinou. All rights reserved.
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

+ (instancetype)matrixFromArray:(double *)arr Rows:(int)m Columns:(int)n Copy:(BOOL)copy
{
    YCMatrix *mt = [[YCMatrix alloc] init];
    if (copy)
    {
        double *new_m = malloc(m*n*sizeof(double));
        memcpy(new_m, arr, m*n*sizeof(double));
        mt->matrix = new_m;
    }
    else
    {
        mt->matrix = arr;
    }
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
    for (long i=0, j=[arr count]; i<j; i++)
    {
        cArray[i] = [[arr objectAtIndex:i] doubleValue];
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
    return [self matrixByTransposing:NO
                    TransposingRight:NO
                   MultiplyWithRight:mt
                              Factor:1
                              Adding:nil];
}

- (YCMatrix *)matrixByMultiplyingWithRight:(YCMatrix *)mt AndTransposing:(bool)trans
{
    YCMatrix *M1 = trans ? mt : self;
    YCMatrix *M2 = trans ? self : mt;
    return [M1 matrixByTransposing:trans
                  TransposingRight:trans
                 MultiplyWithRight:M2
                            Factor:1
                            Adding:nil];
}

- (YCMatrix *)matrixByMultiplyingWithRight:(YCMatrix *)mt AndAdding:(YCMatrix *)ma
{
    return [self matrixByTransposing:NO
                    TransposingRight:NO
                   MultiplyWithRight:mt
                              Factor:1
                              Adding:ma];
}

- (YCMatrix *)matrixByMultiplyingWithRight:(YCMatrix *)mt AndFactor:(double)sf
{
    return [self matrixByTransposing:NO
                    TransposingRight:NO
                   MultiplyWithRight:mt
                              Factor:sf
                              Adding:nil];
}

- (YCMatrix *)matrixByTransposingAndMultiplyingWithRight:(YCMatrix *)mt
{
    return [self matrixByTransposing:YES
                    TransposingRight:NO
                   MultiplyWithRight:mt
                              Factor:1
                              Adding:nil];
}

- (YCMatrix *)matrixByTransposingAndMultiplyingWithLeft:(YCMatrix *)mt
{
    return [mt matrixByTransposing:NO
                  TransposingRight:YES
                 MultiplyWithRight:self
                            Factor:1
                            Adding:nil];
}

//
// Actual calls to BLAS

- (YCMatrix *)matrixByTransposing:(BOOL)transposeLeft
                 TransposingRight:(BOOL)transposeRight
                MultiplyWithRight:(YCMatrix *)mt
                           Factor:(double)factor
                           Adding:(YCMatrix *)addend
{
    int M = transposeLeft ? columns : rows;
    int N = transposeRight ? mt->rows : mt->columns;
    int K = transposeLeft ? rows : columns;
    int lda = columns;
    int ldb = mt->columns;
    int ldc = N;
    
    if ((transposeLeft ? rows : columns) != (transposeRight ? mt->columns : mt->rows))
    {
        @throw [NSException exceptionWithName:@"MatrixSizeException"
                                       reason:@"Matrix size unsuitable for multiplication."
                                     userInfo:nil];
    }
    if (addend && (addend->rows != M && addend->columns != N)) // FIX!!!
    {
        @throw [NSException exceptionWithName:@"MatrixSizeException"
                                       reason:@"Matrix size unsuitable for addition."
                                     userInfo:nil];
    }
    enum CBLAS_TRANSPOSE lT = transposeLeft ? CblasTrans : CblasNoTrans;
    enum CBLAS_TRANSPOSE rT = transposeRight ? CblasTrans : CblasNoTrans;
    
    YCMatrix *result = addend ? [YCMatrix matrixFromMatrix:addend] : [YCMatrix matrixOfRows:M
                                                                                    Columns:N];
    cblas_dgemm(CblasRowMajor, lT,          rT,         M,
                N,              K,          factor,     matrix,
                lda,            mt->matrix, ldb,        1,
                result->matrix, ldc);
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

// End of actual calls to BLAS
//

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

- (instancetype)copyWithZone:(NSZone *)zone
{
    YCMatrix *newMatrix = [YCMatrix matrixFromArray:self->matrix
                                               Rows:self->rows
                                            Columns:self->columns];
    return newMatrix;
}

@end
