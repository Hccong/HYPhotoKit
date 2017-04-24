//
//  NSObject+CurrentVc.m
//  HYPhotoKitDemo
//
//  Created by Harry on 2017/4/19.
//  Copyright © 2017年 Harry. All rights reserved.
//

#import "NSObject+CurrentVc.h"

@implementation NSObject (CurrentVc)


- (UIViewController *)getCurrentVC
{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] firstObject];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return [self getViewControllerWithVC:nextResponder];
    } else {
        return [self getViewControllerWithVC:window.rootViewController];
    }
}


- (UIViewController *)getViewControllerWithVC:(UIViewController *)vc
{
    if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabVC = (UITabBarController *)vc;
        UINavigationController *navigationController = tabVC.selectedViewController;
        
        if (navigationController.viewControllers.count) {
            vc = navigationController.viewControllers.lastObject;
            if (vc.presentedViewController) {
                vc = vc.presentedViewController;
                return [self getViewControllerWithVC:vc];
            }
        }
    } else if([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)vc;
        if (navigationController.viewControllers.count) {
            vc = navigationController.viewControllers.lastObject;
            if (vc.presentedViewController) {
                vc = vc.presentedViewController;
                return [self getViewControllerWithVC:vc];
            }
        }
    } else {
        vc = vc;
    }
    
    return vc;
}

+ (UIViewController *)getCurrentVC
{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] firstObject];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return [self getViewControllerWithVC:nextResponder];
    } else {
        return [self getViewControllerWithVC:window.rootViewController];
    }

}

+ (UIViewController *)getViewControllerWithVC:(UIViewController *)vc
{
    if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabVC = (UITabBarController *)vc;
        UINavigationController *navigationController = tabVC.selectedViewController;
        
        if (navigationController.viewControllers.count) {
            vc = navigationController.viewControllers.lastObject;
            if (vc.presentedViewController) {
                vc = vc.presentedViewController;
                return [self getViewControllerWithVC:vc];
            }
        }
    } else if([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)vc;
        if (navigationController.viewControllers.count) {
            vc = navigationController.viewControllers.lastObject;
            if (vc.presentedViewController) {
                vc = vc.presentedViewController;
                return [self getViewControllerWithVC:vc];
            }
        }
    } else {
        vc = vc;
    }
    
    return vc;
}



@end
