//
//  ViewController.m
//  HYPhotoKitDemo
//
//  Created by Harry on 2017/4/19.
//  Copyright © 2017年 Harry. All rights reserved.
//

#import "ViewController.h"
#import "HYCameraManager.h"
#import "CommonTool.h"
#import "UIImage+HYAdd.h"
#import "HYPhotoKitMacro.h"

@interface ViewController () <HYCameraDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}


- (IBAction)openCamera:(id)sender {
//*******************************第1️⃣种方案（直接通过block获取image对象）*******************************
//    [HYCameraManager showCameraBlock:^(id  _Nonnull response) {
//        
//    }];
   
    /*
    HYCameraManager *manager = [HYCameraManager showCameraBlock:^(id  _Nonnull response) {
        
    }];
    manager.saveLocal = YES;
    manager.sessionPresetType = HYAVCaptureSessionPreset1280x720;
    */
    
//*******************************第2️⃣种方案（直接通过block获取image对象）*******************************
//    HYCameraManager *manager = [[HYCameraManager alloc] initWithCameraBlock:^(id  _Nonnull response) {
//        
//    }];
//    manager.saveLocal = YES;
//    manager.sessionPresetType = HYAVCaptureSessionPreset1280x720;
    
    
//*******************************第3️⃣种方案（直接通过block获取image对象）*******************************
//    HYCameraManager *manager = [[HYCameraManager alloc] initWithCameraBlock:^(id  _Nonnull response) {
//        
//    } title:@"我的提示" message:@"详细信息"];
//    manager.saveLocal = YES;
//    manager.sessionPresetType = HYAVCaptureSessionPreset1280x720;
    
    
//*******************************第4️⃣种方案（直接通过block获取image对象）*******************************

//    HYCameraManager *manager = [[HYCameraManager alloc] initWithCameraInViewController:self resultBlock:^(id  _Nonnull response) {
//        
//    } title:@"提示" message:@"我的详细信息"];
//    manager.saveLocal = YES;
//    manager.sessionPresetType = HYAVCaptureSessionPreset1280x720;
    
    

    
//*******************************第5️⃣种方案 （通过delegate方式）*******************************
    HYCameraManager *manager = [HYCameraManager showCameraDelegate:self];
    manager.saveLocal = YES;
    manager.sessionPresetType = HYAVCaptureSessionPreset1280x720;
    
    
  
//*******************************第6️⃣种方案 （通过delegate方式）*******************************
//    HYCameraManager *manager = [[HYCameraManager alloc] initWithShowCameraDelegate:self];
//    manager.saveLocal = YES;
//    manager.sessionPresetType = HYAVCaptureSessionPreset1280x720;

//*******************************第7️⃣种方案 （通过delegate方式）*******************************
//    HYCameraManager *manager = [[HYCameraManager alloc] initWithShowCameraDelegate:self title:@"哈哈" message:@"你好啊"];
//    manager.saveLocal = YES;
//    manager.sessionPresetType = HYAVCaptureSessionPreset1280x720;
    
//*******************************第8️⃣种方案 （通过delegate方式）*******************************
//    HYCameraManager *manager = [[HYCameraManager alloc] initWithCameraInViewController:self withDelegate:self title:@"提示的内容" message:@"详细信息"];
//    manager.saveLocal = YES;
//    manager.sessionPresetType = HYAVCaptureSessionPreset1280x720;
}


#pragma mark - <HYCameraDelegate>

// 点击了取消操作
- (void)cameraPickerCancelButtonClick
{
    DLog(@"xxx点击了取消操作");
}

// 点击了拍照操作
- (void)cameraPickerTakePhotoButtonClick:(UIImage *)image
{
    DLog(@"xxx拍照操作 %@", image);
    self.imageV.image = image;
}

// 点击了重拍
- (void)cameraPickerResetButtonClick
{
    DLog(@"xxx点击了重拍操作");
}

// 点击了确认操作
- (void)cameraPickerConfirmButtonClick:(UIImage *)image
{
    DLog(@"xxx确认操作  %@", image);
    self.imageV.image = image;
}

// 点击了闪光灯操作 YES表示闪光灯打开 NO表示闪光灯关闭
- (void)cameraFlashStatus:(BOOL)isOpen
{
    if (isOpen) {
        DLog(@"xxx闪光灯打开");
    } else {
        DLog(@"xxx闪光灯关闭");
    }
}

// 点击了摄像头方向操作 YES代表是后摄像头 NO代表是后摄像头
- (void)cameraDirectionStatus:(BOOL)isOpen
{
    if (isOpen) {
        DLog(@"xxx摄像头切换到后摄像头");
    } else {
        DLog(@"xxx摄像头切换到前摄像头");
    }
}


@end
