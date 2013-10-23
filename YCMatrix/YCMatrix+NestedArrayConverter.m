//
//  YCMatrix+NestedArrayConverter.m
//  YCogni
//
//  Created by Yan Const on 19/7/13.
//  Copyright (c) 2013 Ioannis Chatzikonstantinou. All rights reserved.
//

#import "YCMatrix+NestedArrayConverter.h"

@implementation YCMatrix (NestedDictionaryConverter)

+ (YCMatrix *)convertToMatrix:(NSDictionary *)input Types:(NSDictionary *)types Selector:(int)selector Order:(NSArray *)order
{
    if ([types count] != [order count])
    {
        // exception
    }
    int sampleCount = (int)[[[input allValues] objectAtIndex:0] count];
    if (sampleCount == 0) return nil;
    YCMatrix *convertedMatrix = [YCMatrix matrixOfRows:0 Columns:sampleCount];
    for (NSString *label in order)
    {
        if ([[types objectForKey:label] doubleValue] != selector) continue;
        YCMatrix *rowMatrix = [YCMatrix matrixOfRows:1 Columns:sampleCount];
        int iter = 0;
        for (NSNumber *val in [input objectForKey:label])
        {
            [rowMatrix setValue:[val doubleValue] Row:0 Column:iter++];
        }
        convertedMatrix = [convertedMatrix appendRow:rowMatrix];
    }
    return convertedMatrix;
}
+ (NSMutableDictionary *)generateDatasetFromInput:(YCMatrix *)input Output:(YCMatrix *)output Types:(NSDictionary *)types Order:(NSArray *)order
{
    if (input->rows != output->rows)
    {
        // exception
    }
    int sampleCount = input->columns;
    NSMutableDictionary *convertedDictionary = [NSMutableDictionary dictionary];
    int inputIter = 0;
    int outputIter = 0;
    for (NSString *label in order)
    {
        NSMutableArray *featureSamples = [NSMutableArray array];
        YCMatrix *selectedMatrix;
        int iter;
        if ([[types objectForKey:label] doubleValue] == 0)
        {
            selectedMatrix = input;
            iter = inputIter++;
        }
        else
        {
            selectedMatrix = output;
            iter = outputIter++;
        }
        for (int i=0; i<sampleCount; i++)
        {
            double value = [selectedMatrix getValueAtRow:iter Column:i];
            [featureSamples addObject:[NSNumber numberWithDouble:value]];
        }
        [convertedDictionary setValue:featureSamples forKey:label];
    }
    return convertedDictionary;
}

@end
