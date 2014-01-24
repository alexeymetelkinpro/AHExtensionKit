//
//  NSString+ExtensionKit.h
//  AHExtensionKit
//
//  Created by Alexey Hippie on 19/01/14.
//  Copyright (c) 2014 Alexey Hippie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ExtensionKit)

#pragma mark - initializer
+ (NSString *)localizedStringFromBool:(BOOL)b;

#pragma mark - modifications
- (NSString *)lowerCaseFirstLetter;
- (NSString *)upperCaseFirstLetter;

#pragma mark - checking
- (BOOL)containsString:(NSString *)substring;
- (BOOL)notEmpty;

@end