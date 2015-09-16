//
//  SCImageTools.m
//  QCloudFRDemo
//
//  Created by Aevit on 15/9/9.
//  Copyright (c) 2015年 Aevit. All rights reserved.
//

#import "SCImageTools.h"

@implementation SCImageTools

#pragma mark - ---------------UIViewController---------------
/**
 *  查找最顶层的present的controller（可能是navCon或tabCon或普通的con）
 *
 *  @return UIViewController
 */
+ (UIViewController *)getTopPresentedViewController {
    UIViewController *topViewController = [[[UIApplication sharedApplication].windows objectAtIndex:0] rootViewController];
    while (topViewController.presentedViewController) {
        topViewController = topViewController.presentedViewController;
    }
    
    return topViewController;
}

/**
 *  查找最顶层的present的controller（如果是navCon或tabCon，则查找其最顶层的controller）
 *
 *  @return UIViewController
 */
+ (UIViewController *)getTopViewController {
    UIViewController *topViewController = [[[UIApplication sharedApplication].windows objectAtIndex:0] rootViewController];
    while (topViewController.presentedViewController) {
        topViewController = topViewController.presentedViewController;
    }
    
    if ([topViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController*)topViewController;
        topViewController = [nav.viewControllers lastObject];
    }
    if ([topViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController*)topViewController;
        topViewController = tab.selectedViewController;
    }
    if ([topViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController*)topViewController;
        topViewController = [nav.viewControllers lastObject];
    }
    
    return topViewController;
}

/**
 *  找到当前view所在的controller
 *
 *  @param currView 当前view
 *
 *  @return UIViewController
 */
+ (UIViewController*)viewControllerOfView:(UIView*)currView {
    for (UIView *next = [currView superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

@end
