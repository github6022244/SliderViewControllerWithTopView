//
//  GGMainSliderViewController.h
//  GGMainSliderViewController
//
//  Created by zhaoyan on 2018/2/12.
//  Copyright © 2018年 WGH. All rights reserved.
//  类似新浪微博个人中心页面的控制器

#import <UIKit/UIKit.h>
#import "UIViewController+GGSliderFunc.h"

/**<
 主控制器回调
 */
@protocol GGMainSliderViewControllerDelegate <NSObject>
/**< 子控制器滑动结束回调 */
- (void)ggMainSliderViewControllerSliderSubVCToIndex:(NSInteger)index;
/**< 子控制器滑动中回调 */
- (void)ggMainSliderViewControllerSliderSubVCWithContentOffset:(CGPoint)contentOffset;
@end

/**<
 子控制器需要实现的协议
 */
@protocol GGSubSliderVCProtocol <NSObject>
/**
 滑动到顶部
 注意使用 setContentOffset: 方法，不要使用系统的 scrollToTop, 因为此时的子控制器scrollView可能处于不可滑动状态
 */
- (void)scrollToTop;
@end

@interface GGMainSliderViewController : UIViewController<GGMainSliderViewControllerDelegate>
/**< readonly */
@property (nonatomic, strong, readonly) UIScrollView * backScrollView;/**< 背景scrollView */
@property (nonatomic, strong, readonly) UICollectionView * gg_pageCollectionView;/**< 存放子控制器的vc */
/**<
 子类需要配置的属性
 只能在 - (void)initializeProperty NS_REQUIRES_SUPER; 方法里配置
 */
@property (nonatomic, assign) CGFloat pageVCHeight;/**< gg_pageViewController.view的高度 */
@property (nonatomic, strong) UIView * topView;/**< 顶部视图 */
@property (nonatomic, assign) CGFloat stopTopSpace;/**< 顶部视图留在主控制器上的高度 */
@property (nonatomic, strong) NSArray<UIViewController<GGSubSliderVCProtocol> *> * viewControllers;/**< 子控制器<遵循协议 GGSubSliderVCProtocol 并实现 scrollToTop 方法及功能> */

/**
 初始化配置
 子类重写
 */
- (void)initializeProperty NS_REQUIRES_SUPER;

/**
 展示某个控制器

 @param tag 下标
 */
- (void)showViewControllerWithTag:(NSInteger)tag;
@end



@interface GGMainSliderView : UIScrollView

@end
