//
//  NSString+HYAdd.m
//  HYPhotoKitDemo
//
//  Created by Harry on 2017/4/19.
//  Copyright © 2017年 Harry. All rights reserved.
//

#import "NSString+HYAdd.h"

@implementation NSString (HYAdd)

- (NSString *)stringByTrim {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}


- (BOOL)isEmpty {
    if (self == NULL || self == nil) {
        return YES;
    }
    if ([self isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([self.stringByTrim length] == 0) {
        return YES;
    }
    return NO;
}

@end
