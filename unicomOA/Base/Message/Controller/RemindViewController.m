//
//  LYMainViewController.m
//  Page Demo
//
//  Created by 刘勇航 on 16/3/12.
//  Copyright © 2016年 Yonghang Liu. All rights reserved.
//

#define kView_W self.view.frame.size.width
#define kView_H self.view.frame.size.height
#define kPageCount 3
#define kButton_H 50
#define kMrg 10
#define kTag 100

#import "RemindViewController.h"
#import "LYOneViewController.h"
#import "LYTwoViewController.h"
#import "LYThreeViewController.h"
#import "UIView+MGBadgeView.h"

@interface RemindViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong)UIScrollView *scroll;
@property (nonatomic, strong)UIButton *selectBtn;
@property (nonatomic, strong)UIView *pageLine;
@property (nonatomic, assign)NSInteger currentPages;
@property (nonatomic, strong)LYOneViewController *oneVC;
@property (nonatomic, strong)LYTwoViewController *twoVC;
@property (nonatomic, strong)LYThreeViewController *threeVC;
@end

@implementation RemindViewController

- (UIView *)pageLine {
    if (_pageLine == nil) {
        self.pageLine = [[UIView alloc]init];
        _pageLine.backgroundColor = [UIColor redColor];
    }
    return _pageLine;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"工作提醒";
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    [barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    barButtonItem.tintColor=[UIColor whiteColor];
    [barButtonItem setImage:[UIImage imageNamed:@"returnlogo.png"]];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    self.view.backgroundColor=[UIColor whiteColor];

    //设置可以左右滑动的ScrollView
    [self setupScrollView];
    
    //设置控制的每一个子控制器
    [self setupChildViewControll];
    
    //设置分页按钮
    [self setupPageButton:_i_index1 index_2:_i_index2 index_3:_i_index3];
    
    
}
/**
 *  设置可以左右滑动的ScrollView
 */
- (void)setupScrollView{
    self.scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kButton_H , kView_W, kView_H)];
    _scroll.pagingEnabled = YES;
    _scroll.delegate = self;
    _scroll.showsVerticalScrollIndicator = NO;
    //方向锁
    _scroll.directionalLockEnabled = YES;
    //取消自动布局
    self.automaticallyAdjustsScrollViewInsets = NO;
    _scroll.contentSize = CGSizeMake(kView_W * kPageCount, kView_H);
    
    [self.view addSubview:_scroll];
}

/**
 *  设置控制的每一个子控制器
 */
- (void)setupChildViewControll{
    self.oneVC = [[LYOneViewController alloc]init];
    self.twoVC = [[LYTwoViewController alloc]init];
    self.threeVC=[[LYThreeViewController alloc]init];
    
    //指定该控制器为其子控制器
    [self addChildViewController:_oneVC];
    [self addChildViewController:_twoVC];
    [self addChildViewController:_threeVC];
    
    //将视图加入ScrollView上
    [_scroll addSubview:_oneVC.view];
    [_scroll addSubview:_twoVC.view];
    [_scroll addSubview:_threeVC.view];
    
    //设置两个控制器的尺寸
    _twoVC.view.frame = CGRectMake(kView_W, 0, kView_W, kView_H - CGRectGetMinY(self.pageLine.frame));
    _oneVC.view.frame = CGRectMake(0, 0, kView_W, kView_H - CGRectGetMinY(self.pageLine.frame));
    _threeVC.view.frame=CGRectMake(2*kView_W, 0, kView_W, kView_H - CGRectGetMinY(self.pageLine.frame));
}
/**
 *  设置分页按钮
 */
- (void)setupPageButton:(NSInteger)i_index1 index_2:(NSInteger)i_index2 index_3:(NSInteger)i_index3{
    //button的index值应当从0开始
    UIButton *btn = [self setupButtonWithTitle:@"待办流程" Index:0  Badage:i_index1];
    self.selectBtn = btn;
    [btn setBackgroundColor:[UIColor colorWithRed:80/255.0f green:125/255.0f blue:236/255.0f alpha:1]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setupButtonWithTitle:@"公文传阅" Index:1 Badage:i_index2];
    [self setupButtonWithTitle:@"消息提醒" Index:2 Badage:i_index3];
}

- (UIButton *)setupButtonWithTitle:(NSString *)title Index:(NSInteger)index Badage:(NSInteger)i_badage{
    CGFloat y = 0;
    CGFloat w = (kView_W - kMrg * 2)/kPageCount;
    CGFloat h = kButton_H;
    CGFloat x = kMrg + index * w;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:(UIControlStateNormal)];
    btn.frame = CGRectMake(x, y, w, h);
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitleColor:[UIColor colorWithRed:173/255.0f green:173/255.0f blue:173/255.0f alpha:1] forState:(UIControlStateNormal)];
   // [btn setTitleColor:[UIColor whiteColor]  forState:UIControlStateSelected];
    btn.tag = index + kTag;
    [btn.badgeView setBadgeValue:i_badage];
    [btn.badgeView setOutlineWidth:0.0];
    [btn.badgeView setPosition:MGBadgePositionCenterRight];
    [btn.badgeView setBadgeColor:[UIColor redColor]];
    if (iPhone6 || iPhone6_plus) {
       btn.titleEdgeInsets=UIEdgeInsetsMake(0, -30, 0, 0);
    }
    else {
        btn.titleEdgeInsets=UIEdgeInsetsMake(0, -35, 0, 0);
        btn.titleLabel.font=[UIFont systemFontOfSize:14];
    }
    
    
    [btn addTarget:self action:@selector(pageClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    //按钮下方的红线
    self.pageLine.frame = CGRectMake(kMrg, CGRectGetMaxY(btn.frame), w, 2);
    [self.view addSubview:_pageLine];
    return btn;
}
- (void)pageClick:(UIButton *)btn{
    self.currentPages = btn.tag - kTag;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn setBackgroundColor:[UIColor colorWithRed:80/255.0f green:125/255.0f blue:236/255.0f alpha:1]];
    [self gotoCurrentPage];
}
/**
 *  设置选中button的样式
 */
- (void)setupSelectBtn{
    UIButton *btn = [self.view viewWithTag:self.currentPages + kTag];
    if ([self.selectBtn isEqual:btn]) {
        return;
    }
    
    [self.selectBtn setBackgroundColor:[UIColor whiteColor]];
    [self.selectBtn setTitleColor:[UIColor colorWithRed:173/255.0f green:173/255.0f blue:173/255.0f alpha:1] forState:UIControlStateNormal];
    self.selectBtn = btn;
    [btn setBackgroundColor:[UIColor colorWithRed:80/255.0f green:125/255.0f blue:236/255.0f alpha:1]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.pageLine.center = CGPointMake(btn.center.x, CGRectGetMaxY(btn.frame));
}
/**
 *  进入当前的选定页面
 */
- (void)gotoCurrentPage{
    CGRect frame;
    frame.origin.x = self.scroll.frame.size.width * self.currentPages;
    frame.origin.y = 0;
    frame.size = _scroll.frame.size;
    [_scroll scrollRectToVisible:frame animated:YES];
}


#pragma mark - ScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = _scroll.frame.size.width;
    self.currentPages = floor((_scroll.contentOffset.x - pageWidth/2)/pageWidth) + 1;
    
    //设置选中button的样式
    [self setupSelectBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)MovePreviousVc:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
