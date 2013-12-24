//
//  AdvancedMatrixTests.m
//  cLayout
//
//  Created by Yan Const on 6/7/13.
//
//

#import "AdvancedMatrixTests.h"


@implementation AdvancedMatrixTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    TitleNSLog(@"Advanced Matrix Unit Tests");
}

- (void)tearDown
{
    // Tear-down code here.
    TitleNSLog(@"End Of Advanced Matrix Unit Tests");
    [super tearDown];
}

// All code under test must be linked into the Unit Test bundle
- (void)testAdvancedMatrixFunctions
{
    STAssertTrue((1 + 1) == 2, @"Compiler isn't feeling well today :-(");
    
    //
    // PseudoInverse Derivation
    //
    double *arr = calloc(9, sizeof(double));
    arr[0] = 1;
    arr[1] = 2;
    arr[2] = 3;
    arr[3] = 4;
    arr[4] = 5;
    arr[5] = 6;
    arr[6] = 7;
    arr[7] = 8;
    arr[8] = 9;
    
    double *res = calloc(9, sizeof(double));
    [YCMatrix getPinvOf:arr Rows:3 Columns:3 Out:res];
    NSString *resstr = @"";
    for (int i=0; i< 9; i++)
    {
        resstr = [resstr stringByAppendingString: [NSString stringWithFormat:@"%g, ", res[i]]];
    }
    CleanNSLog(@"%@", resstr);
    
    double *arr2 = calloc(6, sizeof(double));
    arr2[0] = 1;
    arr2[1] = 2;
    arr2[2] = 3;
    arr2[3] = 4;
    arr2[4] = 5;
    arr2[5] = 6;
    
    double *res2 = calloc(6, sizeof(double));
    [YCMatrix getPinvOf:arr2 Rows:3 Columns:2 Out:res2];
    NSString *resstr2 = @"";
    for (int i=0; i< 6; i++)
    {
        resstr2 = [resstr2 stringByAppendingString: [NSString stringWithFormat:@"%g, ", res2[i]]];
    }
    CleanNSLog(@"%@", resstr2);
    
    //
    // QR Decomposition Test (A:4x3)
    //
    TitleNSLog(@"QR Decomposition Test (A:4x3)");
    double simple_array[12] = { 1.0, 2.0, 3.0,
        4.0, 5.0, 6.0,
        7.0, 8.0, 9.0,
        10.0, 11.0, 12.0};
    YCMatrix *simple_matrix = [YCMatrix matrixFromArray:simple_array Rows:4 Columns:3];
    CleanNSLog(@"Original Matrix: %@",simple_matrix);
    NSDictionary *QR = [simple_matrix QR];
    YCMatrix *Q = [QR objectForKey:@"Q"];
    CleanNSLog(@"Q: %@",Q);
    YCMatrix *R = [QR objectForKey:@"R"];
    CleanNSLog(@"R: %@",R);
    YCMatrix *A = [Q matrixByMultiplyingWithRight:R];
    CleanNSLog(@"Q*R: %@",A);
    
    //
    // QR Decomposition Test (A:2x3)
    //
    TitleNSLog(@"QR Decomposition Test (A:2x3)");
    double simple_array2[6] = { 1.0, 2.0, 3.0,
        4.0, 5.0, 6.0};
    YCMatrix *simple_matrix2 = [YCMatrix matrixFromArray:simple_array2 Rows:2 Columns:3];
    CleanNSLog(@"Original Matrix: %@",simple_matrix2);
    NSDictionary *QR2 = [simple_matrix2 QR];
    YCMatrix *Q2 = [QR2 objectForKey:@"Q"];
    CleanNSLog(@"Q: %@",Q2);
    YCMatrix *R2 = [QR2 objectForKey:@"R"];
    CleanNSLog(@"R: %@",R2);
    YCMatrix *A2 = [Q2 matrixByMultiplyingWithRight:R2];
    CleanNSLog(@"Q*R: %@",A2);
    
    // STAssertTrue([A isEqualTo: simple_matrix] , @"Error in QR decomposition. QR != A");
    
    //
    // Mean Test
    //
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
    STAssertTrue([rowMeans isEqualTo: rowMeanTargetMatrix] , @"Error in calculating Row Means.");
    STAssertTrue([columnMeans isEqualTo: columnMeanTargetMatrix] , @"Error in calculating Column Means.");
    CleanNSLog(@"%@", rowMeans);
    CleanNSLog(@"%@", columnMeans);
    
}
@end
