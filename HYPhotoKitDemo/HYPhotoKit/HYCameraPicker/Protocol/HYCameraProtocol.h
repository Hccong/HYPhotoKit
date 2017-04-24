//
//  HYCameraProtocol.h
//  HYPhotoKitDemo
//
//  Created by Harry on 2017/4/20.
//  Copyright © 2017年 Harry. All rights reserved.
//

@protocol HYCameraDelegate <NSObject>

// 点击了取消操作
- (void)cameraPickerCancelButtonClick;

// 点击了拍照操作
- (void)cameraPickerTakePhotoButtonClick:(UIImage *)image;

// 点击了重拍操作
- (void)cameraPickerResetButtonClick;

// 点击了确认操作
- (void)cameraPickerConfirmButtonClick:(UIImage *)image;

// 点击了闪光灯操作 YES表示闪光灯打开 NO表示闪光灯关闭
- (void)cameraFlashStatus:(BOOL)isOpen;

// 点击了摄像头方向操作 YES代表是后摄像头 NO代表是后摄像头
- (void)cameraDirectionStatus:(BOOL)isOpen;

@end
