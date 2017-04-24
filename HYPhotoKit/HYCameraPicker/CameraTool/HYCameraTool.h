//
//  HYCameraTool.h
//  HYPhotoKitDemo
//
//  Created by Harry on 2017/4/20.
//  Copyright © 2017年 Harry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CameraBlock)(AVCaptureDevice *device, AVCaptureSession *session);
typedef void(^SavePhotoSuccessBlock)(BOOL isOpenAuthorization);

@interface HYCameraTool : NSObject

// 获取拍照后的照片
@property (nonatomic, readonly, strong) UIImage *photoImage;

/**
 初始化配置
 */
- (instancetype)initCameraPickerBlock:(CameraBlock)block;

/**
 点击拍照
 */
- (void)takeCaptureImageBlock:(void(^)(void))block;

/**
 改变闪光灯状态
 */
- (void)changeFlashStatus:(void(^)(void))flashBlock;

/**
 改变摄像头 
 */
- (BOOL)changeCameraOperation;

/**
 保存本地图片 保存成功或失败都会有回调
 */
- (void)savePhotoImageLocal:(BOOL)saveLocal saveSuccessBlock:(SavePhotoSuccessBlock)block;


@end

NS_ASSUME_NONNULL_END
