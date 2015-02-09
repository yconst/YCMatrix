
<img src="https://raw.githubusercontent.com/yconst/YCMatrix/master/ycmatrix.png" alt="YCMatrix" style="width: 128px; height: 128px;"/>

#YCMatrix

[![Build Status](https://travis-ci.org/yconst/YCMatrix.svg?branch=master)](https://travis-ci.org/yconst/YCMatrix)

A flexible Matrix library for Objective-C, which interfaces 
BLAS, LAPACK and vDSP functions via the Accelerate Framework.

##Installation

It is recommended to install YCMatrix using [Cocoapods](http://cocoapods.org/).

#### Podfile

```ruby
platform :osx, '10.7'
pod "YCMatrix"
```

##Getting started

Import the project in your workspace, or compile the framework
and import. YCMatrix has no dependencies other than system 
frameworks.

##Example Usage

    #include "YCMatrix/YCMatrix.h"
    
    YCMatrix *I = [YCMatrix identityOfRows:3 Columns:3];
    YCMatrix *C = [YCMatrix matrixOfRows:3 Columns:3 Value:2];
    YCMatrix *S = [I matrixByAddition:C];
    NSLog(@"Result:\n%@", S);
    
    // Result:
    // 3.0  2.0  2.0
    // 2.0  3.0  2.0
    // 2.0  2.0  3.0
    
##File Structure

The matrix functionality is split into three files: The base class
definition, and two categories:

- YCMatrix.h             : YCMatrix class definition and basic operations.
- YCMatrix+Advanced.h    : Interface to more advanced LAPACK functions.
- YCMatrix+Manipulate.h  : Functions for manipulating rows/columns etc.

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
