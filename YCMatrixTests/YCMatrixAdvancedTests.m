//
//  YCMatrixAdvancedTests.m
//
// YCMatrix
//
// Copyright (c) 2013 - 2016 Ioannis (Yannis) Chatzikonstantinou. All rights reserved.
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

@import XCTest;
@import YCMatrix;
#import <mm_malloc.h>

#define ARC4RANDOM_MAX 0x100000000 

// Definitions for convenience logging functions (without date/object and title logging).
#define CleanNSLog(FORMAT, ...) fprintf(stderr,"%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#define TitleNSLog(FORMAT, ...) fprintf(stderr,"\n%s\n_____________________________________\n\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

@interface YCMatrixAdvancedTests : XCTestCase

@end

@implementation YCMatrixAdvancedTests

- (void)testUniformRandom
{
    Matrix *lower = [Matrix matrixFromNSArray:@[@10, @5, @5, @10] rows:1 columns:4];
    Matrix *upper = [Matrix matrixFromNSArray:@[@20, @6, @10, @30] rows:1 columns:4];
    Matrix *random = [Matrix uniformRandomLowerBound:lower upperBound:upper];
    CleanNSLog(@"%@", random);
    XCTAssert([random i:0 j:0]>10);
    XCTAssert([random i:0 j:0]<20);
    XCTAssert([random i:0 j:1]>5);
    XCTAssert([random i:0 j:1]<6);
    XCTAssert([random i:0 j:2]>5);
    XCTAssert([random i:0 j:2]<10);
    XCTAssert([random i:0 j:3]>10);
    XCTAssert([random i:0 j:3]<30);
}

- (void)testNormalRandomColumns
{
    Matrix *mean = [Matrix matrixFromNSArray:@[@10, @5, @5, @10] rows:1 columns:4];
    Matrix *variance = [Matrix matrixFromNSArray:@[@1, @2, @3, @4] rows:1 columns:4];
    Matrix *random = [Matrix normalRandomMean:mean variance:variance count:20000];
    Matrix *actualMean = [random meansOfColumns];
    Matrix *actualVariance = [random variancesOfColumns];
    
    XCTAssert([mean isEqualToMatrix:actualMean tolerance:0.1]);
    XCTAssert([variance isEqualToMatrix:actualVariance tolerance:0.1]);
}

- (void)testNormalRandomRows
{
    Matrix *mean = [Matrix matrixFromNSArray:@[@10, @5, @5, @10] rows:4 columns:1];
    Matrix *variance = [Matrix matrixFromNSArray:@[@1, @2, @3, @4] rows:4 columns:1];
    Matrix *random = [Matrix normalRandomMean:mean variance:variance count:20000];
    Matrix *actualMean = [random meansOfRows];
    Matrix *actualVariance = [random variancesOfRows];
    
    XCTAssert([mean isEqualToMatrix:actualMean tolerance:0.1]);
    XCTAssert([variance isEqualToMatrix:actualVariance tolerance:0.1]);
}

- (void)testSVD
{
    TitleNSLog(@"Singular Value Decomposition");
    int m = 10;
    int n = 6;
    double *orig_array = _mm_malloc(m*n*sizeof(double), 64);
    for (int i=0, j=m*n; i<j; i++)
    {
        orig_array[i] = ((double)arc4random() / ARC4RANDOM_MAX) * 100 - 50;
    }
    Matrix *original = [Matrix matrixFromArray:orig_array rows:m columns:n];
    NSDictionary *svdResults = [original SVD];
    
    Matrix *reconstructed = [[svdResults[@"U"] matrixByMultiplyingWithRight:svdResults[@"S"]] matrixByMultiplyingWithRight:[svdResults[@"V"] matrixByTransposing]];
    CleanNSLog(@"Original:\n%@", original);
    CleanNSLog(@"Reconstructed:\n%@", reconstructed);
    XCTAssert([reconstructed isEqualToMatrix:original tolerance:1E-6], @"Error in Singular Value Decomposition");
}

- (void)testPseudoInverse
{
    TitleNSLog(@"Pseudo Inverse");
    double pinv_orig_array[4] = { 1.0, 2.0,
        3.0, 4.0};
    Matrix *po = [Matrix matrixFromArray:pinv_orig_array rows:2 columns:2];
    Matrix *poi = [po pseudoInverse];
    CleanNSLog(@"Original: %ix%i",po->rows, po->columns);
    CleanNSLog(@"%@",po);
    CleanNSLog(@"PseudoInverse: %ix%i",poi->rows, poi->columns);
    CleanNSLog(@"%@",poi);
    
    double pinv_orig_array2[6] = { 1.0, 2.0,
        3.0, 4.0, 5.0, 6.0};
    Matrix *po2 = [Matrix matrixFromArray:pinv_orig_array2 rows:3 columns:2];
    Matrix *poi2 = [po2 pseudoInverse];
    CleanNSLog(@"Original: %ix%i",po2->rows, po2->columns);
    CleanNSLog(@"%@",po2);
    CleanNSLog(@"PseudoInverse: %ix%i",poi2->rows, poi2->columns);
    CleanNSLog(@"%@",poi2);
}

- (void)testCholesky
{
    TitleNSLog(@"Cholesky Decomposition Test (A: 3x3)");
    double simple_array[9] = {  4, 12, -16,
        12, 37, -43,
        -16, -43, 98}; // Test from Wikipedia
    Matrix *A = [Matrix matrixFromArray:simple_array rows:3 columns:3];
    CleanNSLog(@"Original Matrix A: %@",A);
    Matrix *ch = [A matrixByCholesky];
    CleanNSLog(@"Cholesky Decomposition of A: %@",ch);
    XCTAssertEqualObjects([ch matrixByTransposingAndMultiplyingWithLeft:ch], A,
                          @"Error with Cholesky decomposition");
    
    TitleNSLog(@"Cholesky Decomposition Test (Correlation Matrix: 4x4)");
    
    double correlation_array[16] = { 1, 0.5, 0.5, 0.5,
                                     0.5, 1, 0.5, 0.5,
                                     0.5, 0.5, 1, 0.5,
                                     0.5, 0.5, 0.5, 1 };
    Matrix *correlationMatrix = [Matrix matrixFromArray:correlation_array rows:4 columns:4];
    
    CleanNSLog(@"Correlation Matrix: %@",correlationMatrix);
    Matrix *correlationCholesky = [correlationMatrix matrixByCholesky];
    CleanNSLog(@"Cholesky Decomposition of Correlation Matrix: %@",correlationCholesky);
    Matrix *response = [correlationCholesky matrixByTransposingAndMultiplyingWithLeft:correlationCholesky];
    XCTAssert([response isEqualToMatrix:correlationMatrix tolerance:1E-9],
                          @"Error with Cholesky decomposition");
}

- (void)testSobol
{
    // test integrand from Joe and Kuo paper ... integrates to 1
    
    int count = 1000;
    
    TitleNSLog(@"Sobol Sequence Test");
    
    Matrix *lower = [Matrix matrixOfRows:10 columns:1 value:0.0];
    Matrix *upper = [Matrix matrixOfRows:10 columns:1 value:1.0];
    
    Matrix *sequence = [Matrix sobolSequenceLowerBound:lower upperBound:upper count:count];
    
    NSArray *columns = [sequence columnsAsNSArray];
    
    double acc = 0;
    
    for (Matrix *column in columns)
    {
        double f = 1;
        for (int j = 1; j <= column.count; ++j) {
            double cj = pow((double) j, 0.3333333333333333333);
            f *= (fabs(4*column->matrix[j-1] - 2) + cj) / (1 + cj);
        }
        acc += f;
    }
    acc /= count;
    
    XCTAssertEqualWithAccuracy(acc, 1.0, 0.01);
    CleanNSLog(@"%f", acc);
}

- (void)testHalton
{
    // test integrand from Joe and Kuo paper ... integrates to 1
    
    int count = 1000;
    
    TitleNSLog(@"Halton Sequence Test");
    
    Matrix *lower = [Matrix matrixOfRows:10 columns:1 value:0.0];
    Matrix *upper = [Matrix matrixOfRows:10 columns:1 value:1.0];
    
    Matrix *sequence = [Matrix haltonSequenceWithLowerBound:lower upperBound:upper count:count];
    
    NSArray *columns = [sequence columnsAsNSArray];
    
    double acc = 0;
    
    for (Matrix *column in columns)
    {
        double f = 1;
        for (int j = 1; j <= column.count; ++j) {
            double cj = pow((double) j, 0.3333333333333333333);
            f *= (fabs(4*column->matrix[j-1] - 2) + cj) / (1 + cj);
        }
        acc += f;
    }
    acc /= count;
    
    XCTAssertEqualWithAccuracy(acc, 1.0, 0.01);
    CleanNSLog(@"%f", acc);
}

- (void)testMeans
{
    TitleNSLog(@"Mean Test");
    double mean_array[12] = { 1.0, 1.0, 1.0,
        4.0, -4.0, 2.0,
        -153.0, 614.0, 33.0,
        -100.0, 100.0, 0.0};
    double columnMeanTargetArray[3] = { -62.0, 177.75, 9.0 };
    double rowMeantargetArray[4] = { 1.0, 2.0/3.0, 494.0/3.0, 0.0  };
    Matrix *columnMeanTargetMatrix = [Matrix matrixFromArray:columnMeanTargetArray rows:1 columns:3];
    Matrix *rowMeanTargetMatrix = [Matrix matrixFromArray:rowMeantargetArray rows:4 columns:1];
    Matrix *meanMatrix = [Matrix matrixFromArray:mean_array rows:4 columns:3];
    Matrix *rowMeans = [meanMatrix meansOfRows];
    Matrix *columnMeans = [meanMatrix meansOfColumns];
    XCTAssertEqualObjects(rowMeans, rowMeanTargetMatrix,
                          @"Error in calculating Row Means.");
    XCTAssertEqualObjects(columnMeans, columnMeanTargetMatrix,
                          @"Error in calculating Column Means.");
    CleanNSLog(@"%@", rowMeans);
    CleanNSLog(@"%@", columnMeans);
}

- (void)testVariances
{
    TitleNSLog(@"Variances Test");
    double var_array[12] = { 1.0, 10.0, 1.0,
        2.0, -6.0, -5.0,
        -153.0, 34.0, 15.67,
        -110.1, 1900.0, 0.0};
    double columnVarTargetArray[3] = { 6207.66917, 890777.00000, 79.16722 };
    double rowVartargetArray[4] = { 27.00, 19.00, 10625.76, 1277104.00 };
    Matrix *columnVarTargetMatrix = [Matrix matrixFromArray:columnVarTargetArray rows:1 columns:3];
    Matrix *rowVarTargetMatrix = [Matrix matrixFromArray:rowVartargetArray rows:4 columns:1];
    Matrix *varMatrix = [Matrix matrixFromArray:var_array rows:4 columns:3];
    Matrix *rowVars = [varMatrix sampleVariancesOfRows];
    Matrix *columnVars = [varMatrix sampleVariancesOfColumns];
    XCTAssert([rowVars isEqualToMatrix:rowVarTargetMatrix tolerance:0.01],
              @"Error in calculating Row Variances.");
    XCTAssert([columnVars isEqualToMatrix:columnVarTargetMatrix tolerance:0.01],
              @"Error in calculating Column Variances.");
    CleanNSLog(@"%@", rowVarTargetMatrix);
    CleanNSLog(@"%@", columnVarTargetMatrix);
    CleanNSLog(@"%@", rowVars);
    CleanNSLog(@"%@", columnVars);
}

- (void)testMins
{
    TitleNSLog(@"Minimums Test");
    double var_array[12] = { 1.0, 10.0, 1.0,
        2.0, -6.0, -5.0,
        -153.0, 34.0, 15.67,
        -110.1, 1900.0, 0.0};
    double columnMinTargetArray[3] = { -153.0, -6.0, -5.0 };
    double rowMintargetArray[4] = { 1.0, -6.0, -153.0, -110.1 };
    Matrix *columnMinTargetMatrix = [Matrix matrixFromArray:columnMinTargetArray rows:1 columns:3];
    Matrix *rowMinTargetMatrix = [Matrix matrixFromArray:rowMintargetArray rows:4 columns:1];
    Matrix *minMatrix = [Matrix matrixFromArray:var_array rows:4 columns:3];
    Matrix *rowMins = [minMatrix minimumsOfRows];
    Matrix *columnMins = [minMatrix minimumsOfColumns];
    XCTAssert([rowMins isEqualToMatrix:rowMinTargetMatrix tolerance:0.01],
              @"Error in calculating Row Minimums.");
    XCTAssert([columnMins isEqualToMatrix:columnMinTargetMatrix tolerance:0.01],
              @"Error in calculating Column Minimums.");
    CleanNSLog(@"%@", rowMinTargetMatrix);
    CleanNSLog(@"%@", columnMinTargetMatrix);
    CleanNSLog(@"%@", rowMins);
    CleanNSLog(@"%@", columnMins);
}


- (void)testMaxs
{
    TitleNSLog(@"Maximums Test");
    double var_array[12] = { 1.0, 10.0, -1.0,
        2.0, -6.0, -5.0,
        -153.0, 34.0, -15.67,
        -110.1, 1900.0, -0.1};
    double columnMaxTargetArray[3] = { 2.0, 1900.0, -0.1 };
    double rowMaxTargetArray[4] = { 10.0, 2.00, 34.0, 1900.00 };
    Matrix *columnMaxTargetMatrix = [Matrix matrixFromArray:columnMaxTargetArray rows:1 columns:3];
    Matrix *rowMaxTargetMatrix = [Matrix matrixFromArray:rowMaxTargetArray rows:4 columns:1];
    Matrix *maxMatrix = [Matrix matrixFromArray:var_array rows:4 columns:3];
    Matrix *rowMaxs = [maxMatrix maximumsOfRows];
    Matrix *columnMaxs = [maxMatrix maximumsOfColumns];
    XCTAssert([rowMaxs isEqualToMatrix:rowMaxTargetMatrix tolerance:0.01],
              @"Error in calculating Row Maximums.");
    XCTAssert([columnMaxs isEqualToMatrix:columnMaxTargetMatrix tolerance:0.01],
              @"Error in calculating Column Maximums.");
    CleanNSLog(@"%@", rowMaxTargetMatrix);
    CleanNSLog(@"%@", columnMaxTargetMatrix);
    CleanNSLog(@"%@", rowMaxs);
    CleanNSLog(@"%@", columnMaxs);
}

- (void)testEigenvalues
{
    TitleNSLog(@"Eigenvalues Test");
    double simple_array[9] = { 1.000,  2.000,  3.000,
        5.000, 10.000, 15.000,
        0.100,  0.200,  0.300 };
    double ref_array[3] = {11.3, 0.0, 0.0};
    Matrix *original = [Matrix matrixFromArray:simple_array rows:3 columns:3];
    Matrix *ev = [original realEigenvalues];
    Matrix *evRef = [Matrix matrixFromArray:ref_array  rows:1 columns:3];
    CleanNSLog(@"%@", ev);
    XCTAssert([ev isEqualToMatrix:evRef tolerance:1E-4], @"Error with Eigenvalue calculation");
}

- (void)testEigenValuesandVectors
{
    TitleNSLog(@"Eigenvectors Test");
    double simple_array[9] = { 35.000, 100.000,  42.000,
        87.000,  72.000,  97.000,
        28.000,  21.000,  55.000 };
    double left_result[9] = {-0.6062, -0.8280, -0.6705,
        -0.7489, 0.5461, -0.2132,
        -0.2678, 0.1268, 0.7106};
    Matrix *original = [Matrix matrixFromArray:simple_array rows:3 columns:3];
    Matrix *leftTarget = [Matrix matrixFromArray:left_result rows:3 columns:3];
    NSDictionary *e = [original eigenvectorsAndEigenvalues];
    XCTAssert([[e[@"Left Eigenvectors"] matrixByTransposing]
               isEqualToMatrix:leftTarget tolerance:1E-3]);
}

- (void)testDeterminant
{
    TitleNSLog(@"Determinant Test");
    double simple_array[16] = { 1.0, 2.0, 3.0, 4.0,
        5.0, 6.0, 7.0, 8.0,
        2.0, 6.0, 4.0, 8.0,
        3.0, 1.0, 1.0, 2.0 };
    Matrix *original = [Matrix matrixFromArray:simple_array rows:4 columns:4];
    double det = [original determinant];
    double detRef = 72;
    CleanNSLog(@"%f", det);
    XCTAssertEqual(det, detRef, @"Error with Determinant calculation");
}

- (void)testBernoulli
{
    TitleNSLog(@"Bernoulli Distribution Test");
    
    Matrix *ones = [Matrix matrixOfRows:20 columns:20 value:1];
    Matrix *onesWithProbability = [ones copy];
    [onesWithProbability bernoulli];
    XCTAssertEqualObjects(ones, onesWithProbability);
    
    Matrix *zeroes = [Matrix matrixOfRows:20 columns:20 value:0];
    Matrix *zeroesWithProbability = [zeroes copy];
    [zeroesWithProbability bernoulli];
    XCTAssertEqualObjects(zeroes, zeroesWithProbability);
}


@end
