//
//  Matrix.h
//  Matrix
//
//  Created by Yan Const on 11/7/13.
//  Copyright (c) 2013, 2014 Ioannis Chatzikonstantinou. All rights reserved.
//

#import "YCMatrix.h"
#import "YCMatrix+Manipulate.h"
#import <Accelerate/Accelerate.h>

@interface YCMatrix (Advanced)

// Returns the pseudo-inverse using Singular Value Decomposition
- (YCMatrix *)pseudoInverse;

// Returns the QR factorization of a matrix
- (NSDictionary *)QR;

// Returns the SVD decomposition of a matrix
- (NSDictionary *)SVD;

// Performs an in-place Cholesky decomposition
- (void)cholesky;

// Returns a new matrix by performing Cholesky decomposition
- (YCMatrix *)matrixByCholesky;

// Returns a row matrix containing the Eigenvalues of the matrix
- (YCMatrix *)eigenvalues;

// Returns a vector of the means of the rows
- (YCMatrix *)RowMean;

// Returns a vector of the means of the columns
- (YCMatrix *)ColumnMean;

@end
