//
//  UIViewController+GGSliderFunc.h
//  GGMainSliderViewController
//
//  Created by zhaoyan on 2018/2/12.
//  Copyright © 2018年 WGH. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString * const GGSubSliderVCScrollStateNotification;

@interface UIViewController (GGSliderFunc)

@property (nonatomic, assign) BOOL gg_scrollEnable;/**< 是否能够滑动 */

/**
 子控制器需要遵循 UIScrollViewDelegate
 
 并且实现 - (void)scrollViewDidScroll:(UIScrollView *)scrollView;
 在此代理方法中 调用 [self gg_scrollViewDidScroll:scrollView];

 @param scrollView 子控制器的scrollView
 */
- (void)gg_scrollViewDidScroll:(UIScrollView *)scrollView;
@end
