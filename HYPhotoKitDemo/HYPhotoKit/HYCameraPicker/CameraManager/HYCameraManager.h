//
//  HYCameraManager.h
//  HYPhotoKitDemo
//
//  Created by Harry on 2017/4/19.
//  Copyright © 2017年 Harry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYPhotoKitMacro.h"
#import "HYCameraProtocol.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HYResultBlock)(id response);

typedef NS_ENUM(NSUInteger, HYSessionPresetType) {
    HYAVCaptureSessionPreset320x240,      //320 x 240
    HYAVCaptureSessionPreset352x288,      //352 x 288
    HYAVCaptureSessionPreset640x480,      //640 x 480
    HYAVCaptureSessionPreset960x540,      //960 x 540
    HYAVCaptureSessionPreset1280x720,     //1280 x 720
    HYAVCaptureSessionPreset1920x1080,    //1920 x 1080
    HYAVCaptureSessionPreset3840x2160     //3840 x 2160
};


@interface HYCameraManager : NSObject

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

/**
 设置后摄像头的分辨率(前摄像头无法设置分辨率)
 */
@property (nonatomic, assign) HYSessionPresetType sessionPresetType;

/**
 点击确认的时候是否将图片保存到相册
 */
@property (nonatomic, assign) BOOL saveLocal;


/**
 block回调的方式获取图片
 */
+ (HYCameraManager *)showCameraBlock:(HYResultBlock)resultBlock;

- (instancetype)initWithCameraBlock:(HYResultBlock)resultBlock;

- (instancetype)initWithCameraBlock:(HYResultBlock)resultBlock title:(NSString *)title message:(NSString *)message;

- (instancetype)initWithCameraInViewController:(nullable UIViewController *)vc resultBlock:(HYResultBlock)resultBlock title:(NSString *)title message:(NSString *)message;


/**
 delegate回调的方式获取图片
 */

+ (HYCameraManager *)showCameraDelegate:(id <HYCameraDelegate>)delegate;

- (instancetype)initWithShowCameraDelegate:(id <HYCameraDelegate>)delegate;

- (instancetype)initWithShowCameraDelegate:(id <HYCameraDelegate>)delegate title:(NSString *)title message:(NSString *)message;

- (instancetype)initWithCameraInViewController:(UIViewController *)vc withDelegate:(id <HYCameraDelegate>)delegate title:(NSString *)title message:(NSString *)message;

@end


NS_ASSUME_NONNULL_END
