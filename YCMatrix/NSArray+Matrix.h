//
//  NSArray+Matrix.h
//
//  YCMatrix
//
//  Created by Ioannis Chatzikonstantinou on 6/2/15.
//  Copyright (c) 2015 Ioannis Chatzikonstantinou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Matrix.h"

@interface NSArray (Matrix)

@property (readonly) Matrix *matrixSum;

@property (readonly) Matrix *matrixProduct;

@property (readonly) Matrix *matrixMean;

@end
