/* Copyright (c) 2007 Christopher J. W. Lloyd

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */

#import "KGPDFArray.h"
#import "KGPDFObject_Real.h"
#import "KGPDFObject_Boolean.h"
#import "KGPDFObject_Integer.h"
#import "KGPDFContext.h"
#import <Foundation/NSString.h>
#import <stddef.h>

@implementation O2PDFArray

+(O2PDFArray *)pdfArray {
   return [[[self alloc] init] autorelease];
}

+(O2PDFArray *)pdfArrayWithRect:(CGRect)rect {
   O2PDFArray *result=[self pdfArray];
   
   [result addNumber:rect.origin.x];
   [result addNumber:rect.origin.y];
   [result addNumber:rect.size.width];
   [result addNumber:rect.size.height];
   
   return result;
}

+(O2PDFArray *)pdfArrayWithNumbers:(O2PDFReal *)values count:(unsigned)count {
   O2PDFArray *result=[self pdfArray];
   int         i;
   
   for(i=0;i<count;i++)
    [result addNumber:values[i]];
   
   return result;
}

+(O2PDFArray *)pdfArrayWithIntegers:(O2PDFInteger *)values count:(unsigned)count {
   O2PDFArray *result=[self pdfArray];
   int         i;
   
   for(i=0;i<count;i++)
    [result addInteger:values[i]];
   
   return result;
}


-init {
   _capacity=1;
   _count=0;
   _objects=NSZoneMalloc(NULL,sizeof(O2PDFObject *)*_capacity);
   return self;
}

-(void)dealloc {
   NSZoneFree(NULL,_objects);
   [super dealloc];
}

-(O2PDFObjectType)objectType { return kKGPDFObjectTypeArray; }

-(BOOL)checkForType:(O2PDFObjectType)type value:(void *)value {
   if(type!=kKGPDFObjectTypeArray)
    return NO;
   
   *((O2PDFArray **)value)=self;
   return YES;
}

-(unsigned)count { return _count; }

-(void)addObject:(O2PDFObject *)object {
   [object retain];

   _count++;
   if(_count>_capacity){
    _capacity=_count*2;
    _objects=NSZoneRealloc([self zone],_objects,sizeof(id)*_capacity);
   }
   _objects[_count-1]=object;
}

-(void)addNumber:(O2PDFReal)value {
   [self addObject:[O2PDFObject_Real pdfObjectWithReal:value]];
}

-(void)addInteger:(O2PDFInteger)value {
   [self addObject:[O2PDFObject_Integer pdfObjectWithInteger:value]];
}

-(void)addBoolean:(O2PDFBoolean)value {
   [self addObject:[O2PDFObject_Boolean pdfObjectWithBoolean:value]];
}

-(O2PDFObject *)objectAtIndex:(unsigned)index {
   if(index<_count)
    return _objects[index];
   else 
    return nil;
}

-(BOOL)getObjectAtIndex:(unsigned)index value:(O2PDFObject **)objectp {
   *objectp=[[self objectAtIndex:index] realObject];
   
   return YES;
}

-(BOOL)getNullAtIndex:(unsigned)index {
   O2PDFObject *object=[self objectAtIndex:index];
   
   return ([object objectType]==kKGPDFObjectTypeNull)?YES:NO;
}

-(BOOL)getBooleanAtIndex:(unsigned)index value:(O2PDFBoolean *)valuep {
   O2PDFObject *object=[self objectAtIndex:index];
   
   return [object checkForType:kKGPDFObjectTypeBoolean value:valuep];
}

-(BOOL)getIntegerAtIndex:(unsigned)index value:(O2PDFInteger *)valuep {
   O2PDFObject *object=[self objectAtIndex:index];
   
   return [object checkForType:kKGPDFObjectTypeInteger value:valuep];
}

-(BOOL)getNumberAtIndex:(unsigned)index value:(O2PDFReal *)valuep {
   O2PDFObject *object=[self objectAtIndex:index];
   
   return [object checkForType:kKGPDFObjectTypeReal value:valuep];
}

-(BOOL)getNameAtIndex:(unsigned)index value:(char **)namep {
   O2PDFObject *object=[self objectAtIndex:index];
   
   return [object checkForType:kKGPDFObjectTypeName value:namep];
}

-(BOOL)getStringAtIndex:(unsigned)index value:(O2PDFString **)stringp {
   O2PDFObject *object=[self objectAtIndex:index];
   
   return [object checkForType:kKGPDFObjectTypeString value:stringp];
}

-(BOOL)getArrayAtIndex:(unsigned)index value:(O2PDFArray **)arrayp {
   O2PDFObject *object=[self objectAtIndex:index];
   
   return [object checkForType:kKGPDFObjectTypeArray value:arrayp];
}

-(BOOL)getDictionaryAtIndex:(unsigned)index value:(O2PDFDictionary **)dictionaryp {
   O2PDFObject *object=[self objectAtIndex:index];
   
   return [object checkForType:kKGPDFObjectTypeDictionary value:dictionaryp];
}

-(BOOL)getStreamAtIndex:(unsigned)index value:(O2PDFStream **)streamp {
   O2PDFObject *object=[self objectAtIndex:index];
   
   return [object checkForType:kKGPDFObjectTypeStream value:streamp];
}

-(BOOL)getNumbers:(O2PDFReal **)numbersp count:(unsigned *)countp {
   unsigned   i,count=[self count];
   O2PDFReal *numbers;
   
   numbers=NSZoneMalloc(NULL,sizeof(O2PDFReal)*count);
   for(i=0;i<count;i++){
    if(![self getNumberAtIndex:i value:numbers+i]){
     NSZoneFree(NULL,numbers);
     *numbersp=NULL;
     *countp=0;
     return NO;
    }
   }
   
   *numbersp=numbers;
   *countp=count;
   return YES;
}


-(NSString *)description {
   NSMutableString *result=[NSMutableString string];
   int              i;
   
   [result appendString:@"[ \n"];
   for(i=0;i<_count;i++)
    [result appendFormat:@"%@ ",_objects[i]];
   [result appendString:@" ]\n"];
   return result;
}

-(void)encodeWithPDFContext:(O2PDFContext *)encoder {
   int i;
   
   [encoder appendString:@"[ "];
   for(i=0;i<_count;i++)
    [encoder encodePDFObject:_objects[i]];
   [encoder appendString:@"]\n"];
}

@end
