//
//  Matrix.h
//  Matrix
//
//  Created by Yan Const on 11/7/13.
//  Copyright (c) 2013 Ioannis Chatzikonstantinou. All rights reserved.
//

#import "YCMatrix.h"
#import "YCMatrix+Manipulate.h"
#import <Accelerate/Accelerate.h>

@interface YCMatrix (Advanced)

- (YCMatrix *)inverse;
- (YCMatrix *)pseudoInverse;
- (NSDictionary *)QR;
- (NSDictionary *)WA;
- (YCMatrix *)RowMean;
- (YCMatrix *)ColumnMean;
+ (void)getPinvOf:(double *)A Rows:(int)rows Columns:(int)columns Out:(double *)Aplus;
+ (void)getQROf:(double *)A Rows:(int)rows Columns:(int)columns OutQ:(double *)Q OutR:(double *)R;

@end
