//
//  Matrix.h
//  Matrix
//
//  Created by Yan Const on 11/7/13.
//  Copyright (c) 2013 Ioannis Chatzikonstantinou. All rights reserved.
//

#import "YCMatrix.h"

@interface YCMatrix (Manipulate)

- (YCMatrix *)getRow:(int) rowNumber;
- (void)setRow:(int) rowNumber Value:(YCMatrix *) rowValue;
- (NSArray *)RowsAsNSArray;
- (YCMatrix *)getColumn:(int) colNumber;
- (void)setColumn:(int) colNumber Value:(YCMatrix *) columnValue;
- (NSArray *)ColumnsAsNSArray;
- (YCMatrix *)addRowToAllRows:(YCMatrix *) addend;
- (YCMatrix *)subtractRowFromAllRows:(YCMatrix *) subtrahend;
- (YCMatrix *)multiplyAllRowsWithRow:(YCMatrix *) factor;
- (YCMatrix *)addColumnToAllColumns:(YCMatrix *) addend;
- (YCMatrix *)subtractColumnFromAllColumns:(YCMatrix *) subtrahend;
- (YCMatrix *)multiplyAllColumnsWithColumn:(YCMatrix *) factor;
- (YCMatrix *)appendRow:(YCMatrix *) row;
- (YCMatrix *)appendColumn:(YCMatrix *) column;
- (YCMatrix *)removeRow:(int) rowNumber;
- (YCMatrix *)removeColumn:(int) columnNumber;
- (YCMatrix *)appendValueAsRow:(double) value;

@end
