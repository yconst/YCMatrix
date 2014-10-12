//
// YCMatrix+Manipulate.h
//
// YCMatrix
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

#import "YCMatrix.h"

@interface YCMatrix (Manipulate)

/**
 Initializes and returns a new YCMatrix from an NSArray of row matrices.
 
 @param rows The NSArray containing row YCMatrix objects.
 
 @return A new YCMatrix resulting from merging the rows.
 */
+ (YCMatrix *)matrixFromRows:(NSArray *)rows;

/**
 Initializes and returns a new YCMatrix from an NSArray of column matrices.
 
 @param rows The NSArray containing column YCMatrix objects.
 
 @return A new YCMatrix resulting from merging the column.
 */
+ (YCMatrix *)matrixFromColumns:(NSArray *)columns;

/**
 Returns a row matrix with the contents of row |rowNumber|.
 
 @param rowNumber The index of the row to copy.
 
 @return The row YCMatrix.
 */
- (YCMatrix *)getRow:(int)rowIndex;

/**
 Replaces the values of row |rowIndex| with those of row matrix |rowValue|
 
 @param rowIndex The index of the row to replace.
 @param rowValue The values to replace with.
 */
- (void)setRow:(int)rowIndex Value:(YCMatrix *)rowValue;

/**
 Returns an NSArray of row matrices, each representing one row of the receiver.
 
 @return The NSArray of row matrices.
 */
- (NSArray *)RowsAsNSArray;

/**
 Returns the values of column |colIndex| as a column matrix.
 
 @param colIndex The index of the column
 
 @return The column matrix with the values of the column |colIndex|.
 */
- (YCMatrix *)getColumn:(int)colIndex;

/**
 Replaces values of column |colIndex| with those of column matrix |columnValue|
 
 @param colNumber   The index of the column to replace.
 @param columnValue The values to replace with.
 */
- (void)setColumn:(int)colNumber Value:(YCMatrix *)columnValue;

/**
 Creates column matrices from the columns of the matrix and returns them as an NSArray.
 
 @return The NSArray containing the columns of the receiver.
 */
- (NSArray *)ColumnsAsNSArray;

/**
 Returns a matrix resulting from adding the values in the 
 row matrix |addend| to every row.
 
 @param addend The row matrix whose values to add.
 
 @return The matrix after the addition.
 */
- (YCMatrix *)addRowToAllRows:(YCMatrix *)addend;

/**
 Returns a matrix resulting from subtracting the values in 
 row matrix |subtrahend| from every row.
 
 @param subtrahend The row matrix whose values to subtract.
 
 @return The matrix after the subtraction.
 */
- (YCMatrix *)subtractRowFromAllRows:(YCMatrix *)subtrahend;

/**
 Returns a matrix resulting from multiplying the values in 
 row matrix |factor| with every row.
 
 @param factor The row matrix whose values to multiply with.
 
 @return The matrix after the multiplication
 */
- (YCMatrix *)multiplyAllRowsWithRow:(YCMatrix *)factor;

/**
 Returns a matrix resulting from adding the values in the 
 column matrix |addend| to every column.
 
 @param addend The column matrix whose values to add.
 
 @return The matrix after the addition.
 */
- (YCMatrix *)addColumnToAllColumns:(YCMatrix *)addend;

/**
 Returns a matrix resulting from subtracting the values in 
 column matrix |subtrahend| from every column.
 
 @param subtrahend The rocolumnw matrix whose values to subtract.
 
 @return The matrix after the subtraction.
 */
- (YCMatrix *)subtractColumnFromAllColumns:(YCMatrix *)subtrahend;

/**
 Returns a matrix resulting from multiplying the values in 
 column matrix |factor| with every column.
 
 @param factor The column matrix whose values to multiply with.
 
 @return The matrix after the multiplication
 */
- (YCMatrix *)multiplyAllColumnsWithColumn:(YCMatrix *)factor;

/**
 Returns a new matrix with the values of the columns 
 whose indices are in |range|.
 
 @param range The range of indices of columns to include.
 
 @return The matrix of columns in |range|.
 */
- (YCMatrix *)matrixWithColumnsInRange:(NSRange)range;

/**
 Returns a new matrix with the values of the rows 
 whose indices are in |range|.
 
 @param range The range of indices of rows to include.
 
 @return The matrix of rows in |range|.
 */
- (YCMatrix *)matrixWithRowsInRange:(NSRange)range;

/**
 Returns a new matrix by appending row matrix |row|.
 
 @param row The row matrix to append.
 
 @return The result of appending.
 */
- (YCMatrix *)appendRow:(YCMatrix *)row;

/**
 Returns a new matrix by appending column matrix |column|.
 
 @param column The column matrix to append.
 
 @return The result of appending.
 */
- (YCMatrix *)appendColumn:(YCMatrix *)column;

/**
 Returns a new matrix that is the result of removing 
 the row at |rowIndex|.
 
 @param rowIndex The index of the row to remove.
 
 @return The matrix missing the removed row.
 */
- (YCMatrix *)removeRow:(int)rowIndex;

/**
 Returns a new matrix that is the result of removing 
 the column at |columnIndex|.
 
 @param columnIndex The index of the column to remove.
 
 @return The matrix missing the removed column.
 */
- (YCMatrix *)removeColumn:(int)columnIndex;

/**
 Returns a matrix resulting from appending a row with values |value|
 
 @param value The value of the row matrix to append.
 
 @return The matrix after appending.
 */
- (YCMatrix *)appendValueAsRow:(double)value;

/**
 Returns a matrix with shuffled rows
 
 @return The matrix after shuffling rows.
 */
- (YCMatrix *)newFromShufflingRows;

/**
 Shuffles the rows of the receiver.
 */
- (void)shuffleRows;

/**
 Returns a matrix with shuffled columns.
 
 @return The matrix after shuffling columns.
 */
- (YCMatrix *)newFromShufflingColumns;

/**
 Shuffles the columns of the receiver.
 */
- (void)shuffleColumns;

/**
 Returns a matrix resulting from uniform random sampling of |sampleCount| 
 rows, optionally with |replacement|.
 
 @param sampleCount The number of rows to sample.
 @param replacement Whether to use replacement in sampling.
 
 @return The matrix resulting from the sampling.
 */
- (YCMatrix *)matrixBySamplingRows:(NSUInteger)sampleCount Replacement:(BOOL)replacement;

/**
 Returns a matrix resulting from uniform random sampling of |sampleCount|
 columns, optionally with |replacement|.
 
 @param sampleCount The number of columns to sample.
 @param replacement Whether to use replacement in sampling.
 
 @return The matrix resulting from the sampling.
 */
- (YCMatrix *)matrixBySamplingColumns:(NSUInteger)sampleCount Replacement:(BOOL)replacement;

@end
