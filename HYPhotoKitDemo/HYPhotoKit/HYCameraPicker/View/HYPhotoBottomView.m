//
//  HYPhotoBottomView.m
//  HYPhotoKitDemo
//
//  Created by Harry on 2017/4/19.
//  Copyright © 2017年 Harry. All rights reserved.
//

#import "HYPhotoBottomView.h"
#import "CommonTool.h"
#import "UIView+HYAdd.h"
#import "HYPhotoKitMacro.h"

@interface HYPhotoBottomView ()

@property (nonatomic, strong) UIButton *takePhotoButton;

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation HYPhotoBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self addSubview:self.takePhotoButton];
        [self addSubview:self.cancelButton];
        [self addSubview:self.confirmButton];
    }
    return self;
}

- (UIButton *)viewWithButtonType:(BottomButtonType)type
{
    if (type == BottomButtonTakePhotoType) {
        return self.takePhotoButton;
    } else if (type == BottomButtonCancelType) {
        return self.cancelButton;
    } else {
        return self.confirmButton;
    }
}

#pragma mark - <拍照按钮>

- (void)takePhotoButtonClick:(UIButton *)button
{
    self.bottomClickBlock(button, BottomButtonTakePhotoType);
}

#pragma mark - <取消按钮>

- (void)cancelButtonClick:(UIButton *)button
{
    self.bottomClickBlock(button, BottomButtonCancelType);
}

#pragma mark - <确认按钮>

- (void)confirmButtonClick:(UIButton *)button
{
    self.bottomClickBlock(button, BottomButtonConfirmType);
}


#pragma mark - <lazy>

- (UIButton *)takePhotoButton
{
    if (_takePhotoButton == nil) {
        _takePhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 15, 50, 50)];
        _takePhotoButton.centerX = self.centerX;
        [_takePhotoButton addTarget:self action:@selector(takePhotoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_takePhotoButton setImage:[CommonTool imageFromCustomBundle:@"take_photo_pic"] forState:UIControlStateNormal];
    }
    return _takePhotoButton;
}

- (UIButton *)cancelButton
{
    if (_cancelButton == nil) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(15, 10, 50, 50);
        _cancelButton.centerY = self.height*0.5;
        [_cancelButton setTitle:kHYCameraCancelString forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _confirmButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_cancelButton  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)confirmButton
{
    if (_confirmButton == nil) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-15-50, 10, 50, 50);
        _confirmButton.centerY = self.height*0.5;
        _confirmButton.hidden = YES;
        [_confirmButton setTitle:kHYCameraConfirmString forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _confirmButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [_confirmButton  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}
@end
