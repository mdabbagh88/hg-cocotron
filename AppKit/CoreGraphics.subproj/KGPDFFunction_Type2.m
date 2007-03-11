/* Copyright (c) 2007 Christopher J. W. Lloyd

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */

// Original - Christopher Lloyd <cjwl@objc.net>
#import "KGPDFFunction_Type2.h"
#import "KGPDFArray.h"
#import <Foundation/NSString.h>
#import <stddef.h>
#import <math.h>

@implementation KGPDFFunction_Type2

-initWithDomain:(KGPDFArray *)domain range:(KGPDFArray *)range C0:(KGPDFArray *)C0 C1:(KGPDFArray *)C1 N:(KGPDFReal)N {
   if([super initWithDomain:domain range:range]==nil)
    return nil;
    
   [C0 getNumbers:&_C0 count:&_C0Count];
   [C1 getNumbers:&_C1 count:&_C1Count];
   if(_C0Count!=_C1Count){
    NSLog(@"_C0Count(%d)!=_C1Count(%d)",_C0Count,_C1Count);
    [self dealloc];
    return nil;
   }
   
   _N=N;

   if(_rangeCount==0){
    int i;
    
    _rangeCount=_C0Count*2;
    if(_range!=NULL)
     NSZoneFree(NULL,_range);
     
    _range=NSZoneMalloc(NULL,sizeof(float)*_rangeCount);
    for(i=0;i<_rangeCount/2;i++){
     _range[i*2]=0;
     _range[i*2+1]=1;
    }
   }
   
   return self;
}

-(void)dealloc {
   if(_C0!=NULL)
    NSZoneFree(NULL,_C0);
   if(_C1!=NULL)
    NSZoneFree(NULL,_C1);
    
   [super dealloc];
}

-(void)evaluateInput:(float)x output:(float *)output {
   int j;
   
   if(_N==1.0){
    for(j=0;j<_C0Count;j++){
     output[j]=_C0[j]+x*(_C1[j]-_C0[j]);
    }
   }
   else {
    for(j=0;j<_C0Count;j++){
     output[j]=_C0[j]+pow(x,_N)*(_C1[j]-_C0[j]);
    }
   }
}

@end