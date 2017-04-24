//
//  CommonTool.h
//  HYPhotoKitDemo
//
//  Created by Harry on 2017/4/19.
//  Copyright © 2017年 Harry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonTool : NSObject

// 取出Bundle内的图片
+ (UIImage *)imageFromCustomBundle:(NSString *)imageName;

// 调整方向
+ (UIImage *)fixOrientation:(UIImage *)srcImg;

@end
