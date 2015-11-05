//
//  YCMatrixMapTests.m
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

@interface YCMatrixMapTests : XCTestCase

@end

@implementation YCMatrixMapTests

- (void)testMinMaxMapping
{
    Matrix *low = [Matrix matrixOfRows:4 columns:5 value:3];
    Matrix *high = [Matrix matrixOfRows:4 columns:5 value:8];
    Matrix *original = [Matrix randomValuesMatrixWithLowerBound:low upperBound:high];
    Matrix *mapping = [original rowWiseMapToDomain:YCMakeDomain(0, 1) basis:MinMax];
    Matrix *inverse = [original rowWiseInverseMapFromDomain:YCMakeDomain(0, 1) basis:MinMax];
    Matrix *mapped = [original matrixByRowWiseMapUsing:mapping];
    Matrix *copy = [mapped matrixByRowWiseMapUsing:inverse];
    XCTAssert([copy isEqualToMatrix:original tolerance:1E-9], @"Mapping failed");
}

- (void)testStDevMapping
{
    Matrix *low = [Matrix matrixOfRows:4 columns:5 value:3];
    Matrix *high = [Matrix matrixOfRows:4 columns:5 value:8];
    Matrix *original = [Matrix randomValuesMatrixWithLowerBound:low upperBound:high];
    Matrix *mapping = [original rowWiseMapToDomain:YCMakeDomain(-1, 2) basis:StDev];
    Matrix *inverse = [original rowWiseInverseMapFromDomain:YCMakeDomain(-1, 2) basis:StDev];
    Matrix *mapped = [original matrixByRowWiseMapUsing:mapping];
    Matrix *copy = [mapped matrixByRowWiseMapUsing:inverse];
    XCTAssert([copy isEqualToMatrix:original tolerance:1E-9], @"Mapping failed");
}

@end
