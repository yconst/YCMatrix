//
//  YCMatrixPerformanceTests.m
//  YCMatrix
//
//  Created by Ioannis Chatzikonstantinou on 28/1/16.
//  Copyright © 2016 Ioannis Chatzikonstantinou. All rights reserved.
//

#import <XCTest/XCTest.h>
@import YCMatrix;

@interface YCMatrixPerformanceTests : XCTestCase

@end

@implementation YCMatrixPerformanceTests

- (void)testVDSPAddPerformance {
    
    Matrix *lower = [Matrix matrixOfRows:10000 columns:2000 value:0];
    Matrix *upper = [Matrix matrixOfRows:10000 columns:2000 value:1];
    
    Matrix *A = [Matrix randomValuesMatrixWithLowerBound:lower upperBound:upper];
    Matrix *B = [Matrix randomValuesMatrixWithLowerBound:lower upperBound:upper];
    
    [self measureBlock:^{
        [A matrixByAdding:B];
    }];
}

- (void)testBLASMultiplyScalarAndAddPerformance {
    
    Matrix *lower = [Matrix matrixOfRows:10000 columns:2000 value:0];
    Matrix *upper = [Matrix matrixOfRows:10000 columns:2000 value:1];
    
    Matrix *A = [Matrix randomValuesMatrixWithLowerBound:lower upperBound:upper];
    Matrix *B = [Matrix randomValuesMatrixWithLowerBound:lower upperBound:upper];
    
    [self measureBlock:^{
        [A matrixByMultiplyingWithScalar:1 AndAdding:B];
    }];
}

- (void)testCAddPerformance {
    
    Matrix *lower = [Matrix matrixOfRows:10000 columns:2000 value:0];
    Matrix *upper = [Matrix matrixOfRows:10000 columns:2000 value:1];
    
    Matrix *A = [Matrix randomValuesMatrixWithLowerBound:lower upperBound:upper];
    Matrix *B = [Matrix randomValuesMatrixWithLowerBound:lower upperBound:upper];
    
    double *ma = A->matrix;
    double *mb = B->matrix;

    [self measureBlock:^{
        
        // Need to include memory allocation as well here
        Matrix *C = [Matrix matrixLike:A];
        double *mc = C->matrix;
        
        #pragma vector always
        for (int i=0, j=(int)A.count; i<j; i++)
        {
            mc[i] = ma[i] + mb[i];
            
        }
    }];
}

- (void)testVDSPSubtractPerformance {
    
    Matrix *lower = [Matrix matrixOfRows:10000 columns:2000 value:0];
    Matrix *upper = [Matrix matrixOfRows:10000 columns:2000 value:1];
    
    Matrix *A = [Matrix randomValuesMatrixWithLowerBound:lower upperBound:upper];
    Matrix *B = [Matrix randomValuesMatrixWithLowerBound:lower upperBound:upper];
    
    [self measureBlock:^{
        [A matrixBySubtracting:B];
    }];
}

- (void)testBLASSubtractPerformance {
    
    Matrix *lower = [Matrix matrixOfRows:10000 columns:2000 value:0];
    Matrix *upper = [Matrix matrixOfRows:10000 columns:2000 value:1];
    
    Matrix *A = [Matrix randomValuesMatrixWithLowerBound:lower upperBound:upper];
    Matrix *B = [Matrix randomValuesMatrixWithLowerBound:lower upperBound:upper];
    
    [self measureBlock:^{
        [A matrixByMultiplyingWithScalar:-1 AndAdding:B];
    }];
}

- (void)testCSubtractPerformance {
    
    Matrix *lower = [Matrix matrixOfRows:10000 columns:2000 value:0];
    Matrix *upper = [Matrix matrixOfRows:10000 columns:2000 value:1];
    
    Matrix *A = [Matrix randomValuesMatrixWithLowerBound:lower upperBound:upper];
    Matrix *B = [Matrix randomValuesMatrixWithLowerBound:lower upperBound:upper];
    
    double *ma = A->matrix;
    double *mb = B->matrix;
    
    [self measureBlock:^{
        
        // Need to include memory allocation as well here
        Matrix *C = [Matrix matrixLike:A];
        double *mc = C->matrix;
        
#pragma vector always
        for (int i=0, j=(int)A.count; i<j; i++)
        {
            mc[i] = ma[i] - mb[i];
            
        }
    }];
}

- (void)testBLASMultiplyScalarPerformance
{
    Matrix *lower = [Matrix matrixOfRows:10000 columns:2000 value:0];
    Matrix *upper = [Matrix matrixOfRows:10000 columns:2000 value:1];
    
    Matrix *A = [Matrix randomValuesMatrixWithLowerBound:lower upperBound:upper];
    
    [self measureBlock:^{
        cblas_dscal(A->rows*A->columns, 10, A->matrix, 1);
    }];
}

- (void)testVDSPMultiplyScalarPerformance
{
    Matrix *lower = [Matrix matrixOfRows:10000 columns:2000 value:0];
    Matrix *upper = [Matrix matrixOfRows:10000 columns:2000 value:1];
    
    Matrix *A = [Matrix randomValuesMatrixWithLowerBound:lower upperBound:upper];
    
    [self measureBlock:^{
        [A multiplyWithScalar:10];
    }];
}

@end
