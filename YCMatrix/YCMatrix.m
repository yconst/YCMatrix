//
//  YCMatrix.m
//  YCMatrix
//
//  Created by Yan Const on 11/7/13.
//  Copyright (c) 2013 Ioannis Chatzikonstantinou. All rights reserved.
//

#import "YCMatrix.h"

@implementation YCMatrix

+ (instancetype)matrixOfRows:(int)m Columns:(int)n {
    YCMatrix *mt = [[YCMatrix alloc] init];
    double *new_m = calloc(m*n, sizeof(double));
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
+ (instancetype)matrixFromArray:(double *)arr Rows:(int)m Columns:(int)n {
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
+ (instancetype) matrixFromMatrix:(YCMatrix *)other {
    YCMatrix *mt = [YCMatrix matrixFromArray:other->matrix Rows:other->rows Columns:other->columns];
    return mt;
}
+ (instancetype)identityOfRows:(int)m Columns:(int)n {
    double *new_m = calloc(m*n, sizeof(double));
    int minsize = m;
    if (n < m) minsize = n;
    for(int i=0; i<minsize; i++) {
        new_m[(n + 1)*i] = 1.0;
    }
    return [YCMatrix matrixFromArray:new_m Rows:m Columns:n];
}
- (double)getValueAtRow:(int)row Column:(int)column
{
    [self checkBoundsForRow:row Column:column];
    return matrix[row*columns + column];
}
- (void)setValue:(double)vl Row:(int)row Column:(int)column
{
    [self checkBoundsForRow:row Column:column];
    matrix[row*columns + column] = vl;
}
- (void)checkBoundsForRow:(int)row Column:(int)column
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
- (YCMatrix *)addWith:(YCMatrix *)addend {
    if(columns != addend->columns || rows != addend->rows || sizeof(matrix) != sizeof(addend->matrix))
        @throw [NSException exceptionWithName:@"MatrixSizeException"
                                       reason:@"Matrix size mismatch."
                                     userInfo:nil];
    int lng = rows*columns;
    YCMatrix *sum = [YCMatrix matrixOfRows:rows Columns:columns];
    double *sumArray = sum->matrix;
    for (int i=0; i<lng; i++) {
        sumArray[i] = matrix[i] + addend->matrix[i];
    }
    return sum;
}
- (YCMatrix *)subtract:(YCMatrix *)subtrahend {
    if(columns != subtrahend->columns || rows != subtrahend->rows || sizeof(matrix) != sizeof(subtrahend->matrix))
        @throw [NSException exceptionWithName:@"MatrixSizeException"
                                       reason:@"Matrix size mismatch."
                                     userInfo:nil];
    int lng = rows*columns;
    YCMatrix *diff = [YCMatrix matrixOfRows:rows Columns:columns];
    double *diffArray = diff->matrix;
    for (int i = 0;i < lng; i++) {
        diffArray[i] = matrix[i] - subtrahend->matrix[i];
    }
    return diff;
}
- (YCMatrix *)multiplyWithRight:(YCMatrix *)mt {
    if(columns != mt->rows)
        @throw [NSException exceptionWithName:@"MatrixSizeException"
                                       reason:@"Matrix size unsuitable for multiplication."
                                     userInfo:nil];
    YCMatrix *result = [YCMatrix matrixOfRows:rows Columns:mt->columns];
    cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, rows, mt->columns, columns, 1, matrix, columns, mt->matrix, mt->columns, 1, result->matrix, result->columns);
    return result;
}
- (YCMatrix *)multiplyWithLeft:(YCMatrix *)mt {
    YCMatrix *result = [mt multiplyWithRight:self];
    return result;
}
- (YCMatrix *)multiplyWithScalar:(double)ms {
    int lng = rows*columns;
    YCMatrix *product = [YCMatrix matrixOfRows:rows Columns:columns];
    double *multArray = product->matrix;
    for (int i = 0;i < lng; i++) {
        multArray[i] = matrix[i] * ms;
    }
    return product;
}
- (YCMatrix *)negate {
    return [self multiplyWithScalar:-1];
}
// http://rosettacode.org/wiki/Matrix_transposition
- (YCMatrix *)transpose {
    YCMatrix *trans = [YCMatrix matrixFromMatrix:self];
    trans->columns = rows;
    trans->rows = columns;
    double *m = trans->matrix;
    int start, next, i;
	double tmp;
    
	for (start = 0; start <= columns * rows - 1; start++) {
		next = start;
		i = 0;
		do {	i++;
			next = (next % rows) * columns + next / rows;
		} while (next > start);
		if (next < start || i == 1) continue;
        
		tmp = m[next = start];
		do {
			i = (next % rows) * columns + next / rows;
			m[next] = (i == start) ? tmp : m[i];
			next = i;
		} while (next > start);
	}
    return trans;
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
    int size = self->rows * self->columns;
    double result = 0;
    for (int i=0; i<size; i++)
    {
        result += self->matrix[i] * other->matrix[i];
    }
    return result;
}
- (YCMatrix *)unit
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
- (double *)getArray {
    return matrix;
}
- (double *)getArrayCopy
{
    double *resArr = calloc(self->rows*self->columns, sizeof(double));
    memcpy(resArr, matrix, self->rows*self->columns*sizeof(double));
    return resArr;
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
-(void)dealloc {
    free(self->matrix);
}

@end
