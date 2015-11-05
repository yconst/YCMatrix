
<img src="https://raw.githubusercontent.com/yconst/YCMatrix/master/ycmatrix.png" alt="YCMatrix" style="width: 64px; height: 64px;"/>

#YCMatrix

[![Build Status](https://travis-ci.org/yconst/YCMatrix.svg?branch=master)](https://travis-ci.org/yconst/YCMatrix)

A flexible Matrix library for Objective-C and Swift, that interfaces 
BLAS, LAPACK and vDSP functions via the Accelerate Framework.

YCMatrix is available for OS X (10.7+), as well as iOS (8.0+).

##Getting started

It is recommended to install YCMatrix using [Cocoapods](http://cocoapods.org/).

### Using CocoaPods

There is an [official guide to using CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html). 
YCMatrix may be easily added as a project dependency by following 
the guide.

#### Podfile

```ruby
platform :osx, '10.7'
pod "YCMatrix"
```

### Adding the framework manually

Import the project in your workspace, or open the framework project
in XCode, build and import the product.

### Importing

YCMatrix defines a module so in newer versions of XCode, 
 you can simply import the framework with:

    @include YCMatrix;

Alternatively, you can do:

    #import "YCMatrix/YCMatrix.h"

### Dependencies

YCMatrix has no dependencies other than system 
frameworks (namely Foundation.framework and Accelerate.framework). 

## Usage

### Naming Conventions

Methods that result in a new Matrix instance are usually prefixed with "matrixFrom",
e.g. -matrixFromSubtraction: . Methods that change the receiver in-place
do not have the prefix. In some cases, such as matrix-matrix multiplication,
the prefix is not included in the method name, even though it is obvious that
the result of the operation is a new Matrix instance.

### Example

The snippet below is a basic example of matrix multiplication. 
It also shows how you can easily create matrices with predefined 
values.

    @include YCMatrix;
    
    Matrix *I = [Matrix identityOfRows:3 columns:3]; // 3x3 Identity
    Matrix *C = [Matrix matrixOfRows:3 columns:3 value:2]; // 3x3 filled with 2s
    Matrix *S = [I matrixByAddition:C]; // Outputs a new matrix
    NSLog(@"Result:\n%@", S);
    
    // Result:
    // 3.0  2.0  2.0
    // 2.0  3.0  2.0
    // 2.0  2.0  3.0
    
##File Structure

The matrix functionality is split into three files: The base class
definition, and two categories:

- Matrix.h             : YCMatrix class definition and basic operations.
- Matrix+Advanced.h    : Interface to more advanced LAPACK functions.
- Matrix+Manipulate.h  : Functions for manipulating rows/columns etc.

Please refer to the [docs](http://cocoadocs.org/docsets/YCMatrix/) for a complete overview of the functionality 
contained in each of the categories.

##License

__YCMatrix__

Copyright (c) 2013 - 2015 Ioannis (Yannis) Chatzikonstantinou. All rights reserved.
http://yconst.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
