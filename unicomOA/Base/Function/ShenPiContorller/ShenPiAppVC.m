//
//  ShenPiAppVC.m
//  unicomOA
//
//  Created by hnsi-03 on 16/5/19.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "ShenPiAppVC.h"
#import "DataBase.h"
#import "AFNetworking.h"
#import "LXAlertView.h"
#import "PrintApplicationTitleCell.h"
#import "PrintApplicationDetailCell.h"

@interface ShenPiAppVC()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) AFHTTPSessionManager *session;

@property (nonatomic,strong) NSString *str_url_login;
//控件组
@property (nonatomic,strong) NSArray *arr_groupList;
//初始控件列表
@property (nonatomic,strong) NSArray *arr_ctlList;

//控件列表组织后的
@property (nonatomic,strong) NSDictionary *dic_clt;

@property (nonatomic,strong) UITableView *tableview;

@end


@implementation ShenPiAppVC {
    DataBase *db;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"新建申请";
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    [barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(SubmitToPrint:)];
    [barButtonItem2 setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=barButtonItem2;
    
    self.view.backgroundColor=[UIColor colorWithRed:246/255.0f green:249/255.0f blue:254/255.0f alpha:1];
    
    db=[DataBase sharedinstanceDB];
    
    _session=[AFHTTPSessionManager manager];
    _session.responseSerializer= [AFHTTPResponseSerializer serializer];
    [_session.requestSerializer setHTTPShouldHandleCookies:YES];

    _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _tableview.delegate=self;
    _tableview.dataSource=self;
    _tableview.backgroundColor=[UIColor clearColor];
    
    [self.view addSubview:_tableview];

    
    [self DisplayUI];
    
}



-(void)DisplayUI {
    if (_str_url!=nil) {
        
        NSString *str_ip=@"";
        NSString *str_port=@"";
        NSMutableArray *t_array=[db fetchIPAddress];
        if (t_array.count==1) {
            NSArray *arr_ip=[t_array objectAtIndex:0];
            str_ip=[arr_ip objectAtIndex:0];
            str_port=[arr_ip objectAtIndex:1];
        }
        
        
        NSString *str_url=[NSString stringWithFormat:@"%@%@:%@%@",@"http://",str_ip,str_port,_str_url];
        [_session POST:str_url parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"添加界面成功,%@",responseObject);
            NSDictionary *JSON=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSString *str_success= [JSON objectForKey:@"success"];
            BOOL b_success=[str_success boolValue];
            if (b_success==YES) {
                _arr_groupList=[JSON objectForKey:@"groupList"];
                _arr_ctlList=[JSON objectForKey:@"ctlList"];
                _dic_clt=[self manageData:_arr_groupList ctlList:_arr_ctlList];
                [self.tableview reloadData];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"添加界面失败");
        }];

        
    }
    
}


-(void)MovePreviousVc:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)SubmitToPrint:(UIButton*)sender {
    
}


-(NSDictionary*)manageData:(NSArray*)arr_groupList ctlList:(NSArray*)arr_ctlList {
    NSMutableDictionary *dic_tmp=[NSMutableDictionary dictionaryWithCapacity:1];
    for (int i=0;i<[arr_groupList count];i++) {
        NSDictionary *dic_group=[arr_groupList objectAtIndex:i];
        NSString *str_key=[dic_group objectForKey:@"groupKey"];
        NSMutableArray *arr_array=[[NSMutableArray alloc]init];
        for (int j=0;j<[arr_ctlList count];j++) {
            NSDictionary *dic_ctl=[arr_ctlList objectAtIndex:j];
            NSString *str_key2=[dic_ctl objectForKey:@"groupKey"];
            if ([str_key isEqualToString:str_key2]) {
                [arr_array addObject:dic_ctl];
            }
        }
        NSString *str_index=[NSString stringWithFormat:@"%d",i];
        [dic_tmp setValue:arr_array forKey:str_index];
    }
    
    return dic_tmp;
}


#pragma mark tableview方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([_arr_groupList count]==0) {
        return 1;
    }
    else {
        return [_arr_groupList count];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_dic_clt count]==0) {
        return 1;
    }
    else {
        NSString *str_index=[NSString stringWithFormat:@"%ld",(long)section];
        NSArray *arr_ctl= [_dic_clt objectForKey:str_index];
        NSInteger i_count=0;
        for (int i=0;i<[arr_ctl count];i++) {
            NSDictionary *dic_tmp=[arr_ctl objectAtIndex:i];
            NSString *str_type= [dic_tmp objectForKey:@"type"];
            if (![str_type isEqualToString:@"hidden"]) {
                i_count=i_count+1;
            }
        }
        return i_count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    view.backgroundColor=[UIColor clearColor];
    CGRect view_title;
    view_title=CGRectMake(0, 0, self.view.frame.size.width, 30);
    UILabel *lbl_sectionTitle=[[UILabel alloc]initWithFrame:view_title];
    lbl_sectionTitle.textAlignment=NSTextAlignmentLeft;
    lbl_sectionTitle.backgroundColor=[UIColor whiteColor];
    NSDictionary *dic_group=[_arr_groupList objectAtIndex:section];
    NSString *str_label=[dic_group objectForKey:@"label"];
    lbl_sectionTitle.text=[NSString stringWithFormat:@"     %@",str_label];
    
    [view addSubview:lbl_sectionTitle];
    return view;

    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_dic_clt count]==0) {
        return 40;
    }
    else {
        NSString *str_index=[NSString stringWithFormat:@"%ld",indexPath.section];
        NSArray *arr_ctl= [_dic_clt objectForKey:str_index];
        NSDictionary *dic_tmp = [arr_ctl objectAtIndex:indexPath.row];
        NSString *str_type=[dic_tmp objectForKey:@"type"];
        if ([str_type isEqualToString:@"textarea"]) {
            return 180;
        }
        else {
            return 40;
        }
    }
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID=@"cellId";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellID];
    }
    cell.backgroundColor=[UIColor whiteColor];
    cell.textLabel.textColor=[UIColor blackColor];
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    cell.textLabel.textAlignment=NSTextAlignmentLeft;
    cell.detailTextLabel.textColor=[UIColor colorWithRed:112/255.0f green:112/255.0f blue:112/255.0f alpha:1];
    cell.detailTextLabel.font=[UIFont systemFontOfSize:16];
    if ([_dic_clt count]==0) {
        cell.textLabel.text=@"aaa";
        return cell;
    }
    else {
        NSString *str_index=[NSString stringWithFormat:@"%ld",indexPath.section];
        NSArray *arr_ctl= [_dic_clt objectForKey:str_index];
        NSMutableArray *arr_m_ctl=[self DispalyUIWithoutHidden:arr_ctl];
        NSDictionary *dic_tmp = [arr_m_ctl objectAtIndex:indexPath.row];
        NSString *str_type=[dic_tmp objectForKey:@"type"];
        if (![str_type isEqualToString:@"hidden"]) {
            if ([str_type isEqualToString:@"text"] || [str_type isEqualToString:@"int"]) {
                NSString *str_readonly=[dic_tmp objectForKey:@"readonly"];
                BOOL b_readonly=[str_readonly boolValue];
                if (b_readonly==YES) {
                    NSString *str_label=[dic_tmp objectForKey:@"label"];
                    NSString *str_value=[dic_tmp objectForKey:@"value"];
                    cell.textLabel.text=str_label;
                    cell.detailTextLabel.text=str_value;
                }
                else {
                    NSString *str_label=[dic_tmp objectForKey:@"label"];
                    NSObject *obj_prompt=[dic_tmp objectForKey:@"prompt"];
                    NSObject *obj_value=[dic_tmp objectForKey:@"value"];
                    NSString *str_prompt=@"";
                    NSString *str_value=@"";
                    if (obj_prompt!=[NSNull null]) {
                        str_prompt=(NSString*)obj_prompt;
                    }
                    if (obj_value!=[NSNull null]) {
                        str_value=(NSString*)obj_value;
                    }
                    if ([str_type isEqualToString:@"text"]) {
                        cell=[PrintApplicationTitleCell cellWithTable:tableView withName:str_label withPlaceHolder:str_prompt withText:str_value atIndexPath:indexPath keyboardType:UIKeyboardTypeDefault];
                    }
                    else if ([str_type isEqualToString:@"int"]) {
                        cell=[PrintApplicationTitleCell cellWithTable:tableView withName:str_label withPlaceHolder:str_prompt withText:str_value atIndexPath:indexPath keyboardType:UIKeyboardTypeNumberPad];
                    }
                    
                    return cell;
                }
            }
            else if ([str_type isEqualToString:@"textarea"]) {
                NSString *str_readonly=[dic_tmp objectForKey:@"readonly"];
                BOOL b_readonly=[str_readonly boolValue];
                if (b_readonly==YES) {
                    
                }
                else {
                    NSString *str_label=[dic_tmp objectForKey:@"label"];
                    NSObject *obj_prompt=[dic_tmp objectForKey:@"prompt"];
                    NSObject *obj_value=[dic_tmp objectForKey:@"value"];
                    NSString *str_prompt=@"";
                    NSString *str_value=@"";
                    if (obj_prompt!=[NSNull null]) {
                        str_prompt=(NSString*)obj_prompt;
                    }
                    if (obj_value!=[NSNull null]) {
                        str_value=(NSString*)obj_value;
                    }
                    cell=[PrintApplicationDetailCell cellWithTable:tableView withName:str_label withPlaceHolder:str_prompt withText:str_value atIndexPath:indexPath atHeight:180];
                    return cell;
                }
                
            }
        }
        
            
            /*
            if ([str_type isEqualToString:@"text"]) {
                NSString *str_readonly=[dic_tmp objectForKey:@"readonly"];
                BOOL b_readonly=[str_readonly boolValue];
                if (b_readonly==YES) {
                    
                }

            }
             */
         return cell;
        }
    
        /*
        NSString *str_label=[dic_tmp objectForKey:@"label"];
        cell.textLabel.text=str_label;
        if ([str_type isEqualToString:@"text"]) {
            NSString *str_readonly=[dic_tmp objectForKey:@"readonly"];
            BOOL b_readonly=[str_readonly boolValue];
            if (b_readonly==YES) {
                NSString *str_value=[dic_tmp objectForKey:@"value"];
                cell.detailTextLabel.text=str_value;
            }
            return cell;
        }
        else if ([str_type isEqualToString:@"int"]) {
            
        }
        else if ([str_type isEqualToString:@"textarea"]) {
            
        }
        else if ([str_type isEqualToString:@"float"]) {
            
        }
        else if ([str_type isEqualToString:@"list"]) {
            
        }
        else if ([str_type isEqualToString:@"selector"]) {
            
        }
        else if ([str_type isEqualToString:@"tableView"]) {
            
        }
        else if ([str_type isEqualToString:@"date"]) {
            
        }
        else if ([str_type isEqualToString:@"datetime"]) {
            
        }
        
    }
    
    return cell;
    */
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


//去掉hidden属性的UI数据
-(NSMutableArray*)DispalyUIWithoutHidden:(NSArray*)arr_ctl {
    NSMutableArray *arr_m_ctl=(NSMutableArray*)arr_ctl;
    for (int i=0;i<[arr_m_ctl count];i++) {
        NSDictionary *dic_sub_ctl=[arr_m_ctl objectAtIndex:i];
        NSString *str_sub_type=[dic_sub_ctl objectForKey:@"type"];
        if ([str_sub_type isEqualToString:@"hidden"]) {
            [arr_m_ctl removeObject:dic_sub_ctl];
        }
    }
    return arr_m_ctl;
}

@end
