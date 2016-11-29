//
//  YCMatrixTests.m
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

//References for this Document:
// http://en.wikipedia.org/wiki/Cholesky_decomposition

@import XCTest;
@import YCMatrix;

#define ARC4RANDOM_MAX 0x100000000 

// Definitions for convenience logging functions (without date/object and title logging).
#define CleanNSLog(FORMAT, ...) fprintf(stderr,"%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#define TitleNSLog(FORMAT, ...) fprintf(stderr,"\n%s\n_____________________________________\n\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

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
    Matrix *idmRef = [Matrix matrixFromArray:idm_ref_array rows:5 columns:3];
    Matrix *idm = [Matrix identityOfRows:5 columns:3];
    CleanNSLog(@"%@",idm);
    XCTAssertEqualObjects(idm, idmRef, @"Error in creating Identity Matrix");
}

- (void)testOnes
{
    Matrix *template = [Matrix matrixOfRows:5 columns:5 value:1];
    Matrix *match = [Matrix onesLike:template];
    XCTAssertEqualObjects(template, match, @"Error in creating matrix of ones.");
}

- (void)testAbsolute
{
    Matrix *absoluteMatrix = [Matrix uniformRandomRows:10 columns:10 domain:YCMakeDomain(-1.0, 1.0)];
    [absoluteMatrix absolute];
    for (int i=0, k=absoluteMatrix.rows; i<k; i++)
    {
        for (int j=0; j<k; j++)
        {
            NSAssert([absoluteMatrix i:i j:j] >= 0, @"Negative value in absolute matrix");
        }
    }
}

- (void)testRetrieval
{
    TitleNSLog(@"Simple Array Test");
    double simple_array[9] = { 1.0, 2.0, 3.0,
        4.0, 5.0, 6.0,
        7.0, 8.0, 9.0 };
    Matrix *simple_matrix = [Matrix matrixFromArray:simple_array rows:3 columns:3];
    CleanNSLog(@"%@",simple_matrix);
    
    // Perform various get item tests
    TitleNSLog(@"Get Items Test");
    CleanNSLog(@"Value at 0,0: %f",[simple_matrix valueAtRow:0 column:0]);
    CleanNSLog(@"Value at 1,1: %f",[simple_matrix valueAtRow:1 column:1]);
    CleanNSLog(@"Value at 2,1: %f",[simple_matrix valueAtRow:2 column:1]);
    CleanNSLog(@"Value at 1,2: %f",[simple_matrix valueAtRow:1 column:2]);
    CleanNSLog(@"Value at 2,2: %f",[simple_matrix valueAtRow:2 column:2]);
    XCTAssertTrue([simple_matrix valueAtRow:0 column:0] == 1.0, @"GetValue error!");
    XCTAssertTrue([simple_matrix valueAtRow:1 column:0] == 4.0, @"GetValue error!");
    XCTAssertTrue([simple_matrix valueAtRow:2 column:0] == 7.0, @"GetValue error!");
    XCTAssertTrue([simple_matrix valueAtRow:0 column:1] == 2.0, @"GetValue error!");
    XCTAssertTrue([simple_matrix valueAtRow:0 column:2] == 3.0, @"GetValue error!");
    XCTAssertTrue([simple_matrix valueAtRow:2 column:1] == 8.0, @"GetValue error!");
    XCTAssertTrue([simple_matrix i:0 j:1] == 2.0, @"GetValue error!");
    XCTAssertTrue([simple_matrix i:0 j:2] == 3.0, @"GetValue error!");
    XCTAssertTrue([simple_matrix i:2 j:1] == 8.0, @"GetValue error!");
}

- (void)testDiagonal
{
    double source_array[12] = { 1.0, 2.0, 3.0,
        4.0, 5.0, 6.0,
        7.0, 8.0, 9.0,
        1.0, 2.0, 6.0};
    Matrix *sourceMatrix = [Matrix matrixFromArray:source_array rows:4 columns:3];
    double target_array[3] = { 1.0, 5.0, 9.0 };
    Matrix *targetMatrix = [Matrix matrixFromArray:target_array rows:3 columns:1];
    Matrix *diagonal = [sourceMatrix diagonal];
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
    Matrix *orig = [Matrix matrixFromArray:matrix_orig_arr rows:2 columns:3];
    Matrix *trans = [Matrix matrixFromArray:matrix_trans_arr rows:3 columns:2];
    Matrix *trans2 = [orig matrixByTransposing];
    CleanNSLog(@"%@",orig);
    CleanNSLog(@"%@",trans);
    CleanNSLog(@"%@",trans2);
    XCTAssertEqualObjects(trans, trans2, @"M^T != Mt");
    XCTAssertEqualObjects(orig, [[orig matrixByTransposing] matrixByTransposing], @"M^T^T != M");
}

- (void)testDot
{
    TitleNSLog(@"Dot Product");
    double vectorarray[3] = { 1.0, 2.0, 3.0 };
    Matrix *Vector = [Matrix matrixFromArray:vectorarray rows:3 columns:1];
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
    Matrix *tracetestm = [Matrix matrixFromArray:matrix_array rows:3 columns:3];
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
    Matrix *testm1 = [Matrix matrixFromArray:matrix_array rows:3 columns:3];
    Matrix *testm2 = [Matrix matrixFromMatrix:testm1];
    Matrix *testm_add = [testm1 matrixByAdding:testm2];
    Matrix *testm_ms = [testm1 matrixByMultiplyingWithScalar:2];
    XCTAssertEqualObjects(testm_ms, testm_add, @"M+M != 2*M");
    
    TitleNSLog(@"Matrix Multiplication");
    CleanNSLog(@"Test Matrix 1: %ix%i",testm1->rows, testm1->columns);
    CleanNSLog(@"Test Matrix 2: %ix%i",testm2->rows, testm2->columns);
    Matrix *multResult = [testm1 matrixByMultiplyingWithRight:testm2];
    CleanNSLog(@"Resulting Matrix: %ix%i",multResult->rows, multResult->columns);
    CleanNSLog(@"%@",multResult);
}

- (void)testVDSPAdd
{
    Matrix *A = [Matrix matrixOfRows:10 columns:1 value:1];
    Matrix *B = [Matrix matrixOfRows:10 columns:1 value:1];
    
    Matrix *C = [A matrixByAdding:B];
    Matrix *T = [Matrix matrixOfRows:10 columns:1 value:2];
    XCTAssertEqualObjects(C, T, @"Matrix subtraction failed");
    [A add:B];
    XCTAssertEqualObjects(A, T, @"Matrix subtraction failed");
}

- (void)testVDSPSubtract
{
    Matrix *A = [Matrix matrixOfRows:10 columns:1 value:0];
    Matrix *B = [Matrix matrixOfRows:10 columns:1 value:1];
    
    Matrix *C = [A matrixBySubtracting:B];
    Matrix *T = [Matrix matrixOfRows:10 columns:1 value:-1];
    XCTAssertEqualObjects(C, T, @"Matrix subtraction failed");
    [A subtract:B];
    XCTAssertEqualObjects(A, T, @"Matrix subtraction failed");
}

- (void)testTransposedMultiply
{
    double simple_array[6] = { 1.0, 2.0, 3.0, 4.0, 5.0, 6.0 };
    Matrix *A = [Matrix matrixFromArray:simple_array rows:2 columns:3];
    CleanNSLog(@"%@",A);
    
    double simple_array_2[6] = { 2.0, 3.0, 1.0, 4.0, 0.0, 5.0 };
    Matrix *B = [Matrix matrixFromArray:simple_array_2 rows:3 columns:2];
    CleanNSLog(@"%@",B);
    
    Matrix *C = [A matrixByMultiplyingWithRight:B AndTransposing:YES];
    CleanNSLog(@"%@",C);
}

- (void)testGEMMPerformance
{
    Matrix *A = [Matrix uniformRandomRows:1000 columns:1000 domain:YCMakeDomain(0, 10)];
    Matrix *B = [Matrix uniformRandomRows:1000 columns:1000 domain:YCMakeDomain(0, 10)];
    
    [self measureBlock:^{
        [A matrixByMultiplyingWithRight:B];
    }];
}

- (void)testGEMM
{
    Matrix *A = [Matrix uniformRandomRows:10 columns:10 domain:YCMakeDomain(0, 10)];
    Matrix *B = [Matrix uniformRandomRows:10 columns:10 domain:YCMakeDomain(0, 10)];
    
    Matrix *ACopy = [A copy];
    Matrix *BCopy = [B copy];
    NSLog(@"%@", [A matrixByMultiplyingWithRight:B]);
    XCTAssertEqualObjects(A, ACopy);
    XCTAssertEqualObjects(B, BCopy);
}

- (void)testDictionaryContainsKey
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    Matrix *m1 = [Matrix uniformRandomRows:5 columns:5 domain:YCMakeDomain(0, 1)];
    [dict setObject:@1 forKey:[m1 copy]];
    id val = dict[m1];
    XCTAssert([val isEqual:@1], @"Matrix dictionary key lookup unsuccessful");
}

- (void)testHash
{
    Matrix *m1 = [Matrix uniformRandomRows:50 columns:50 domain:YCMakeDomain(0, 1)];
    NSLog(@"%lu", m1.hash);
}

- (void)testSerialization
{
    Matrix *testm1 = [Matrix uniformRandomRows:10 columns:10 domain:YCMakeDomain(0, 10)];
    NSData *serialized = [NSKeyedArchiver archivedDataWithRootObject:testm1];
    Matrix *recovered = [NSKeyedUnarchiver unarchiveObjectWithData:serialized];
    XCTAssertEqualObjects(testm1, recovered, @"Error in deserialization");
}

@end
