//
//  ManipulateTests.m
//
// YCMatrix
//
// Copyright (c) 2013 - 2015 Ioannis (Yannis) Chatzikonstantinou. All rights reserved.
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

#define ARC4RANDOM_MAX 0x100000000 

// Definitions for convenience logging functions (without date/object and title logging).
#define CleanNSLog(FORMAT, ...) fprintf(stderr,"%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#define TitleNSLog(FORMAT, ...) fprintf(stderr,"\n%s\n_____________________________________\n\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

@interface YCMatrixManipulateTests : XCTestCase

@end

@implementation YCMatrixManipulateTests

- (void)testRowRetrieval
{
    TitleNSLog(@"Matrix row retrieval");
    double testmrarr[6] = { 1.0, 2.0, 3.0, 4.0, 5.0, 6.0 };
    Matrix *testmr = [Matrix matrixFromArray:testmrarr rows:2 columns:3];
    Matrix *rowm = [testmr row:1]; // This is being tested.
    CleanNSLog(@"%@", rowm);
    double templatermatrixarr[3] = { 4.0, 5.0, 6.0 };
    Matrix *templatemr = [Matrix matrixFromArray:templatermatrixarr rows:1 columns:3];
    XCTAssertTrue([rowm isEqual:templatemr], @"Matrix row retrieval error.");
}

- (void)testMultipleRowRetrieval
{
    TitleNSLog(@"Multiple matrix row retrieval");
    double testmrarr[9] = { 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0 };
    Matrix *testmr = [Matrix matrixFromArray:testmrarr rows:3 columns:3];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 2)];
    Matrix *rowm = [testmr rows:indexSet]; // This is being tested.
    CleanNSLog(@"%@", rowm);
    double templatermatrixarr[6] = { 4.0, 5.0, 6.0, 7.0, 8.0, 9.0 };
    Matrix *templatemr = [Matrix matrixFromArray:templatermatrixarr rows:2 columns:3];
    XCTAssertTrue([rowm isEqual:templatemr], @"Multiple matrix row retrieval error.");
}

- (void)testColumnRetrieval
{
    TitleNSLog(@"Matrix column retrieval");
    double testmcarr[6] = { 1.0, 4.0, 2.0, 5.0, 3.0, 6.0 };
    Matrix *testmc = [Matrix matrixFromArray:testmcarr rows:3 columns:2];
    Matrix *columnm = [testmc column:1]; // This is being tested.
    CleanNSLog(@"%@", columnm);
    double templatecmatrixarr[3] = { 4.0, 5.0, 6.0 };
    Matrix *templatemc = [Matrix matrixFromArray:templatecmatrixarr rows:3 columns:1];
    XCTAssertTrue([columnm isEqual:templatemc], @"Matrix column retrieval error.");
}

- (void)testMultipleColumnRetrieval
{
    TitleNSLog(@"Multiple matrix column retrieval");
    double testmcarr[9] = { 1.0, 4.0, 7.0, 2.0, 5.0, 8.0, 3.0, 6.0, 9.0 };
    Matrix *testmc = [Matrix matrixFromArray:testmcarr rows:3 columns:3];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 2)];
    Matrix *columnm = [testmc columns:indexSet]; // This is being tested.
    CleanNSLog(@"%@", columnm);
    double templatecmatrixarr[6] = { 4.0, 7.0, 5.0, 8.0, 6.0, 9.0 };
    Matrix *templatemc = [Matrix matrixFromArray:templatecmatrixarr rows:3 columns:2];
    XCTAssertTrue([columnm isEqual:templatemc], @"Multiple matrix column retrieval error.");
}

- (void)testRowsToNSArray
{
    TitleNSLog(@"Rows as NSArray");
    double rowsColumnsArrayTest[12] = { 1.0, 2.0, 3.0, 4.0,
        5.0, 6.0, 7.0, 8.0,
        9.0, 10.0, 11.0, 12.0};
    double firstRow[4] = { 1.0, 2.0, 3.0, 4.0 };
    Matrix *firstRowMatrix = [Matrix matrixFromArray:firstRow rows:1 columns:4];
    double secondRow[4] = { 5.0, 6.0, 7.0, 8.0 };
    Matrix *secondRowMatrix = [Matrix matrixFromArray:secondRow rows:1 columns:4];
    double thirdRow[4] = { 9.0, 10.0, 11.0, 12.0 };
    Matrix *thirdRowMatrix = [Matrix matrixFromArray:thirdRow rows:1 columns:4];
    
    Matrix *rowsColumnsTestMatrix = [Matrix matrixFromArray:rowsColumnsArrayTest rows:3 columns:4];
    NSArray *rowsTestRows = [rowsColumnsTestMatrix rowsAsNSArray];
    XCTAssertEqualObjects([rowsTestRows objectAtIndex:0], firstRowMatrix, @"Error in conversion to rows array(1).");
    XCTAssertEqualObjects([rowsTestRows objectAtIndex:1], secondRowMatrix, @"Error in conversion to rows array(2).");
    XCTAssertEqualObjects([rowsTestRows objectAtIndex:2], thirdRowMatrix, @"Error in conversion to rows array(3).");
}

// All code under test must be linked into the Unit Test bundle
- (void)testColumnsToNSArray
{
    TitleNSLog(@"Columns as NSArray");
    double rowsColumnsArrayTest[12] = { 1.0, 2.0, 3.0, 4.0,
        5.0, 6.0, 7.0, 8.0,
        9.0, 10.0, 11.0, 12.0};
    double firstColumn[3] = { 1.0, 5.0, 9.0 };
    Matrix *firstColumnMatrix = [Matrix matrixFromArray:firstColumn rows:3 columns:1];
    double secondColumn[3] = { 2.0, 6.0, 10.0 };
    Matrix *secondColumnMatrix = [Matrix matrixFromArray:secondColumn rows:3 columns:1];
    double thirdColumn[3] = { 3.0, 7.0, 11.0 };
    Matrix *thirdColumnMatrix = [Matrix matrixFromArray:thirdColumn rows:3 columns:1];
    double fourthColumn[3] = { 4.0, 8.0, 12.0 };
    Matrix *fourthColumnMatrix = [Matrix matrixFromArray:fourthColumn rows:3 columns:1];

    Matrix *rowsColumnsTestMatrix = [Matrix matrixFromArray:rowsColumnsArrayTest rows:3 columns:4];
    NSArray *columnsTestColumns = [rowsColumnsTestMatrix columnsAsNSArray];
    XCTAssertEqualObjects([columnsTestColumns objectAtIndex:0], firstColumnMatrix,
                          @"Error in conversion to columns array(1).");
    XCTAssertEqualObjects([columnsTestColumns objectAtIndex:1], secondColumnMatrix,
                          @"Error in conversion to columns array(2).");
    XCTAssertEqualObjects([columnsTestColumns objectAtIndex:2], thirdColumnMatrix,
                          @"Error in conversion to columns array(3).");
    XCTAssertEqualObjects([columnsTestColumns objectAtIndex:3], fourthColumnMatrix,
                          @"Error in conversion to columns array(4).");
}

- (void)testSubMatrices
{
    TitleNSLog(@"Sub-Matrix Extraction Test");
    double simple_array[16] = { 1.0, 2.0, 3.0, 4.0,
        5.0, 6.0, 7.0, 8.0,
        9.0, 10.0, 11.0, 12.0,
        13.0, 14.0, 15.0, 16.0 };
    Matrix *original = [Matrix matrixFromArray:simple_array rows:4 columns:4];
    
    double expected_rows[8] = { 5.0, 6.0, 7.0, 8.0,
        9.0, 10.0, 11.0, 12.0 };
    Matrix *expectedRows = [Matrix matrixFromArray:expected_rows rows:2 columns:4];
    Matrix *resultRows = [original matrixWithRowsInRange:NSMakeRange(1, 2)];
    CleanNSLog(@"%@", resultRows);
    XCTAssertEqualObjects(expectedRows, resultRows, @"Error while extracting rows to sub-matrix");
    
    double expected_columns[8] = { 2.0, 3.0,
        6.0, 7.0,
        10.0, 11.0,
        14.0, 15.0 };
    Matrix *expectedColumns = [Matrix matrixFromArray:expected_columns rows:4 columns:2];
    Matrix *resultColumns = [original matrixWithColumnsInRange:NSMakeRange(1, 2)];
    CleanNSLog(@"%@", resultColumns);
    XCTAssertEqualObjects(expectedColumns, resultColumns, @"Error while extracting columns to sub-matrix");
}

- (void)testRowAndColumnAdditionsSubtractions
{
    TitleNSLog(@"Row / Column Additions / Subtractions");
    double simple_array[16] = { 1.0, 2.0, 3.0, 4.0,
        5.0, 6.0, 7.0, 8.0,
        9.0, 10.0, 11.0, 12.0,
        13.0, 14.0, 15.0, 16.0 };
    Matrix *original = [Matrix matrixFromArray:simple_array rows:4 columns:4];
    double element[4] = { 4.0, 1.0, -40.0, -22.5 };
    Matrix *column = [Matrix matrixFromArray:element rows:4 columns:1];
    Matrix *row = [Matrix matrixFromArray:element rows:1 columns:4];
    Matrix *step1 = [original matrixByAddingRow:row];
    Matrix *step2 = [step1 matrixByAddingColumn:column];
    Matrix *step3 = [step2 matrixBySubtractingColumn:column];
    Matrix *step4 = [step3 matrixBySubtractingRow:row];
    
    XCTAssertEqualObjects(original, step4, @"Error while Adding / Subtracting Rows / Columns");
}

- (void)testRowRemoval
{
    double original[16] = {
        16.0, 2.0,  3.0,  13.0,
        5.0,  11.0, 10.0, 8.0,
        9.0,  7.0,  6.0,  12.0,
        4.0,  14.0, 15.0, 0.05
    };
    
    double test[12] = {
        16.0, 2.0,  3.0,  13.0,
        9.0,  7.0,  6.0,  12.0,
        4.0,  14.0, 15.0, 0.05
    };
    
    Matrix *originalMatrix = [Matrix matrixFromArray:original rows:4 columns:4];
    Matrix *resultMatrix = [originalMatrix removeRow:1];
    Matrix *testMatrix = [Matrix matrixFromArray:test rows:3 columns:4];
    XCTAssertEqualObjects(testMatrix, resultMatrix);
    CleanNSLog(@"Original:\n%@", originalMatrix);
    CleanNSLog(@"Test:\n%@", testMatrix);
    CleanNSLog(@"-removeRow: Result:\n%@", resultMatrix);
}

- (void)testColumnRemoval
{
    double original[16] = {
        16.0, 2.0,  3.0,  13.0,
        5.0,  11.0, 10.0, 8.0,
        9.0,  7.0,  6.0,  12.0,
        4.0,  14.0, 15.0, 0.05
    };
    
    double test[12] = {
        16.0,  3.0,  13.0,
        5.0, 10.0, 8.0,
        9.0,  6.0,  12.0,
        4.0, 15.0, 0.05
    };
    
    Matrix *originalMatrix = [Matrix matrixFromArray:original rows:4 columns:4];
    Matrix *resultMatrix = [originalMatrix removeColumn:1];
    Matrix *testMatrix = [Matrix matrixFromArray:test rows:4 columns:3];
    XCTAssertEqualObjects(testMatrix, resultMatrix);
    CleanNSLog(@"Original:\n%@", originalMatrix);
    CleanNSLog(@"Test:\n%@", testMatrix);
    CleanNSLog(@"-removeColumn: Result:\n%@", resultMatrix);
}

- (void)testRowShuffling
{
    double original[20] = {
        1.0,    10.0,   100.0,  1000.0, 10000.0,
        2.0,    20.0,   200.0,  2000.0, 20000.0,
        3.0,    30.0,   300.0,  3000.0, 30000.0,
        4.0,    40.0,   400.0,  4000.0, 40000.0
    };
    
    Matrix *originalMatrix = [Matrix matrixFromArray:original rows:4 columns:5];
    CleanNSLog(@"%@", originalMatrix);
    Matrix *shuffledMatrix = [originalMatrix copy];
    [shuffledMatrix shuffleRows];
    CleanNSLog(@"%@", shuffledMatrix);
    // Sums of columns should remain the same
    XCTAssertEqualObjects([originalMatrix sumsOfColumns], [shuffledMatrix sumsOfColumns]);
    
    shuffledMatrix = [originalMatrix matrixByShufflingRows];
    CleanNSLog(@"%@", shuffledMatrix);
    // Sums of columns should remain the same
    XCTAssertEqualObjects([originalMatrix sumsOfColumns], [shuffledMatrix sumsOfColumns]);
}

- (void)testColumnShuffling
{
    double original[20] = {
        1.0,    10.0,   100.0,  1000.0, 10000.0,
        2.0,    20.0,   200.0,  2000.0, 20000.0,
        3.0,    30.0,   300.0,  3000.0, 30000.0,
        4.0,    40.0,   400.0,  4000.0, 40000.0
    };
    
    Matrix *originalMatrix = [Matrix matrixFromArray:original rows:4 columns:5];
    CleanNSLog(@"%@", originalMatrix);
    Matrix *shuffledMatrix = [originalMatrix copy];
    [shuffledMatrix shuffleColumns];
    CleanNSLog(@"%@", shuffledMatrix);
    // Sums of rows should remain the same
    XCTAssertEqualObjects([originalMatrix sumsOfRows], [shuffledMatrix sumsOfRows]);
    
    shuffledMatrix = [originalMatrix matrixByShufflingColumns];
    CleanNSLog(@"%@", shuffledMatrix);
    // Sums of columns should remain the same
    XCTAssertEqualObjects([originalMatrix sumsOfRows], [shuffledMatrix sumsOfRows]);
}

- (void)testRowPartitioning
{
    double original[25] = {
        1.0,    10.0,   100.0,  1000.0, 10000.0,
        2.0,    20.0,   200.0,  2000.0, 20000.0,
        3.0,    30.0,   300.0,  3000.0, 30000.0,
        4.0,    40.0,   400.0,  4000.0, 40000.0,
        5.0,    50.0,   500.0,  5000.0, 50000.0
    };
    Matrix *originalMatrix = [Matrix matrixFromArray:original rows:5 columns:5];
    
    double partition0[10] = {
        1.0,    10.0,   100.0,  1000.0, 10000.0,
        2.0,    20.0,   200.0,  2000.0, 20000.0
    };
    Matrix *partition0Matrix = [Matrix matrixFromArray:partition0 rows:2 columns:5];
    
    double partition1[10] = {
        3.0,    30.0,   300.0,  3000.0, 30000.0,
        4.0,    40.0,   400.0,  4000.0, 40000.0
    };
    Matrix *partition1Matrix = [Matrix matrixFromArray:partition1 rows:2 columns:5];
    
    double partition2[5] = {
        5.0,    50.0,   500.0,  5000.0, 50000.0
    };
    Matrix *partition2Matrix = [Matrix matrixFromArray:partition2 rows:1 columns:5];
    
    NSArray *partitions = [originalMatrix rowWisePartition:2];
    XCTAssertEqualObjects(partitions[0], partition0Matrix, @"Partitions not equal");
    XCTAssertEqualObjects(partitions[1], partition1Matrix, @"Partitions not equal");
    XCTAssertEqualObjects(partitions[2], partition2Matrix, @"Partitions not equal");
}

- (void)testColumnPartitioning
{
    double original[25] = {
        1.0,    10.0,   100.0,  1000.0, 10000.0,
        2.0,    20.0,   200.0,  2000.0, 20000.0,
        3.0,    30.0,   300.0,  3000.0, 30000.0,
        4.0,    40.0,   400.0,  4000.0, 40000.0,
        5.0,    50.0,   500.0,  5000.0, 50000.0
    };
    Matrix *originalMatrix = [Matrix matrixFromArray:original rows:5 columns:5];
    
    double partition0[10] = {
        1.0,    10.0,
        2.0,    20.0,
        3.0,    30.0,
        4.0,    40.0,
        5.0,    50.0
    };
    Matrix *partition0Matrix = [Matrix matrixFromArray:partition0 rows:5 columns:2];
    
    double partition1[10] = {
        100.0,  1000.0,
        200.0,  2000.0,
        300.0,  3000.0,
        400.0,  4000.0,
        500.0,  5000.0
    };
    Matrix *partition1Matrix = [Matrix matrixFromArray:partition1 rows:5 columns:2];
    
    double partition2[5] = {
        10000.0,
        20000.0,
        30000.0,
        40000.0,
        50000.0
    };
    Matrix *partition2Matrix = [Matrix matrixFromArray:partition2 rows:5 columns:1];
    
    NSArray *partitions = [originalMatrix columnWisePartition:2];
    XCTAssertEqualObjects(partitions[0], partition0Matrix, @"Partitions not equal");
    XCTAssertEqualObjects(partitions[1], partition1Matrix, @"Partitions not equal");
    XCTAssertEqualObjects(partitions[2], partition2Matrix, @"Partitions not equal");
}

@end
