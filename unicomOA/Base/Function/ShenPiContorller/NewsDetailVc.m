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
    config.preferences.javaScriptEnabled=YES;
    config.preferences.javaScriptCanOpenWindowsAutomatically=YES;
    config.processPool=[[WKProcessPool alloc]init];
    CGFloat i_width= [UIScreen mainScreen].bounds.size.width-20;
    NSString *js =[NSString stringWithFormat: @"var count = document.images.length;for (var i = 0; i < count; i++) {var image = document.images[i];image.style.width=%f;};window.alert('找到' + count + '张图');",i_width];
    // 根据JS字符串初始化WKUserScript对象
    WKUserScript *script = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    // 根据生成的WKUserScript对象，初始化WKWebViewConfiguration
    [config.userContentController addUserScript:script];
    
    _wb_content=[[WKWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-120) configuration:config];
    
    NSString *str_headscale=[NSString stringWithFormat:@"%@ %@%@ %@%@ %@",@"<meta",@"name=",@"""viewport""",@"content=",@"""initial-scale=1.0""",@"/>"];
    
    NSString *str_content=[NSString stringWithFormat:@"%@%@",str_headscale,_str_value];
    
      
    NSString *str_relplace1=[NSString stringWithFormat:@"%@%@:%@",@"http://",_str_ip,_str_port];
    NSString *str_relplace2=@"<img src=\"";
    NSString *str_replace_after=[NSString stringWithFormat:@"%@%@",str_relplace2,str_relplace1];
    
    NSString *str_newcontent=[str_content stringByReplacingOccurrencesOfString:str_relplace2 withString:str_replace_after];
    
    
    [_wb_content loadHTMLString:str_newcontent baseURL:nil];
    
    [self.view addSubview:_wb_content];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)MovePreviousVc:(UIButton*)sender {
    if (f_v<9.0) {
        self.navigationController.delegate=nil;
    }
    [self.navigationController popViewControllerAnimated:NO];
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
