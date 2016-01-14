//
//  YCMatrixNSArrayTests.m
//  YCMatrix
//
//  Created by Ioannis Chatzikonstantinou on 14/1/16.
//  Copyright © 2016 Ioannis Chatzikonstantinou. All rights reserved.
//

@import XCTest;
@import YCMatrix;

@interface YCMatrixNSArrayTests : XCTestCase

@end

@implementation YCMatrixNSArrayTests

- (void)testArrayMin
{
    double v1[10] = {10, 11, 12, 13, 14, 15, 16, 17, 18, 19};
    double v2[10] = {19, 18, 17, 16, 15, 14, 13, 12, 11, 10};
    double v3[10] = {20, 20, 20, 10, 10, 10, 10, 20, 20, 20};
    double vt[10] = {10, 11, 12, 10, 10, 10, 10, 12, 11, 10};
    
    Matrix *m1 = [Matrix matrixFromArray:v1 rows:10 columns:1];
    Matrix *m2 = [Matrix matrixFromArray:v2 rows:10 columns:1];
    Matrix *m3 = [Matrix matrixFromArray:v3 rows:10 columns:1];
    Matrix *mt = [Matrix matrixFromArray:vt rows:10 columns:1];
    
    NSArray *matrixArray = @[m1, m2, m3];
    
    Matrix *mins = [matrixArray matrixMin];
    
    XCTAssert([mins isEqualTo:mt], @"Error in computing min matrix of array");
}

- (void)testArrayMax
{
    double v1[10] = {10, 11, 12, 13, 14, 15, 16, 17, 18, 19};
    double v2[10] = {19, 18, 17, 16, 15, 14, 13, 12, 11, 10};
    double v3[10] = {20, 20, 20, 10, 10, 10, 10, 20, 20, 20};
    double vt[10] = {20, 20, 20, 16, 15, 15, 16, 20, 20, 20};
    
    Matrix *m1 = [Matrix matrixFromArray:v1 rows:10 columns:1];
    Matrix *m2 = [Matrix matrixFromArray:v2 rows:10 columns:1];
    Matrix *m3 = [Matrix matrixFromArray:v3 rows:10 columns:1];
    Matrix *mt = [Matrix matrixFromArray:vt rows:10 columns:1];
    
    NSArray *matrixArray = @[m1, m2, m3];
    
    Matrix *maxs = [matrixArray matrixMax];
    
    XCTAssert([maxs isEqualTo:mt], @"Error in computing max matrix of array");
}

@end
