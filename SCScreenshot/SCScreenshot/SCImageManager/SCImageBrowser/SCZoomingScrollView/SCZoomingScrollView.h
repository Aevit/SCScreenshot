//
//  SCZoomingScrollView.h
//  SCImagePickerControllerDemo
//
//  Created by Aevit on 15/9/9.
//  Copyright (c) 2015年 Aevit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCTapImageView.h"

@interface SCZoomingScrollView : UIScrollView <UIScrollViewDelegate, SCTapImageViewDelegate>

@property (nonatomic, strong) SCTapImageView *imageView;

- (instancetype)initWithFrame:(CGRect)frame withImage:(UIImage*)image;

@end
