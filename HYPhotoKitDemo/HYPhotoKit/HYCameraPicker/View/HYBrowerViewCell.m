//
//  HYBrowerViewCell.m
//  HYPhotoKitDemo
//
//  Created by Harry on 2017/4/21.
//  Copyright © 2017年 Harry. All rights reserved.
//

#import "HYBrowerViewCell.h"

@interface HYBrowerViewCell() <UIScrollViewDelegate> {
    CGFloat _browser_width;
    CGFloat _browser_height;
}

@property (nonatomic, strong) UIScrollView *scaleView;

@property (nonatomic, strong) UIImageView *photoImageView;

@end

@implementation HYBrowerViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self initConfigSetting];
    }
    return self;
}


#pragma mark - <初始化>

- (void)initConfigSetting
{
    _browser_width = self.frame.size.width;
    _browser_height = self.frame.size.height;

    [self.contentView addSubview:self.scaleView];
    [self.scaleView addSubview:self.photoImageView];
    
    UITapGestureRecognizer *doubleTap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapHandle:)];
    doubleTap.numberOfTapsRequired = 2;
    [_photoImageView addGestureRecognizer:doubleTap];
}


#pragma mark - <双击>

- (void)doubleTapHandle:(UITapGestureRecognizer *)sender
{
    if (_scaleView.zoomScale > 1.0) {
        [_scaleView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint touchPoint = [sender locationInView:self.photoImageView];
        CGFloat maxScale = _scaleView.maximumZoomScale;
        CGFloat xsize = self.frame.size.width / maxScale;
        CGFloat ysize = self.frame.size.height / maxScale;
        [_scaleView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}


#pragma mark - <改变frame>

- (void)changeFrameWithImage:(UIImage *)image
{
    CGFloat height = image.size.height / image.size.width * _browser_width;
    self.photoImageView.frame = CGRectMake(0, 0, _browser_width, height);
    self.photoImageView.center = CGPointMake(_browser_width / 2, _browser_height / 2);
    _scaleView.contentSize = CGSizeMake(_browser_width, MAX(self.photoImageView.frame.size.height, _browser_height));
}


#pragma mark - <加载图片>

- (void)loadPicData:(UIImage *)image
{
    if (image != nil) {
        [self changeFrameWithImage:image];
        self.photoImageView.image = image;
    }
}

- (void)recoverSubview
{
    [_scaleView setZoomScale:1.0 animated:NO];
}

#pragma mark - <UIScrollViewDelegate>

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _photoImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    _photoImageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                        scrollView.contentSize.height * 0.5 + offsetY);
}



#pragma mark - <lazy>

- (UIScrollView *)scaleView
{
    if (_scaleView == nil) {
        _scaleView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, _browser_width, _browser_height)];
        _scaleView.delegate = self;
        _scaleView.maximumZoomScale = 2.5;
        _scaleView.minimumZoomScale = 1.0;
        _scaleView.bouncesZoom = YES;
        _scaleView.multipleTouchEnabled = YES;
        _scaleView.delegate = self;
        _scaleView.scrollsToTop = NO;
        _scaleView.showsHorizontalScrollIndicator = NO;
        _scaleView.showsVerticalScrollIndicator = NO;
        _scaleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scaleView.delaysContentTouches = NO;
        _scaleView.canCancelContentTouches = YES;
        _scaleView.alwaysBounceVertical = NO;
    }
    return _scaleView;
}

- (UIImageView *)photoImageView
{
    if (_photoImageView == nil) {
        _photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _browser_width, _browser_height)];
        _photoImageView.contentMode = UIViewContentModeScaleAspectFit;
        _photoImageView.userInteractionEnabled = YES;
    }
    return _photoImageView;
}


@end
