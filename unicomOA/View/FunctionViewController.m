//
//  FunctionViewController.m
//  unicomOA
//
//  Created by zr-mac on 16/2/15.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "FunctionViewController.h"
#import "UITableGridViewCell.h"
#import "UIImageButton.h"
#import "NotesViewController.h"
#import "NewsManagementViewController.h"
#import "IVotingManamentController.h"
#import "UIView+Frame.h"
#import "WZLBadgeImport.h"
#import "MyShenPiViewController.h"
#import "DataBase.h"
#import "AFNetworking.h"
#import "LXAlertView.h"
#import "UITabBar+badge.h"


#define kImageWidth 100      //UITAbleViewCell里面图片的宽度
#define kImageHeight 100     //UITableViewCell里面图片的高度

@interface FunctionViewController ()<ClearRedDotDelegate,MyShenPiViewControllerDelegate>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIImage *image;

@property (nonatomic,strong) AFHTTPSessionManager *session;

@end

@implementation FunctionViewController {
    DataBase *db;
    UIActivityIndicatorView *indicator;
    NSInteger i_total;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSDictionary * dict;
        if (iPad) {
            dict=@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:25]};
        }
        else {
            dict =@{
                    NSForegroundColorAttributeName:   [UIColor whiteColor]};
        }
        self.title=@"应用";
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.view.backgroundColor=[UIColor yellowColor];
    self.title=@"应用";
    self.view.backgroundColor=[UIColor whiteColor];
    NSDictionary * dict;
    if (iPad) {
        dict=@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:25]};
    }
    else {
        dict =@{
                NSForegroundColorAttributeName:   [UIColor whiteColor]};
        
    }
 
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    
    CGSize mSize=[[UIScreen mainScreen] bounds].size;
    CGFloat screenWidth=mSize.width;
    CGFloat screenHeiht=mSize.height;
    
    [self.tabBarController.tabBar hideBadgeOnItemIndex:2];
    
    indicator=[self AddLoop];

    i_total=0;
    CGFloat i_Height=-1;
    if (iPhone4_4s || iPhone5_5s) {
        i_Height=68;
    }
    else if (iPhone6) {
        i_Height=79;
    }
    else if (iPhone6_plus) {
        i_Height=87;
    }
    else if (iPad) {
        i_Height=211;
    }
    UIImageView *img_View=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, i_Height)];
    if (iPad) {
        img_View.image=[UIImage imageNamed:@"bg_Nav-IPad.png"];
    }
    else {
        img_View.image=[UIImage imageNamed:@"bg_Nav.png"];
    }
    
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeiht) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    self.tableView.dataSource=self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.delegate=self;
    self.tableView.backgroundColor=[UIColor clearColor];
    
   // [self.view addSubview:img_View];
    
    self.view.backgroundColor=[UIColor colorWithRed:244/255.0f green:245/255.0f blue:249/255.0f alpha:1];
    
    db=[DataBase sharedinstanceDB];
    
    _session=[AFHTTPSessionManager manager];
    _session.responseSerializer= [AFHTTPResponseSerializer serializer];
    [_session.requestSerializer setHTTPShouldHandleCookies:YES];
    
    NSMutableDictionary *dic_param1=[NSMutableDictionary dictionary];
    dic_param1[@"pageIndex"]=_str_page;
    [self PrePareData:dic_param1 interface:@"UnFinishTaskShenPiList"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITable datasource and delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


-(UIImageButton *)createImageButton:(CGFloat)x CenterY:(CGFloat)y title:(NSString*)str_title image:(NSString *)str_image {
    UIImageButton *tmp_btn=[UIImageButton buttonWithType:UIButtonTypeCustom];
    if ( iPhone6_plus) {
        tmp_btn.bounds=CGRectMake(0, 0, kImageWidth, kImageHeight);
    }
    else if (iPhone6) {
        tmp_btn.bounds=CGRectMake(0, 0, 92, 92);
    }
    else if (iPhone4_4s || iPhone5_5s) {
        tmp_btn.bounds=CGRectMake(0, 0, 90, 90);

    }
    else if (iPad) {
        tmp_btn.bounds=CGRectMake(0, 0, 160, 160);
    }
    
    
    tmp_btn.center=CGPointMake(x,y);
    [tmp_btn setValue:[NSNumber numberWithInt:0] forKey:@"column"];
    [tmp_btn setTitle:str_title forState:UIControlStateNormal];
    [tmp_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if (iPad) {
        [tmp_btn setTitleEdgeInsets:UIEdgeInsetsMake(50, 0, -150, 0)];
    }
    else if (iPhone5_5s) {
        [tmp_btn setTitleEdgeInsets:UIEdgeInsetsMake(50, 0, -63, 0)];
    }
    else if (iPhone6) {
        [tmp_btn setTitleEdgeInsets:UIEdgeInsetsMake(50, 0, -68, 0)];
    }
    else if (iPhone6_plus) {
        [tmp_btn setTitleEdgeInsets:UIEdgeInsetsMake(50, 0, -73, 0)];
    }

    
    
    
    [tmp_btn setBackgroundImage:[UIImage imageNamed:str_image] forState:UIControlStateNormal];
    
    return tmp_btn;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier=@"Cell";
    //自定义UITableGridViewCell
    UITableGridViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    //if (cell==nil) {
        cell=[[UITableGridViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectedBackgroundView=[[UIView alloc]init];
        NSMutableArray *array=[NSMutableArray array];
        
#pragma mark 添加通知公告图标
        UIImageButton *btn_News;
        UIImageButton *btn_ShenPi;
        UIImageButton *btn_IVoting;
        UIImageButton *btn_Notes;
    
    UIView *line1_1;
    UIView *line1_2;
    
    UIView *line2_1;
    UIView *line2_2;
    UIView *line2_3;
    
        if (iPhone6) {
            btn_News=[self createImageButton:60 CenterY:70 title:@"公告" image:@"News.png"];
            [btn_News addTarget:self action:@selector(NewsItemClick:) forControlEvents:UIControlEventTouchUpInside];
            btn_ShenPi=[self createImageButton:185 CenterY:70 title:@"审批" image:@"ShenPi.png"];
            [btn_ShenPi addTarget:self action:@selector(ShenPiItemClick:) forControlEvents:UIControlEventTouchUpInside];
            btn_IVoting=[self createImageButton:315 CenterY:70 title:@"投票" image:@"IVoting.png"];
            [btn_IVoting addTarget:self action:@selector(IVotingItemClick:) forControlEvents:UIControlEventTouchUpInside];
            btn_Notes=[self createImageButton:60 CenterY:70 title:@"备忘录" image:@"Notes.png"];
            [btn_Notes addTarget:self action:@selector(NotesItemClick:) forControlEvents:UIControlEventTouchUpInside];
            
            line1_1=[[UIView alloc]initWithFrame:CGRectMake(120, 0, 1, 550)];
            line2_1=[[UIView alloc] initWithFrame:CGRectMake(10, 140, [UIScreen mainScreen].bounds.size.width-20, 1)];
            line1_2=[[UIView alloc]initWithFrame:CGRectMake(255, 0, 1, 550)];
            line2_2=[[UIView alloc] initWithFrame:CGRectMake(10, 270, [UIScreen mainScreen].bounds.size.width-20, 1)];
            line2_3=[[UIView alloc] initWithFrame:CGRectMake(10, 400, [UIScreen mainScreen].bounds.size.width-20, 1)];
            
        }
        else if (iPhone5_5s || iPhone4_4s) {
            btn_News=[self createImageButton:55 CenterY:55 title:@"公告" image:@"News.png"];
            [btn_News addTarget:self action:@selector(NewsItemClick:) forControlEvents:UIControlEventTouchUpInside];
            btn_ShenPi=[self createImageButton:165 CenterY:55 title:@"审批" image:@"ShenPi.png"];
            [btn_ShenPi addTarget:self action:@selector(ShenPiItemClick:) forControlEvents:UIControlEventTouchUpInside];
            btn_IVoting=[self createImageButton:270 CenterY:55 title:@"投票" image:@"IVoting.png"];
            [btn_IVoting addTarget:self action:@selector(IVotingItemClick:) forControlEvents:UIControlEventTouchUpInside];
            btn_Notes=[self createImageButton:55 CenterY:55 title:@"备忘录" image:@"Notes.png"];
            [btn_Notes addTarget:self action:@selector(NotesItemClick:) forControlEvents:UIControlEventTouchUpInside];
            
            line1_1=[[UIView alloc]initWithFrame:CGRectMake(110, -20, 1, 470)];
            line2_1=[[UIView alloc] initWithFrame:CGRectMake(10, 130, [UIScreen mainScreen].bounds.size.width-20, 1)];
            line1_2=[[UIView alloc]initWithFrame:CGRectMake(220, -20, 1, 470)];
            line2_2=[[UIView alloc] initWithFrame:CGRectMake(10, 280, [UIScreen mainScreen].bounds.size.width-20, 1)];
            line2_3=[[UIView alloc] initWithFrame:CGRectMake(10, 430, [UIScreen mainScreen].bounds.size.width-20, 1)];

        }
        else if (iPhone6_plus)
        {
                btn_News=[self createImageButton:70 CenterY:75 title:@"公告" image:@"News.png"];
                [btn_News addTarget:self action:@selector(NewsItemClick:) forControlEvents:UIControlEventTouchUpInside];
                btn_ShenPi=[self createImageButton:200 CenterY:75 title:@"审批" image:@"ShenPi.png"];
               [btn_ShenPi addTarget:self action:@selector(ShenPiItemClick:) forControlEvents:UIControlEventTouchUpInside];
                btn_IVoting=[self createImageButton:340 CenterY:75 title:@"投票" image:@"IVoting.png"];
               [btn_IVoting addTarget:self action:@selector(IVotingItemClick:) forControlEvents:UIControlEventTouchUpInside];
                btn_Notes=[self createImageButton:70 CenterY:75 title:@"备忘录" image:@"Notes.png"];
               [btn_Notes addTarget:self action:@selector(NotesItemClick:) forControlEvents:UIControlEventTouchUpInside];
            
            line1_1=[[UIView alloc]initWithFrame:CGRectMake(135, 0, 1, 610)];
            line2_1=[[UIView alloc] initWithFrame:CGRectMake(10, 160, [UIScreen mainScreen].bounds.size.width-20, 1)];
            line1_2=[[UIView alloc]initWithFrame:CGRectMake(270, 0, 1, 610)];
            line2_2=[[UIView alloc] initWithFrame:CGRectMake(10, 310, [UIScreen mainScreen].bounds.size.width-20, 1)];
            line2_3=[[UIView alloc] initWithFrame:CGRectMake(10, 460, [UIScreen mainScreen].bounds.size.width-20, 1)];
        }
        else if (iPad) {
            btn_News=[self createImageButton:122 CenterY:102 title:@"公告" image:@"News.png"];
            [btn_News addTarget:self action:@selector(NewsItemClick:) forControlEvents:UIControlEventTouchUpInside];
            line1_1=[[UIView alloc]initWithFrame:CGRectMake(250, 0, 1, 765)];
            line2_1=[[UIView alloc] initWithFrame:CGRectMake(10, 250, [UIScreen mainScreen].bounds.size.width-20, 1)];
            btn_ShenPi=[self createImageButton:378 CenterY:102 title:@"审批" image:@"ShenPi.png"];
            [btn_ShenPi addTarget:self action:@selector(ShenPiItemClick:) forControlEvents:UIControlEventTouchUpInside];
            line1_2=[[UIView alloc]initWithFrame:CGRectMake(500, 0, 1, 765)];
            line2_2=[[UIView alloc] initWithFrame:CGRectMake(10, 500, [UIScreen mainScreen].bounds.size.width-20, 1)];
            btn_IVoting=[self createImageButton:634 CenterY:102 title:@"投票" image:@"IVoting.png"];
           // [btn_IVoting addTarget:self action:@selector(IVotingItemClick:) forControlEvents:UIControlEventTouchUpInside];
            btn_Notes=[self createImageButton:122 CenterY:102 title:@"备忘录" image:@"Notes.png"];
            [btn_Notes addTarget:self action:@selector(NotesItemClick:) forControlEvents:UIControlEventTouchUpInside];
        }
       // btn_News.badgeBgColor=[UIColor redColor];
       // btn_News.badgeCenterOffset=CGPointMake(0, btn_News.size.height*0.08);
        //[btn_News showBadgeWithStyle:WBadgeStyleRedDot value:1 animationType:WBadgeAnimTypeNone];
        
        if (i_total!=0) {
            btn_ShenPi.badgeBgColor=[UIColor redColor];
            btn_ShenPi.badgeCenterOffset=CGPointMake(0, btn_ShenPi.size.height*0.08);
            [btn_ShenPi showBadgeWithStyle:WBadgeStyleNumber value:i_total animationType:WBadgeAnimTypeNone];
            if (iPad) {
                [btn_ShenPi setBadgeFrame:CGRectMake(btn_ShenPi.badge.frame.origin.x, btn_ShenPi.badge.frame.origin.y, 35, 35)];
                btn_ShenPi.badge.layer.cornerRadius=17.5;
                btn_ShenPi.badge.font=[UIFont systemFontOfSize:18];
               // btn_ShenPi.badge.layer.cornerRadius=btn_ShenPi.badge.frame.size.height*2;
            }

        }
       
    
    line1_1.backgroundColor=[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
    line1_2.backgroundColor=[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
    line2_1.backgroundColor=[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
    line2_2.backgroundColor=[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
    line2_3.backgroundColor=[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
    
    
        if (indexPath.row==0) {
            [cell addSubview:btn_News];
            [cell addSubview:btn_ShenPi];
            [cell addSubview:btn_IVoting];
            [cell addSubview:line1_1];
            [cell addSubview:line1_2];
            [cell addSubview:line2_1];
            [cell addSubview:line2_2];
            [cell addSubview:line2_3];
            cell.backgroundColor=[UIColor colorWithRed:244/255.0f green:245/255.0f blue:249/255.0f alpha:1];
            [array addObject:btn_News];
            [array addObject:btn_ShenPi];
            [array addObject:btn_IVoting];
        }
        else if (indexPath.row==1) {
            [cell addSubview:btn_Notes];
            [array addObject:btn_Notes];
            cell.backgroundColor=[UIColor colorWithRed:244/255.0f green:245/255.0f blue:249/255.0f alpha:1];
        }

        
        [cell setValue:array forKey:@"buttons"];
  //  }
        NSArray *imageButtons=cell.buttons;
        
        [imageButtons setValue:[NSNumber numberWithInt:(int)indexPath.row] forKey:@"row"];
        
        return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (iPad) {
        return 270;
    }
    else if (iPhone6_plus) {
        return 150;
    }
    else if (iPhone5_5s) {
        return 140;
    }
    else {
        return kImageHeight+30;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //不让tableViewcellY有选中效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)NewsItemClick:(UIImageButton *)button {
#pragma mark 控制红点通知
    
    NewsManagementViewController *newsView=[[NewsManagementViewController alloc]init];
    newsView.b_hasnews= button.badge.isHidden;
    newsView.delegate=self;
    newsView.userInfo=_userInfo;
    [self.navigationController pushViewController:newsView animated:YES];
}

-(void)ShenPiItemClick:(UIImageButton *)button {
    /*
    NSString *msg = [NSString stringWithFormat:@"第%i行 第%i列",button.row + 1, button.column + 1];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"好的，知道了"
                                          otherButtonTitles:nil, nil];
    [alert show];
     */
    /*
    ShenPiManagementController *viewController=[[ShenPiManagementController alloc] init];
    viewController.userInfo=_userInfo;
    [self.navigationController pushViewController:viewController animated:YES];
    */
    MyShenPiViewController *viewController=[[MyShenPiViewController alloc] init];
    viewController.userInfo=_userInfo;
    viewController.delegate=self;
    [self.navigationController pushViewController:viewController animated:YES];

}

-(void)IVotingItemClick:(UIImageButton *)button {
    IVotingManamentController *viewController=[[IVotingManamentController alloc]init];
    viewController.user_Info=_userInfo;
    [self.navigationController pushViewController:viewController animated:YES];

}


-(void)NotesItemClick:(UIImageButton *)button {
    NotesViewController *notesView=[[NotesViewController alloc]init];
    notesView.user_Info=_userInfo;
    [self.navigationController pushViewController:notesView animated:YES];
}

-(void)ClearNewsRedDot {
    UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITableGridViewCell *news_cell=(UITableGridViewCell*)cell;
    for (UIView *view in news_cell.subviews) {
        if ([view isMemberOfClass:[UIImageButton class]]) {
            UIImageButton *news_btn=(UIImageButton*)view;
            if ([news_btn.titleLabel.text isEqualToString:@"公告"]) {
                [news_btn clearBadge];
            }
            
        }
    }
    [self.tableView reloadData];
    
}

//点击审批后返回时刷新badgeValue
-(void)RefreshBadge:(NSMutableDictionary*)param {
    NSString *str_connection=[self GetConnectionStatus];
    if ([str_connection isEqualToString:@"wifi"] || [str_connection isEqualToString:@"GPRS"]) {
         NSString *str_ip=@"";
        NSString *str_port=@"";
        NSMutableArray *t_array=[db fetchIPAddress];
        if (t_array.count==1) {
            NSArray *arr_ip=[t_array objectAtIndex:0];
            str_ip=[arr_ip objectAtIndex:0];
            str_port=[arr_ip objectAtIndex:1];
        }
        NSString *str_urldata=[db fetchInterface:@"UnFinishTaskShenPiList"];
        NSString *str_url=[NSString stringWithFormat:@"%@%@:%@%@",@"http://",str_ip,str_port,str_urldata];
        [_session POST:str_url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *JSON=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSString *str_success= [JSON objectForKey:@"success"];
            BOOL b_success=[str_success boolValue];
            if (b_success==YES) {
               NSString *str_totalPage=[JSON objectForKey:@"totalPage"];
                NSMutableDictionary *dic_param1=[NSMutableDictionary dictionary];
                dic_param1[@"pageIndex"]=str_totalPage;
                NSString *str_ip_1=@"";
                NSString *str_port_1=@"";
                NSMutableArray *t_array=[db fetchIPAddress];
                if (t_array.count==1) {
                    NSArray *arr_ip=[t_array objectAtIndex:0];
                    str_ip_1=[arr_ip objectAtIndex:0];
                    str_port_1=[arr_ip objectAtIndex:1];
                }
                NSString *str_urldata_1=[db fetchInterface:@"UnFinishTaskShenPiList"];
                NSString *str_url2=[NSString stringWithFormat:@"%@%@:%@%@",@"http://",str_ip_1,str_port_1,str_urldata_1];
                [_session POST:str_url2 parameters:dic_param1 progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     NSDictionary *JSON1=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    NSArray *arr_TaskList=[JSON1 objectForKey:@"taskList"];
                    NSInteger i_integer=[str_totalPage integerValue];
                    i_total=[arr_TaskList count]+(i_integer-1)*10;
                    [self.tableView reloadData];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                }];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
    }
}

//整理数据
-(void)PrePareData:(NSMutableDictionary*)param interface:(NSString*)str_interface{
    NSString *str_connection=[self GetConnectionStatus];
    if ([str_connection isEqualToString:@"wifi"] || [str_connection isEqualToString:@"GPRS"]) {
        NSString *str_ip=@"";
        NSString *str_port=@"";
        NSMutableArray *t_array=[db fetchIPAddress];
        if (t_array.count==1) {
            NSArray *arr_ip=[t_array objectAtIndex:0];
            str_ip=[arr_ip objectAtIndex:0];
            str_port=[arr_ip objectAtIndex:1];
        }
        NSString *str_urldata=[db fetchInterface:str_interface];
        NSCharacterSet *whitespace = [NSCharacterSet  whitespaceAndNewlineCharacterSet];
        str_urldata= [str_urldata stringByTrimmingCharactersInSet:whitespace];
        NSString *str_url=[NSString stringWithFormat:@"%@%@:%@%@",@"http://",str_ip,str_port,str_urldata];
        [_session POST:str_url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *JSON=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSString *str_success= [JSON objectForKey:@"success"];
            BOOL b_success=[str_success boolValue];
            if (b_success==YES) {
                [indicator stopAnimating];
                NSLog(@"获取审批列表成功");
                NSArray *arr_TaskList=[JSON objectForKey:@"taskList"];
                NSInteger i_integer=[_str_page integerValue];
                i_total=[arr_TaskList count]+(i_integer-1)*10;
                
                
                
                
                 [self.tableView reloadData];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [indicator stopAnimating];
            //停止刷新
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


-(void)RefreshBadgeNumber {
    NSMutableDictionary *dic_param1=[NSMutableDictionary dictionary];
    dic_param1[@"pageIndex"]=@"1";
    [self RefreshBadge:dic_param1];

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

