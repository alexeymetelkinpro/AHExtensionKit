//
//  NSString+ExtensionKit.m
//  AHExtensionKit
//
//  Created by Alexey Hippie on 19/01/14.
//  Copyright (c) 2014 Alexey Hippie. All rights reserved.
//

#import "NSString+ExtensionKit.h"

@implementation NSString (ExtensionKit)

#pragma mark - initializer

+ (NSString *)localizedStringFromBool:(BOOL)b {
    NSString *result = @"";
    if (b) {
        result = NSLocalizedString(@"Yes", @"Yes");
    } else {
        result = NSLocalizedString(@"No", @"No");
    }
    
    return result;
}

#pragma mark - modifications

- (NSString *)lowerCaseFirstLetter {
	unichar l = [self characterAtIndex:0];
	NSString *letter = [[NSString stringWithCharacters:&l length:1] lowercaseString];
	NSString *rest = [self substringFromIndex:1];
    
	return [NSString stringWithFormat:@"%@%@", letter, rest];
}

- (NSString *)upperCaseFirstLetter {
	unichar l = [self characterAtIndex:0];
	NSString *letter = [[NSString stringWithCharacters:&l length:1] uppercaseString];
	NSString *rest = [self substringFromIndex:1];
    
	return [NSString stringWithFormat:@"%@%@", letter, rest];
}

- (NSDate *)convertToDate {
    NSDate *result = nil;
    
    NSArray *validSeparators = @[@".", @"-", @"/", @"\\"];
    NSDateFormatter *frmttr = [[NSDateFormatter alloc] init];
    frmttr.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    for (NSString *separator in validSeparators) {
        [frmttr setDateFormat:[NSString stringWithFormat:@"d%@M%@yy", separator, separator]];
        result = [frmttr dateFromString:self];
        if (result) {
            break;
        }
    }
    
    if (result) {
        // fix YY to YYYY
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *dc = [cal components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:result];
        if (dc) {
            if (dc.year <= 99) {
                NSDateComponents *dcNow = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
                NSInteger century = dcNow.year / 100;
                NSInteger year2d = dcNow.year % 100;
                if (year2d > 50) {
                    if (dc.year <= year2d - 50) {
                        // next century
                        century++;
                    }
                } else {
                    if (dc.year >= year2d + 50) {
                        // previous century
                        century--;
                    }
                }
                dc.year = dc.year + century * 100;
                result = [cal dateFromComponents:dc];
            }
        }
    }
    
    return result;
}

#pragma mark - checking

- (BOOL)containsString:(NSString *)substring {
    NSRange range = [self.lowercaseString rangeOfString:substring.lowercaseString];
    BOOL found = (range.location != NSNotFound);
    return found;
}

- (BOOL)notEmpty {
    BOOL result = NO;
    if (self && ![self isEqualToString:@""] && self.length > 0) {
        result = YES;
    }
    
    return result;
}

- (BOOL)isValidEmail {
    BOOL result = NO;
    NSString *regExPattern = @"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern
                                                                      options:NSRegularExpressionCaseInsensitive
                                                                        error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:self options:0 range:NSMakeRange(0, [self length])];
    if (regExMatches == 0) {
        result = NO;
    } else {
        result = YES;
    }
    
    return result;
}

@end
