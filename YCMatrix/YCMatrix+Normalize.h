//
//  YCMatrix+Normalize.h
//  YCMatrix
//
//  Created by Ioannis Chatzikonstantinou on 2/7/14.
//  Copyright (c) 2014 Ioannis Chatzikonstantinou. All rights reserved.
//

#import <YCMatrix/YCMatrix.h>

@interface YCMatrix (Normalize)

// Transform matrix |mtx| using transformation bi-vector |transform|
- (YCMatrix *)matrixByScalingUsing:(YCMatrix *)transform;

- (YCMatrix *)DetermineScalingMatrix;

- (YCMatrix *)DetermineInverseScalingMatrix;

@end
