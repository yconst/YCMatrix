//
//  YCMatrixTests.m
//  YCMatrixTests
//
//  Created by Yan Const on 11/7/13.
//  Copyright (c) 2013, 2014 Ioannis Chatzikonstantinou. All rights reserved.
//
//References for this Document:
// http://en.wikipedia.org/wiki/Cholesky_decomposition

#import "YCMatrixTests.h"

@implementation YCMatrixTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    TitleNSLog(@"YCMatrix Unit Tests");
}

- (void)tearDown
{
    // Tear-down code here.
    TitleNSLog(@"End Of YCMatrix Unit Tests");
    [super tearDown];
}

- (void)testBasicFunctions
{
    //
    // Array Test
    //
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
    
    //
    // Identity Matrix
    //
    TitleNSLog(@"Identity Matrix Test");
    YCMatrix *idm1 = [YCMatrix identityOfRows:3 Columns:5];
    CleanNSLog(@"%@",idm1);
    YCMatrix *idm2 = [YCMatrix identityOfRows:6 Columns:4];
    CleanNSLog(@"%@",idm2);
    
    //
    // Addition and Scalar Multiplication
    //
    TitleNSLog(@"Addition and Scalar Multiplication");
    double matrix_array[9] = { 1.0, 2.0, 3.0,
        4.0, 5.0, 6.0,
        7.0, 8.0, 9.0 };
    YCMatrix *testm1 = [YCMatrix matrixFromArray:matrix_array Rows:3 Columns:3];
    YCMatrix *testm2 = [YCMatrix matrixFromMatrix:testm1];
    YCMatrix *testm_add = [testm1 matrixByAdding:testm2];
    YCMatrix *testm_ms = [testm1 matrixByMultiplyingWithScalar:2];
    XCTAssertTrue([testm_ms isEqual: testm_add], @"M+M != 2*M");
    
    //
    // Matrix Multiplication
    //
    TitleNSLog(@"Matrix Multiplication");
    CleanNSLog(@"Test Matrix 1: %ix%i",testm1->rows, testm1->columns);
    CleanNSLog(@"Test Matrix 2: %ix%i",testm2->rows, testm2->columns);
    YCMatrix *multResult = [testm1 matrixByMultiplyingWithRight:testm2];
    CleanNSLog(@"Resulting Matrix: %ix%i",multResult->rows, multResult->columns);
    CleanNSLog(@"%@",multResult);
    
    //
    // Transposition
    //
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
    
    //
    // Trace
    //
    TitleNSLog(@"Trace");
    YCMatrix *tracetestm = [YCMatrix matrixFromArray:matrix_array Rows:3 Columns:3];
    double trace = [[tracetestm matrixByMultiplyingWithRight:tracetestm] trace];
    CleanNSLog(@"%f",trace);
    XCTAssertEqual(trace, 261.000, @"Trace is not correct!");
    
    //
    // Dot
    //
    TitleNSLog(@"Dot Product");
    double vectorarray[3] = { 1.0, 2.0, 3.0 };
    YCMatrix *Vector = [YCMatrix matrixFromArray:vectorarray Rows:3 Columns:1];
    double dotp = [Vector dotWith:Vector];
    CleanNSLog(@"Dot Product: %f",dotp);
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
    double rowMeantargetArray[4] = { 1.0, 3/2, 164 + 3/2, 0.0 };
    YCMatrix *columnMeanTargetMatrix = [YCMatrix matrixFromArray:columnMeanTargetArray Rows:3 Columns:1];
    YCMatrix *rowMeanTargetMatrix = [YCMatrix matrixFromArray:rowMeantargetArray Rows:4 Columns:1];
    YCMatrix *meanMatrix = [YCMatrix matrixFromArray:mean_array Rows:4 Columns:3];
    YCMatrix *rowMeans = [meanMatrix RowMean];
    YCMatrix *columnMeans = [meanMatrix ColumnMean];
    XCTAssertTrue([rowMeans isEqualTo: rowMeanTargetMatrix] , @"Error in calculating Row Means.");
    XCTAssertTrue([columnMeans isEqualTo: columnMeanTargetMatrix] , @"Error in calculating Column Means.");
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
    XCTAssertEqualObjects(ev, evRef, @"Error with Eigenvalue calculation");
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
