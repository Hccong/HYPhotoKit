//
//  UIImage+HYAdd.m
//  HYPhotoKitDemo
//
//  Created by Harry on 2017/4/19.
//  Copyright © 2017年 Harry. All rights reserved.
//

#import "UIImage+HYAdd.h"

@implementation UIImage (HYAdd)

- (UIImage *)imageFromCustomBundle:(NSString *)imageName
{
    NSString *bundlePath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"Resource.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    NSString *imgPath = [bundle pathForResource:imageName ofType:@"png"];
    
    return [self initWithContentsOfFile:imgPath];
}


@end
