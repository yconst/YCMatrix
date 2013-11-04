//
//  YCMatrix.h
//  YCMatrix
//
//  Created by Yan Const on 11/7/13.
//  Copyright (c) 2013 Ioannis Chatzikonstantinou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accelerate/Accelerate.h>

@interface YCMatrix : NSObject <NSCoding>
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

// Returns a new YCMatrix of |m| rows and |n| columns, using the values from NSArray |arr|
+ (instancetype)matrixFromNSArray:(NSArray *)arr Rows:(int)m Columns:(int)n;

// Returns a new YCMatrix by copying matrix |other|
+ (instancetype)matrixFromMatrix:(YCMatrix *) other;

// Returns a new Identity Matrix of |m| rows and |n| columns
+ (instancetype)identityOfRows:(int)m Columns:(int)n;

// Returns value at |row| and |column|
- (double)getValueAtRow:(long)row Column:(long)column;

// Sets value |vl| at |row| and |column|
- (void)setValue:(double)vl Row:(long)row Column:(long)column;

// Returns a new YCMatrix by adding this matrix to |addend|
- (YCMatrix *)addWith:(YCMatrix *)addend;

// Returns a new YCMatrix by subtracting |subtrahend|
- (YCMatrix *)subtract:(YCMatrix *)subtrahend;

// Returns a new YCMatrix by multiplying with right matrix |mt|
- (YCMatrix *)multiplyWithRight:(YCMatrix *)mt;

// Returns a new YCMatrix by multiplying with left matrix |mt|
- (YCMatrix *)multiplyWithLeft:(YCMatrix *)ml;

// Returns a new YCMatrix by multiplying with scalar |ms|
- (YCMatrix *)multiplyWithScalar:(double)ms;

// Returns a new YCMatrix by negating
- (YCMatrix *)negate;

// Returns a new YCMatrix by transposing
- (YCMatrix *)transpose;

// Returns the trace
- (double)trace;

// Returns a scalar value resulting from the summation of element-to-element multiplication with |other|
- (double)dotWith:(YCMatrix *)other;

// Returns a unitized copy (only applicable to vectors)
- (YCMatrix *)unit;
- (double *)getArray;
- (double *)getArrayCopy;

@end
