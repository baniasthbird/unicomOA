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
    UITableView *tableView;
    NSMutableArray *arr_content;
    UIActivityIndicatorView *indicator;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title=_str_title;
    
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
    
    tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    
    
    /*
    lbl_title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    lbl_title.font=[UIFont systemFontOfSize:18];
    lbl_title.textAlignment=NSTextAlignmentCenter;
    lbl_title.textColor=[UIColor blackColor];
    lbl_title.text=@"";
    
    lbl_subtitle=[[UILabel alloc]initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, 20)];
    lbl_subtitle.font=[UIFont systemFontOfSize:9];
    lbl_subtitle.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    lbl_subtitle.textAlignment=NSTextAlignmentCenter;
    lbl_subtitle.text=@"";
    
    lbl_content=[[UITextView alloc]initWithFrame:CGRectMake(0, 70, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-150)];
    lbl_content.font=[UIFont systemFontOfSize:12];
    lbl_content.textColor=[UIColor blackColor];
    lbl_content.textAlignment=NSTextAlignmentCenter;
    lbl_content.backgroundColor=[UIColor colorWithRed:246/255.0f green:249/255.0f blue:254/255.0f alpha:1];
    */
    
    
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"id"]=[NSString stringWithFormat:@"%ld",(long)_i_id];
    [self SysMessageContent:param];

    [self.view addSubview:tableView];
    
    indicator =[_baseFunc AddLoop];
    
    [indicator startAnimating];
    [self.view addSubview:indicator];
    /*
    [self.view addSubview:lbl_title];
    [self.view addSubview:lbl_subtitle];
    [self.view addSubview:lbl_content];
     */
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
                
                [tableView reloadData];
                
                
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
