//
//  YCMatrixTests.m
//  YCMatrixTests
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

//References for this Document:
// http://en.wikipedia.org/wiki/Cholesky_decomposition

#import <XCTest/XCTest.h>
#import "YCMatrix.h"

@interface YCMatrixTests : XCTestCase

@end

@implementation YCMatrixTests

- (void)testIdentity
{
    TitleNSLog(@"Identity Matrix Test");
    double idm_ref_array[15] = { 1.0, 0.0, 0.0,
        0.0, 1.0, 0.0,
        0.0, 0.0, 1.0,
        0.0, 0.0, 0.0,
        0.0, 0.0, 0.0 };
    YCMatrix *idmRef = [YCMatrix matrixFromArray:idm_ref_array Rows:5 Columns:3];
    YCMatrix *idm = [YCMatrix identityOfRows:5 Columns:3];
    CleanNSLog(@"%@",idm);
    XCTAssertEqualObjects(idm, idmRef, @"Error in creating Identity Matrix");
}

- (void)testRetrieval
{
    TitleNSLog(@"Simple Array Test");
    double simple_array[9] = { 1.0, 2.0, 3.0,
        4.0, 5.0, 6.0,
        7.0, 8.0, 9.0 };
    YCMatrix *simple_matrix = [YCMatrix matrixFromArray:simple_array Rows:3 Columns:3];
    CleanNSLog(@"%@",simple_matrix);
    
    // Perform various get item tests
    TitleNSLog(@"Get Items Test");
    CleanNSLog(@"Value at 0,0: %f",[simple_matrix getValueAtRow:0 Column:0]);
    CleanNSLog(@"Value at 1,1: %f",[simple_matrix getValueAtRow:1 Column:1]);
    CleanNSLog(@"Value at 2,1: %f",[simple_matrix getValueAtRow:2 Column:1]);
    CleanNSLog(@"Value at 1,2: %f",[simple_matrix getValueAtRow:1 Column:2]);
    CleanNSLog(@"Value at 2,2: %f",[simple_matrix getValueAtRow:2 Column:2]);
    XCTAssertTrue([simple_matrix getValueAtRow:0 Column:0] == 1.0, @"GetValue error!");
    XCTAssertTrue([simple_matrix getValueAtRow:1 Column:0] == 4.0, @"GetValue error!");
    XCTAssertTrue([simple_matrix getValueAtRow:2 Column:0] == 7.0, @"GetValue error!");
    XCTAssertTrue([simple_matrix getValueAtRow:0 Column:1] == 2.0, @"GetValue error!");
    XCTAssertTrue([simple_matrix getValueAtRow:0 Column:2] == 3.0, @"GetValue error!");
    XCTAssertTrue([simple_matrix getValueAtRow:2 Column:1] == 8.0, @"GetValue error!");
}

- (void)testDiagonal
{
    double source_array[12] = { 1.0, 2.0, 3.0,
        4.0, 5.0, 6.0,
        7.0, 8.0, 9.0,
        1.0, 2.0, 6.0};
    YCMatrix *sourceMatrix = [YCMatrix matrixFromArray:source_array Rows:4 Columns:3];
    double target_array[3] = { 1.0, 5.0, 9.0 };
    YCMatrix *targetMatrix = [YCMatrix matrixFromArray:target_array Rows:3 Columns:1];
    YCMatrix *diagonal = [sourceMatrix diagonal];
    XCTAssertEqualObjects(diagonal, targetMatrix, @"Error in deriving diagonal.");
}

- (void)testTransposition
{
    TitleNSLog(@"Transposition");
    double matrix_orig_arr[6] = { 1.0, 2.0, 3.0,
        4.0, 5.0, 6.0 };
    double matrix_trans_arr[6] = { 1.0, 4.0,
        2.0, 5.0,
        3.0, 6.0 };
    YCMatrix *orig = [YCMatrix matrixFromArray:matrix_orig_arr Rows:2 Columns:3];
    YCMatrix *trans = [YCMatrix matrixFromArray:matrix_trans_arr Rows:3 Columns:2];
    YCMatrix *trans2 = [orig matrixByTransposing];
    CleanNSLog(@"%@",orig);
    CleanNSLog(@"%@",trans);
    CleanNSLog(@"%@",trans2);
    XCTAssertTrue([trans isEqual: trans2], @"M^T != Mt");
    XCTAssertEqualObjects(orig, [[orig matrixByTransposing] matrixByTransposing], @"M^T^T != M");
}

- (void)testDot
{
    TitleNSLog(@"Dot Product");
    double vectorarray[3] = { 1.0, 2.0, 3.0 };
    YCMatrix *Vector = [YCMatrix matrixFromArray:vectorarray Rows:3 Columns:1];
    double dotp = [Vector dotWith:Vector];
    CleanNSLog(@"Dot Product: %f",dotp);
    XCTAssertEqual(dotp, 14.0, @"Error in calculating dot product");
}

- (void)testTrace
{
    TitleNSLog(@"Trace");
    double matrix_array[9] = { 1.0, 2.0, 3.0,
        4.0, 5.0, 6.0,
        7.0, 8.0, 9.0 };
    YCMatrix *tracetestm = [YCMatrix matrixFromArray:matrix_array Rows:3 Columns:3];
    double trace = [[tracetestm matrixByMultiplyingWithRight:tracetestm] trace];
    CleanNSLog(@"%f",trace);
    XCTAssertEqual(trace, 261.000, @"Trace is not correct!");
}

- (void)testAdditionScalarMultiplication
{
    TitleNSLog(@"Addition and Scalar Multiplication");
    double matrix_array[9] = { 1.0, 2.0, 3.0,
        4.0, 5.0, 6.0,
        7.0, 8.0, 9.0 };
    YCMatrix *testm1 = [YCMatrix matrixFromArray:matrix_array Rows:3 Columns:3];
    YCMatrix *testm2 = [YCMatrix matrixFromMatrix:testm1];
    YCMatrix *testm_add = [testm1 matrixByAdding:testm2];
    YCMatrix *testm_ms = [testm1 matrixByMultiplyingWithScalar:2];
    XCTAssertTrue([testm_ms isEqual: testm_add], @"M+M != 2*M");
    
    TitleNSLog(@"Matrix Multiplication");
    CleanNSLog(@"Test Matrix 1: %ix%i",testm1->rows, testm1->columns);
    CleanNSLog(@"Test Matrix 2: %ix%i",testm2->rows, testm2->columns);
    YCMatrix *multResult = [testm1 matrixByMultiplyingWithRight:testm2];
    CleanNSLog(@"Resulting Matrix: %ix%i",multResult->rows, multResult->columns);
    CleanNSLog(@"%@",multResult);
}

- (void)testTransposedMultiply
{
    double simple_array[6] = { 1.0, 2.0, 3.0, 4.0, 5.0, 6.0 };
    YCMatrix *A = [YCMatrix matrixFromArray:simple_array Rows:2 Columns:3];
    CleanNSLog(@"%@",A);
    
    double simple_array_2[6] = { 2.0, 3.0, 1.0, 4.0, 0.0, 5.0 };
    YCMatrix *B = [YCMatrix matrixFromArray:simple_array_2 Rows:3 Columns:2];
    CleanNSLog(@"%@",B);
    
    YCMatrix *C = [A matrixByMultiplyingWithRight:B AndTransposing:YES];
    CleanNSLog(@"%@",C);
}

@end
