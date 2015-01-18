//
//  YCMatrixMapTests.m
//  YCMatrix
//
//  Created by Ioannis Chatzikonstantinou on 18/1/15.
//  Copyright (c) 2015 Ioannis Chatzikonstantinou. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "YCMatrix.h"
#import "YCMatrix+Advanced.h"
#import "YCMatrix+Map.h"

@interface YCMatrixMapTests : XCTestCase

@end

@implementation YCMatrixMapTests

- (void)testMinMaxMapping
{
    YCMatrix *low = [YCMatrix matrixOfRows:4 Columns:5 Value:3];
    YCMatrix *high = [YCMatrix matrixOfRows:4 Columns:5 Value:8];
    YCMatrix *original = [YCMatrix randomValuesMatrixWithLowerBound:low upperBound:high];
    YCMatrix *mapping = [original rowWiseMapToRange:NSMakeRange(0, 1) basis:MinMax];
    YCMatrix *inverse = [original rowWiseInverseMapFromRange:NSMakeRange(0, 1) basis:MinMax];
    YCMatrix *mapped = [original matrixByRowWiseMapUsing:mapping];
    YCMatrix *copy = [mapped matrixByRowWiseMapUsing:inverse];
    XCTAssert([copy isEqualToMatrix:original Precision:1E-9], @"Mapping failed");
}

@end
