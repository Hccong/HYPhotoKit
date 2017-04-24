//
//  HYPhotoKitMacro.h
//  HYPhotoKitDemo
//
//  Created by Harry on 2017/4/19.
//  Copyright © 2017年 Harry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#ifndef HYPhotoKitMacro_h
#define HYPhotoKitMacro_h

// 按照自己的需求设置按钮字体文本
#define kHYCameraResetString @"重拍"
#define kHYCameraCancelString @"取消"
#define kHYCameraConfirmString @"确认"


#define kHYCameraDelegateKey @"kHYCameraDelegateKey"
#define kHYCameraPhotoIsSaveLocalKey @"kHYCameraPhotoIsSaveLocalKey"
#define kHYCameraPhotoSessionPresetType @"kHYCameraPhotoSessionPresetType"
#define kHYCameraPhotoResultBlockKey @"kHYCameraPhotoResultBlockKey"

// 判别系统版本
#define ShortSystemVersion  [[UIDevice currentDevice].systemVersion floatValue]
#define kIOS_6 (ShortSystemVersion < 7)
#define kIOS_7 (ShortSystemVersion >= 7 && ShortSystemVersion < 8)
#define kIOS_8 (ShortSystemVersion >= 8 && ShortSystemVersion < 9)
#define kIOS_9 (ShortSystemVersion >= 9 && ShortSystemVersion < 10)
#define kIOS_10 (ShortSystemVersion >= 10)

#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

//打印
#ifdef DEBUG
#define ALog(fmt, ...) NSLog(fmt, ##__VA_ARGS__)
#define DLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#else
#define ALog(fmt, ...)
#define DLog(fmt, ...)
#define NSLog(...) {}
#endif



#endif /* HYPhotoKitMacro_h */
