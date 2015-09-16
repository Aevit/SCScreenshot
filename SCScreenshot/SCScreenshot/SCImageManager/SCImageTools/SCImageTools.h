//
//  SCImageTools.h
//  QCloudFRDemo
//
//  Created by Aevit on 15/9/9.
//  Copyright (c) 2015年 Aevit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SCImageTools : NSObject

#pragma mark - ---------------UIViewController---------------
/**
 *  查找最顶层的present的controller（可能是navCon或tabCon或普通的con）
 *
 *  @return UIViewController
 */
+ (UIViewController *)getTopPresentedViewController;

/**
 *  查找最顶层的present的controller（如果是navCon或tabCon，则查找其最顶层的controller）
 *
 *  @return UIViewController
 */
+ (UIViewController *)getTopViewController;

/**
 *  找到当前view所在的controller
 *
 *  @param currView 当前view
 *
 *  @return UIViewController
 */
+ (UIViewController*)viewControllerOfView:(UIView*)currView;

@end
