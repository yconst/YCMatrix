//
//  ManipulateTests.m
//  cLayout
//
//  Created by Ioannis Chatzikonstantinou on 14/6/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ManipulateTests.h"

@implementation ManipulateTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    TitleNSLog(@"Manipulate Matrix Unit Tests");
}

- (void)tearDown
{
    // Tear-down code here.
    TitleNSLog(@"End Of Manipulate Matrix Unit Tests");
    [super tearDown];
}

// All code under test must be linked into the Unit Test bundle
- (void)testManipulateMatrixFunctions
{
    //
    // Matrix row retrieval
    //
    TitleNSLog(@"Matrix row retrieval");
    double testmrarr[6] = { 1.0, 2.0, 3.0, 4.0, 5.0, 6.0 };
    YCMatrix *testmr = [YCMatrix matrixFromArray:testmrarr Rows:2 Columns:3];
    YCMatrix *rowm = [testmr getRow:1]; // This is being tested.
    CleanNSLog(@"%@", rowm);
    double templatermatrixarr[3] = { 4.0, 5.0, 6.0 };
    YCMatrix *templatemr = [YCMatrix matrixFromArray:templatermatrixarr Rows:1 Columns:3];
    XCTAssertTrue([rowm isEqual: templatemr], @"Matrix row retrieval is problematic.");
    
    //
    // Matrix column retrieval
    //
    TitleNSLog(@"Matrix column retrieval");
    double testmcarr[6] = { 1.0, 4.0, 2.0, 5.0, 3.0, 6.0 };
    YCMatrix *testmc = [YCMatrix matrixFromArray:testmcarr Rows:3 Columns:2];
    YCMatrix *columnm = [testmc getColumn:1]; // This is being tested.
    CleanNSLog(@"%@", columnm);
    double templatecmatrixarr[3] = { 4.0, 5.0, 6.0 };
    YCMatrix *templatemc = [YCMatrix matrixFromArray:templatecmatrixarr Rows:3 Columns:1];
    XCTAssertTrue([columnm isEqual: templatemc], @"Matrix column retrieval is problematic.");
    
    //
    // Subtract from all cols
    //
    TitleNSLog(@"Subtract from all cols");
    YCMatrix *testmsubc = [YCMatrix matrixFromArray:testmcarr Rows:3 Columns:2];
    YCMatrix *subtracted = [testmsubc subtractColumnFromAllColumns:templatemc];
    CleanNSLog(@"%@", testmsubc);
    CleanNSLog(@"%@", subtracted);
    
    //
    // Append row
    //
    YCMatrix *testappendrow = [YCMatrix matrixFromArray:testmrarr Rows:2 Columns:3];
    YCMatrix *testrow = [testappendrow getRow:0];
    YCMatrix *testappendedrow = [testappendrow appendRow:testrow];
    CleanNSLog(@"Test Appended Row: %@", testappendedrow);
    
    //
    // Append column
    //
    YCMatrix *testappendcolumn = [YCMatrix matrixFromMatrix:testappendedrow];
    YCMatrix *testcolumn = [[YCMatrix matrixFromMatrix:testrow] matrixByTransposing];
    YCMatrix *testappendedcolumn = [testappendcolumn appendColumn:testcolumn];
    CleanNSLog(@"Test Appended Column: %@", testappendedcolumn);
    
    //
    // Set column
    //
    [testappendedcolumn setColumn:0 Value:[testappendedcolumn getColumn:2]];
    CleanNSLog(@"Set Column: %@", testappendedcolumn);
    
    //
    // Set row
    //
    [testappendedcolumn setRow:1 Value:[testappendedcolumn getRow:2]];
    CleanNSLog(@"Set Row: %@", testappendedcolumn);
    
    //
    // Remove row
    //
    YCMatrix *removedRow = [testappendedcolumn removeRow:2];
    CleanNSLog(@"Remove row: %@", removedRow);
    
    //
    // Remove column
    //
    YCMatrix *removedColumn = [removedRow removeColumn:2];
    CleanNSLog(@"Remove column: %@", removedColumn);
    
    //
    // Rows as NSArray
    //
    TitleNSLog(@"Rows as NSArray");
    double rowsColumnsArrayTest[12] = { 1.0, 2.0, 3.0, 4.0,
        5.0, 6.0, 7.0, 8.0,
        9.0, 10.0, 11.0, 12.0};
    double firstRow[4] = { 1.0, 2.0, 3.0, 4.0 };
    YCMatrix *firstRowMatrix = [YCMatrix matrixFromArray:firstRow Rows:1 Columns:4];
    double secondRow[4] = { 5.0, 6.0, 7.0, 8.0 };
    YCMatrix *secondRowMatrix = [YCMatrix matrixFromArray:secondRow Rows:1 Columns:4];
    double thirdRow[4] = { 9.0, 10.0, 11.0, 12.0 };
    YCMatrix *thirdRowMatrix = [YCMatrix matrixFromArray:thirdRow Rows:1 Columns:4];
    
    YCMatrix *rowsColumnsTestMatrix = [YCMatrix matrixFromArray:rowsColumnsArrayTest Rows:3 Columns:4];
    NSArray *rowsTestRows = [rowsColumnsTestMatrix RowsAsNSArray];
    XCTAssertEqualObjects([rowsTestRows objectAtIndex:0], firstRowMatrix, @"Error in conversion to rows array(1).");
    XCTAssertEqualObjects([rowsTestRows objectAtIndex:1], secondRowMatrix, @"Error in conversion to rows array(2).");
    XCTAssertEqualObjects([rowsTestRows objectAtIndex:2], thirdRowMatrix, @"Error in conversion to rows array(3).");
    CleanNSLog(@"Passed");
    
    //
    // Columns as NSArray
    //
    TitleNSLog(@"Columns as NSArray");
    double firstColumn[3] = { 1.0, 5.0, 9.0 };
    YCMatrix *firstColumnMatrix = [YCMatrix matrixFromArray:firstColumn Rows:3 Columns:1];
    double secondColumn[3] = { 2.0, 6.0, 10.0 };
    YCMatrix *secondColumnMatrix = [YCMatrix matrixFromArray:secondColumn Rows:3 Columns:1];
    double thirdColumn[3] = { 3.0, 7.0, 11.0 };
    YCMatrix *thirdColumnMatrix = [YCMatrix matrixFromArray:thirdColumn Rows:3 Columns:1];
    double fourthColumn[3] = { 4.0, 8.0, 12.0 };
    YCMatrix *fourthColumnMatrix = [YCMatrix matrixFromArray:fourthColumn Rows:3 Columns:1];

    NSArray *columnsTestColumns = [rowsColumnsTestMatrix ColumnsAsNSArray];
    XCTAssertEqualObjects([columnsTestColumns objectAtIndex:0], firstColumnMatrix, @"Error in conversion to columns array(1).");
    XCTAssertEqualObjects([columnsTestColumns objectAtIndex:1], secondColumnMatrix, @"Error in conversion to columns array(2).");
    XCTAssertEqualObjects([columnsTestColumns objectAtIndex:2], thirdColumnMatrix, @"Error in conversion to columns array(3).");
    XCTAssertEqualObjects([columnsTestColumns objectAtIndex:3], fourthColumnMatrix, @"Error in conversion to columns array(4).");
    CleanNSLog(@"Passed");
}

@end
