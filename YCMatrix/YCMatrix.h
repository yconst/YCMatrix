//
//  YCMatrix.h
//  YCMatrix
//
//  Created by Yan Const on 11/7/13.
//  Copyright (c) 2013 Ioannis Chatzikonstantinou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accelerate/Accelerate.h>

@interface YCMatrix : NSObject <NSCoding, NSCopying>
{
    
@public double *matrix;
@public int rows;
@public int columns;

}

// Returns a new YCMatrix of |m| rows and |n| columns
+ (instancetype)matrixOfRows:(int)m Columns:(int)n;

// Returns a new YCMatrix of |m| rows and |n| columns, each containing value |val|
+ (instancetype)matrixOfRows:(int)m Columns:(int)n WithValue:(double)val;

// Returns a new YCMatrix of |m| rows and |n| columns, using the values from array |arr|
+ (instancetype)matrixFromArray:(double *)arr Rows:(int)m Columns:(int)n;

// Returns a new YCMatrix of |m| rows and |n| columns, using the values from
// either array |arr| or a copy of it
+ (instancetype)matrixFromArray:(double *)arr Rows:(int)m Columns:(int)n Copy:(BOOL)copy;

// Returns a new YCMatrix of |m| rows and |n| columns, using the values from NSArray |arr|
+ (instancetype)matrixFromNSArray:(NSArray *)arr Rows:(int)m Columns:(int)n;

// Returns a new YCMatrix by copying matrix |other|
+ (instancetype)matrixFromMatrix:(YCMatrix *)other;

// Returns a new Identity Matrix of |m| rows and |n| columns
+ (instancetype)identityOfRows:(int)m Columns:(int)n;

// Returns value at |row| and |column|
- (double)getValueAtRow:(long)row Column:(long)column;

// Sets value |vl| at |row| and |column|
- (void)setValue:(double)vl Row:(long)row Column:(long)column;

// Returns a new YCMatrix by adding this matrix to |addend|
- (YCMatrix *)matrixByAdding:(YCMatrix *)addend;

// Returns a new YCMatrix by subtracting |subtrahend|
- (YCMatrix *)matrixBySubtracting:(YCMatrix *)subtrahend;

// Returns a new YCMatrix by multiplying with right matrix |mt|
- (YCMatrix *)matrixByMultiplyingWithRight:(YCMatrix *)mt;

// Returns a new YCMatrix by multiplying with right matrix |mt| and optionally transposing
- (YCMatrix *)matrixByMultiplyingWithRight:(YCMatrix *)mt AndTransposing:(bool)trans;

// Returns a new YCMatrix by multiplying with right matrix |mt| and afterwards adding |ma|
- (YCMatrix *)matrixByMultiplyingWithRight:(YCMatrix *)mt AndAdding:(YCMatrix *)ma;

// Returns a new YCMatrix by multiplying with right matrix |mt| and
// afterwards with scaling factor |sf|
- (YCMatrix *)matrixByMultiplyingWithRight:(YCMatrix *)mt AndFactor:(double)sf;

// Returns a new YCMatrix by first transposing and then multiplying
// with right matrix |mt|
- (YCMatrix *)matrixByTransposingAndMultiplyingWithRight:(YCMatrix *)mt;

// Returns a new YCMatrix by first transposing and then multiplying
// with left matrix |mt|
- (YCMatrix *)matrixByTransposingAndMultiplyingWithLeft:(YCMatrix *)mt;

// Returns a new YCMatrix by multiplying with scalar |ms|
- (YCMatrix *)matrixByMultiplyingWithScalar:(double)ms;

// Returns a new YCMatrix by multiplying with scalar |ms| and adding matrix |addend|
- (YCMatrix *)matrixByMultiplyingWithScalar:(double)ms AndAdding:(YCMatrix *)addend;

// Returns a new YCMatrix by negating
- (YCMatrix *)matrixByNegating;

// Returns a new YCMatrix by transposing
- (YCMatrix *)matrixByTransposing;

// Performs an in-place addition
- (void)add:(YCMatrix *)addend;

// Performs an in-place subtraction
- (void)subtract:(YCMatrix *)subtrahend;

// Performs an in-place scalar multiplication
- (void)multiplyWithScalar:(double)ms;

// Performs an in-place negation
- (void)negate;

// Returns the trace
- (double)trace;

// Returns the determinant of the matrix. NOTE: Untested!
//- (double)determinant;

// Returns a scalar value resulting from the summation of element-to-element multiplication with |other|
- (double)dotWith:(YCMatrix *)other;

// Returns a unitized copy (only applicable to vectors)
- (YCMatrix *)matrixByUnitizing;

// Returns a reference to the matrix's elements array
- (double *)getArray;

// Returns a copy of the matrix's elements array
- (double *)getArrayCopy;

// Returns whether the matrix is square or not
- (BOOL)isSquare;

@end
