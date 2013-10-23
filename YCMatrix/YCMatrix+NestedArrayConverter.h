//
//  YCMatrix+NestedArrayConverter.h
//  YCogni
//
//  Created by Yan Const on 19/7/13.
//  Copyright (c) 2013 Ioannis Chatzikonstantinou. All rights reserved.
//

#import <YCMatrix/YCMatrix.h>
#import <YCMatrix/YCMatrix+Manipulate.h>


@interface YCMatrix (NestedDictionaryConverter)

+ (YCMatrix *)convertToMatrix:(NSDictionary *)input Types:(NSDictionary *)types Selector:(int)selector Order:(NSArray *)order;
+ (NSMutableDictionary *)generateDatasetFromInput:(YCMatrix *)input Output:(YCMatrix *)output Types:(NSDictionary *)types Order:(NSArray *)order;

@end
