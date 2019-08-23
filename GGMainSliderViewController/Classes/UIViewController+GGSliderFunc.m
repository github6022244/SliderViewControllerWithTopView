//
//  UIViewController+GGSliderFunc.m
//  GGMainSliderViewController
//
//  Created by zhaoyan on 2018/2/12.
//  Copyright © 2018年 WGH. All rights reserved.
//

#import "UIViewController+GGSliderFunc.h"
#import <objc/runtime.h>

/**< 子控制器滑动到顶部发送的通知名称 */
NSString * const GGSubSliderVCScrollStateNotification = @"GGSubSliderVCScrollStateNotification";

@implementation UIViewController (GGSliderFunc)

#pragma mark 接口
- (void)gg_scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.gg_scrollEnable) {
        [scrollView setContentOffset:CGPointZero];
        return;
    }
    if (scrollView.contentOffset.y <= 0) {
        self.gg_scrollEnable = NO;
        [scrollView setContentOffset:CGPointZero];
        [[NSNotificationCenter defaultCenter] postNotificationName:GGSubSliderVCScrollStateNotification object:nil];
    }
}

#pragma mark set / get
#pragma mark 是否可以滑动
- (BOOL)gg_scrollEnable
{
    NSNumber * enable_num = objc_getAssociatedObject(self, _cmd);
    
    return [enable_num boolValue];
}

- (void)setGg_scrollEnable:(BOOL)gg_scrollEnable
{
    objc_setAssociatedObject(self, @selector(gg_scrollEnable), [NSNumber numberWithBool:gg_scrollEnable], OBJC_ASSOCIATION_RETAIN);
}

@end
