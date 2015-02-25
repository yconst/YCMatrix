//
//  YCMatrixAdvancedTests.m
//  YCMatrix
//
//  Created by Ioannis Chatzikonstantinou on 23/9/14.
//  Copyright (c) 2014 Ioannis Chatzikonstantinou. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YCMatrix.h"
#import "YCMatrix+Advanced.h"

@interface YCMatrixAdvancedTests : XCTestCase

@end

@implementation YCMatrixAdvancedTests

- (void)testRandom
{
    YCMatrix *lower = [YCMatrix matrixFromNSArray:@[@10, @5, @5, @10] Rows:1 Columns:4];
    YCMatrix *upper = [YCMatrix matrixFromNSArray:@[@20, @6, @10, @30] Rows:1 Columns:4];
    YCMatrix *random = [YCMatrix randomValuesMatrixWithLowerBound:lower upperBound:upper];
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

- (void)testSVD
{
    TitleNSLog(@"Singular Value Decomposition");
    int m = 10;
    int n = 6;
    double *orig_array = malloc(m*n*sizeof(double));
    for (int i=0, j=m*n; i<j; i++)
    {
        orig_array[i] = ((double)arc4random() / ARC4RANDOM_MAX) * 100 - 50;
    }
    YCMatrix *original = [YCMatrix matrixFromArray:orig_array Rows:m Columns:n];
    NSDictionary *svdResults = [original SVD];
    
    YCMatrix *reconstructed = [[svdResults[@"U"] matrixByMultiplyingWithRight:svdResults[@"S"]] matrixByMultiplyingWithRight:[svdResults[@"V"] matrixByTransposing]];
    CleanNSLog(@"Original:\n%@", original);
    CleanNSLog(@"Reconstructed:\n%@", reconstructed);
    XCTAssert([reconstructed isEqualToMatrix:original tolerance:1E-6], @"Error in Singular Value Decomposition");
}

- (void)testPseudoInverse
{
    TitleNSLog(@"Pseudo Inverse");
    double pinv_orig_array[4] = { 1.0, 2.0,
        3.0, 4.0};
    YCMatrix *po = [YCMatrix matrixFromArray:pinv_orig_array Rows:2 Columns:2];
    YCMatrix *poi = [po pseudoInverse];
    CleanNSLog(@"Original: %ix%i",po->rows, po->columns);
    CleanNSLog(@"%@",po);
    CleanNSLog(@"PseudoInverse: %ix%i",poi->rows, poi->columns);
    CleanNSLog(@"%@",poi);
    
    double pinv_orig_array2[6] = { 1.0, 2.0,
        3.0, 4.0, 5.0, 6.0};
    YCMatrix *po2 = [YCMatrix matrixFromArray:pinv_orig_array2 Rows:3 Columns:2];
    YCMatrix *poi2 = [po2 pseudoInverse];
    CleanNSLog(@"Original: %ix%i",po2->rows, po2->columns);
    CleanNSLog(@"%@",po2);
    CleanNSLog(@"PseudoInverse: %ix%i",poi2->rows, poi2->columns);
    CleanNSLog(@"%@",poi2);
}

- (void)testCholesky
{
    TitleNSLog(@"Cholesky Decomposition Test (A:3x3)");
    double simple_array[9] = {  4, 12, -16,
        12, 37, -43,
        -16, -43, 98}; // Test from Wikipedia
    YCMatrix *A = [YCMatrix matrixFromArray:simple_array Rows:3 Columns:3];
    CleanNSLog(@"Original Matrix A: %@",A);
    YCMatrix *ch = [A matrixByCholesky];
    CleanNSLog(@"Cholesky Decomposition of A: %@",ch);
    XCTAssert([[ch matrixByTransposingAndMultiplyingWithLeft:ch] isEqualTo:A],
              @"Error with Cholesky decomposition");
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
    YCMatrix *columnMeanTargetMatrix = [YCMatrix matrixFromArray:columnMeanTargetArray Rows:3 Columns:1];
    YCMatrix *rowMeanTargetMatrix = [YCMatrix matrixFromArray:rowMeantargetArray Rows:4 Columns:1];
    YCMatrix *meanMatrix = [YCMatrix matrixFromArray:mean_array Rows:4 Columns:3];
    YCMatrix *rowMeans = [meanMatrix meansOfRows];
    YCMatrix *columnMeans = [meanMatrix meansOfColumns];
    XCTAssertEqualObjects(rowMeans, rowMeanTargetMatrix, @"Error in calculating Row Means.");
    XCTAssertEqualObjects(columnMeans, columnMeanTargetMatrix, @"Error in calculating Column Means.");
    CleanNSLog(@"%@", rowMeans);
    CleanNSLog(@"%@", columnMeans);
}

- (void)testEigenvalues
{
    TitleNSLog(@"Eigenvalues Test");
    double simple_array[9] = { 1.000,  2.000,  3.000,
        5.000, 10.000, 15.000,
        0.100,  0.200,  0.300,};
    double ref_array[3] = {11.3, 0.0, 0.0};
    YCMatrix *original = [YCMatrix matrixFromArray:simple_array Rows:3 Columns:3];
    YCMatrix *ev = [original eigenvalues];
    YCMatrix *evRef = [YCMatrix matrixFromArray:ref_array  Rows:1 Columns:3];
    CleanNSLog(@"%@", ev);
    XCTAssert([ev isEqualToMatrix:evRef tolerance:1E-4], @"Error with Eigenvalue calculation");
}

- (void)testDeterminant
{
    TitleNSLog(@"Determinant Test");
    double simple_array[16] = { 1.0, 2.0, 3.0, 4.0,
        5.0, 6.0, 7.0, 8.0,
        2.0, 6.0, 4.0, 8.0,
        3.0, 1.0, 1.0, 2.0 };
    YCMatrix *original = [YCMatrix matrixFromArray:simple_array Rows:4 Columns:4];
    double det = [original determinant];
    double detRef = 72;
    CleanNSLog(@"%f", det);
    XCTAssertEqual(det, detRef, @"Error with Determinant calculation");
}

@end
