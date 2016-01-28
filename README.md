
<img src="https://raw.githubusercontent.com/yconst/YCMatrix/master/ycmatrix.png" alt="YCMatrix" style="max-width: 64px; max-height: 64px;"/>

#YCMatrix

[![Build Status](https://travis-ci.org/yconst/YCMatrix.svg?branch=master)](https://travis-ci.org/yconst/YCMatrix)
[![DOI](https://zenodo.org/badge/20003/yconst/YCMatrix.svg)](https://zenodo.org/badge/latestdoi/20003/yconst/YCMatrix)

A flexible Matrix library for Objective-C and Swift, that interfaces 
BLAS, LAPACK and vDSP functions via the Accelerate Framework.

YCMatrix is available for OS X (10.7+), as well as iOS (8.0+).

##Getting started

### Adding the framework to your project

Import the project in your workspace, or open the framework project in XCode, build and import the product.

.. or alternatively, just drag+drop the files (.h and .m) that you want to your project, presto.

### Importing

YCMatrix defines a module so in newer versions of XCode, 
 you can simply import the framework with:

    @include YCMatrix;

Alternatively, you can do:

    #import "YCMatrix/YCMatrix.h"

### Dependencies

YCMatrix has no dependencies other than system 
frameworks (namely Foundation.framework and Accelerate.framework). 

### Importing/Using with CocoaPods

Installation using Cocoapods is no longer the recommended way for using YCMatrix, but it is still a perfectly viable option.
There is an [official guide to using CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html). 
YCMatrix may be easily added as a project dependency by following 
the guide.

#### Podfile

```ruby
platform :osx, '10.7'
pod "YCMatrix"
```

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
    
##What's in there?

The Framework functionality is split into four files: The base class
definition, and three categories:

- Matrix.h                : YCMatrix class definition and basic operations.
- Matrix+Advanced.h       : Interface to more advanced LAPACK functions.
- Matrix+Manipulate.h     : Functions for manipulating rows/columns etc.
- Matrix+Map.h            : Functions for linearly mapping matrices.

In addition, there is a file that implements functionality related to NSArrays containing Matrices.

Please refer to the [docs](http://cocoadocs.org/docsets/YCMatrix/) for a complete overview of the functionality 
contained in each of the categories.

In addition, YCMatrix comes with many unit tests included. Tests are divided in six files:

- YCMatrixTests           : General Matrix-related tests.
- YCMatrixAdvancedTests   : Tests related to higher-level operations (decompositions, inverses etc.).
- YCMatrixManipulateTests : Tests related to matrix manipulation operations.
- YCMatrixMapTests        : Tests related to linear mapping operations.
- YCMatrixNSArrayTests    : Tests related to NSArray categories.
- YCMatrixPerformanceTests: Tests for measuring performance of various operations.

##License

__YCMatrix__

Copyright (c) 2013 - 2016 Ioannis (Yannis) Chatzikonstantinou. All rights reserved.
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

##Acknowledgments

This software relies on the following copyrighted material, the use of which is hereby acknowledged.

----

soboldata.h and sobolseq.c
Part of the NLOpt Software

Copyright (c) 2007 Massachusetts Institute of Technology

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 

----

haltondata.cpp

Copyright (c) 2012 Leonhard Gruenschloss (leonhard@gruenschloss.org)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

----

Routine for computing the Singular Value Decomposition 
of *column-major* matrix A using LAPACK 

Author:  Luke Lonergan
Date:    5/31/08
License: Use pfreely

