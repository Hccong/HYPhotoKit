//
//  HYCameraFocusView.m
//  HYPhotoKitDemo
//
//  Created by Harry on 2017/4/19.
//  Copyright © 2017年 Harry. All rights reserved.
//

#import "HYCameraFocusView.h"
#import "CommonTool.h"

@interface HYCameraFocusView ()
{
    NSTimer *_timer;
}

@property (nonatomic, strong) UIImageView *focusImageView;

@end

@implementation HYCameraFocusView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.focusImageView];
        _focusImageView.center = self.center;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    _focusImageView.center = point;
    [self addSubview:_focusImageView];
    [self shakeToShow:_focusImageView];
    
    // 用定时器实现延迟隐藏聚焦的图片
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(hideFocusView) userInfo:nil repeats:YES];
    
    self.focusBlock(point);
}


#pragma mark - <为聚焦的图片添加动画>

- (void)shakeToShow:(UIView *)view
{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [view.layer addAnimation:animation forKey:nil];
}

#pragma mark - <隐藏聚焦的图片>

- (void)hideFocusView
{
    [_focusImageView removeFromSuperview];
    [_timer invalidate];
}

#pragma mark - <lazy>

- (UIImageView *)focusImageView
{
    if (_focusImageView == nil) {
        _focusImageView = [[UIImageView alloc] init];
        _focusImageView.image = [CommonTool imageFromCustomBundle:@"camera_focus_pic"];
        _focusImageView.frame = CGRectMake(0, 0, 80, 80);
    }
    return _focusImageView;
}

@end
