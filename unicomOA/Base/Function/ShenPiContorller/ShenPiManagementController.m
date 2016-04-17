//
//  ShenPiManagementController.m
//  unicomOA
//
//  Created by hnsi-03 on 16/4/6.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "ShenPiManagementController.h"
#import "MyApplication.h"
#import "MyShenPiViewController.h"
#import "NewApplication.h"
#import "SendMeViewController.h"

@interface ShenPiManagementController()<MyApplicationDelegate,NewApplicationDelegate>

@property (nonatomic,strong) NSMutableArray *arr_application;

@end


@implementation ShenPiManagementController


-(void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"审批";
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    barButtonItem.tintColor=[UIColor whiteColor];
    [barButtonItem setImage:[UIImage imageNamed:@"returnlogo.png"]];
    
    [barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    self.view.backgroundColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1];
    
    UIButton *btn_myApplication;
    UIButton *btn_myApproval;
    UIButton *btn_sendme;
    UIButton *btn_newApplication;
    //我的申请
    if (iPhone5_5s) {
        btn_myApplication=[self CreateButton:self.view.frame.size.width*0.02 y:self.view.frame.size.height*0.135 w:self.view.frame.size.width*0.96 h:self.view.frame.size.height*0.17 bgred:2.0f bggreen:166.0f bgblue:228.0f title:@"我的申请" icon:@"myApplication.png"];
        btn_myApproval=[self CreateButton:self.view.frame.size.width*0.02 y:self.view.frame.size.height*0.32 w:self.view.frame.size.width*0.96 h:self.view.frame.size.height*0.17 bgred:28.0f bggreen:193.0f bgblue:255.0f title:@"我的审批" icon:@"myApproval.png"];
        btn_sendme=[self CreateButton:self.view.frame.size.width*0.02 y:self.view.frame.size.height*0.505 w:self.view.frame.size.width*0.96 h:self.view.frame.size.height*0.17 bgred:75.0f bggreen:206.0f bgblue:255.0f title:@"抄送给我" icon:@"SendMe.png"];
        btn_newApplication=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.38, self.view.frame.size.height*0.67, self.view.frame.size.width*0.4, self.view.frame.size.height*0.2)];
        [btn_newApplication setImage:[UIImage imageNamed:@"newApplication.png"] forState:UIControlStateNormal];
        [btn_newApplication setTitle:@"新建申请" forState:UIControlStateNormal];
        [btn_newApplication setTitleColor:[UIColor colorWithRed:0/255.0f green:165/255.0f blue:227/255.0f alpha:1] forState:UIControlStateNormal];
        btn_newApplication.titleLabel.font=[UIFont boldSystemFontOfSize:16];
        btn_newApplication.titleLabel.textAlignment=NSTextAlignmentCenter;
        btn_newApplication.titleEdgeInsets=UIEdgeInsetsMake(0, -120, -85, 0);
    }
    else {
        btn_myApplication=[self CreateButton:self.view.frame.size.width*0.02 y:self.view.frame.size.height*0.115 w:self.view.frame.size.width*0.96 h:self.view.frame.size.height*0.17 bgred:2.0f bggreen:166.0f bgblue:228.0f title:@"我的申请" icon:@"myApplication.png"];
        btn_myApproval=[self CreateButton:self.view.frame.size.width*0.02 y:self.view.frame.size.height*0.3 w:self.view.frame.size.width*0.96 h:self.view.frame.size.height*0.17 bgred:28.0f bggreen:193.0f bgblue:255.0f title:@"我的审批" icon:@"myApproval.png"];
        btn_sendme=[self CreateButton:self.view.frame.size.width*0.02 y:self.view.frame.size.height*0.485 w:self.view.frame.size.width*0.96 h:self.view.frame.size.height*0.17 bgred:75.0f bggreen:206.0f bgblue:255.0f title:@"抄送给我" icon:@"SendMe.png"];
        btn_newApplication=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.38, self.view.frame.size.height*0.65, self.view.frame.size.width*0.4, self.view.frame.size.height*0.2)];
        [btn_newApplication setImage:[UIImage imageNamed:@"newApplication.png"] forState:UIControlStateNormal];
        [btn_newApplication setTitle:@"新建申请" forState:UIControlStateNormal];
        [btn_newApplication setTitleColor:[UIColor colorWithRed:0/255.0f green:165/255.0f blue:227/255.0f alpha:1] forState:UIControlStateNormal];
        btn_newApplication.titleLabel.font=[UIFont boldSystemFontOfSize:16];
        btn_newApplication.titleLabel.textAlignment=NSTextAlignmentCenter;
        if (iPhone6) {
            btn_newApplication.titleEdgeInsets=UIEdgeInsetsMake(0, -130, -85, 0);
        }
        else if (iPhone6_plus) {
            btn_newApplication.titleEdgeInsets=UIEdgeInsetsMake(0, -135, -85, 0);
        }
        
    }
    
    
   
    
    
    
    [btn_myApplication addTarget:self action:@selector(MyApplication:) forControlEvents:UIControlEventTouchUpInside];
    [btn_myApproval addTarget:self action:@selector(MyApproval:) forControlEvents:UIControlEventTouchUpInside];
    [btn_sendme addTarget:self action:@selector(SendMe:) forControlEvents:UIControlEventTouchUpInside];
    [btn_newApplication addTarget:self action:@selector(NewApplication:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn_myApplication];
    [self.view addSubview:btn_myApproval];
    [self.view addSubview:btn_sendme];
    [self.view addSubview:btn_newApplication];
    
    _arr_application=[[NSMutableArray alloc]initWithCapacity:0];

}

-(UIButton*)CreateButton:(CGFloat)x y:(CGFloat)y w:(CGFloat)width h:(CGFloat)height bgred:(CGFloat)red bggreen:(CGFloat)green bgblue:(CGFloat)blue title:(NSString*)str_title icon:(NSString*)str_icon {
    UIButton *tmp_btn=[[UIButton alloc]initWithFrame:CGRectMake(x, y, width, height)];
    [tmp_btn setBackgroundColor:[UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1]];
    [tmp_btn setTitle:str_title forState:UIControlStateNormal];
    tmp_btn.titleLabel.textAlignment=NSTextAlignmentCenter;
    tmp_btn.titleLabel.textColor=[UIColor whiteColor];
    tmp_btn.titleLabel.font=[UIFont boldSystemFontOfSize:13];
    [tmp_btn setImage:[UIImage imageNamed:str_icon] forState:UIControlStateNormal];
    tmp_btn.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 20);
    
    return tmp_btn;
}

-(void)MovePreviousVc:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)MyApplication:(UIButton*)sender {
    MyApplication *viewController=[[MyApplication alloc]init];
    viewController.delegate=self;
    viewController.userInfo=_userInfo;
    viewController.arr_MyApplication=_arr_application;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)MyApproval:(UIButton*)sender {
    MyShenPiViewController *viewController=[[MyShenPiViewController alloc]init];
    viewController.arr_MyShenPi=_arr_application;
    viewController.userInfo=_userInfo;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)SendMe:(UIButton*)sender {
    //抄送给我，文件目前仅供显示
    SendMeViewController *viewController=[[SendMeViewController alloc]init];
    viewController.arr_SendMe=_arr_application;
    viewController.userInfo=_userInfo;
    [self.navigationController pushViewController:viewController animated:YES];

}

-(void)NewApplication:(UIButton*)sender {
    NewApplication *viewController=[[NewApplication alloc]init];
    viewController.userInfo=_userInfo;
    viewController.delegate=self;
    [self.navigationController pushViewController:viewController animated:YES];
    
}

-(void)PassArray:(NSMutableArray *)arr__MyApplication {
    _arr_application=arr__MyApplication;
}

-(void)PassValueFromCarApplication:(NSString *)str_title CarObject:(CarService *)service {
    
}

-(void)PassValueFromPrintApplication:(NSString *)str_title PrintObject:(PrintService *)service {
    
}

@end
