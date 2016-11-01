//
//  SysMsgDisplayController.m
//  unicomOA
//
//  Created by hnsi-03 on 16/8/1.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "SysMsgDisplayController.h"
#import "DataBase.h"
#import "AFNetworking.h"
#import "BaseFunction.h"

@interface SysMsgDisplayController()<UITableViewDelegate,UITableViewDataSource> {
    }

@property (nonatomic,strong) BaseFunction *baseFunc;
@property (nonatomic,strong) AFHTTPSessionManager *session;

@end

@implementation SysMsgDisplayController {
    DataBase *db;
   // UITableView *tableView;
    NSMutableArray *arr_content;
    UIActivityIndicatorView *indicator;
    UILabel *lbl_sendTitle;
    UILabel *lbl_receiveTitle;
    UILabel *lbl_sendName;
    UILabel *lbl_receiveName;
    UILabel *lbl_sendCompany;
    UILabel *lbl_receiveCompany;
    UIView *view_seperator1;
    UILabel *lbl_SysMsg_Title;
    UILabel *lbl_Time;
    UILabel *lbl_Category;
    UIView *view_seperator2;
    UILabel *lbl_SysMsg_Content1;
    UILabel *lbl_SysMsg_Content2;
    UILabel *lbl_sYSmsg_Content3;
    CGFloat i_FontSize1;
    CGFloat i_FontSize2;
    
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title=_str_title;
    
    if (iPhone5_5s) {
        i_FontSize1=14;
        i_FontSize2=13;
    }
    else if (iPhone6) {
        i_FontSize1=16;
        i_FontSize2=15;
    }
    else if (iPhone6_plus) {
        i_FontSize1=17;
        i_FontSize2=16;
    }
    
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
    
    self.view.backgroundColor=[UIColor colorWithRed:246/255.0f green:249/255.0f blue:254/255.0f alpha:1];
    
    lbl_sendTitle=[[UILabel alloc]initWithFrame:CGRectMake(0.0667*Width, 0.027*Height, 0.2*Width, 0.024*Height)];
    lbl_sendTitle.textColor=[UIColor blackColor];
    lbl_sendTitle.font=[UIFont systemFontOfSize:i_FontSize1];
    lbl_sendTitle.text=@"发送人：";
    [lbl_sendTitle sizeToFit];
    
    lbl_receiveTitle=[[UILabel alloc]initWithFrame:CGRectMake(0.0667*Width, 0.070464767616192*Height, 0.2*Width, 0.024*Height)];
    lbl_receiveTitle.textColor=[UIColor blackColor];
    lbl_receiveTitle.font=[UIFont systemFontOfSize:i_FontSize1];
    lbl_receiveTitle.text=@"接收人：";
    [lbl_receiveTitle sizeToFit];
    
    lbl_sendName=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lbl_sendTitle.frame)+10, 0.027*Height, 0.16*Width, 0.024*Height)];
    lbl_sendName.textColor=[UIColor colorWithRed:85/255.0f green:132/255.0f blue:241/255.0f alpha:1];
    lbl_sendName.font=[UIFont systemFontOfSize:i_FontSize1];
    lbl_sendName.text=_str_sendName;
    [lbl_sendName sizeToFit];
    
    lbl_receiveName=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lbl_sendTitle.frame)+10, 0.070464767616192*Height, 0.16*Width, 0.024*Height)];
    lbl_receiveName.textColor=[UIColor colorWithRed:85/255.0f green:132/255.0f blue:241/255.0f alpha:1];
    lbl_receiveName.font=[UIFont systemFontOfSize:i_FontSize1];
    lbl_receiveName.text=_usrInfo.str_name;
    [lbl_receiveName sizeToFit];
    
    lbl_sendCompany=[[UILabel alloc]initWithFrame:CGRectMake(0.6213*Width, 0.027*Height, 0.312*Width, 0.024*Height)];
    lbl_sendCompany.textColor=[UIColor colorWithRed:174/255.0f green:174/255.0f blue:174/255.0f alpha:1];
    lbl_sendCompany.font=[UIFont systemFontOfSize:i_FontSize1];
    lbl_sendCompany.textAlignment=NSTextAlignmentRight;
   
    
    lbl_receiveCompany=[[UILabel alloc]initWithFrame:CGRectMake(0.6213*Width, 0.070464767616192*Height,  0.312*Width, 0.024*Height)];
    lbl_receiveCompany.textColor=[UIColor colorWithRed:174/255.0f green:174/255.0f blue:174/255.0f alpha:1];
    lbl_receiveCompany.font=[UIFont systemFontOfSize:i_FontSize1];
    lbl_receiveCompany.textAlignment=NSTextAlignmentRight;
  
    
    view_seperator1=[[UIView alloc]initWithFrame:CGRectMake(0, 0.129*Height, Width, 1)];
    view_seperator1.backgroundColor=[UIColor colorWithRed:173/255.0f green:173/255.0f blue:173/255.0f alpha:1];
    
    lbl_SysMsg_Title=[[UILabel alloc]initWithFrame:CGRectMake(0.0667*Width, 0.151424*Height, 0.68*Width, 0.024*Height)];
    lbl_SysMsg_Title.textColor=[UIColor blackColor];
    lbl_SysMsg_Title.text=_str_SysMsg_Title;
    lbl_SysMsg_Title.font=[UIFont systemFontOfSize:i_FontSize1];
    [lbl_SysMsg_Title sizeToFit];
    
    lbl_Time=[[UILabel alloc]initWithFrame:CGRectMake(0.6813*Width, 0.151424*Height, 0.3*Width,0.024*Height )];
    lbl_Time.textColor=[UIColor colorWithRed:174/255.0f green:174/255.0f blue:174/255.0f alpha:1];
    lbl_Time.text=_str_time;
    lbl_Time.font=[UIFont systemFontOfSize:i_FontSize1];
    [lbl_Time sizeToFit];
    
    lbl_Category=[[UILabel alloc]initWithFrame:CGRectMake(0.0667*Width, 0.1934*Height,0.8666*Width, 0.02*Height)];
    lbl_Category.textAlignment=NSTextAlignmentLeft;
    lbl_Category.textColor=[UIColor colorWithRed:174/255.0f green:174/255.0f blue:174/255.0f alpha:1];
    lbl_Category.font=[UIFont systemFontOfSize:i_FontSize2];
    lbl_Category.text=_str_category;
    [lbl_Category sizeToFit];
    
    
    view_seperator2=[[UIView alloc]initWithFrame:CGRectMake(0, 0.2459*Height, Width, 1)];
    view_seperator2.backgroundColor=[UIColor colorWithRed:173/255.0f green:173/255.0f blue:173/255.0f alpha:1];
    
    lbl_SysMsg_Content1=[[UILabel alloc]initWithFrame:CGRectMake(0.0667*Width, 0.259*Height, 0.2*Width, 0.024*Height)];
    lbl_SysMsg_Content1.textColor=[UIColor blackColor];
    lbl_SysMsg_Content1.textAlignment=NSTextAlignmentLeft;
    lbl_SysMsg_Content1.font=[UIFont systemFontOfSize:i_FontSize1];
    lbl_SysMsg_Content1.text=@"消息内容";
    [lbl_SysMsg_Content1 sizeToFit];
    
    lbl_SysMsg_Content2=[[UILabel alloc]initWithFrame:CGRectMake(0.4267*Width, 0.259*Height, 0.533*Width, 0.024*Height)];
    lbl_SysMsg_Content2.textColor=[UIColor colorWithRed:173/255.0f green:173/255.0f blue:173/255.0f alpha:1];
    lbl_SysMsg_Content2.textAlignment=NSTextAlignmentLeft;
    lbl_SysMsg_Content2.font=[UIFont boldSystemFontOfSize:i_FontSize1];
    lbl_SysMsg_Content2.text=@"具体信息请在PC端查询";
    [lbl_SysMsg_Content2 sizeToFit];
    
    CGFloat i_content_height=0.2853*Height;
    if (iPhone5_5s) {
        i_content_height=0.33*Height;
    }
    else if (iPhone6) {
        i_content_height=0.3*Height;
    }
    lbl_sYSmsg_Content3=[[UILabel alloc]initWithFrame:CGRectMake(0.0667*Width, i_content_height, 0.8666*Width, 0.3*Height)];
    lbl_sYSmsg_Content3.textColor=[UIColor blackColor];
    lbl_sYSmsg_Content3.textAlignment=NSTextAlignmentLeft;
    lbl_sYSmsg_Content3.font=[UIFont systemFontOfSize:i_FontSize1];
    [lbl_sYSmsg_Content3 sizeToFit];
    
    
     _baseFunc=[[BaseFunction alloc]init];
    
    db=[DataBase sharedinstanceDB];    
    
    _session=[AFHTTPSessionManager manager];
    _session.responseSerializer = [AFHTTPResponseSerializer serializer];
    [_session.requestSerializer setHTTPShouldHandleCookies:YES];
    [_session.requestSerializer setTimeoutInterval:10.0f];
    
    arr_content =[[NSMutableArray alloc]initWithCapacity:7];
    for (int i=0;i<7;i++) {
        [arr_content setObject:@"" atIndexedSubscript:i];
    }
    
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"id"]=[NSString stringWithFormat:@"%ld",(long)_i_id];
    [self SysMessageContent:param];

   // [self.view addSubview:tableView];
    
    indicator =[_baseFunc AddLoop];
    
    [indicator startAnimating];
    [self.view addSubview:indicator];
    /*
    [self.view addSubview:lbl_title];
    [self.view addSubview:lbl_subtitle];
    [self.view addSubview:lbl_content];
     */
    
    [self.view addSubview:lbl_sendTitle];
    [self.view addSubview:lbl_sendName];
    [self.view addSubview:lbl_receiveTitle];
    [self.view addSubview:lbl_receiveName];
    [self.view addSubview:lbl_sendCompany];
    [self.view addSubview:lbl_receiveCompany];
    [self.view addSubview:view_seperator1];
    [self.view addSubview:lbl_SysMsg_Title];
    [self.view addSubview:lbl_Time];
    [self.view addSubview:lbl_Category];
    [self.view addSubview:view_seperator2];
    [self.view addSubview:lbl_SysMsg_Content1];
    [self.view addSubview:lbl_SysMsg_Content2];
    [self.view addSubview:lbl_sYSmsg_Content3];
}

-(void)SysMessageContent:(NSMutableDictionary*)param {
    NSString *str_connection=[_baseFunc GetConnectionStatus];
    if ([str_connection isEqualToString:@"wifi"] || [str_connection isEqualToString:@"GPRS"]) {
        NSString *str_msgDetail=[db fetchInterface:@"SysMsgDetail"];
        NSString *str_ip=@"";
        NSString *str_port=@"";
        NSMutableArray *t_array=[db fetchIPAddress];
        if (t_array.count==1) {
            NSArray *arr_ip=[t_array objectAtIndex:0];
            str_ip=[arr_ip objectAtIndex:0];
            str_port=[arr_ip objectAtIndex:1];
        }
        NSString *str_url=[NSString stringWithFormat:@"%@%@:%@%@",@"http://",str_ip,str_port,str_msgDetail];
        [_session POST:str_url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *JSON=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSString *str_success=[JSON objectForKey:@"success"];
            BOOL b_success=[str_success boolValue];
            if (b_success==YES) {
                [indicator stopAnimating];
                NSDictionary *dic_content=[JSON objectForKey:@"data"];
                NSString *str_title=[dic_content objectForKey:@"title"];
              //  lbl_title.text=str_title;
                NSString *str_sendTime=[dic_content objectForKey:@"sendTime"];
                NSArray *arr_sendTime = [str_sendTime componentsSeparatedByString:@" "];
                NSString *str_sendTime2=[arr_sendTime objectAtIndex:0];
                NSString *str_sendEmpname=[dic_content objectForKey:@"sendEmpname"];
                NSString *str_receiveEmpname=[dic_content objectForKey:@"receiveEmpname"];
                NSString *str_depart=[dic_content objectForKey:@"sendDeptname"];
               // lbl_subtitle.text=[NSString stringWithFormat:@"%@    %@    %@",str_depart,str_sendEmpname,str_sendTime2];
                NSString *str_msgType=[dic_content objectForKey:@"msgType"];
                NSInteger i_msgType=[str_msgType integerValue];
                NSString *str_msgTypeC=@"";
                if (i_msgType==1) {
                    str_msgTypeC=@"普通消息";
                }
                else if (i_msgType==2) {
                    str_msgTypeC=@"项目反馈";
                }
                else if (i_msgType==3) {
                    str_msgTypeC=@"流程反馈";
                }
                NSString *str_content=[dic_content objectForKey:@"content"];
                [arr_content setObject:str_msgTypeC atIndexedSubscript:0];
                [arr_content setObject:str_title atIndexedSubscript:1];
                [arr_content setObject:str_sendEmpname atIndexedSubscript:2];
                [arr_content setObject:str_depart atIndexedSubscript:3];
                [arr_content setObject:str_sendTime2 atIndexedSubscript:4];
                [arr_content setObject:str_receiveEmpname atIndexedSubscript:5];
                [arr_content setObject:str_content atIndexedSubscript:6];
                lbl_sendCompany.text=str_depart;
                lbl_receiveCompany.text=_usrInfo.str_position;
                lbl_sYSmsg_Content3.text=str_content;
                [lbl_sendCompany sizeToFit];
                [lbl_receiveCompany sizeToFit];
                [lbl_sYSmsg_Content3 sizeToFit];
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [indicator stopAnimating];
        }];
        
    }
}


-(void)MovePreviousVc:(UIButton*)sender {
    if (f_v<9.0) {
        self.navigationController.delegate=nil;
    }
    [self.navigationController popViewControllerAnimated:NO];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

-(UITableViewCell*)tableView:(UITableView *)tableViewLocal cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier=@"Cell";
    UITableViewCell *cell=[tableViewLocal dequeueReusableCellWithIdentifier:identifier];
   // if (cell==nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        if (indexPath.row==0) {
            cell.textLabel.text=@"消息类型";
            cell.detailTextLabel.text=[arr_content objectAtIndex:0];
        }
        else if (indexPath.row==1) {
            cell.textLabel.text=@"标题";
            cell.detailTextLabel.text=[arr_content objectAtIndex:1];
            cell.detailTextLabel.numberOfLines=0;

        }
        else if (indexPath.row==2) {
            cell.textLabel.text=@"发送人";
            cell.detailTextLabel.text=[arr_content objectAtIndex:2];

        }
        else if (indexPath.row==3) {
            cell.textLabel.text=@"发送部门";
            cell.detailTextLabel.text=[arr_content objectAtIndex:3];

        }
        else if (indexPath.row==4) {
            cell.textLabel.text=@"发送时间";
            cell.detailTextLabel.text=[arr_content objectAtIndex:4];

        }
        else if (indexPath.row==5) {
            cell.textLabel.text=@"接收人";
            cell.detailTextLabel.text=[arr_content objectAtIndex:5];

        }
        else if (indexPath.row==6) {
            cell.textLabel.text=@"消息内容";
            cell.detailTextLabel.text=[arr_content objectAtIndex:6];
            cell.detailTextLabel.numberOfLines=0;

        }
    [cell sizeToFit];
    
  //  }
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==6 || indexPath.row==1) {
        return 80;
    }
    else {
        return 44;
    }
}


@end
