//
//  Matrix.h
//  Matrix
//
//  Created by Yan Const on 11/7/13.
//  Copyright (c) 2013, 2014 Ioannis Chatzikonstantinou. All rights reserved.
//

#import "YCMatrix.h"

@interface YCMatrix (Manipulate)

// Returns a new YCMatrix from an array of rows
+ (YCMatrix *)matrixFromRows:(NSArray *)rows;

// Returns a new YCMatrix from an array of columns
+ (YCMatrix *)matrixFromColumns:(NSArray *)columns;

// Returns a new YCMatrix from the elements of row |rowNumber|
- (YCMatrix *)getRow:(int)rowNumber;

// Sets row |rowNumber| to value |rowValue|
- (void)setRow:(int) rowNumber Value:(YCMatrix *)rowValue;

// Returns an NSArray of YCMatrix objects representing rows
- (NSArray *)RowsAsNSArray;

// Returns a new YCMatrix from the elements of column |colNumber|
- (YCMatrix *)getColumn:(int)colNumber;

// Sets column |colNumber| to value |columnValue|
- (void)setColumn:(int) colNumber Value:(YCMatrix *)columnValue;

// Returns an NSArray of YCMatrix objects representing columns
- (NSArray *)ColumnsAsNSArray;

// Adds the values in |addend| to all rows
- (YCMatrix *)addRowToAllRows:(YCMatrix *)addend;

// Subtracts the values in |subtrahend| from all rows
- (YCMatrix *)subtractRowFromAllRows:(YCMatrix *)subtrahend;

// Multiplies element-wise all rows with the values in |factor|
- (YCMatrix *)multiplyAllRowsWithRow:(YCMatrix *)factor;

// Adds the values in |addend| to all columns
- (YCMatrix *)addColumnToAllColumns:(YCMatrix *)addend;

// Subtracts the values in |subtrahend| from all columns
- (YCMatrix *)subtractColumnFromAllColumns:(YCMatrix *)subtrahend;

// Multiplies element-wise all columns with the values in |factor|
- (YCMatrix *)multiplyAllColumnsWithColumn:(YCMatrix *)factor;

// Returns a new YCMatrix with the columns specified in |range|
- (YCMatrix *)matrixWithColumnsInRange:(NSRange)range;

// Returns a new YCMatrix with the rows specified in |range|
- (YCMatrix *)matrixWithRowsInRange:(NSRange)range;

// Appends |row|
- (YCMatrix *)appendRow:(YCMatrix *)row;

// Appends |column|
- (YCMatrix *)appendColumn:(YCMatrix *)column;

// Removes row at |rowIndex|
- (YCMatrix *)removeRow:(int)rowIndex;

// Removes row at |columnIndex|
- (YCMatrix *)removeColumn:(int)columnIndex;

// Creates a 1xn YCMatrix with values equal to |value| and appends it
- (YCMatrix *)appendValueAsRow:(double)value;

// Returns a new YCMatrix with shuffled rows
- (YCMatrix *)newFromShufflingRows;

// Shuffles rows in-place
- (void)shuffleRows;

// Returns a new YCMatrix with shuffled columns
- (YCMatrix *)newFromShufflingColumns;

// Shuffles columns in-place
- (void)shuffleColumns;

// Returns a new YCMatrix by sampling |sampleCount| rows. If |replacement| is YES, it does
// so using replacement
- (YCMatrix *)matrixBySamplingRows:(NSUInteger)sampleCount Replacement:(BOOL)replacement;

// Returns a new YCMatrix by sampling |sampleCount| columns. If |replacement| is YES, it does
// so using replacement
- (YCMatrix *)matrixBySamplingColumns:(NSUInteger)sampleCount Replacement:(BOOL)replacement;

@end
