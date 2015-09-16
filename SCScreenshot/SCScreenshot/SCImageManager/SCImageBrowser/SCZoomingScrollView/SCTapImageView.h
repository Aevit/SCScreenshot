//
//  SCTapImageView.h
//  QCloudFRDemo
//
//  Created by Aevit on 15/9/9.
//  Copyright (c) 2015年 Aevit. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCTapImageViewDelegate;

@interface SCTapImageView : UIImageView

@property (nonatomic, weak) id <SCTapImageViewDelegate> tapDelegate;
@property (nonatomic, assign) BOOL fixFrameToZoomOne;

+ (CGRect)fixScaleFrame:(CGRect)frame inScrollView:(UIScrollView*)scrollView;

@end


@protocol SCTapImageViewDelegate <NSObject>

@optional
- (void)imageView:(UIImageView *)imageView singleTapDetected:(UITouch *)touch;
- (void)imageView:(UIImageView *)imageView doubleTapDetected:(UITouch *)touch;
- (void)imageView:(UIImageView *)imageView tripleTapDetected:(UITouch *)touch;

@end
