//
// YCMatrix+Manipulate.m
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

#import "YCMatrix+Manipulate.h"
#import "Constants.h"

@implementation YCMatrix (Manipulate)

+ (YCMatrix *)matrixFromRows:(NSArray *)rows
{
    NSUInteger rowCount = [rows count];
    if (rowCount == 0) return [YCMatrix matrixOfRows:0 Columns:0];
    YCMatrix *firstRow = rows[0];
    int columnCount = firstRow->columns;
    YCMatrix *ret = [YCMatrix matrixOfRows:(int)rowCount Columns:(int)columnCount];
    for (int i=0; i<rowCount; i++)
    {
        YCMatrix *currentRow = rows[i];
        for (int j=0; j<columnCount; j++)
        {
            [ret setValue:currentRow->matrix[j] Row:i Column:j];
        }
    }
    return ret;
}

+ (YCMatrix *)matrixFromColumns:(NSArray *)columns
{
    NSUInteger columnCount = [columns count];
    if (columnCount == 0) return [YCMatrix matrixOfRows:0 Columns:0];
    YCMatrix *firstCol = columns[0];
    int rowCount = firstCol->rows;
    YCMatrix *ret = [YCMatrix matrixOfRows:(int)rowCount Columns:(int)columnCount];
    for (int i=0; i<columnCount; i++)
    {
        YCMatrix *currentCol = columns[i];
        for (int j=0; j<rowCount; j++)
        {
            [ret setValue:currentCol->matrix[j] Row:j Column:i];
        }
    }
    return ret;
}

- (YCMatrix *)getRow:(int) rowIndex
{
    if (rowIndex > self->rows - 1)
    {
        @throw [NSException exceptionWithName:@"IndexOutOfBoundsException"
                                       reason:@"Row index input is out of bounds."
                                     userInfo:nil];
    }
    // http://stackoverflow.com/questions/5850000/how-to-split-array-into-two-arrays-in-c
    int startIndex = rowIndex * self->columns;
    YCMatrix *rowmatrix = [YCMatrix matrixOfRows:1 Columns:self->columns];
    double *row = rowmatrix->matrix;
    memcpy(row, self->matrix + startIndex, self->columns * sizeof(double));
    return rowmatrix;
}

- (void)setRow:(int)rowIndex Value:(YCMatrix *)rowValue
{
    if (rowIndex > self->rows - 1)
    {
        @throw [NSException exceptionWithName:@"IndexOutOfBoundsException"
                                       reason:@"Row index input is out of bounds."
                                     userInfo:nil];
    }
    if (rowValue->rows != 1 || rowValue->columns != columns)
    {
        @throw [NSException exceptionWithName:@"MatrixSizeException"
                                       reason:@"Matrix size mismatch."
                                     userInfo:nil];
    }
    memcpy(self->matrix + columns * rowIndex, rowValue->matrix, columns * sizeof(double));
}

- (NSArray *)RowsAsNSArray
{
    NSMutableArray *rowsArray = [NSMutableArray arrayWithCapacity:rows];
    for (int i=0; i<rows; i++)
    {
        [rowsArray addObject: [self getRow:i]];
    }
    return rowsArray;
}

- (YCMatrix *)getColumn:(int) colIndex
{
    if (colIndex > self->columns - 1)
    {
        @throw [NSException exceptionWithName:@"IndexOutOfBoundsException"
                                       reason:@"Column index input is out of bounds."
                                     userInfo:nil];
    }
    YCMatrix *columnmatrix = [YCMatrix matrixOfRows:self->rows Columns:1];
    double *column = columnmatrix->matrix;
    for (int i=0; i<self->rows; i++)
    {
        column[i] = self->matrix[i*self->columns + colIndex];
    }
    return columnmatrix;
}

- (void)setColumn:(int)colNumber Value:(YCMatrix *)columnValue
{
    if (colNumber > self->columns - 1)
    {
        @throw [NSException exceptionWithName:@"IndexOutOfBoundsException"
                                       reason:@"Column index input is out of bounds."
                                     userInfo:nil];
    }
    if (columnValue->columns != 1 || columnValue->rows != rows)
    {
        @throw [NSException exceptionWithName:@"MatrixSizeException"
                                       reason:@"Matrix size mismatch."
                                     userInfo:nil];
    }
    for (int i=0; i<rows; i++)
    {
        self->matrix[columns*i + colNumber] = columnValue->matrix[i];
    }
}

- (NSArray *)ColumnsAsNSArray // needs some speed improvement
{
    NSMutableArray *columnsArray = [NSMutableArray arrayWithCapacity:columns];
    for (int i=0; i<columns; i++)
    {
        [columnsArray addObject: [self getColumn:i]];
    }
    return columnsArray;
}

- (YCMatrix *)addRowToAllRows:(YCMatrix *)addend
{
    if (addend->rows != 1 || addend->columns != self->columns)
    {
        @throw [NSException exceptionWithName:@"MatrixSizeException"
                                       reason:@"Matrix size mismatch."
                                     userInfo:nil];
    }
    YCMatrix *sum = [YCMatrix matrixFromMatrix:self];
    double *sumarray = sum->matrix;
    double *addendarray = addend->matrix;
    int cols = self->columns;
    int rws = self->rows;
    for (int i=0; i<rws; i++)
    {
        for (int j=0; j<cols; j++)
        {
            sumarray[i*cols + j] += addendarray[j]; //j!
        }
    }
    return sum;
}

- (YCMatrix *)subtractRowFromAllRows:(YCMatrix *)subtrahend
{
    return [self addRowToAllRows:[subtrahend matrixByNegating]];
}

- (YCMatrix *)multiplyAllRowsWithRow:(YCMatrix *)factor{
    if (factor->rows != 1 || factor->columns != self->columns)
    {
        @throw [NSException exceptionWithName:@"MatrixSizeException"
                                       reason:@"Matrix size mismatch."
                                     userInfo:nil];
    }
    YCMatrix *product = [YCMatrix matrixFromMatrix:self];
    double *productarray = product->matrix;
    double *factorarray = factor->matrix;
    int cols = self->columns;
    int rws = self->rows;
    for (int i=0; i<rws; i++)
    {
        for (int j=0; j<cols; j++)
        {
            productarray[i*cols + j] *= factorarray[j]; //j!
        }
    }
    return product;
}

- (YCMatrix *)addColumnToAllColumns:(YCMatrix *)addend
{
    if (addend->columns != 1 || addend->rows != self->rows)
    {
        @throw [NSException exceptionWithName:@"MatrixSizeException"
                                       reason:@"Matrix size mismatch."
                                     userInfo:nil];
    }
    YCMatrix *sum = [YCMatrix matrixFromMatrix:self];
    double *sumarray = sum->matrix;
    double *addendarray = addend->matrix;
    int cols = self->columns;
    int rws = self->rows;
    for (int i=0; i<rws; i++)
    {
        for (int j=0; j<cols; j++)
        {
            sumarray[i*cols + j] += addendarray[i]; //i!
        }
    }
    return sum;
}

- (YCMatrix *)subtractColumnFromAllColumns:(YCMatrix *)subtrahend
{
    return [self addColumnToAllColumns:[subtrahend matrixByNegating]];
}

- (YCMatrix *)multiplyAllColumnsWithColumn:(YCMatrix *)factor
{
    if (factor->columns != 1 || factor->rows != self->rows)
    {
        @throw [NSException exceptionWithName:@"MatrixSizeException"
                                       reason:@"Matrix size mismatch."
                                     userInfo:nil];
    }
    YCMatrix *product = [YCMatrix matrixFromMatrix:self];
    double *productarray = product->matrix;
    double *factorarray = factor->matrix;
    int cols = self->columns;
    int rws = self->rows;
    for (int i=0; i<rws; i++)
    {
        for (int j=0; j<cols; j++)
        {
            productarray[i*cols + j] *= factorarray[i]; //i!
        }
    }
    return product;
}

- (YCMatrix *)matrixWithRowsInRange:(NSRange)range
{
    if (range.location + range.length > self->rows)
    {
        @throw [NSException exceptionWithName:@"MatrixSizeException"
                                       reason:@"Range outside matrix."
                                     userInfo:nil];
    }
    int valueOffset = (int)range.location * self->columns;
    int valueCount = (int)range.length * self->columns;
    
    YCMatrix *newMatrix = [YCMatrix matrixOfRows:(int)range.length Columns:self->columns];
    memcpy(newMatrix->matrix, self->matrix+valueOffset, valueCount * sizeof(double));
    
    return newMatrix;
}

- (YCMatrix *)matrixWithColumnsInRange:(NSRange)range
{
    if (range.location + range.length > self->columns)
    {
        @throw [NSException exceptionWithName:@"MatrixSizeException"
                                       reason:@"Range outside matrix."
                                     userInfo:nil];
    }
    int rowOffset = (int)range.location;
    int rowLength = (int)range.length;
    
    YCMatrix *newMatrix = [YCMatrix matrixOfRows:self->rows Columns:rowLength];
    
    for (int i=0; i<self->rows; i++)
    {
        memcpy(newMatrix->matrix + i*rowLength,
               self->matrix + rowOffset + i*self->columns,
               rowLength * sizeof(double));
    }
    return newMatrix;
}

- (YCMatrix *)appendRow:(YCMatrix *)newRow
{
    if (newRow->rows != 1 || newRow->columns != columns)
    {
        @throw [NSException exceptionWithName:@"MatrixSizeException"
                                       reason:@"Matrix size mismatch."
                                     userInfo:nil];
    }
    double *newMatrix = malloc(columns * (rows + 1) * sizeof(double));
    memcpy(newMatrix, self->matrix, columns * rows * sizeof(double));
    memcpy(newMatrix + columns*rows, newRow->matrix, columns * sizeof(double));
    return [YCMatrix matrixFromArray:newMatrix Rows:rows + 1 Columns:columns Mode:YCMStrong];
}

- (YCMatrix *)appendColumn:(YCMatrix *)newColumn
{
    if (newColumn->columns != 1 || newColumn->rows != rows)
    {
        @throw [NSException exceptionWithName:@"MatrixSizeException"
                                       reason:@"Matrix size mismatch."
                                     userInfo:nil];
    }
    double *newMatrix = malloc((columns + 1) * rows * sizeof(double));
    int newCols = columns + 1;
    for (int i=0; i < rows; i++)
    {
        memcpy(newMatrix + newCols * i, self->matrix + columns * i, columns * sizeof(double));
        newMatrix[newCols * i + columns] = newColumn->matrix[i];
    }
    return [YCMatrix matrixFromArray:newMatrix Rows:rows Columns:columns + 1 Mode:YCMStrong];
}

- (YCMatrix *)removeRow:(int)rowNumber
{
    double newRows = rows - 1;
    if (rowNumber > newRows)
    {
        @throw [NSException exceptionWithName:@"IndexOutOfBoundsException"
                                       reason:@"Row index input is out of bounds."
                                     userInfo:nil];
    }
    double *newMatrix = malloc(columns * newRows * sizeof(double));
    for (int i=0; i < newRows; i++) // should count to one-less than rows, so newRows
    {
        int idx = i >= rowNumber ? i+1 : i;
        memcpy(newMatrix + columns * i, self->matrix + columns * idx, columns * sizeof(double));
    }
    return [YCMatrix matrixFromArray:newMatrix Rows:newRows Columns:columns];
}

- (YCMatrix *)removeColumn:(int)columnNumber
{
    if (columnNumber > self->columns - 1)
    {
        @throw [NSException exceptionWithName:@"IndexOutOfBoundsException"
                                       reason:@"Column index input is out of bounds."
                                     userInfo:nil];
    }
    double newCols = columns - 1;
    double *newMatrix = malloc(newCols * rows * sizeof(double));
    for (int i=0; i < rows; i++)
    {
        memcpy(newMatrix, self->matrix, columnNumber * sizeof(double));
        memcpy(newMatrix + columnNumber, self->matrix + columnNumber + 1, (newCols - columnNumber) * sizeof(double));
    }
    return [YCMatrix matrixFromArray:newMatrix Rows:rows Columns:newCols];
}

- (YCMatrix *)appendValueAsRow:(double)value
{
    if(columns != 1)
        @throw [NSException exceptionWithName:@"MatrixSizeException"
                                       reason:@"appendValueAsRow can only be performed on vectors."
                                     userInfo:nil];
    int newRows = rows + 1;
    double *newArray = malloc(columns * newRows * sizeof(double));
    memcpy(newArray, matrix, columns * rows * sizeof(double));
    newArray[columns * newRows - 1] = value;
    return [YCMatrix matrixFromArray:newArray Rows:newRows Columns:columns];
}

// Fisher-Yates Inside-out Shuffle (UNTESTED!)
- (YCMatrix *)newFromShufflingRows
{
    YCMatrix *ret = [YCMatrix matrixFromMatrix:self];
    int rowCount = self->rows;
    int colCount = self->columns;
    for (int i=0; i<rowCount; i++)
    {
        int o = arc4random_uniform((int)i);
        if (o == i) continue;
        for (int j=0; j<colCount; j++)
        {
            ret->matrix[i*rowCount + j] = ret->matrix[o*rowCount + j];
            ret->matrix[o*rowCount + j] = self->matrix[o*rowCount + j];
        }
    }
    return ret;
}

// Fisher-Yates Shuffle (UNTESTED!)
- (void)shuffleRows
{
    int rowCount = self->rows;
    int colCount = self->columns;
    double tmp;
    for (int i = rowCount - 1; i>=0; --i)
    {
        int o = arc4random_uniform((int)i);
        for (int j=0; j<colCount; j++)
        {
            tmp = self->matrix[i*rowCount + j];
            self->matrix[i*rowCount + j] = self->matrix[o*rowCount + j];
            self->matrix[o*rowCount + j] = tmp;
        }
    }
}

// Fisher-Yates Inside-out Shuffle (UNTESTED!)
- (YCMatrix *)newFromShufflingColumns
{
    YCMatrix *ret = [YCMatrix matrixFromMatrix:self];
    int rowCount = self->rows;
    int colCount = self->columns;
    for (int i=0; i<colCount; i++)
    {
        int o = arc4random_uniform((int)i);
        for (int j=0; j<colCount; j++)
        {
            ret->matrix[j*rowCount + i] = ret->matrix[j*rowCount + o];
            ret->matrix[j*rowCount + o] = self->matrix[j*rowCount + o];
        }
    }
    return ret;
}

// Fisher-Yates Shuffle (UNTESTED!)
- (void)shuffleColumns
{
    int rowCount = self->rows;
    int colCount = self->columns;
    double tmp;
    for (int i = colCount - 1; i>=0; --i)
    {
        int o = arc4random_uniform((int)i);
        for (int j=0; j<rowCount; j++)
        {
            tmp = self->matrix[j*rowCount + i];
            self->matrix[j*rowCount + i] = self->matrix[j*rowCount + o];
            self->matrix[j*rowCount + o] = tmp;
        }
    }
}

- (YCMatrix *)sumsOfRows
{
    YCMatrix *result = [YCMatrix matrixOfRows:self->rows Columns:1];
    for (int i=0; i<self->rows; i++)
    {
        double sum = 0;
        for (int j=0; j<self->columns; j++)
        {
            sum += self->matrix[i*self->columns + j];
        }
        result->matrix[i] = sum;
    }
    return result;
}

- (YCMatrix *)sumsOfColumns
{
    YCMatrix *result = [YCMatrix matrixOfRows:1 Columns:self->columns];
    for (int i=0; i<self->columns; i++)
    {
        double sum = 0;
        for (int j=0; j<self->rows; j++)
        {
            sum += self->matrix[j*self->columns + i];
        }
        result->matrix[i] = sum;
    }
    return result;
}

// Returns a new YCMatrix by sampling |sampleCount| rows. If |replacement| is YES, it does
// so using replacement
- (YCMatrix *)matrixBySamplingRows:(NSUInteger)sampleCount Replacement:(BOOL)replacement
{
    int rowSize = self->rows;
    int colSize = self->columns;
    int colMemory = colSize * sizeof(double);
    YCMatrix *new = [YCMatrix matrixOfRows:(int)sampleCount Columns:(int)colSize];
    if (replacement)
    {
        for (int i=0; i<sampleCount; i++)
        {
            int rnd = arc4random_uniform((int)self->rows);
            memcpy(new->matrix + i * colMemory, new->matrix + rnd * colMemory, colSize);
        }
    }
    else
    {
        NSUInteger toGo = sampleCount;
        for (int i=0; i<rowSize; i++)
        {
            int rnd = arc4random_uniform((int)rowSize);
            if (rnd < toGo)
            {
                toGo--;
                memcpy(new->matrix + toGo * colMemory, new->matrix + i * colMemory, colSize);
            }
        }
    }
    return new;
}

// Returns a new YCMatrix by sampling |sampleCount| columns. If |replacement| is YES, it does
// so using replacement
- (YCMatrix *)matrixBySamplingColumns:(NSUInteger)sampleCount Replacement:(BOOL)replacement
{
    int rowSize = self->rows;
    int colSize = self->columns;
    int colMemory = colSize * sizeof(double);
    YCMatrix *new = [YCMatrix matrixOfRows:(int)rowSize Columns:(int)sampleCount];
    if (replacement)
    {
        for (int i=0; i<sampleCount; i++)
        {
            //long rnd = arc4random_uniform((int)self->rows);
            // copy column
        }
    }
    else
    {
        NSUInteger toGo = sampleCount;
        for (int i=0; i<colSize; i++)
        {
            int rnd = arc4random_uniform((int)colSize);
            if (rnd < toGo)
            {
                toGo--;
                // copy column
            }
        }
    }
    return new;
}

@end
