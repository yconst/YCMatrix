//
//  ManipulateTests.m
//  cLayout
//
//  Created by Ioannis Chatzikonstantinou on 14/6/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ManipulateTests.h"

@implementation ManipulateTests

// All code under test must be linked into the Unit Test bundle
- (void)testMath
{
    STAssertTrue((1 + 1) == 2, @"Compiler isn't feeling well today :-(");
    
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
    STAssertTrue([rowm isEqual: templatemr], @"Matrix row retrieval is problematic.");
    
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
    STAssertTrue([columnm isEqual: templatemc], @"Matrix column retrieval is problematic.");
    
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
    YCMatrix *testcolumn = [[YCMatrix matrixFromMatrix:testrow] transpose];
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
    
}

@end
