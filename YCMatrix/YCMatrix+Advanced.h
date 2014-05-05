//
//  Matrix.h
//  Matrix
//
//  Created by Yan Const on 11/7/13.
//  Copyright (c) 2013 Ioannis Chatzikonstantinou. All rights reserved.
//

#import "YCMatrix.h"
#import "YCMatrix+Manipulate.h"
#import <Accelerate/Accelerate.h>

@interface YCMatrix (Advanced)

// Returns the inverse or nil if inversion failed
- (YCMatrix *)inverse;

// Returns the pseudo-inverse using Singular Value Decomposition
- (YCMatrix *)pseudoInverse;

// Returns the QR factorization of a matrix
- (NSDictionary *)QR;

// Returns a vector of the means of the rows
- (YCMatrix *)RowMean;

// Returns a vector of the means of the columns
- (YCMatrix *)ColumnMean;

@end
