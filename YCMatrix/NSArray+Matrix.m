//
//  NSArray+Matrix.m
//
//  YCMatrix
//
//  Created by Ioannis Chatzikonstantinou on 6/2/15.
//  Copyright (c) 2015 Ioannis Chatzikonstantinou. All rights reserved.
//

#import "NSArray+Matrix.h"

@implementation NSArray (Matrix)

- (Matrix *)matrixSum
{
    Matrix *result;
    for (Matrix *m in self)
    {
        if (!result)
        {
            result = [m copy];
        }
        else
        {
            [result add:m];
        }
    }
    return result;
}

- (Matrix *)matrixMean
{
    Matrix *result = [self matrixSum];
    [result multiplyWithScalar:1.0 / (double)self.count];
    return result;
}

- (Matrix *)matrixProduct
{
    Matrix *result;
    for (Matrix *m in self)
    {
        if (!result)
        {
            result = [m copy];
        }
        else
        {
            [result elementWiseMultiply:m];
        }
    }
    return result;
}

@end
