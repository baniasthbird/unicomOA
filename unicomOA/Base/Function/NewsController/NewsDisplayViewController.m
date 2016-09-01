//
//  NewsDisplayViewController.m
//  unicomOA
//
//  Created by zr-mac on 16/3/11.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "NewsDisplayViewController.h"
#import "CommentViewController.h"
#import "DataBase.h"
#import "AFNetworking.h"
#import "UILabel+LabelHeightAndWidth.h"
#import "LXAlertView.h"



@interface NewsDisplayViewController ()<WKNavigationDelegate> {
    NSURLSessionDownloadTask *_downloadTask;
}

@property (nonatomic,strong) AFHTTPSessionManager *session;

@property (nonatomic,strong) NSMutableDictionary *param;

@property (nonatomic,strong) NSString *str_headscale;

@property CGFloat h_depart;

@property CGFloat h_title;


@end

@implementation NewsDisplayViewController {
    DataBase *db;
    
    UIActivityIndicatorView *indicator;
    
    NSURL *str_download_path;
}


@synthesize delegate;

int i_num;

int i_comment_num;

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
   // [self.navigationController.navigationBar setFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 44)];
   // [self.navigationController.navigationBar setHidden:NO];
  //  self.navigationController.navigationBar.backgroundColor=[UIColor blackColor];
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    barButtonItem.tintColor=[UIColor whiteColor];
    [barButtonItem setImage:[UIImage imageNamed:@"returnlogo.png"]];
    
    //[barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    
    UIButton *btn_back=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btn_back setImage:[UIImage imageNamed:@"returnlogo.png"] forState:UIControlStateNormal];
    [btn_back setBackgroundColor:[UIColor blueColor]];
    [btn_back addTarget:self action:@selector(MovePreviousVc:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
  //  [self.view addSubview:btn_back];
    indicator=[self AddLoop];
    
    db=[DataBase sharedinstanceDB];
    
    _session=[AFHTTPSessionManager manager];
    _session.responseSerializer= [AFHTTPResponseSerializer serializer];
    [_session.requestSerializer setHTTPShouldHandleCookies:YES];
    [_session.requestSerializer setTimeoutInterval:10.0f];
    
    _param=[NSMutableDictionary dictionary];
    _param[@"id"]=[NSString stringWithFormat:@"%ld",(long)_news_index];
    

    [self NewsContent:_param];
    
  
    _lbl_label=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/32, 5, 15*self.view.frame.size.width/16, self.view.frame.size.height*0.2)];
    
    _lbl_label.numberOfLines=0;
   
    [_lbl_label setLineBreakMode:NSLineBreakByWordWrapping];
    _lbl_label.font=[UIFont systemFontOfSize:24];
    _lbl_label.textColor=[UIColor blackColor];
    _lbl_label.text=_str_label;
    _h_title=[UILabel_LabelHeightAndWidth getHeightByWidth:_lbl_label.frame.size.width title:_str_label font:[UIFont systemFontOfSize:24]];
    _lbl_label.frame=CGRectMake(self.view.frame.size.width/32, 10, 15*self.view.frame.size.width/16, _h_title);
    _lbl_label.textAlignment=NSTextAlignmentCenter;
    //[_lbl_label sizeToFit];
    
    
    _lbl_depart=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/32, _h_title+15, 15*self.view.frame.size.width/16, self.view.frame.size.height*0.02)];
    _lbl_depart.numberOfLines=1;
    [_lbl_depart setLineBreakMode:NSLineBreakByWordWrapping];
    _lbl_depart.textColor=[UIColor lightGrayColor];
    _lbl_depart.font=[UIFont systemFontOfSize:14];
    _lbl_depart.textAlignment=NSTextAlignmentCenter;
    _lbl_depart.text=[NSString stringWithFormat:@"     %@       %@  %@",_str_depart,_str_operator,_str_time];
    
    
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

    
    
   
    _wb_content=[[WKWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-40) configuration:config];
    _wb_content.navigationDelegate=self;
         //_txt_content=[[UITextView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/32, self.view.frame.size.height*0.20, 15*self.view.frame.size.width/16, self.view.frame.size.height*0.51)];
    
    
    _str_headscale=[NSString stringWithFormat:@"%@ %@%@ %@%@ %@",@"<meta",@"name=",@"""viewport""",@"content=",@"""initial-scale=1.0""",@"/>"];
    //[_lbl_content setLineBreakMode:NSLineBreakByWordWrapping];
    
    //_txt_content.font=[UIFont systemFontOfSize:14];
    //_txt_content.textColor=[UIColor blackColor];
    //_txt_content.text=@"国务院有关部门、直属机构，各省、自治区、直辖市发展改革委、物价局：\n        为贯彻落实党的十八届三中全会精神和国务院关于进一步简政放权、推进职能转变的要求，根据当前市场竞争情况，经商住房和城乡建设部同意，决定放开部分建设项目服务收费标准。现就有关事项通知如下：\n        放开除政府投资项目及政府委托服务以外的建设项目前期工作咨询、工程勘察设计、招标代理、工程监理等4项服务收费标准，实行市场调节价。采用直接投资和资本金注入的政府投资项目，以及政府委托的上述服务收费，继续实行政府指导价管理，执行规定的收费标准；实行市场调节价的专业服务收费，由委托双方依据服务成本、服务质量和市场供求状况等协商确定。\n        各级价格主管部门要强化市场价格监测，加强市场价格行为监管和反价格垄断执法，依法查处各类价格违法行为，维护正常的市场秩序，保障市场主体合法权益。\n        在放开收费标准过程中遇到的问题和建议，请及时报告我委（价格司）。\n        上述规定自2014年8月1日起执行。此前有关规定与本通知不符的，按本通知规定执行。\n                   国家发展改革委                2014年7月10日";
   // _txt_content.scrollEnabled=YES;
   // _txt_content.editable=NO;
   // [self.view addSubview:_lbl_depart];
    //[self.view addSubview:_lbl_label];
    [self.view addSubview:_wb_content];
    
    [indicator startAnimating];
    [self.view addSubview:indicator];

    
   // self.delegate=self;
    
    i_num=0;
    i_comment_num=5;
    
    UILabel *lbl_line;
    
    
    
    
    
#pragma mark 最底下为三个button
    
    UIButton *btn_read;
    UIButton *btn_focus;
    UIButton *btn_comment;
    
    CGFloat i_Height;
    if (iPhone6 || iPhone6_plus) {
        i_Height=self.view.frame.size.height*0.75;
    }
    else {
        i_Height=self.view.frame.size.height*0.72;
    }
    
    lbl_line=[[UILabel alloc]initWithFrame:CGRectMake(0, i_Height,self.view.frame.size.width, 1)];
    lbl_line.backgroundColor=[UIColor lightGrayColor];
    
    
    //[self.view addSubview:lbl_line];
    NSString *str_readnum=[NSString stringWithFormat:@"%@%d",@"阅读",i_num];
    btn_read=[self createButton:0 y:i_Height w:self.view.frame.size.width*0.329 h:self.view.frame.size.height*0.08 title:str_readnum image:@"read"];
   // [btn_read addTarget:self action:@selector(ReadNum:) forControlEvents:UIControlEventTouchUpInside];
    
    btn_focus=[self createButton:self.view.frame.size.width*0.33 y:i_Height w:self.view.frame.size.width*0.329 h:self.view.frame.size.height*0.08 title:@"关注" image:@"focus"];
    [btn_focus addTarget:self action:@selector(FocusEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    btn_comment=[self createButton:self.view.frame.size.width*0.66 y:i_Height w:self.view.frame.size.width*0.34 h:self.view.frame.size.height*0.08 title:@"评论" image:@"comment"];
    [btn_comment addTarget:self action:@selector(CommentEvent:) forControlEvents:UIControlEventTouchUpInside];
    
   // [self.view addSubview:btn_comment];
   // [self.view addSubview:btn_focus];
   // [self.view addSubview:btn_read];
    
    self.view.backgroundColor=[UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)ReadNum:(UIButton*)btn {
    i_num= i_num+1;
    NSString *str_num=[NSString stringWithFormat:@"%d",i_num];
    NSString *str_titile=[NSString stringWithFormat:@"%@%@%@",@"阅读（",str_num,@")"];
    [btn setTitle:str_titile forState:UIControlStateNormal];
}

-(void)FocusEvent:(UIButton*)btn {
    if ([btn.titleLabel.text isEqualToString:@"关注"]) {
        [btn setTitle:@"已关注" forState:UIControlStateNormal];
        [self.delegate passFocusValue:@""];
    }
    else if ([btn.titleLabel.text isEqualToString:@"已关注"]) {
        [btn setTitle:@"关注" forState:UIControlStateNormal];
    }
}

-(void)CommentEvent:(UIButton*)btn {
    CommentViewController *viewController=[[CommentViewController alloc]init];
    viewController.userInfo=_userInfo;
    viewController.news_index=_news_index;
   // viewController.str=[NSString stringWithFormat:@"%d",i_comment_num];
    [self.navigationController pushViewController:viewController animated:NO];
}


-(void)MovePreviousVc:(UIButton*)sender {
    if (f_v<9.0) {
        self.navigationController.delegate=nil;
    }
    [self.navigationController popViewControllerAnimated:NO];
}


-(UIButton*)createButton:(CGFloat)x y:(CGFloat)y w:(CGFloat)w h:(CGFloat)h title:(NSString*)str_title image:(NSString*)str_imgname {
    UIButton *btn_tmp=[[UIButton alloc]initWithFrame:CGRectMake(x, y, w, h)];
    [btn_tmp setTitle:str_title forState:UIControlStateNormal];
    [btn_tmp setTitleColor:[UIColor colorWithRed:25/255.0f green:186/255.0f blue:142/255.0f alpha:1] forState:UIControlStateNormal];
    [btn_tmp.layer setBorderWidth:1.0];
    btn_tmp.layer.borderColor=[[UIColor colorWithRed:185/255.0f green:180/255.0f blue:181/255.0f alpha:1] CGColor];
    [btn_tmp setImage:[UIImage imageNamed:str_imgname] forState:UIControlStateNormal];
    [btn_tmp setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    btn_tmp.titleLabel.font=[UIFont systemFontOfSize:22];
    btn_tmp.titleLabel.textAlignment=NSTextAlignmentCenter;
    
    return btn_tmp;
}



-(void)NewsContent:(NSMutableDictionary*)param {
    NSString *str_connection=[self GetConnectionStatus];
    if ([str_connection isEqualToString:@"wifi"] || [str_connection isEqualToString:@"GPRS"]) {
        NSString *str_newsContent= [db fetchInterface:@"NewsContent"];
        if (_b_News==NO) {
            str_newsContent=@"/default/mobile/oa/com.hnsi.erp.mobile.oa.RulesSearch.detail.biz.ext";
        }
        __block NSString *str_ip=@"";
        __block NSString *str_port=@"";
        NSMutableArray *t_array=[db fetchIPAddress];
        if (t_array.count==1) {
            NSArray *arr_ip=[t_array objectAtIndex:0];
            str_ip=[arr_ip objectAtIndex:0];
            str_port=[arr_ip objectAtIndex:1];
        }
        NSString *str_url=[NSString stringWithFormat:@"%@%@:%@%@",@"http://",str_ip,str_port,str_newsContent];
        [_session POST:str_url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *JSON=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dic_news= [JSON objectForKey:@"news"];
            NSString *str_title=@"";
            NSString *str_departlabel=@"";
            NSString *str_content=@"";
            NSObject *obj_files;
            if (dic_news!=nil) {
                [indicator stopAnimating];
                str_title=[dic_news objectForKey:@"title"];
                _lbl_label.text=str_title; 
                NSString *str_depart=[dic_news objectForKey:@"operationDeptName"];
                NSString *str_operator=[dic_news objectForKey:@"operatorName"];
                NSString *str_date=[dic_news objectForKey:@"addTime"];
                NSArray *arr_date=[str_date componentsSeparatedByString:@" "];
                NSString *str_day=[arr_date objectAtIndex:0];
                str_departlabel=[NSString stringWithFormat:@"%@      %@     %@",str_depart,str_operator,str_day];
                _lbl_depart.text=str_departlabel;
               // _h_depart=[UILabel_LabelHeightAndWidth getHeightByWidth:_lbl_depart.frame.size.width title:str_departlabel font:[UIFont systemFontOfSize:14]];
               // _lbl_depart.frame=CGRectMake(0, _h_title+5, [UIScreen mainScreen].bounds.size.width, _h_depart);
               //  [_lbl_depart sizeToFit];
                str_content=[dic_news objectForKey:@"content"];
                str_content=str_content.lowercaseString;
            }
            else {
                NSDictionary *dic_data = [JSON objectForKey:@"data"];
                if (dic_data!=nil) {
                     [indicator stopAnimating];
                    str_title=[dic_data objectForKey:@"title"];
                    NSString *str_operator=[dic_data objectForKey:@"operatorName"];
                    NSObject *obj=[dic_data objectForKey:@"content"];
                    if (obj==[NSNull null]) {
                        str_content=@"";
                    }
                    else {
                        str_content=(NSString*)obj;
                    }
                    NSString *str_date=[dic_data objectForKey:@"operationTime"];
                    NSArray *arr_date=[str_date componentsSeparatedByString:@" "];
                    NSString *str_day=[arr_date objectAtIndex:0];
                    str_departlabel=[NSString stringWithFormat:@"      %@     %@",str_operator,str_day];
                    str_content=str_content.lowercaseString;
                    obj_files=[dic_data objectForKey:@"files"];
                    if (obj_files!=[NSNull null]) {
                        //zr 如果是ios9可按这种方法打开word文档
                        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"打开附件" style:UIBarButtonItemStyleDone target:self action:@selector(OpenFile:)];
                        barButtonItem.tintColor=[UIColor whiteColor];
                        self.navigationItem.rightBarButtonItem=barButtonItem;
                        [self.view setNeedsDisplay];
                    }
                }
            }
            [self ModifyContent:str_content title:str_title departlabel:str_departlabel ip:str_ip port:str_port file:obj_files];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [indicator stopAnimating];
            LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:@"无法连接到服务器" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
                
            }];
            [alert showLXAlertView];

        }];

    }
    else {
        [indicator stopAnimating];
        LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"警告" message:@"无网络连接" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
            
        }];
        [alert showLXAlertView];
    }
    

}

-(void)ModifyContent:(NSString*)str_content title:(NSString*)str_title departlabel:(NSString*)str_departlabel ip:(NSString*)str_ip port:(NSString*)str_port file:(NSObject*)obj_file{
    if (_b_News==NO) {
        if (obj_file!=[NSNull null]) {
            NSString *str_file=(NSString*)obj_file;
            if (![str_file isEqualToString:@""]) {
                //如果是规章制度，完善str_content
                
                NSArray *arr_content=[str_file componentsSeparatedByString:@"|"];
                NSString *str_file_title=[arr_content objectAtIndex:0];
                NSString *str_file_id=[arr_content objectAtIndex:1];
                NSString *str_file_link=[NSString stringWithFormat:@"%@%@%@%@%@%@",@"http://",str_ip,@":",str_port,@"/default/erp/common/fileUpload/download.jsp?isOpen=false&fileid=",str_file_id];
                [self DownLoadFile:str_file_link title:str_file_title content:str_content];
            //    NSString  *str_link_content=[NSString stringWithFormat:@"%@%@%@%@%@%@%@",@"<p style=\"line-height:180%;\"><a style=\"font-size:16px; color:#0066cc;\" href=\"",str_file_link,@"\"title=\"",str_file_title,@"\">",str_file_title,@"</a></p>"];
                  NSString  *str_link_content=[NSString stringWithFormat:@"%@%@%@%@%@%@",@"<p style=\"line-height:180%;\"><a style=\"font-size:16px;",@"\"title=\"",str_file_title,@"\">",str_file_title,@"</a></p>"];
                //  str_link_content=[NSString stringWithFormat:@"%@%@%@%@",@"<p style=\"line-height:180%; font-size:16px;\">",@"请在PC端查看附件",str_file_title,@"</p>"];
                str_content=[NSString stringWithFormat:@"%@%@",str_content,str_link_content];
            }

        }
    }
    else {
        //替换字号为16号
        NSRange searchRange=NSMakeRange(0, str_content.length);
        NSRange foundRange;
        while (searchRange.location<str_content.length) {
            searchRange.length=str_content.length-searchRange.location;
            foundRange=[str_content rangeOfString:@"font-size:" options:nil range:searchRange];
            // foundRange=[str_content rangeOfString:@"" options:NSStringCompareOptions.foundRange range:<#(NSRange)#>]
            if (foundRange.location!=NSNotFound) {
                searchRange.location=foundRange.location+foundRange.length;
                NSRange fontsizeRange=NSMakeRange(searchRange.location, 4);
                NSString *str_fontsize= [str_content substringWithRange:fontsizeRange];
                NSRange range_keyword=[str_fontsize rangeOfString:@"px"];
                if (range_keyword.location!=NSNotFound) {
                    str_content=[str_content stringByReplacingCharactersInRange:fontsizeRange withString:@"16px"];
                }
                else {
                    NSRange fontsizeRange=NSMakeRange(searchRange.location, 5);
                    str_content=[str_content stringByReplacingCharactersInRange:fontsizeRange withString:@"16px"];
                }
            }
            else {
                break;
            }
        }
        
        //替换行距为180%
        NSRange foundRange2;
        NSRange searchRange2=NSMakeRange(0, str_content.length);
        while (searchRange2.location<str_content.length) {
            searchRange2.length=str_content.length-searchRange2.location;
            foundRange2=[str_content rangeOfString:@"line-height:" options:nil range:searchRange2];
            // foundRange=[str_content rangeOfString:@"" options:NSStringCompareOptions.foundRange range:<#(NSRange)#>]
            if (foundRange2.location!=NSNotFound) {
                searchRange2.location=foundRange2.location+foundRange2.length;
                NSRange searchRange_sub=NSMakeRange(searchRange2.location, str_content.length-searchRange2.location);
                NSRange foundRange_sub=[str_content rangeOfString:@";" options:nil range:searchRange_sub];
                if (foundRange_sub.location-searchRange2.location>9) {
                    foundRange_sub=[str_content rangeOfString:@"\"" options:nil range:searchRange_sub];
                }
                NSRange fontsizeRange=NSMakeRange(searchRange2.location, foundRange_sub.location-searchRange2.location+1);
                NSString *str_fontsize= [str_content substringWithRange:fontsizeRange];
                NSRange range_keyword=[str_fontsize rangeOfString:@";"];
                if (range_keyword.location!=NSNotFound) {
                    str_content=[str_content stringByReplacingCharactersInRange:fontsizeRange withString:@"180%;"];
                }
                else {
                    NSRange range_keyword=[str_fontsize rangeOfString:@"\""];
                    if (range_keyword.location!=NSNotFound) {
                        str_content=[str_content stringByReplacingCharactersInRange:fontsizeRange withString:@"180%\""];
                    }
                    NSRange range_keyword2=[str_fontsize rangeOfString:@"px"];
                    if (range_keyword2.location!=NSNotFound) {
                        NSRange range_keyword3=[str_fontsize rangeOfString:@"\""];
                        if (range_keyword3.location!=NSNotFound) {
                            str_content=[str_content stringByReplacingCharactersInRange:fontsizeRange withString:@"180%\""];
                        }
                        else {
                            str_content=[str_content stringByReplacingCharactersInRange:fontsizeRange withString:@"180%"];
                        }
                        
                    }
                    else {
                        
                    }
                    
                }
                
            }
            else {
                break;
            }
        }
        
        //设置每段前空两行
        NSRange foundRange3;
        NSRange searchRange3=NSMakeRange(0, str_content.length);
        BOOL b_Replace=NO;
        while (searchRange3.location<str_content.length) {
            searchRange3.length=str_content.length-searchRange3.location;
            foundRange3=[str_content rangeOfString:@"text-indent:" options:nil range:searchRange3];
            // foundRange=[str_content rangeOfString:@"" options:NSStringCompareOptions.foundRange range:<#(NSRange)#>]
            if (foundRange3.location!=NSNotFound) {
                searchRange3.location=foundRange3.location+foundRange3.length;
                NSRange searchRange_sub=NSMakeRange(searchRange3.location, str_content.length-searchRange3.location);
                NSRange foundRange_sub=[str_content rangeOfString:@";" options:nil range:searchRange_sub];
                if (foundRange_sub.location-searchRange3.location>9) {
                    foundRange_sub=[str_content rangeOfString:@"\"" options:nil range:searchRange_sub];
                }
                
                NSRange fontsizeRange=NSMakeRange(searchRange3.location, foundRange_sub.location-searchRange3.location+1);
                NSString *str_fontsize= [str_content substringWithRange:fontsizeRange];
                NSRange range_keyword=[str_fontsize rangeOfString:@";"];
                if (range_keyword.location!=NSNotFound) {
                    str_content=[str_content stringByReplacingCharactersInRange:fontsizeRange withString:@"2em;"];
                }
                else {
                    NSRange range_keyword2=[str_fontsize rangeOfString:@"p"];
                    if (range_keyword2.location!=NSNotFound) {
                        fontsizeRange=NSMakeRange(searchRange3.location, 5);
                        str_content=[str_content stringByReplacingCharactersInRange:fontsizeRange withString:@"2em"];
                    }
                }
                b_Replace=YES;
            }
            else {
                break;
            }
        }
        
        
        //若源代码中存在doc、docx、ppt、pptx、xls、xlsx字样的，全部去掉其中的图片
        NSRange range1=[str_content rangeOfString:@"doc"];
        NSRange range2=[str_content rangeOfString:@"xls"];
        NSRange range3=[str_content rangeOfString:@"ppt"];
        NSString *str_tmp_content=@"";
        if (range1.length>0 || range2.length>0 || range3.length>0) {
            
            NSLog(@"找到office文档");
            NSArray *arr_tmp= [str_content componentsSeparatedByString:@"<p"];
            NSMutableArray *arr_new_content=[NSMutableArray arrayWithArray:arr_tmp];
            for (int i=(int)[arr_new_content count]-1;i>-0;i--) {
                NSString *str_tmp=[arr_new_content objectAtIndex:i];
                NSRange rangesub1=[str_tmp rangeOfString:@"doc"];
                NSRange rangesub2=[str_tmp rangeOfString:@"xls"];
                NSRange rangesub3=[str_tmp rangeOfString:@"ppt"];
                if (rangesub1.length>0 || rangesub2.length>0 || rangesub3.length > 0) {
                    // [arr_new_content removeObjectAtIndex:i];
                    NSRange rangesub_img_start= [str_tmp rangeOfString:@"<img style="];
                    NSString *str_img_tmp=[str_tmp substringFromIndex:rangesub_img_start.location];
                    NSRange rangesub_img_end=[str_img_tmp rangeOfString:@"/>"];
                    str_img_tmp=[str_img_tmp substringToIndex:rangesub_img_end.location+2];
                    NSString *str_replace=[str_tmp stringByReplacingOccurrencesOfString:str_img_tmp withString:@""];
                    [arr_new_content setObject:str_replace atIndexedSubscript:i];
                }
            }
            NSLog(@"删减完成");
            
            for (int i=1;i<[arr_new_content count];i++) {
                NSString *str_tmp=[arr_new_content objectAtIndex:i];
                str_tmp=[NSString stringWithFormat:@"%@%@",@"<p",str_tmp];
                str_tmp_content=[NSString stringWithFormat:@"%@%@",str_tmp_content,str_tmp];
            }
            str_content=[NSString stringWithFormat:@"%@%@",[arr_new_content objectAtIndex:0],str_tmp_content];
        }

        //替换图片源
        NSString *str_relplace1=[NSString stringWithFormat:@"%@%@:%@",@"http://",str_ip,str_port];
        NSString *str_relplace2=@"/default/ueditor/jsp/upload/image/";
        NSString *str_replace_after=[NSString stringWithFormat:@"%@%@",str_relplace1,str_relplace2];
        
        str_content=[str_content stringByReplacingOccurrencesOfString:str_relplace2 withString:str_replace_after];
        
        
        NSString *str_replace3=@"href=\"";
        NSString *str_replace_after2=[NSString stringWithFormat:@"%@%@",str_replace3,str_relplace1];
        str_content=[str_content stringByReplacingOccurrencesOfString:str_replace3 withString:str_replace_after2];

    }
    
   
    
    
    NSString *str_title_style1=@"<p style=\"margin-top: 0px; margin-bottom: 0px; padding: 0px; font-size: 24px; text-indent: 0em; font-stretch: normal; line-height: 32px; font-family: &quot;Microsoft Yahei&quot;; color: rgb(64, 64, 64); text-align: center; white-space: normal; background-color: rgb(255, 255, 255);\">";
    
    NSString *str_depart_style1=@"<p style=\"margin-top: 5px; margin-bottom: 0px; padding: 0px; font-size: 12px; text-indent: 0em; font-stretch: normal; line-height: 10px; font-family: &quot;Microsoft Yahei&quot;; color: rgb(117, 117, 117); text-align: center; white-space: normal; background-color: rgb(255, 255, 255);\">";
    
    NSString *str_title_style2=@"</p>";
    NSString *str_title_new=[NSString stringWithFormat:@"%@%@%@",str_title_style1,str_title,str_title_style2];
    
    NSString *str_depart_new=[NSString stringWithFormat:@"%@%@%@",str_depart_style1,str_departlabel,str_title_style2];
    NSString *str_newcontent=[NSString stringWithFormat:@"%@%@%@%@",_str_headscale,str_title_new,str_depart_new,str_content];
    
    [_wb_content loadHTMLString:str_newcontent baseURL:nil];
    
    [self.view setNeedsDisplay];
}

-(NSString*)GetConnectionStatus {
    NSString *currentNetWorkState=[[NSUserDefaults standardUserDefaults] objectForKey:@"connection"];
    return currentNetWorkState;
}




//添加菊花等待图标
-(UIActivityIndicatorView*)AddLoop {
    //初始化:
    UIActivityIndicatorView *l_indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    
    l_indicator.tag = 103;
    
    //设置显示样式,见UIActivityIndicatorViewStyle的定义
    l_indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
    
    //设置背景色
    l_indicator.backgroundColor = [UIColor blackColor];
    
    //设置背景透明
    l_indicator.alpha = 0.5;
    
    //设置背景为圆角矩形
    l_indicator.layer.cornerRadius = 6;
    l_indicator.layer.masksToBounds = YES;
    //设置显示位置
    [l_indicator setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0)];
    return l_indicator;
}


-(void)dealloc {
    
}


-(void)DownLoadFile:(NSString*)str_file_link title:(NSString*)str_file_title content:(NSString*)str_content{
    //远程地址
  //  NSURL *url=[NSURL URLWithString:str_file_link];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:str_file_link];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        str_download_path=filePath;
        
        //zr 如果是ios9可按这种方法打开word文档
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"打开附件" style:UIBarButtonItemStyleDone target:self action:@selector(OpenFile:)];
        barButtonItem.tintColor=[UIColor whiteColor];
        self.navigationItem.rightBarButtonItem=barButtonItem;
        [self.view setNeedsDisplay];
       // [_wb_content loadFileURL:filePath allowingReadAccessToURL:filePath];
       // [self.view setNeedsDisplay];

        
    }];
    [downloadTask resume];

}

-(void)OpenFile:(UIButton*)sender {
    //如果系统是ios9
    CGFloat f_version = [[[UIDevice currentDevice]systemVersion] floatValue];
    if (f_version>9.0f) {
        [_wb_content loadFileURL:str_download_path allowingReadAccessToURL:str_download_path];
    }
    else {
        NSURL *fileURL = [self fileURLForBuggyWKWebView8:str_download_path];
        NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
        [_wb_content loadRequest:request];
    }
    self.navigationItem.rightBarButtonItem=nil;
    [self.view setNeedsDisplay];
}


//将文件copy到tmp目录
- (NSURL *)fileURLForBuggyWKWebView8:(NSURL *)fileURL {
    NSError *error = nil;
    if (!fileURL.fileURL || ![fileURL checkResourceIsReachableAndReturnError:&error]) {
        return nil;
    }
    // Create "/temp/www" directory
    NSFileManager *fileManager= [NSFileManager defaultManager];
    NSURL *temDirURL = [[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:@"www"];
    [fileManager createDirectoryAtURL:temDirURL withIntermediateDirectories:YES attributes:nil error:&error];
    
    NSURL *dstURL = [temDirURL URLByAppendingPathComponent:fileURL.lastPathComponent];
    // Now copy given file to the temp directory
    [fileManager removeItemAtURL:dstURL error:&error];
    [fileManager copyItemAtURL:fileURL toURL:dstURL error:&error];
    // Files in "/temp/www" load flawlesly :)
    return dstURL;
}
/*
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [ webView evaluateJavaScript:@"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth;"
     "var maxwidth = 320;" // UIWebView中显示的图片宽度
     "for(i=1;i <document.images.length;i++){"
     "myimg = document.images[i];"
     "oldwidth = myimg.width;"
     "myimg.width = maxwidth;"
     "}"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);ResizeImages();" completionHandler:nil];
}
*/
/*
 
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
