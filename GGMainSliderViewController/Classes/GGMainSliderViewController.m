//
//  GGMainSliderViewController.m
//  GGMainSliderViewController
//
//  Created by zhaoyan on 2018/2/12.
//  Copyright © 2018年 WGH. All rights reserved.
//

#import "GGMainSliderViewController.h"

#define gg_ScreenWidth self.view.bounds.size.width
#define gg_ScreenHeight self.view.bounds.size.height

@interface GGMainSliderViewController ()
<UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionViewFlowLayout *gg_pageFlowLayout;/**< 子控制器的FlowLayout */
@property (nonatomic, strong, readwrite) UIScrollView * backScrollView;/**< 背景scrollView */
@property (nonatomic, strong, readwrite) GGMainSliderView * backSliderView;/**< 背景scrollView */
@property (nonatomic, strong, readwrite) UICollectionView * gg_pageCollectionView;/**< 存放子控制器的vc */
@property (nonatomic, assign) CGFloat topSpace;/**< pageView的Y */
@property (nonatomic, assign) BOOL canContentContainerScroll;/**< 背景scrollView是否可以滑动 */
@end

@implementation GGMainSliderViewController

#pragma mark -------------- 生命周期 ---------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeProperty];
    [self gg_setUpUI];
    [self addNotif];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -------------- 代理 ---------------
#pragma mark - UICollectionViewDelegate / UICollectionViewDataSource
#pragma mark  设置CollectionView的组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark  设置CollectionView每组所包含的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewControllers.count;
    
}

#pragma mark  设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"UICollectionViewCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    UIViewController * vc = self.viewControllers[indexPath.item];
    if (!vc.view.superview) {
        [self addChildViewController:vc];
        [cell.contentView addSubview:vc.view];
        vc.view.translatesAutoresizingMaskIntoConstraints = NO;
        //创建左边约束
        NSLayoutConstraint *leftLc = [NSLayoutConstraint constraintWithItem:vc.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        [cell.contentView addConstraint:leftLc];
        
        //创建右边约束
        NSLayoutConstraint *rightLc = [NSLayoutConstraint constraintWithItem:vc.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        [cell.contentView addConstraint:rightLc];
        
        //创建底部约束
        NSLayoutConstraint *bottomLc = [NSLayoutConstraint constraintWithItem:vc.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        [cell.contentView addConstraint:bottomLc];
        
        //创建高度约束
        NSLayoutConstraint *heightLc = [NSLayoutConstraint constraintWithItem:vc.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:_pageVCHeight];
        [vc.view addConstraint: heightLc];
    }
    
    return cell;
}

#pragma mark  定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake(gg_ScreenWidth,_pageVCHeight);
}



#pragma mark  定义整个CollectionViewCell与整个View的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);//（上、左、下、右）
}


#pragma mark  定义每个UICollectionView的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark  定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.backScrollView]) {
        CGFloat offsetThreshold = self.topView.frame.size.height - _stopTopSpace;
        if (scrollView.contentOffset.y >= offsetThreshold) {
            [scrollView setContentOffset:CGPointMake(0.0, offsetThreshold)];
            _canContentContainerScroll = NO;
            // 子视图可以滚动了
            for (UIViewController * vc in _viewControllers) {
                vc.gg_scrollEnable = YES;
            }
        } else {
            if (!_canContentContainerScroll) {
                [scrollView setContentOffset:CGPointMake(0.0, offsetThreshold)];
            }
        }
        
        /**< 取消水平方向回弹效果 */
        if (scrollView.contentOffset.x != 0.0) {
            scrollView.bounces = NO;
        }else
        {
            scrollView.bounces = YES;
        }
    }else
    {
        [self ggMainSliderViewControllerSliderSubVCWithContentOffset:scrollView.contentOffset];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    /**< 如果主scrollView不是处在 topView 停留上方的状态下，子控制器滑动到最顶部 */
    if ([scrollView isEqual:self.backScrollView]) {
        if ((scrollView.contentOffset.y != self.topView.frame.size.height - _stopTopSpace) && [scrollView isEqual:self.backSliderView]) {
            for (UIViewController<GGSubSliderVCProtocol> *vc in _viewControllers) {
                [vc scrollToTop];
            }
        }
    }else
    {
        [self ggMainSliderViewControllerSliderSubVCToIndex:(NSInteger)(scrollView.contentOffset.x / gg_ScreenWidth)];
    }
}

#pragma mark -------------- 接口 ---------------
#pragma mark 配置属性
- (void)initializeProperty
{
    /**< 默认主scrollView可滑动 */
    _canContentContainerScroll = YES;
    
    /**< gg_pageVC.view的高度 */
    _pageVCHeight = self.view.bounds.size.height;
    
    /**< 头部视图 */
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200.0f)];
    
    /**< 顶部试图留在主控制器上的高度 */
    _stopTopSpace = 44.0f;
}

#pragma mark 展示某个下标的控制器
- (void)showViewControllerWithTag:(NSInteger)tag
{
    if (tag > self.viewControllers.count) {
        return;
    }
    
    [self.gg_pageCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathWithIndex:tag] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

#pragma mark 子控制器滑动结束回调
- (void)ggMainSliderViewControllerSliderSubVCToIndex:(NSInteger)index
{
    /**< 子类重写 */
}

#pragma mark 子控制器滑动中回调
- (void)ggMainSliderViewControllerSliderSubVCWithContentOffset:(CGPoint)contentOffset
{
    
}

#pragma mark -------------- 私有方法 ---------------
#pragma mark 布局UI
- (void)gg_setUpUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    /**< 背景scrollView */
    self.backSliderView = [[GGMainSliderView alloc] init];
    [self.view addSubview:self.backSliderView];
    self.backSliderView.delegate = self;
    self.backSliderView.showsVerticalScrollIndicator = NO;
    self.backSliderView.showsHorizontalScrollIndicator = NO;
    self.backScrollView = self.backSliderView;
    [self addConstraintSubView:self.backSliderView superView:self.view top:0 left:0 bottom:0 right:0 height:0];
    
    [self.view layoutIfNeeded];
    
    /**< 头部视图 */
    [self.backSliderView addSubview:self.topView];
    self.topView.frame = CGRectMake(0, 0, self.topView.frame.size.width, self.topView.frame.size.height);
    
    /**< pageCollectionView */
    _gg_pageFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [_gg_pageFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    self.gg_pageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_gg_pageFlowLayout];
    self.gg_pageCollectionView.dataSource = self;
    self.gg_pageCollectionView.delegate = self;
    [self.gg_pageCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    self.gg_pageCollectionView.pagingEnabled = YES;
    self.gg_pageCollectionView.bounces = NO;
    self.gg_pageCollectionView.showsHorizontalScrollIndicator = NO;
    self.gg_pageCollectionView.backgroundColor = [UIColor clearColor];
    [self.backSliderView addSubview:self.gg_pageCollectionView];
    self.gg_pageCollectionView.frame = CGRectMake(0, self.topView.frame.size.height, self.view.frame.size.width, _pageVCHeight);
    
    /**< contentSize */
    self.backSliderView.contentSize = CGSizeMake(self.backSliderView.frame.size.width, self.topView.bounds.size.height + _pageVCHeight);
}

#pragma mark 添加通知
#pragma mark 子控制器滑动到顶部回调
- (void)addNotif
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:GGSubSliderVCScrollStateNotification object:nil];
}

- (void)notificationAction:(NSNotification *)sender {
    _canContentContainerScroll = YES;
    for (UIViewController<GGSubSliderVCProtocol> *vc in _viewControllers) {
        vc.gg_scrollEnable = NO;
        [vc scrollToTop];
    }
}

#pragma mark - Override
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}
#endif

#pragma mark ----------- 内部方法 ------------
#pragma mark 添加约束
- (void)addConstraintSubView:(UIView *)subView superView:(UIView *)superView top:(CGFloat)topSpace left:(CGFloat)leftSpace bottom:(CGFloat)bottomSpace right:(CGFloat)rightSpace height:(CGFloat)heightSpace
{
    subView.translatesAutoresizingMaskIntoConstraints = NO;
    //创建上边约束
    NSLayoutConstraint *topLc = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1.0 constant:topSpace];
    [superView addConstraint:topLc];
    //创建左边约束
    NSLayoutConstraint *leftLc = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace];
    [superView addConstraint:leftLc];
    //创建右边约束
    NSLayoutConstraint *rightLc = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeRight multiplier:1.0 constant:rightSpace];
    [superView addConstraint:rightLc];
    if (!heightSpace) {
        //创建底部约束
        NSLayoutConstraint *bottomLc = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:bottomSpace];
        [superView addConstraint:bottomLc];
    }else
    {
        //创建高度约束
        NSLayoutConstraint *heightLc = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:heightSpace];
        [subView addConstraint: heightLc];
    }
}

@end




@implementation GGMainSliderView

/// 允许同时识别多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
