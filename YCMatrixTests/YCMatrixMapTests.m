//
//  YCMatrixMapTests.m
//  YCMatrix
//
//  Created by Ioannis Chatzikonstantinou on 18/1/15.
//  Copyright (c) 2015 Ioannis Chatzikonstantinou. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "Matrix.h"
#import "Matrix+Advanced.h"
#import "Matrix+Map.h"

#define ARC4RANDOM_MAX 0x100000000 

// Definitions for convenience logging functions (without date/object and title logging).
#define CleanNSLog(FORMAT, ...) fprintf(stderr,"%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#define TitleNSLog(FORMAT, ...) fprintf(stderr,"\n%s\n_____________________________________\n\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

@interface YCMatrixMapTests : XCTestCase

@end

@implementation YCMatrixMapTests

- (void)testMinMaxMapping
{
    Matrix *low = [Matrix matrixOfRows:4 Columns:5 Value:3];
    Matrix *high = [Matrix matrixOfRows:4 Columns:5 Value:8];
    Matrix *original = [Matrix randomValuesMatrixWithLowerBound:low upperBound:high];
    Matrix *mapping = [original rowWiseMapToDomain:YCMakeDomain(0, 1) basis:MinMax];
    Matrix *inverse = [original rowWiseInverseMapFromDomain:YCMakeDomain(0, 1) basis:MinMax];
    Matrix *mapped = [original matrixByRowWiseMapUsing:mapping];
    Matrix *copy = [mapped matrixByRowWiseMapUsing:inverse];
    XCTAssert([copy isEqualToMatrix:original tolerance:1E-9], @"Mapping failed");
}

- (void)testStDevMapping
{
    Matrix *low = [Matrix matrixOfRows:4 Columns:5 Value:3];
    Matrix *high = [Matrix matrixOfRows:4 Columns:5 Value:8];
    Matrix *original = [Matrix randomValuesMatrixWithLowerBound:low upperBound:high];
    Matrix *mapping = [original rowWiseMapToDomain:YCMakeDomain(-1, 2) basis:StDev];
    Matrix *inverse = [original rowWiseInverseMapFromDomain:YCMakeDomain(-1, 2) basis:StDev];
    Matrix *mapped = [original matrixByRowWiseMapUsing:mapping];
    Matrix *copy = [mapped matrixByRowWiseMapUsing:inverse];
    XCTAssert([copy isEqualToMatrix:original tolerance:1E-9], @"Mapping failed");
}

@end
