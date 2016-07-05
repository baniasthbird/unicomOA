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

@interface FunctionViewController ()<MyShenPiViewControllerDelegate>

//@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIImage *image;

@property (nonatomic,strong) AFHTTPSessionManager *session;

@property (nonatomic,strong) UIImageButton *btn_ShenPi;

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
    //CGFloat screenHeiht=mSize.height;
    
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
    
    UILabel *lbl_title1=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-10, 15)];
    lbl_title1.textAlignment=NSTextAlignmentLeft;
    lbl_title1.text=@"快捷办公";
    lbl_title1.textColor=[UIColor blackColor];
    lbl_title1.font=[UIFont systemFontOfSize:14];
    
    UIView *view_part1=[[UIView alloc]initWithFrame:CGRectMake(8, 35, [UIScreen mainScreen].bounds.size.width-16, 80)];
    view_part1.backgroundColor=[UIColor clearColor];
    view_part1.layer.borderWidth=1;
    view_part1.layer.borderColor=[[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1] CGColor];
    
    UIImageButton *btn_News=[self createImageButton:20 y:10 width:60 height:60 title:@"新闻公告" image:@"News.png"];
    [btn_News addTarget:self action:@selector(NewsItemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageButton *btn_IVoting=[self createImageButton:95 y:10 width:60 height:60 title:@"在线投票" image:@"IVoting.png"];
    [btn_IVoting addTarget:self action:@selector(IVotingItemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *lbl_title2=[[UILabel alloc]initWithFrame:CGRectMake(10, 130, [UIScreen mainScreen].bounds.size.width-10, 15)];
    lbl_title2.textAlignment=NSTextAlignmentLeft;
    lbl_title2.text=@"常用审批";
    lbl_title2.textColor=[UIColor blackColor];
    lbl_title2.font=[UIFont systemFontOfSize:14];
    
    UIView *view_part2=[[UIView alloc]initWithFrame:CGRectMake(8, 152, [UIScreen mainScreen].bounds.size.width-16, 160)];
    view_part2.backgroundColor=[UIColor clearColor];
    view_part2.layer.borderWidth=1;
    view_part2.layer.borderColor=[[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1] CGColor];
    
    _btn_ShenPi=[self createImageButton:28 y:162 width:60 height:60 title:@"审批" image:@"ShenPi.png"];
    [_btn_ShenPi addTarget:self action:@selector(ShenPiItemClick:) forControlEvents:UIControlEventTouchUpInside];
    if (i_total!=0) {
        _btn_ShenPi.badgeBgColor=[UIColor redColor];
       // _btn_ShenPi.badgeCenterOffset=CGPointMake(0, _btn_ShenPi.size.height*0.08);
        [_btn_ShenPi showBadgeWithStyle:WBadgeStyleNumber value:i_total animationType:WBadgeAnimTypeNone];
        if (iPad) {
            [_btn_ShenPi setBadgeFrame:CGRectMake(_btn_ShenPi.badge.frame.origin.x, _btn_ShenPi.badge.frame.origin.y, 35, 35)];
            _btn_ShenPi.badge.layer.cornerRadius=17.5;
            _btn_ShenPi.badge.font=[UIFont systemFontOfSize:18];
            // btn_ShenPi.badge.layer.cornerRadius=btn_ShenPi.badge.frame.size.height*2;
        }
        
    }
    
    UILabel *lbl_title3=[[UILabel alloc]initWithFrame:CGRectMake(10, 327, [UIScreen mainScreen].bounds.size.width-10, 15)];
    lbl_title3.textAlignment=NSTextAlignmentLeft;
    lbl_title3.text=@"应用中心";
    lbl_title3.textColor=[UIColor blackColor];
    lbl_title3.font=[UIFont systemFontOfSize:14];
    
    UIView *view_part3=[[UIView alloc]initWithFrame:CGRectMake(8, 349, [UIScreen mainScreen].bounds.size.width-16, 80)];
    view_part3.backgroundColor=[UIColor clearColor];
    view_part3.layer.borderWidth=1;
    view_part3.layer.borderColor=[[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1] CGColor];
    
    UIImageButton *btn_Notes=[self createImageButton:20 y:10 width:60 height:60 title:@"备忘录" image:@"Notes.png"];
    [btn_Notes addTarget:self action:@selector(NotesItemClick:) forControlEvents:UIControlEventTouchUpInside];

    
    
    [self.view addSubview:lbl_title1];
    [self.view addSubview:lbl_title2];
    [self.view addSubview:lbl_title3];
    [view_part1 addSubview:btn_News];
    [view_part1 addSubview:btn_IVoting];
    [self.view addSubview:_btn_ShenPi];
    [view_part3 addSubview:btn_Notes];
    [self.view addSubview:view_part1];
    [self.view addSubview:view_part2];
    [self.view sendSubviewToBack:view_part2];
    [self.view addSubview:view_part3];
    
    /*
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeiht) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    self.tableView.dataSource=self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.delegate=self;
    self.tableView.backgroundColor=[UIColor clearColor];
    */
   // [self.view addSubview:img_View];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
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
/*
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }
    else if (section==1) {
        return 2;
    }
    else {
        return 2;
    }
}
*/

-(UIImageButton *)createImageButton:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height title:(NSString*)str_title image:(NSString *)str_image {
    UIImageButton *tmp_btn=[UIImageButton buttonWithType:UIButtonTypeCustom];
    [tmp_btn setFrame:CGRectMake(x, y, width, height)];
    
    
    [tmp_btn setValue:[NSNumber numberWithInt:0] forKey:@"column"];
    
  //  [tmp_btn setTitle:str_title forState:UIControlStateNormal];
  //  tmp_btn.titleLabel.textColor=[UIColor blackColor];
    //tmp_btn.titleEdgeInsets=UIEdgeInsetsMake(46, 44, 0, 0);
    
    
    [tmp_btn setBackgroundImage:[UIImage imageNamed:str_image] forState:UIControlStateNormal];
    
    return tmp_btn;

}

/*
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
    
    
        if (iPhone6) {
            btn_News=[self createImageButton:60 CenterY:70 title:@"公告" image:@"News.png"];
            [btn_News addTarget:self action:@selector(NewsItemClick:) forControlEvents:UIControlEventTouchUpInside];
            btn_ShenPi=[self createImageButton:185 CenterY:70 title:@"审批" image:@"ShenPi.png"];
            [btn_ShenPi addTarget:self action:@selector(ShenPiItemClick:) forControlEvents:UIControlEventTouchUpInside];
            btn_IVoting=[self createImageButton:315 CenterY:70 title:@"投票" image:@"IVoting.png"];
            [btn_IVoting addTarget:self action:@selector(IVotingItemClick:) forControlEvents:UIControlEventTouchUpInside];
            btn_Notes=[self createImageButton:60 CenterY:70 title:@"备忘录" image:@"Notes.png"];
            [btn_Notes addTarget:self action:@selector(NotesItemClick:) forControlEvents:UIControlEventTouchUpInside];
            
            
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
            
                  }
        else if (iPad) {
            btn_News=[self createImageButton:122 CenterY:102 title:@"公告" image:@"News.png"];
            [btn_News addTarget:self action:@selector(NewsItemClick:) forControlEvents:UIControlEventTouchUpInside];
         
            btn_ShenPi=[self createImageButton:378 CenterY:102 title:@"审批" image:@"ShenPi.png"];
            [btn_ShenPi addTarget:self action:@selector(ShenPiItemClick:) forControlEvents:UIControlEventTouchUpInside];
          
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
       
    
 
    
    
        if (indexPath.row==0) {
            [cell addSubview:btn_News];
            [cell addSubview:btn_ShenPi];
            [cell addSubview:btn_IVoting];
      
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
*/

/*
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
*/
-(void)NewsItemClick:(UIImageButton *)button {
#pragma mark 控制红点通知
    
    NewsManagementViewController *newsView=[[NewsManagementViewController alloc]init];
    newsView.b_hasnews= button.badge.isHidden;
    //newsView.delegate=self;
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

/*
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
*/
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
                    _btn_ShenPi.badgeBgColor=[UIColor redColor];
                    // _btn_ShenPi.badgeCenterOffset=CGPointMake(0, _btn_ShenPi.size.height*0.08);
                    [_btn_ShenPi showBadgeWithStyle:WBadgeStyleNumber value:i_total animationType:WBadgeAnimTypeNone];
                    [self.view setNeedsDisplay];

                  //  [self.tableView reloadData];
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
               // [_btn_ShenPi setNeedsDisplay];
                _btn_ShenPi.badgeBgColor=[UIColor redColor];
                // _btn_ShenPi.badgeCenterOffset=CGPointMake(0, _btn_ShenPi.size.height*0.08);
                [_btn_ShenPi showBadgeWithStyle:WBadgeStyleNumber value:i_total animationType:WBadgeAnimTypeNone];
                [self.view setNeedsDisplay];
                
                
                
               //  [self.tableView reloadData];
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

