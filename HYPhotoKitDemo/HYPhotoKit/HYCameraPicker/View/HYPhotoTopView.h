//
//  HYTopView.h
//  HYPhotoKitDemo
//
//  Created by Harry on 2017/4/19.
//  Copyright © 2017年 Harry. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TopButtonType) {
    TopButtonFlashType,
    TopButtonDirectionType,
};

typedef void(^TopButtonBlock)(TopButtonType type, UIButton *button);

@interface HYPhotoTopView : UIView

@property (nonatomic, copy) TopButtonBlock buttonClickBlock;

- (UIButton *)viewWithType:(TopButtonType)type;

@end
