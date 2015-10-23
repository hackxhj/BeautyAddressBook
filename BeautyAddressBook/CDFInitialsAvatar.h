// CDCInitialsAvatar.h
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


#import <UIKit/UIKit.h>

@interface CDFInitialsAvatar : NSObject

/**
 Frame into which avatar will be rendered to. I would recommend to simple use `destinationImaveView.bounds` in `-initWithRect:fullName:` and forget about it. `CDCInitialsAvatar` _will_ adjust to your screen scale factor automatically, thus use points dimensions if assigned manually.
 
 @warning `frame` must not be `nil`.
 */
@property (readwrite, assign) CGRect frame;

/**
 Full name of person whose avatar should be displayed.
 
 @warning Do not use initials, `CDCInitialsAvatar` will calculate them automatically from full name. Also consider setting `initialsFont` manually when `frame` is anything other ran square.
 */
@property (readwrite, copy) NSString *fullName;

/**
 Background color of avatar. Default is `lightGrayColor`.
 */
@property (readwrite, strong) UIColor *backgroundColor;

/**
 Color of initials text in avatar. Default is white.
 */
@property (readwrite, strong) UIColor *initialsColor;

/**
 Font and size used generated initials. When `nil` system font with size of `frame.size.hight / 2.2` is used. Default value is `nil`.
 */
@property (readwrite, strong) UIFont *initialsFont;

/**
 Returns an `UIImage` object for using in `UIImageView` or anywhere else. If you want circular or different shaped avatars, consider masking `UIImageView` using its `mask` layer.
 
 @warning `CDCInitialsAvatar` _does not cache_ images, this means images will be generated each time. For example, when `UITableView` re-draws cell containing instance of `CDCInitialsAvatar`. Use your image caching strategy, which hopefully you already have implemented in your app.
 */
@property (readonly, strong, nonatomic) UIImage *imageRepresentation;

/**
 Returns an initials from `fullName`.
 */
@property (readonly, copy, nonatomic) NSString *initials;


/**
 Creates and returns an `CDCInitialsAvatar` generator object. No rendering is performed yet.
 */
- (instancetype)initWithRect:(CGRect)frame fullName:(NSString *)fullName;

@end
