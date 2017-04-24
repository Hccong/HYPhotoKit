//
//  HYCameraManager.m
//  HYPhotoKitDemo
//
//  Created by Harry on 2017/4/19.
//  Copyright © 2017年 Harry. All rights reserved.
//

#import "HYCameraManager.h"
#import "NSObject+CurrentVc.h"
#import "HYCamerPickerViewController.h"
#import "NSString+HYAdd.h"
#import <AVFoundation/AVFoundation.h>
#import "ValitateTool.h"
#import <objc/runtime.h>
#import "HYPhotoKitMacro.h"


@implementation HYCameraManager {
    HYCamerPickerViewController *_cameraVc;
    NSMutableDictionary *_params;
    NSString *_title;
    NSString *_message;
}

+ (HYCameraManager *)showCameraBlock:(HYResultBlock)resultBlock
{
   return [[self alloc] initWithCameraBlock:resultBlock];
}

- (instancetype)initWithCameraBlock:(HYResultBlock)resultBlock
{
    if (self = [super init]) {
        [self showCameraInViewController:nil resultBlock:resultBlock delegate:nil];
    }
    return self;
}

- (instancetype)initWithCameraBlock:(HYResultBlock)resultBlock title:(NSString *)title message:(NSString *)message
{
    if (self = [super init]) {
        _title = title;
        _message = message;
        [self showCameraInViewController:nil resultBlock:resultBlock delegate:nil];
    }
    return self;
}

- (instancetype)initWithCameraInViewController:(nullable UIViewController *)vc resultBlock:(HYResultBlock)resultBlock title:(NSString *)title message:(NSString *)message
{
    if (self = [super init]) {
        _title = title;
        _message = message;
        [self showCameraInViewController:vc resultBlock:resultBlock delegate:nil];
    }
    return self;
}

+ (HYCameraManager *)showCameraDelegate:(id <HYCameraDelegate>)delegate
{
    return [[self alloc] initWithShowCameraDelegate:delegate];
}

- (instancetype)initWithShowCameraDelegate:(id <HYCameraDelegate>)delegate
{
    if (self = [super init]) {
        [self showCameraInViewController:nil resultBlock:nil delegate:delegate];
    }
    return self;
}

- (instancetype)initWithShowCameraDelegate:(id <HYCameraDelegate>)delegate title:(NSString *)title message:(NSString *)message
{
    if (self = [super init]) {
        _title = title;
        _message = message;
        [self showCameraInViewController:nil resultBlock:nil delegate:delegate];
    }
    return self;
}

- (instancetype)initWithCameraInViewController:(UIViewController *)vc withDelegate:(id <HYCameraDelegate>)delegate title:(NSString *)title message:(NSString *)message
{
    if (self = [super init]) {
        _title = title;
        _message = message;
        [self showCameraInViewController:vc resultBlock:nil delegate:delegate];
    }
    return self;
}

- (void)showCameraInViewController:(UIViewController *)vc resultBlock:(HYResultBlock)resultBlock delegate:(id)delegate
{
    if (!vc) {
        vc = [self getCurrentVC];
        NSAssert(vc != nil, @"获取不到当前控制器");
    }
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (status == AVAuthorizationStatusNotDetermined) {
        //相机进行授权
        @weakify(self)
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                @strongify(self)
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showController:vc result:resultBlock delegate:delegate];
                });
            }
        }];
    }else if (status == AVAuthorizationStatusAuthorized){
        [self showController:vc result:resultBlock delegate:delegate];
    }else if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied){
        [self showAlertViewToController:vc];
    }
}


- (void)showController:(UIViewController *)vc result:(HYResultBlock)resultBlock delegate:(id)delegate
{
    HYCamerPickerViewController *camVc = [HYCamerPickerViewController new];

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (delegate) {
        [dic setObject:delegate forKey:kHYCameraDelegateKey];
    }
    if (resultBlock) {
        [dic setObject:resultBlock forKey:kHYCameraPhotoResultBlockKey];
    }
    _params = dic;
    _cameraVc = camVc;
    
    [vc presentViewController:camVc animated:YES completion:nil];
}

- (void)sendCameraMessage
{
    [_params setObject:@(self.saveLocal) forKey:kHYCameraPhotoIsSaveLocalKey];
    [_params setObject:@(self.sessionPresetType) forKey:kHYCameraPhotoSessionPresetType];
    [_cameraVc performSelector:@selector(hy_sendCameraMessage:) withObject:_params];
}

- (void)hy_sendCameraMessage:(id)message{}

- (void)showAlertViewToController:(UIViewController *)vc
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];

    NSString *noticeTitle = _title;
    NSString *noticeMessage = _message;
    if ([ValitateTool isBlankString:noticeTitle]) {
        noticeTitle = @"提示";
    }
    if ([ValitateTool isBlankString:noticeMessage]) {
        noticeMessage = [NSString stringWithFormat:@"请在iPhone的“设置->隐私->照片”开启%@访问你的相机",appName];
    }

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:noticeTitle message:noticeMessage preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:kHYCameraCancelString style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
    }];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }];
#pragma clang diagnostic pop

    [alert addAction:action1];
    [alert addAction:action2];
    [vc presentViewController:alert animated:YES completion:nil];
}


#pragma mark - <setter>

- (void)setSaveLocal:(BOOL)saveLocal
{
    _saveLocal = saveLocal;
    
    [self sendCameraMessage];
}

- (void)setSessionPresetType:(HYSessionPresetType)sessionPresetType
{
    _sessionPresetType = sessionPresetType;
    
    [self sendCameraMessage];
}

- (void)dealloc
{
    DLog(@"----dealloc   %s", __func__);
}

@end


