//
// YCMatrix+Advanced.h
//
// YCMatrix
//
// Copyright (c) 2013, 2014 Ioannis (Yannis) Chatzikonstantinou. All rights reserved.
// http://yconst.com
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "YCMatrix.h"
#import "YCMatrix+Manipulate.h"
#import <Accelerate/Accelerate.h>

@interface YCMatrix (Advanced)

/**
 Returns the pseudo-inverse of this matrix.
 The calculation is performed using Singular Value Decomposition.
 
 @return The pseudo-inverse of this YCMatrix.
 */
- (YCMatrix *)pseudoInverse;

/**
 Performs Singular Value Decomposition on this matrix.
 
 @return An NSDictionary containing the "U", "S", "V" components of the SVD of this YCMatrix.
 
 @warning   As a matter of efficiency, and because the corresponding LAPACK function requires
            column-major matrices, the output dictionary will contain the "V" matrix, and not 
            it's transpose.
 */
- (NSDictionary *)SVD;

/**
 Returns the X vector that is the solution to the linear system A * X = B, with this
 matrix being A.
 
 @param B The matrix B.
 
 @return The solution vector X.
 */
- (YCMatrix *)solve:(YCMatrix *)B;

/**
 Performs an in-place Cholesky decomposition on this matrix.
 Makes lower triangular R such that R * R' = self. Modifies self.
 */
- (void)cholesky;

/**
 Returns a new matrix by performing Cholesky decomposition on this matrix.
 Makes lower triangular R such that R * R' = self.
 
 @return The matrix resulting from the Cholesky decomposition of this YCMatrix.
 */
- (YCMatrix *)matrixByCholesky;

/**
 Returns a row YCMatrix containing the Eigenvalues of this matrix.
 
 @return The resulting row YCMatrix.
 */
- (YCMatrix *)eigenvalues;

/**
 Returns an NSDictionary with the results of performing an Eigenvalue decomposition.
 
 @return    A dictionary with the following key/value assignments:
            "Eigenvalues" : nx1 vector containing the matrix eigenvalues.
            "Left Eigenvectors" : nxn matrix containing the matrix left eigenvectors, one per row.
            "Right Eigenvectors" : nxn matrix containing the matrix right eigenvectors, one per row.
 */
- (NSDictionary *)eigenvaluesAndEigenvectors;

/**
 Returns the determinant of this YCMatrix.
 
 @return A double value corresponsing to the determinant of this matrix.
 
 @warning This method has not been extensively tested and may contain serious flaws.
 */
- (double)determinant;

// Returns a vector of the means of the rows
- (YCMatrix *)rowMean;

// Returns a vector of the means of the columns
- (YCMatrix *)columnMean;

// Returns a new matrix with each cell being the result of a function application
- (YCMatrix *)matrixByApplyingFunction:(double (^)(double value))function;

// Applies a function to each cell
- (void)applyFunction:(double (^)(double value))function;

@end
