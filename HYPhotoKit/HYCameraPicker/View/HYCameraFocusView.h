//
//  HYCameraFocusView.h
//  HYPhotoKitDemo
//
//  Created by Harry on 2017/4/19.
//  Copyright © 2017年 Harry. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GetFocusPointBlock)(CGPoint point);

@interface HYCameraFocusView : UIView

@property (nonatomic, copy) GetFocusPointBlock focusBlock;

@end
