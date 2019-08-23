//
//  ViewController.m
//  GGMainSliderViewController
//
//  Created by zhaoyan on 2018/2/12.
//  Copyright © 2018年 WGH. All rights reserved.
//

#import "ViewController.h"
#import "GGMainSliderViewController.h"
#import "UIViewController+GGSliderFunc.h"

#define gg_SafeAreaTopHeight ([UIScreen mainScreen].bounds.size.height == 812.0 ? 88 : 64) //iPhone X上NavigationBar高度不一样

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, GGSubSliderVCProtocol>
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, assign) NSInteger gg_type;
@end

@implementation ViewController

- (instancetype)initWithType:(NSInteger)type
{
    if (self = [super init]) {
        self.gg_type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    [self addConstraintSubView:self.tableView superView:self.view top:0 left:0 bottom:0 right:0 height:0];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [self colorArc4random];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10 * _gg_type;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if(!cell){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = [NSString stringWithFormat: @"第%ld页 , 第%ld行",self.gg_type, indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self gg_scrollViewDidScroll:scrollView];
}

- (void)scrollToTop
{
    [self.tableView setContentOffset:CGPointMake(0, 0)];
}

- (UIColor *)colorArc4random {
    
    float red = arc4random()%256 / 255.0;
    float bule = arc4random()%256 / 255.0;
    float green = arc4random()%256 / 255.0;
    
    return [UIColor colorWithRed:red green:green blue:bule alpha:1.0];
}

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
