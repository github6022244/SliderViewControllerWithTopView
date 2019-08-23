//
//  MainViewController.m
//  GGMainSliderViewController
//
//  Created by zhaoyan on 2018/2/12.
//  Copyright © 2018年 WGH. All rights reserved.
//

#import "MainViewController.h"
#import "ViewController.h"

#define gg_SafeAreaTopHeight ([UIScreen mainScreen].bounds.size.height == 812.0 ? 88 : 64) //iPhone X上NavigationBar高度不一样
#define TabBar_Height ([UIApplication sharedApplication].statusBarFrame.size.height > 20 ? 83 : 49)

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeProperty
{
    [super initializeProperty];
    
    /**< 顶部视图 */
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200.f)];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200.0f - self.stopTopSpace)];
    [self.topView addSubview:label];
    label.text = @"顶部视图";
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor orangeColor];
    
    UILabel * subLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), self.view.frame.size.width, 44.0f)];
    [self.topView addSubview:subLabel];
    subLabel.text = @"顶部视图 - 上滑能停留置顶的部分";
    subLabel.textAlignment = NSTextAlignmentCenter;
    subLabel.backgroundColor = [UIColor purpleColor];
    
    self.topView.backgroundColor = [UIColor redColor];
    
    /**< 顶部视图留在主控制器上的高度 */
    self.stopTopSpace = 44.0f;
    
    /**< 底部列表控制器的高度 */
//    self.pageVCHeight = self.view.frame.size.height - TabBar_Height - self.stopTopSpace - self.topView.frame.size.height;
    self.pageVCHeight = self.view.frame.size.height - self.stopTopSpace;
    
    /**< 配置列表控制器 */
    NSMutableArray * marr = @[].mutableCopy;
    for (int i = 0; i < 3; i++) {
        ViewController * vc = [[ViewController alloc] initWithType:i + 1];
        [marr addObject:vc];
    }
    
    self.viewControllers = [NSArray arrayWithArray:marr];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
