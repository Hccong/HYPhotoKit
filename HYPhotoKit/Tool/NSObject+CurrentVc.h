//
//  NSObject+CurrentVc.h
//  HYPhotoKitDemo
//
//  Created by Harry on 2017/4/19.
//  Copyright © 2017年 Harry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSObject (CurrentVc)

/**
 获取当前控制器
 */
- (UIViewController *)getCurrentVC;

+ (UIViewController *)getCurrentVC;

@end
