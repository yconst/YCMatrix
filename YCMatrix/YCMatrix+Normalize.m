//
//  YCMatrix+Normalize.m
//  YCMatrix
//
//  Created by Ioannis Chatzikonstantinou on 2/7/14.
//  Copyright (c) 2014 Ioannis Chatzikonstantinou. All rights reserved.
//

#import "YCMatrix+Normalize.h"
#import "YCMatrix+Manipulate.h"

@implementation YCMatrix (Normalize)

- (YCMatrix *)matrixByRowWiseScalingUsing:(YCMatrix *)transform
{
    double *mtxArray = self->matrix;
    double *transformArray = transform->matrix;
    YCMatrix *transformed = [YCMatrix matrixOfRows:rows Columns:columns];
    double *transformedArray = transformed->matrix;
    dispatch_apply(rows, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t i)
                   {
                       double mval = transformArray[2*i];
                       double aval = transformArray[2*i + 1];
                       for (int j=0; j<columns; j++)
                       {
                           transformedArray[i*columns + j] = mtxArray[i*columns + j] * mval + aval;
                       }
                   });
    return transformed;
}

- (YCMatrix *)DetermineRowWiseScalingMatrix
{
    int numRows = self->rows;
    int numColumns = self->columns;
    NSArray *matrixRows = [self RowsAsNSArray];
    YCMatrix *transform = [YCMatrix matrixOfRows:numRows Columns:2];
    int i=0;
    for (YCMatrix *m in matrixRows)
    {
        // Find Mean
        double pmean = 0;
        for (int j=0; j<numColumns; j++)
        {
            pmean += m->matrix[j];
        }
        pmean /= numColumns;
        // Find stdev
        double pstdev = 0;
        for (int j=0; j<numColumns; j++)
        {
            pstdev += pow(m->matrix[j] - pmean,2);
        }
        pstdev = sqrt(pstdev/(numColumns - 1));
        double a = 1 / (2*pstdev);
        double b = -pmean / (2*pstdev);
        [transform setValue:a Row:i Column:0];
        [transform setValue:b Row:i++ Column:1];
    }
    return transform;
}

- (YCMatrix *)DetermineRowWiseInverseScalingMatrix
{
    int numRows = self->rows;
    int numColumns = self->columns;
    NSArray *matrixRows = [self RowsAsNSArray];
    YCMatrix *transform = [YCMatrix matrixOfRows:numRows Columns:2];
    int i=0;
    for (YCMatrix *m in matrixRows)
    {
        // Find Mean
        double pmean = 0;
        for (int j=0; j<numColumns; j++)
        {
            pmean += m->matrix[j];
        }
        pmean /= numColumns;
        // Find stdev
        double pstdev = 0;
        for (int j=0; j<numColumns; j++)
        {
            pstdev += pow(m->matrix[j] - pmean,2);
        }
        pstdev = sqrt(pstdev/(numColumns - 1));
        double a = 2*pstdev;
        double b = pmean;
        [transform setValue:a Row:i Column:0];
        [transform setValue:b Row:i++ Column:1];
    }
    return transform;
}

@end
