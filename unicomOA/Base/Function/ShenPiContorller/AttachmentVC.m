//
//  AttachmentVC.m
//  unicomOA
//
//  Created by hnsi-03 on 2016/11/28.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "AttachmentVC.h"

@interface AttachmentVC ()

@end

@implementation AttachmentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"公告详情";
    
    NSDictionary * dict;
    if (iPad) {
        dict=@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:25]};
    }
    else {
        dict =@{
                NSForegroundColorAttributeName:   [UIColor whiteColor]};
    }
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    barButtonItem.tintColor=[UIColor whiteColor];
    [barButtonItem setImage:[UIImage imageNamed:@"returnlogo.png"]];
    
    //[barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    WKWebViewConfiguration *config=[[WKWebViewConfiguration alloc]init];
    //设置偏好设置
    config.preferences=[[WKPreferences alloc]init];
    config.preferences.minimumFontSize=10;
    config.preferences.javaScriptEnabled=YES;
    config.preferences.javaScriptCanOpenWindowsAutomatically=NO;
    config.processPool=[[WKProcessPool alloc]init];
    config.selectionGranularity = WKSelectionGranularityCharacter;
    // CGFloat i_width= [UIScreen mainScreen].bounds.size.width-20;
    // NSString *js =[NSString stringWithFormat: @"var count = document.images.length;\n for (var i = 0; i < count; i++)\n {var image = document.images[i];\n var imgWidth=image.style.width;\n  var imgHeight=image.style.height;\n  var iRatio=imgHeight/imgWidth;\n    var targetHeight=iRatio*%f\n  image.style.width=%f;\n  image.style.height=targetHeight;\n };",i_width,i_width];
    NSString *js=[NSString stringWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"imageResize" ofType:@"js" ] encoding:NSUTF8StringEncoding error:nil];
    // 根据JS字符串初始化WKUserScript对象
    WKUserScript *script = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    // 根据生成的WKUserScript对象，初始化WKWebViewConfiguration
    [config.userContentController addUserScript:script];
    
    NSString *jScript=  @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [config.userContentController addUserScript:wkUScript];
    
    WKWebView *wb_content=[[WKWebView alloc]initWithFrame:CGRectMake(0, 0, Width, Height) configuration:config];
    NSURL *url=[NSURL URLWithString:_str_url];
    NSURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    wb_content.contentMode=UIViewContentModeScaleAspectFit;
    [wb_content loadRequest:request];
    
    
    [self.view addSubview:wb_content];

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
