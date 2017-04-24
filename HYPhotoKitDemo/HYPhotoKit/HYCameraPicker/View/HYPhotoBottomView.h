//
//  HYPhotoBottomView.h
//  HYPhotoKitDemo
//
//  Created by Harry on 2017/4/19.
//  Copyright © 2017年 Harry. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BottomButtonType) {
    BottomButtonTakePhotoType,
    BottomButtonCancelType,
    BottomButtonConfirmType
};

typedef void(^BottomButtonBlock)(UIButton *button, BottomButtonType type);

@interface HYPhotoBottomView : UIView

@property (nonatomic, copy) BottomButtonBlock bottomClickBlock;

- (UIButton *)viewWithButtonType:(BottomButtonType)type;

@end
