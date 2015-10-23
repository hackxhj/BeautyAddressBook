// CDCInitialsAvatar.m
//
// Copyright (c) 2014-2015 LLC Code, Design & Coffee http://codedesigncoffee.net
//                         Tornike (Toto) Tvalavadze http://totocaster.com
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

#import "CDFInitialsAvatar.h"

@implementation CDFInitialsAvatar

- (instancetype)initWithRect:(CGRect)frame fullName:(NSString *)fullName
{
    self = [super init];
    if (self) {
        self.frame = frame;
        self.fullName = fullName;
        self.backgroundColor = [UIColor lightGrayColor];
        self.initialsColor = [UIColor whiteColor];
        self.initialsFont = nil;
    }
    return self;
}

- (NSString *)initials {
    NSMutableString * firstCharacters = [NSMutableString string];
    NSArray * words = [self.fullName componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    for (NSString * word in words) {
        if ([word length] > 0) {
            NSString * firstLetter = [word substringWithRange:[word rangeOfComposedCharacterSequenceAtIndex:0]];
            [firstCharacters appendString:[firstLetter uppercaseString]];
        }
    }
    //这里不对文字进行分割判断,直接原样
    return self.fullName;
}

- (UIImage *)imageRepresentation
{
    CGRect frame = self.frame;
    
    // General Declarations
    UIGraphicsBeginImageContextWithOptions(frame.size, YES, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Color Declarations
    UIColor* backgroundColor = self.backgroundColor;
    
    // Variable Declarations
    NSString* initials = self.initials;
    CGFloat fontSize = frame.size.height / 2.8;
    
    // Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), CGRectGetHeight(frame))];
    [backgroundColor setFill];
    [rectanglePath fill];
    
    // Initials String Drawing
    CGRect initialsStringRect = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), CGRectGetHeight(frame));
    NSMutableParagraphStyle* initialsStringStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
    initialsStringStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *font;
    if (!self.initialsFont) {
        font = [UIFont systemFontOfSize:fontSize];
    } else {
        font = self.initialsFont;
    }
    
    NSDictionary* initialsStringFontAttributes = @{NSFontAttributeName: font, NSForegroundColorAttributeName: self.initialsColor, NSParagraphStyleAttributeName: initialsStringStyle};
    
    CGFloat initialsStringTextHeight = [initials boundingRectWithSize: CGSizeMake(initialsStringRect.size.width, INFINITY)  options: NSStringDrawingUsesLineFragmentOrigin attributes: initialsStringFontAttributes context: nil].size.height;
    CGContextSaveGState(context);
    CGContextClipToRect(context, initialsStringRect);
    [initials drawInRect: CGRectMake(CGRectGetMinX(initialsStringRect), CGRectGetMinY(initialsStringRect) + (CGRectGetHeight(initialsStringRect) - initialsStringTextHeight) / 2, CGRectGetWidth(initialsStringRect), initialsStringTextHeight) withAttributes: initialsStringFontAttributes];
    CGContextRestoreGState(context);

    return UIGraphicsGetImageFromCurrentImageContext();
}


@end
