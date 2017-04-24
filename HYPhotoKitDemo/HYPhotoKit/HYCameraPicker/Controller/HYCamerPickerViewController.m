//
//  HYCamerPickerViewController.m
//  HYPhotoKitDemo
//
//  Created by Harry on 2017/4/19.
//  Copyright © 2017年 Harry. All rights reserved.
//

#import "HYCamerPickerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "HYPhotoKitMacro.h"
#import "HYCameraFocusView.h"
#import "HYPhotoTopView.h"
#import "CommonTool.h"
#import "HYPhotoBottomView.h"
#import "HYCameraTool.h"
#import "UIGestureRecognizer+HYAdd.h"
#import "HYBrowerViewCell.h"
#import "HYCameraManager.h"
#import "HYCameraProtocol.h"

#define kPhotoTopViewHeight   70
#define kPhotoBottomViewHeight 80

typedef void(^HYResultBlock)(id response);

@interface HYCamerPickerViewController ()

@property (nonatomic, strong) AVCaptureDevice *device;

@property (nonatomic, strong) HYCameraFocusView *focusView;

@property (nonatomic, strong) HYPhotoTopView *photoTopView;

@property (nonatomic, strong) HYPhotoBottomView *bottomView;

@property (nonatomic, strong) HYCameraTool *camTool;

@property (nonatomic, strong) UIImageView *showImageView;

@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, assign) BOOL saveLocalAlbum;

@property (nonatomic, copy) HYResultBlock resultBlock;

@property (nonatomic, assign) HYSessionPresetType sessionPresetType;

@property (nonatomic, weak) id <HYCameraDelegate> delegate;

@end

@implementation HYCamerPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initCamera];
}

- (void)hy_sendCameraMessage:(NSDictionary *)message
{
    self.saveLocalAlbum = [message[kHYCameraPhotoIsSaveLocalKey] boolValue];
    self.resultBlock = message[kHYCameraPhotoResultBlockKey];
    self.sessionPresetType = [(NSNumber *)message[kHYCameraPhotoSessionPresetType] integerValue];
    self.delegate = message[kHYCameraDelegateKey];
}

#pragma mark - <初始化>

- (void)initCamera
{
    @weakify(self)
    HYCameraTool *camTool = [[HYCameraTool alloc] initCameraPickerBlock:^(AVCaptureDevice *device, AVCaptureSession *session) {
        @strongify(self)
        // 预览层
        AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:session];
        preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
        preview.frame = self.view.bounds;
        [self.view.layer insertSublayer:preview atIndex:0];
        [self.view addSubview:self.focusView];
        [self.view addSubview:self.photoTopView];
        [self.view addSubview:self.bottomView];
        self.device = device;
        
        [self delegateCameraDirection:YES];
        [self delegateFlashMode:NO];
    }];
    self.camTool = camTool;
}

#pragma mark - <隐藏状态栏>

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - <取消>

- (void)cancel:(UIButton *)button
{
    if ([button.titleLabel.text isEqualToString:kHYCameraResetString]) {
        [self.coverView removeFromSuperview];
        [self.showImageView removeFromSuperview];
        [self.bottomView viewWithButtonType:BottomButtonConfirmType].hidden = YES;
        [self.bottomView viewWithButtonType:BottomButtonTakePhotoType].enabled = YES;
        [button setTitle:kHYCameraCancelString forState:UIControlStateNormal];
        self.focusView.hidden = NO;
        if([self.delegate respondsToSelector:@selector(cameraPickerResetButtonClick)]) {
            [self.delegate cameraPickerResetButtonClick];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(cameraPickerCancelButtonClick)]) {
            [self.delegate cameraPickerCancelButtonClick];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - <确认>

- (void)confirm:(UIButton *)button
{
    @weakify(self)
    [self.camTool savePhotoImageLocal:self.saveLocalAlbum saveSuccessBlock:^(BOOL isOpenAuthorization) {
        @strongify(self)
        button.enabled = YES;
        if (isOpenAuthorization == NO) {
            DLog(@"用户未开启相册权限");
        }
        if (self.resultBlock) {
            self.resultBlock(self.camTool.photoImage);
        }
        if ([self.delegate respondsToSelector:@selector(cameraPickerConfirmButtonClick:)]) {
            [self.delegate cameraPickerConfirmButtonClick:self.camTool.photoImage];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}


#pragma mark - <定格>

- (void)freezFrameImageView
{
    UIButton *cancel = [self.bottomView viewWithButtonType:BottomButtonCancelType];
    [cancel setTitle:kHYCameraResetString forState:UIControlStateNormal];
    [self.bottomView viewWithButtonType:BottomButtonTakePhotoType].enabled = NO;
    [self.bottomView viewWithButtonType:BottomButtonConfirmType].hidden = NO;

    self.focusView.hidden = YES;
    
    UIView *cover = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    cover.backgroundColor = [UIColor blackColor];
    [self.view insertSubview:cover belowSubview:self.focusView];
    self.coverView = cover;
    HYBrowerViewCell *cell = [[HYBrowerViewCell alloc] initWithFrame:self.view.frame];
    [cell loadPicData:self.camTool.photoImage];
    [cover addSubview:cell];
    
    __block NSInteger tt = 0;
    @weakify(self)
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        @strongify(self)
        if (tt == 0) {
            tt = 1;
            [UIView animateWithDuration:0.3 animations:^{
                self.photoTopView.frame = CGRectMake(0, -kPhotoTopViewHeight, self.view.frame.size.width, kPhotoTopViewHeight);
                self.bottomView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, kPhotoBottomViewHeight);
            }];
        } else {
            tt = 0;
            [UIView animateWithDuration:0.3 animations:^{
                self.photoTopView.frame = CGRectMake(0, 0, self.view.frame.size.width, kPhotoTopViewHeight);
                self.bottomView.frame = CGRectMake(0, self.view.frame.size.height-kPhotoBottomViewHeight, self.view.frame.size.width, kPhotoBottomViewHeight);
            }];
        }
    }];
    [cell addGestureRecognizer:tap];
}

- (void)delegateFlashMode:(BOOL)isOpen
{
    if ([self.delegate respondsToSelector:@selector(cameraFlashStatus:)]) {
        [self.delegate cameraFlashStatus:isOpen];
    }
}

- (void)delegateCameraDirection:(BOOL)isChange
{
    if ([self.delegate respondsToSelector:@selector(cameraDirectionStatus:)]) {
        [self.delegate cameraDirectionStatus:isChange];
    }
    // 已经切换了后摄像头
    if (isChange) {
        [self.photoTopView viewWithType:TopButtonFlashType].hidden = NO;
    } else {
        [self.photoTopView viewWithType:TopButtonFlashType].hidden = YES;
    }
}

#pragma mark - <lazy>

- (HYCameraFocusView *)focusView
{
    if (_focusView == nil) {
        @weakify(self);
        _focusView = [[HYCameraFocusView alloc] initWithFrame:self.view.bounds];
        _focusView.focusBlock = ^(CGPoint point) {
            @strongify(self);
            NSError *error;
            if ([self.device lockForConfiguration:&error]) {
                // 对焦
                if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
                    [self.device setFocusPointOfInterest:point];
                    [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
                }
                [self.device unlockForConfiguration];
            }
        };
    }
    return _focusView;
}

- (HYPhotoTopView *)photoTopView
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    if (_photoTopView == nil) {
        _photoTopView = [[HYPhotoTopView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kPhotoTopViewHeight)];
        @weakify(self)
        _photoTopView.buttonClickBlock = ^(TopButtonType type, UIButton *button) {
            @strongify(self)

            if (type == TopButtonFlashType) {
                if (self.device.flashMode == 0) {
                    [self.camTool changeFlashStatus:^{
                        [self.device setFlashMode:AVCaptureFlashModeOn];
                        [self delegateFlashMode:YES];
                    }];
                    [button setImage:[CommonTool imageFromCustomBundle:@"flash_open_pic"] forState:UIControlStateNormal];

                }else if (self.device.flashMode == 1){
                    [self.camTool changeFlashStatus:^{
                        [self.device setFlashMode:AVCaptureFlashModeOff];
                        [self delegateFlashMode:NO];
                    }];
                    [button setImage:[CommonTool imageFromCustomBundle:@"flash_close_pic"] forState:UIControlStateNormal];
                }
                
            } else if (type == TopButtonDirectionType) {
                BOOL direction = [self.camTool changeCameraOperation];
                [self delegateCameraDirection:direction];
            }
        };
    }
    return _photoTopView;
#pragma clang diagnostic pop
}


- (HYPhotoBottomView *)bottomView
{
    if (_bottomView == nil) {
        @weakify(self)
        _bottomView = [[HYPhotoBottomView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-kPhotoBottomViewHeight, self.view.frame.size.width, kPhotoBottomViewHeight)];
        _bottomView.bottomClickBlock = ^(UIButton *button, BottomButtonType type){
            @strongify(self)
            if (type == BottomButtonTakePhotoType) {
                button.enabled = NO;
                [self.camTool takeCaptureImageBlock:^{
                    button.enabled = YES;
                    [self freezFrameImageView];
                    if ([self.delegate respondsToSelector:@selector(cameraPickerTakePhotoButtonClick:)]) {
                        [self.delegate cameraPickerTakePhotoButtonClick:self.camTool.photoImage];
                    }
                }];
            } else if (type == BottomButtonCancelType) {
                [self cancel:button];
            } else if (type == BottomButtonConfirmType){
                button.enabled = NO;
                [self confirm:button];
            }
        };
    }
    return _bottomView;
}


- (void)dealloc
{
    DLog(@"***dealloc***%s", __func__);
}

@end

