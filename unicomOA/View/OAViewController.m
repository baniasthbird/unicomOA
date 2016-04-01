//
//  OAViewController.m
//  unicomOA
//
//  Created by zr-mac on 16/2/15.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "OAViewController.h"
#import "NTButton.h"
#import "MessageViewController.h"
#import "ContactViewController.h"
#import "FunctionViewController.h"
#import "SettingViewController.h"
#import "BaseNavigationViewController.h"

@interface OAViewController () {
    UIImageView *_tabBarView;  //自定义的覆盖原先的tabbar控件
    NTButton * _previousBtn;//记录前一次选中的按钮
}

@end

@implementation OAViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.view.backgroundColor = [UIColor grayColor];
        self.title = @"视图";
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /*
    //wsq
    for (UIView* obj in self.tabBar.subviews) {
        if (obj != _tabBarView) {//_tabBarView 应该单独封装。
            [obj removeFromSuperview];
        }
        //        if ([obj isKindOfClass:[]]) {
        //
        //        }
    }
     */
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tabBarView = [[UIImageView alloc]initWithFrame:self.tabBar.bounds];
    _tabBarView.userInteractionEnabled = YES;
    _tabBarView.backgroundColor = [UIColor clearColor];
    //self.view.backgroundColor=[UIColor colorWithRed:70/255.0f green:156/255.0f blue:241/255.0f alpha:1];
    //[self.tabBar addSubview:_tabBarView];
    
    MessageViewController *message=[[MessageViewController alloc]init];
    message.delegate=self;
    
    UINavigationController *navi1=[[BaseNavigationViewController alloc]initWithRootViewController:message];
    
    ContactViewController *contact=[[ContactViewController alloc]init];
    UINavigationController *navi2=[[BaseNavigationViewController alloc]initWithRootViewController:contact];
    
    FunctionViewController *func=[[FunctionViewController alloc]init];
    UINavigationController *navi3=[[UINavigationController alloc]initWithRootViewController:func];
    
    SettingViewController *setting=[[SettingViewController alloc]init];
    UINavigationController *navi4=[[UINavigationController alloc]initWithRootViewController:setting];
    
    self.viewControllers=[NSArray arrayWithObjects:navi1,navi2,navi3,navi4, nil];
    
    [self creatButtonWithNormalName:@"message.png" andSelectName:@"message_selected.png" andTitle:@"" andIndex:0];
    [self creatButtonWithNormalName:@"contact.png" andSelectName:@"contact_selected" andTitle:@"" andIndex:1];
    [self creatButtonWithNormalName:@"appcenter.png" andSelectName:@"appcenter_selected.png" andTitle:@"" andIndex:2];
    [self creatButtonWithNormalName:@"user.png" andSelectName:@"user_selected.png" andTitle:@"" andIndex:3];
    
   // NTButton *button=_tabBarView.subviews[0];
    NTButton *button=self.tabBar.subviews[0];
    [self changeViewController:button];
    
    UITabBarItem *item= [self.tabBar.items objectAtIndex:2];
    item.badgeValue=@"2";
   // [self.tabBar.items objectAtIndex:2].badgeValue=@"1";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark 创建一个按钮

- (void)creatButtonWithNormalName:(NSString *)normal andSelectName:(NSString *)selected andTitle:(NSString *)title andIndex:(int)index{
    
    NTButton * customButton = [NTButton buttonWithType:UIButtonTypeCustom];
    customButton.tag = index;
    
    CGFloat buttonW = self.tabBar.frame.size.width/4;
    CGFloat buttonH = self.tabBar.frame.size.height;
    
    customButton.frame=CGRectMake(buttonW*index, 0, buttonW, buttonH);
    /*
    if (iPhone5_5s || iPhone4_4s) {
        customButton.frame = CGRectMake(80 * index, 0, buttonW, buttonH);
    }
    else if (iPhone6) {
        customButton.frame = CGRectMake(90 * index, 0, buttonW, buttonH);
    }
    else if (iPhone6_plus) {
        customButton.frame = CGRectMake(100 * index, 0, buttonW, buttonH);
    }
    */
    [customButton setImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
    //[customButton setImage:[UIImage imageNamed:selected] forState:UIControlStateDisabled];
    //这里应该设置选中状态的图片。wsq
    [customButton setImage:[UIImage imageNamed:selected] forState:UIControlStateSelected];
    [customButton setTitle:title forState:UIControlStateNormal];
    
    [customButton addTarget:self action:@selector(changeViewController:) forControlEvents:UIControlEventTouchDown];
    
    customButton.imageView.contentMode = UIViewContentModeCenter;
    customButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    customButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [customButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
   // [_tabBarView addSubview:customButton];
    [self.tabBar addSubview:customButton];
    
    
    if(index == 0)//设置第一个选择项。（默认选择项） wsq
    {
        _previousBtn = customButton;
        _previousBtn.selected = YES;
    }
    
}


#pragma mark 按钮被点击时调用
- (void)changeViewController:(NTButton *)sender
{
    if(self.selectedIndex != sender.tag){ //wsq®
        self.selectedIndex = sender.tag; //切换不同控制器的界面
        _previousBtn.selected = ! _previousBtn.selected;
        _previousBtn = sender;
        _previousBtn.selected = YES;
    }
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
