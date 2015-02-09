//
//  NSArray+Matrix.h
//  YCMatrix
//
//  Created by Ioannis Chatzikonstantinou on 6/2/15.
//  Copyright (c) 2015 Ioannis Chatzikonstantinou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YCMatrix.h"

@interface NSArray (Matrix)

@property (readonly) YCMatrix *matrixSum;

@property (readonly) YCMatrix *matrixProduct;

@property (readonly) YCMatrix *matrixMean;

@end
