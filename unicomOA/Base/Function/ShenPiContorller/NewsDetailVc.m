//
//  NewsDetailVc.m
//  unicomOA
//
//  Created by hnsi-03 on 16/5/29.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "NewsDetailVc.h"
@import WebKit;

@interface NewsDetailVc ()

@property (strong,nonatomic) WKWebView *wb_content;


@end

@implementation NewsDetailVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=_str_title2;
    
    self.view.backgroundColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1];
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    barButtonItem.tintColor=[UIColor whiteColor];
    [barButtonItem setImage:[UIImage imageNamed:@"returnlogo.png"]];
    self.navigationItem.leftBarButtonItem=barButtonItem;

    
    WKWebViewConfiguration *config=[[WKWebViewConfiguration alloc]init];
    //设置偏好设置
    config.preferences=[[WKPreferences alloc]init];
    config.preferences.minimumFontSize=18;
    config.preferences.javaScriptEnabled=NO;
    config.preferences.javaScriptCanOpenWindowsAutomatically=NO;
    config.processPool=[[WKProcessPool alloc]init];
    
    _wb_content=[[WKWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-120) configuration:config];
    
    NSString *str_headscale=[NSString stringWithFormat:@"%@ %@%@ %@%@ %@",@"<meta",@"name=",@"""viewport""",@"content=",@"""initial-scale=1.0""",@"/>"];
    
    NSString *str_content=[NSString stringWithFormat:@"%@%@",str_headscale,_str_value];
    
    [_wb_content loadHTMLString:str_content baseURL:nil];
    
    [self.view addSubview:_wb_content];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)MovePreviousVc:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
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