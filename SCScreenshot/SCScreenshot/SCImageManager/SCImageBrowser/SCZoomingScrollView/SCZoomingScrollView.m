//
//  SCZoomingScrollView.m
//  SCImagePickerControllerDemo
//
//  Created by Aevit on 15/9/9.
//  Copyright (c) 2015年 Aevit. All rights reserved.
//

#import "SCZoomingScrollView.h"
#import "SCImageTools.h"

#define SET_MIN_ZOOM_SCALE_TO_ONE 1

static CGFloat statusAndNavBarHeight;

@interface SCZoomingScrollView()

@property (nonatomic, strong) UIImage *image;

@end

@implementation SCZoomingScrollView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withImage:(UIImage*)image {
    self = [super initWithFrame:frame];
    if (self) {
        self.image = image;
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)dealloc {
    self.image = nil;
    self.imageView.image = nil;
}

- (void)commonInit {
    
    self.backgroundColor = [UIColor blackColor];
    
    statusAndNavBarHeight = 0;
    UINavigationController *nav = (UINavigationController*)[SCImageTools getTopPresentedViewController];
    if (nav && [nav isKindOfClass:[UINavigationController class]]) {
        statusAndNavBarHeight = nav.navigationBar.frame.origin.y + nav.navigationBar.frame.size.height;
    }
    
    [self setUp];
}

- (void)setUp {
    
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.decelerationRate = UIScrollViewDecelerationRateFast;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.delegate = self;
    
    if (!_imageView) {
        SCTapImageView *imgView = [[SCTapImageView alloc] initWithImage:_image];
        imgView.tapDelegate = self;
        self.imageView = imgView;
        [self addSubview:_imageView];
    }
    
#if SET_MIN_ZOOM_SCALE_TO_ONE
    // 1. 设置最小zoomScale值为1，计算_imageView的大小为实际在屏幕上显示的大小；使用这种方法的话，画人脸框［不需要］根据最小scale值再去转换
    CGFloat imgViewW = 0;
    CGFloat imgViewH = 0;
    BOOL isHeightFixed = YES;
    
    CGFloat scrollRatio = self.frame.size.width / self.frame.size.height;
    CGFloat imageRatio = _image.size.width / _image.size.height;
    if (scrollRatio > imageRatio) {
        // 高度固定
        isHeightFixed = YES;
        imgViewH = self.frame.size.height - statusAndNavBarHeight;
        imgViewW = imgViewH * (_image.size.width / _image.size.height);
    } else {
        // 宽度固定
        isHeightFixed = NO;
        imgViewW = self.frame.size.width;
        imgViewH = imgViewW / (_image.size.width / _image.size.height);
    }
    _imageView.frame = CGRectMake(0, 0, imgViewW, imgViewH);
    
    self.minimumZoomScale = 1;
    self.maximumZoomScale = (isHeightFixed ? (self.frame.size.width / imgViewW) * 1.5 : (self.frame.size.height - statusAndNavBarHeight) / imgViewH) * 1.5;
#else
    // 2. 设置_imageView的大小为_image的大小，再计算最小zoomScale值；使用这种方法的话，画人脸框［需要］根据最小scale值再去转换
    _imageView.frame = CGRectMake(0, 0, _image.size.width, _image.size.height);
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.frame = CGRectMake((self.frame.size.width - _imageView.frame.size.width) / 2, (self.frame.size.height - _imageView.frame.size.height - statusAndNavBarHeight) / 2, _imageView.frame.size.width, _imageView.frame.size.height);
    
    CGFloat scrollRatio = self.frame.size.width / self.frame.size.height;
    CGFloat imageRatio = _image.size.width / _image.size.height;
    if (scrollRatio > imageRatio) {
        // 高度固定
        self.minimumZoomScale = (self.frame.size.height - statusAndNavBarHeight) / _imageView.frame.size.height;
    } else {
        // 宽度固定
        self.minimumZoomScale = self.frame.size.width / _imageView.frame.size.width;
    }
    self.maximumZoomScale = 2;
    self.zoomScale = self.minimumZoomScale;
    self.contentSize = _imageView.frame.size;
#endif
    
    [self moveViewToCenter:_imageView inScrollView:self];
}


#pragma mark - scrollview zoom delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self moveViewToCenter:_imageView inScrollView:scrollView];
}

#pragma mark - scrollview helper
- (void)moveViewToCenter:(UIView*)aView inScrollView:(UIScrollView*)scrollView {
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) / 2 : 0.0;
    
    // statusAndNavBarHeight may be 0 (when self.navigationController is nil)
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height - statusAndNavBarHeight) ? (scrollView.bounds.size.height - scrollView.contentSize.height - statusAndNavBarHeight) / 2 : 0.0;
    
    aView.center = CGPointMake(scrollView.contentSize.width / 2 + offsetX, scrollView.contentSize.height / 2 + offsetY);
}

#pragma mark - tapDelegate
- (void)imageView:(UIImageView *)imageView doubleTapDetected:(UITouch *)touch {
    [self handleDoubleTap:[touch locationInView:imageView]];
}

// the code below is from https://github.com/mwaterfall/MWPhotoBrowser
- (void)handleDoubleTap:(CGPoint)touchPoint {
    // Cancel any single tap handling
    [NSObject cancelPreviousPerformRequestsWithTarget:[SCImageTools viewControllerOfView:self]];
    
    // Zoom
    if (self.zoomScale != self.minimumZoomScale) {
        // Zoom out
        [self setZoomScale:self.minimumZoomScale animated:YES];
        
    } else {
        
        // Zoom in to twice the size
        CGFloat newZoomScale = ((self.maximumZoomScale + self.minimumZoomScale) / 2);
        CGFloat xsize = self.bounds.size.width / newZoomScale;
        CGFloat ysize = self.bounds.size.height / newZoomScale;
        [self zoomToRect:CGRectMake(touchPoint.x - xsize / 2, touchPoint.y - ysize / 2, xsize, ysize) animated:YES];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
