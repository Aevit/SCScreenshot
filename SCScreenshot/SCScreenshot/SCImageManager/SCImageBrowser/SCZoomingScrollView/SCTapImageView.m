//
//  SCTapImageView.m
//  QCloudFRDemo
//
//  Created by Aevit on 15/9/9.
//  Copyright (c) 2015年 Aevit. All rights reserved.
//

#import "SCTapImageView.h"

@implementation SCTapImageView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self commonInit];
    }
    return self;
}

- (id)initWithImage:(UIImage *)image {
    if ((self = [super initWithImage:image])) {
        [self commonInit];
    }
    return self;
}

- (id)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage {
    if ((self = [super initWithImage:image highlightedImage:highlightedImage])) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.fixFrameToZoomOne = NO;
    self.userInteractionEnabled = YES;
}

#pragma mark - override
- (void)addSubview:(UIView *)view {
    if (self.fixFrameToZoomOne) {
        UIScrollView *superScrollView = (UIScrollView*)self.superview;
        if (superScrollView && [superScrollView isKindOfClass:[UIScrollView class]]) {
            view.frame = [SCTapImageView fixScaleFrame:view.frame inScrollView:superScrollView];
        }
    }
    [super addSubview:view];
}

#pragma mark - helper
/**
 *  fix the frame of a view when the superview-scrollview is been zoomed
 *
 *  NOTICE: if you want to change the transform of the view, you MUST addSubview first, and then to change the transform
 *
 *  @param frame      will be fixed
 *  @param scrollView surperview of the view will be fixed
 *
 *  @return fixed frame
 */
+ (CGRect)fixScaleFrame:(CGRect)frame inScrollView:(UIScrollView*)scrollView {
    if (!scrollView || scrollView.zoomScale < 0 || scrollView.zoomScale == 1) {
        return frame;
    }
    CGFloat zoomScale = scrollView.zoomScale;
    return CGRectMake(frame.origin.x / zoomScale, frame.origin.y / zoomScale, frame.size.width / zoomScale, frame.size.height / zoomScale);
}

#pragma mark - touch delegate
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSUInteger tapCount = touch.tapCount;
    switch (tapCount) {
        case 1:
            [self handleSingleTap:touch];
            break;
        case 2:
            [self handleDoubleTap:touch];
            break;
        case 3:
            [self handleTripleTap:touch];
            break;
        default:
            break;
    }
    [[self nextResponder] touchesEnded:touches withEvent:event];
}

- (void)handleSingleTap:(UITouch *)touch {
    if ([_tapDelegate respondsToSelector:@selector(imageView:singleTapDetected:)])
        [_tapDelegate imageView:self singleTapDetected:touch];
}

- (void)handleDoubleTap:(UITouch *)touch {
    if ([_tapDelegate respondsToSelector:@selector(imageView:doubleTapDetected:)])
        [_tapDelegate imageView:self doubleTapDetected:touch];
}

- (void)handleTripleTap:(UITouch *)touch {
    if ([_tapDelegate respondsToSelector:@selector(imageView:tripleTapDetected:)])
        [_tapDelegate imageView:self tripleTapDetected:touch];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
