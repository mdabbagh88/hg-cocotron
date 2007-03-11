/* Copyright (c) 2006-2007 Christopher J. W. Lloyd

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */

#import <Foundation/Foundation.h>
#import <AppKit/CGAffineTransform.h>
#import <AppKit/CGFont.h>

@class KGContext,KGColor,KGPath,KGImage;

@interface KGRenderingContext : NSObject

-(NSSize)size;

-(KGContext *)graphicsContextWithSize:(NSSize)size;

-(void)beginPage;
-(void)endPage;
-(void)beginDocument;
-(void)endDocument;

-(void)scalePage:(float)scalex:(float)scaley;

-(void)selectFontWithName:(const char *)name pointSize:(float)pointSize antialias:(BOOL)antialias;

-(id)saveCopyOfDeviceState;
-(void)restoreDeviceState:(id)state;

-(void)clipInUserSpace:(CGAffineTransform)ctm rects:(const NSRect *)rect count:(unsigned)count;

-(void)fillInUserSpace:(CGAffineTransform)ctm rects:(const NSRect *)rects count:(unsigned)count color:(KGColor *)color;

-(void)strokeInUserSpace:(CGAffineTransform)ctm rect:(NSRect)rect width:(float)width color:(KGColor *)color;

-(void)copyBitsInUserSpace:(CGAffineTransform)ctm rect:(NSRect)rect toPoint:(NSPoint)point;

-(void)showInUserSpace:(CGAffineTransform)ctm text:(const char *)text count:(unsigned)count atPoint:(float)x:(float)y color:(KGColor *)color;
-(void)showInUserSpace:(CGAffineTransform)ctm glyphs:(const CGGlyph *)glyphs count:(unsigned)count atPoint:(float)x:(float)y color:(KGColor *)color;

-(void)drawPathInDeviceSpace:(KGPath *)path drawingMode:(int)mode ctm:(CGAffineTransform)ctm lineWidth:(float)lineWidth fillColor:(KGColor *)fillColor strokeColor:(KGColor *)strokeColor;

-(void)drawImage:(KGImage *)image inRect:(NSRect)rect ctm:(CGAffineTransform)ctm fraction:(float)fraction;

@end