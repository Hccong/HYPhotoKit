//
//  HYTopView.m
//  HYPhotoKitDemo
//
//  Created by Harry on 2017/4/19.
//  Copyright © 2017年 Harry. All rights reserved.
//

#import "HYPhotoTopView.h"
#import "CommonTool.h"

@interface HYPhotoTopView ()

@property (nonatomic, strong) UIButton *flashButton;

@property (nonatomic, strong) UIButton *directionButton;

@end

@implementation HYPhotoTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.flashButton];
        [self addSubview:self.directionButton];
    }
    return self;
}

- (UIButton *)viewWithType:(TopButtonType)type
{
    if (type == TopButtonFlashType) {
        return self.flashButton;
    } else {
        return self.directionButton;
    }
}

- (void)flashButtonClick:(UIButton *)button
{
    self.buttonClickBlock(TopButtonFlashType, button);
}

- (void)changeCameraDeviceClick:(UIButton *)button
{
    self.buttonClickBlock(TopButtonDirectionType, button);
}

- (UIButton *)flashButton
{
    if (_flashButton == nil) {
        _flashButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        [_flashButton addTarget:self action:@selector(flashButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_flashButton setImage:[CommonTool imageFromCustomBundle:@"flash_close_pic"] forState:UIControlStateNormal];
    }
    return _flashButton;
}

- (UIButton *)directionButton
{
    if (_directionButton == nil) {
        _directionButton = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 40, 10, 30, 30)];
        [_directionButton addTarget:self action:@selector(changeCameraDeviceClick:) forControlEvents:UIControlEventTouchUpInside];
        [_directionButton setImage:[CommonTool imageFromCustomBundle:@"change_camera_pic"] forState:UIControlStateNormal];
    }
    return _directionButton;
}

@end
