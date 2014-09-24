//
//  YCMatrix+Normalize.m
//
// Copyright (c) 2013, 2014 Ioannis (Yannis) Chatzikonstantinou. All rights reserved.
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
