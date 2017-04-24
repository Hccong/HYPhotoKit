//
//  HYCameraTool.m
//  HYPhotoKitDemo
//
//  Created by Harry on 2017/4/20.
//  Copyright © 2017年 Harry. All rights reserved.
//

#import "HYCameraTool.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "CommonTool.h"
#import "HYPhotoKitMacro.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"

@interface HYCameraTool ()

@property (nonatomic, strong) AVCaptureStillImageOutput *captureOutput;

@property (nonatomic, strong) AVCaptureDevice *device;

@property (nonatomic, strong) AVCaptureSession *session;

@property (nonatomic, copy) SavePhotoSuccessBlock saveBlock;

@end

@implementation HYCameraTool

- (instancetype)initCameraPickerBlock:(CameraBlock)block
{
    if (self = [super init]) {
        [self initCameraBlock:block];
    }
    return self;
}


#pragma mark - <初始化>

- (void)initCameraBlock:(CameraBlock)block
{
    // 创建会话层
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 输入
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    // 输出 （这里是为了消除警告 iOS10之前用AVCaptureStillImageOutput  之后用AVCapturePhotoOutput代替）
    AVCaptureStillImageOutput *captureOutput = [[AVCaptureStillImageOutput alloc] init];
    
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [captureOutput setOutputSettings:outputSettings];
    
    // 会话
    AVCaptureSession *session = [[AVCaptureSession alloc]init];
    
    if ([self changeCameraOperation]) {
        [session setSessionPreset:AVCaptureSessionPresetHigh];
    } else {
        [session setSessionPreset:AVCaptureSessionPreset1920x1080];
    }

    if ([session canAddInput:input]) {
        [session addInput:input];
    }
    if ([session canAddOutput:captureOutput]) {
        [session addOutput:captureOutput];
    }
    
    if ([device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
        [device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
    }
    
    block(device,session);
    if (session) {
        [session startRunning];
    }
    
    self.captureOutput = captureOutput;
    self.device = device;
    self.session = session;
}


#pragma mark - <拍照>

- (void)takeCaptureImageBlock:(void(^)(void))block
{
    // 获取连接
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.captureOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    
    [self.captureOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:
     ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         _photoImage = [UIImage imageWithData:imageData];
         block();
    }];
}


- (void)savePhotoImageLocal:(BOOL)saveLocal saveSuccessBlock:(SavePhotoSuccessBlock)block
{
    if (saveLocal == YES) {
        self.saveBlock = block;
         UIImageWriteToSavedPhotosAlbum([CommonTool fixOrientation:self.photoImage], self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    } else {
        block(NO);
    }
}

#pragma mark - <保存到相册>

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied) {
        self.saveBlock(NO);
    } else {
        self.saveBlock(YES);
    }
}


#pragma mark - <改变闪光灯>

- (void)changeFlashStatus:(void(^)(void))flashBlock
{
    if (!flashBlock) return;
    [self.session beginConfiguration];
    [self.device lockForConfiguration:nil];
    flashBlock();
    [self.device unlockForConfiguration];
    [self.session commitConfiguration];
    [self.session startRunning];
}

#pragma mark - <改变摄像头的方向>

- (BOOL)changeCameraOperation
{
    NSArray *inputs = self.session.inputs;
    for ( AVCaptureDeviceInput *input in inputs ) {
        AVCaptureDevice *device = input.device;
        if ( [device hasMediaType:AVMediaTypeVideo] ) {
            AVCaptureDevicePosition position = device.position;
            AVCaptureDevice *newCamera = nil;
            AVCaptureDeviceInput *newInput = nil;
            
            if (position == AVCaptureDevicePositionFront)
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            else
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
            
            [self.session beginConfiguration];
            
            [self.session removeInput:input];
            [self.session addInput:newInput];
            
            [self.session commitConfiguration];
            if (position == AVCaptureDevicePositionFront) {
                return YES;
            } else {
                return NO;
            }
            break;
        }
    }
    return YES;
}


- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position )
            return device;
    return nil;
}

- (void)dealloc
{
    DLog(@"----%s", __func__);
}

@end

#pragma clang diagnostic pop

