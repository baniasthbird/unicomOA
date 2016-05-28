//
//  UnFinishVc.m
//  unicomOA
//
//  Created by hnsi-03 on 16/5/27.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "UnFinishVc.h"
#import "DataBase.h"
#import "AFNetworking.h"
#import "LXAlertView.h"
#import "PrintFileNavCell.h"
#import "PrintFileDetail.h"
#import "UILabel+LabelHeightAndWidth.h"
#import "TableViewCell.h"
#import "PrintApplicationDetailCell.h"

@interface UnFinishVc ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) AFHTTPSessionManager *session;

@property (strong,nonatomic) NSIndexPath *selectedRowIndexPath;

@end

@implementation UnFinishVc {
    DataBase *db;
    UITableView *tableView;
    //控件组
    NSArray *arr_groupList;
    //初始控件列表
    NSArray *arr_ctlList;
    //提交的url
    NSString *str_url_postdata;
    
    NSDictionary *dic_ctl;
    
    NSMutableDictionary *dic_m_ctl;
    
    NSInteger i_row_expand;
    
    NSString *str_selected;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"待办审批";
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    [barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithTitle:@"审批记录" style:UIBarButtonItemStyleDone target:self action:@selector(Submit:)];
    [barButtonItem2 setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=barButtonItem2;
    
    self.view.backgroundColor=[UIColor colorWithRed:246/255.0f green:249/255.0f blue:254/255.0f alpha:1];
    // Do any additional setup after loading the view.
    db=[DataBase sharedinstanceDB];
    
    _session=[AFHTTPSessionManager manager];
    _session.responseSerializer= [AFHTTPResponseSerializer serializer];
    [_session.requestSerializer setHTTPShouldHandleCookies:YES];
    NSMutableDictionary *dic_param=[NSMutableDictionary dictionary];
    dic_param[@"processInstID"]=_str_processInstID;
    dic_param[@"activityDefID"]=_str_activityDefID;
    dic_param[@"workItemID"]=_str_workItemID;
    [self PrePareData:dic_param];
    
    tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.backgroundColor=[UIColor clearColor];
    
    [self.view addSubview:tableView];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)MovePreviousVc:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)PrePareData:(NSMutableDictionary*)param {
    NSString *str_ip=@"";
    NSString *str_port=@"";
    NSMutableArray *t_array=[db fetchIPAddress];
    if (t_array.count==1) {
        NSArray *arr_ip=[t_array objectAtIndex:0];
        str_ip=[arr_ip objectAtIndex:0];
        str_port=[arr_ip objectAtIndex:1];
    }
    NSString *str_urldata=_str_url;
    NSCharacterSet *whitespace = [NSCharacterSet  whitespaceAndNewlineCharacterSet];
    str_urldata= [str_urldata stringByTrimmingCharactersInSet:whitespace];
    NSString *str_url=[NSString stringWithFormat:@"%@%@:%@%@",@"http://",str_ip,str_port,str_urldata];
    [_session POST:str_url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *JSON=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dic_exp=[JSON objectForKey:@"exception"];
        if (dic_exp!=nil) {
            NSString *str_msg=[dic_exp objectForKey:@"message"];
            LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"异常" message:str_msg cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
                
            }];
            [alert showLXAlertView];
            return;
        }
        else {
            NSDictionary *dic_result= [JSON objectForKey:@"result"];
            if (dic_result!=nil) {
                NSString *str_success=[dic_result objectForKey:@"success"];
                BOOL b_success=[str_success boolValue];
                if (b_success==YES) {
                    NSLog(@"获取界面成功!");
                    arr_groupList=[dic_result objectForKey:@"groupList"];
                    arr_ctlList=[dic_result objectForKey:@"ctlList"];
                    dic_ctl=[self manageData:arr_groupList ctlList:arr_ctlList];
                    str_url_postdata=[dic_result objectForKey:@"url"];
                     dic_m_ctl=[self DispalyUIAdvance:dic_ctl];
                    [tableView reloadData];
                }
            }
            else {
                NSString *str_success=[JSON objectForKey:@"success"];
                BOOL b_success=[str_success boolValue];
                if (b_success==YES) {
                    NSLog(@"获取界面成功!");
                    arr_groupList=[JSON objectForKey:@"groupList"];
                    arr_ctlList=[JSON objectForKey:@"ctlList"];
                    dic_ctl=[self manageData:arr_groupList ctlList:arr_ctlList];
                    str_url_postdata=[JSON objectForKey:@"url"];
                     dic_m_ctl=[self DispalyUIAdvance:dic_ctl];
                    [tableView reloadData];
                }
                else {
                    NSString *str_msg= [JSON objectForKey:@"msg"];
                    LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:str_msg cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
                        
                    }];
                    [alert showLXAlertView];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取界面失败");
    }];
    
}

//组织数据，去掉hidden
-(NSDictionary*)manageData:(NSArray*)groupList ctlList:(NSArray*)ctlList {
    NSMutableDictionary *dic_tmp=[NSMutableDictionary dictionaryWithCapacity:1];
    for (int i=0;i<[groupList count];i++) {
        NSDictionary *dic_group=[groupList objectAtIndex:i];
        NSString *str_key=[dic_group objectForKey:@"groupKey"];
        NSMutableArray *arr_array=[[NSMutableArray alloc]init];
        for (int j=0;j<[ctlList count];j++) {
            NSDictionary *dic_ctll=[ctlList objectAtIndex:j];
            NSString *str_key2=[dic_ctll objectForKey:@"groupKey"];
            if ([str_key isEqualToString:str_key2]) {
                [arr_array addObject:dic_ctll];
            }
        }
        NSString *str_index=[NSString stringWithFormat:@"%d",i];
        [dic_tmp setValue:arr_array forKey:str_index];
    }
    
    return dic_tmp;
}

-(void)Submit:(UIButton*)sender {
    //提交申请
    // NSMutableDictionary *dic_submit=[[NSMutableDictionary alloc]init];
    
    
}



#pragma mark tableView方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([arr_groupList count]==0) {
        return 1;
    }
    else {
        return [arr_groupList count];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([dic_ctl count]==0) {
        return 1;
    }
    else {
        NSString *str_index=[NSString stringWithFormat:@"%ld",(long)section];
        NSArray *arr_ctl= [dic_ctl objectForKey:str_index];
        NSInteger i_count=0;
        BOOL b_isExpanded=NO;
        for (int i=0;i<[arr_ctl count];i++) {
            NSDictionary *dic_tmp=[arr_ctl objectAtIndex:i];
            NSString *str_type= [dic_tmp objectForKey:@"type"];
            if ([str_type isEqualToString:@"hidden"]) {
                //i_count=i_count+1;
            }
            else if ([str_type isEqualToString:@"tableView"]) {
                NSArray *arr_list=[dic_tmp objectForKey:@"tableData"];
                i_count=i_count+[arr_list count];
            }
            else if ([str_type isEqualToString:@"list"]) {
                NSString *str_groupKey=[dic_tmp objectForKey:@"groupKey"];
                if (![str_groupKey isEqualToString:@"base"]) {
                    b_isExpanded=YES;
                    i_count=i_count+1;
                }
            }
            else {
                i_count=i_count+1;
            }
        }
        if (b_isExpanded==NO) {
            return i_count;
        }
        else {
            if (self.selectedRowIndexPath) {
                return i_count+i_row_expand;
            }
            else {
                return i_count;
            }
            
        }

    }
}

-(UITableViewCell*)tableView:(UITableView *)tb cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID=[NSString stringWithFormat:@"%@%ld%ld",@"cellID",(long)indexPath.row,(long)indexPath.section];
    UITableViewCell *cell=[tb cellForRowAtIndexPath:indexPath];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellID];
    }
    cell.backgroundColor=[UIColor whiteColor];
    cell.textLabel.textColor=[UIColor blackColor];
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    cell.textLabel.textAlignment=NSTextAlignmentLeft;
    cell.detailTextLabel.textColor=[UIColor colorWithRed:112/255.0f green:112/255.0f blue:112/255.0f alpha:1];
    cell.detailTextLabel.font=[UIFont systemFontOfSize:16];
    if ([dic_ctl count]==0) {
        cell.textLabel.text=@"";
        return cell;
    }
    else {
        NSDictionary  *dic_tmp;
        if (self.selectedRowIndexPath!=nil) {
            if (indexPath.section==self.selectedRowIndexPath.section) {
                if (indexPath.row<=self.selectedRowIndexPath.row) {
                   // dic_tmp= [dic_m_ctl objectAtIndex:indexPath.row];
                    NSString *str_index=[NSString stringWithFormat:@"%ld",(long)indexPath.section];
                    NSArray *arr_tmp=  [dic_m_ctl objectForKey:str_index];
                    dic_tmp=[arr_tmp objectAtIndex:indexPath.row];
                }
                else if (indexPath.row>self.selectedRowIndexPath.row) {
                    if (indexPath.row<=self.selectedRowIndexPath.row+i_row_expand) {
                        NSString *str_index=[NSString stringWithFormat:@"%ld",(long)indexPath.section];
                        NSArray *arr_tmp=  [dic_m_ctl objectForKey:str_index];
                        NSDictionary *dic_target=[arr_tmp objectAtIndex:self.selectedRowIndexPath.row];
                        NSString *str_type=[dic_target objectForKey:@"type"];
                        if ([str_type isEqualToString:@"list"]) {
                            NSArray *arr_list= [dic_target objectForKey:@"listData"];
                            long i_index=indexPath.row-self.selectedRowIndexPath.row-1;
                            NSString *identifier = [TableViewCell reusableIdentifier];
                            TableViewCell *t_cell = [[[NSBundle mainBundle]loadNibNamed:identifier owner:self options:nil]objectAtIndex:0];
                            NSDictionary *dic_select=[arr_list objectAtIndex:i_index];
                            [t_cell addcontentView:[self viewForContainerAtIndexPath:indexPath dic:dic_select cell:t_cell]];
                            cell.textLabel.text=[dic_select objectForKey:@"label"];
                            cell.detailTextLabel.text=@"";
                            NSString *str_tag=[dic_select objectForKey:@"value"];
                            cell.tag=[str_tag integerValue];
                            cell.textLabel.textColor=[UIColor blueColor];
                            cell.accessibilityHint=@"listdata";
                            return t_cell;
                       //     [cell addcontentView:[self viewForContainerAtIndexPath:indexPath isDate:YES]];
                        }
                    }
                    else {
                        NSString *str_index=[NSString stringWithFormat:@"%ld",(long)indexPath.section];
                        NSArray *arr_tmp=  [dic_m_ctl objectForKey:str_index];
                        dic_tmp=[arr_tmp objectAtIndex:self.selectedRowIndexPath.row];
                    }
                    
                }
            }
            else {
                NSString *str_index=[NSString stringWithFormat:@"%ld",(long)indexPath.section];
                NSArray *arr_tmp=  [dic_m_ctl objectForKey:str_index];
                dic_tmp=[arr_tmp objectAtIndex:indexPath.row];
            }
            
        }
        else {
            NSString *str_index=[NSString stringWithFormat:@"%ld",(long)indexPath.section];
            NSArray *arr_tmp=  [dic_m_ctl objectForKey:str_index];
            dic_tmp=[arr_tmp objectAtIndex:indexPath.row];
        }

        NSString *str_type=[dic_tmp objectForKey:@"type"];
        if ([str_type isEqualToString:@"text"] || [str_type isEqualToString:@"int"] || [str_type isEqualToString:@"date"]) {
        //    NSString *str_readonly= [dic_tmp objectForKey:@"readonly"];
         //   BOOL b_readonly=[str_readonly boolValue];
            //if (b_readonly==YES) {
                NSString *str_label=[dic_tmp objectForKey:@"label"];
                NSObject *obj_value=[dic_tmp objectForKey:@"value"];
                NSString *str_value=@"";
                if (obj_value!=[NSNull null]) {
                    str_value=(NSString*)obj_value;
                }
                cell.textLabel.text=str_label;
                cell.detailTextLabel.text=str_value;
                return cell;
         //   }
         //   else {
               
          //  }
        }
        else if ([str_type isEqualToString:@"textarea"]) {
            NSString *str_readonly= [dic_tmp objectForKey:@"readonly"];
            BOOL b_readonly=[str_readonly boolValue];
            if (b_readonly==YES) {
                NSString *str_label=[dic_tmp objectForKey:@"label"];
                NSObject *obj_value=[dic_tmp objectForKey:@"value"];
                NSString *str_value=@"";
                if (obj_value!=[NSNull null]) {
                    str_value=(NSString*)obj_value;
                }
                cell.textLabel.text=str_label;
                cell.detailTextLabel.text=str_value;
                return cell;
            }
            else {
                NSString *str_label=[dic_tmp objectForKey:@"label"];
                NSObject *obj_value=[dic_tmp objectForKey:@"value"];
                NSString *str_value=@"";
                if (obj_value!=[NSNull null]) {
                    str_value=(NSString*)obj_value;
                }
                PrintApplicationDetailCell *cell=[PrintApplicationDetailCell cellWithTable:tableView withName:str_label withPlaceHolder:@"" withText:str_value atIndexPath:indexPath atHeight:180];
                cell.accessibilityHint=@"textArea";
                return cell;
            }
        }
        else if ([str_type isEqualToString:@"tableView"]) {
            NSArray *arr_title=[dic_tmp objectForKey:@"tableTitle"];
            NSArray *arr_data=[dic_tmp objectForKey:@"tableDataCotent"];
            NSString *str_titlename=[arr_title objectAtIndex:0];
            NSString *str_title=[arr_data objectAtIndex:0];
            PrintFileNavCell *cell=[PrintFileNavCell cellWithTable:tb withTitle:str_title withTileName:str_titlename atIndexPath:indexPath];
            cell.file_data=arr_data;
            cell.file_title=arr_title;
            return cell;
        }
        else if ([str_type isEqualToString:@"list"]) {
            NSString *str_label=[dic_tmp objectForKey:@"label"];
            NSObject *obj_value=[dic_tmp objectForKey:@"value"];
            NSString *str_value=@"";
            if (obj_value!=[NSNull null]) {
                str_value=(NSString*)obj_value;
            }
            NSArray *arr_listData=[dic_tmp objectForKey:@"listData"];
            NSInteger i_value=[str_value integerValue];
            NSString *str_detail_value=@"";
            NSString *str_value2=[NSString stringWithFormat:@"%ld",(long)i_value];
            for (int l=0;l<[arr_listData count];l++) {
                NSDictionary *dic= [arr_listData objectAtIndex:l];
                NSString *str_tmp=[dic objectForKey:@"value"];
                if ([str_tmp isEqualToString:str_value2]) {
                    str_detail_value=[dic objectForKey:@"label"];
                }
                
            }

            cell.textLabel.text=str_label;
            if (!self.selectedRowIndexPath) {
                cell.detailTextLabel.text=str_detail_value;
            }
            else {
                cell.detailTextLabel.text=str_selected;
            }
            
            cell.accessibilityElements=[dic_tmp objectForKey:@"listData"];
            NSString *str_groupKey=[dic_tmp objectForKey:@"groupKey"];
            if (![str_groupKey isEqualToString:@"base"]) {
                 cell.accessibilityHint=@"canExpandList";
            }
            
           
            return cell;

        }
        else {
            cell.textLabel.text=@"";
        }
        
        
    }
    return  cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    view.backgroundColor=[UIColor clearColor];
    CGRect view_title;
    view_title=CGRectMake(0, 0, self.view.frame.size.width, 30);
    UILabel *lbl_sectionTitle=[[UILabel alloc]initWithFrame:view_title];
    lbl_sectionTitle.textAlignment=NSTextAlignmentLeft;
    lbl_sectionTitle.backgroundColor=[UIColor whiteColor];
    NSDictionary *dic_group=[arr_groupList objectAtIndex:section];
    NSString *str_label=[dic_group objectForKey:@"label"];
    if (str_label!=nil) {
        lbl_sectionTitle.text=[NSString stringWithFormat:@"     %@",str_label];
    }
    else {
        lbl_sectionTitle.text=@"请稍后,正在加载中...";
    }
    
    
    [view addSubview:lbl_sectionTitle];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

-(CGFloat)tableView:(UITableView *)tb heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
    if (self.selectedRowIndexPath==nil) {
        NSString *str_index=[NSString stringWithFormat:@"%ld",(long)indexPath.section];
        NSArray *arr_tmp=  [dic_m_ctl objectForKey:str_index];
        NSDictionary  *dic_tmp=[arr_tmp objectAtIndex:indexPath.row];
        NSString *str_type=[dic_tmp objectForKey:@"type"];
        if ([str_type isEqualToString:@"textarea"]) {
            NSObject *obj_value=[dic_tmp objectForKey:@"value"];
            NSString *str_value=@"";
            if (obj_value!=[NSNull null]) {
                str_value=(NSString*)obj_value;
            }
            if (![str_value isEqualToString:@""]) {
                CGFloat h_value=[UILabel_LabelHeightAndWidth getHeightByWidth:15*[UIScreen mainScreen].bounds.size.width/16 title:str_value font:[UIFont systemFontOfSize:14]];
                return h_value;
            }
            else {
                return 60;
            }
        }
        else {
            return 44;
        }
    }
    else {
        return 44;
    }
     */
    NSString *str_index=[NSString stringWithFormat:@"%ld",(long)indexPath.section];
    NSArray *arr_tmp=  [dic_m_ctl objectForKey:str_index];
    NSDictionary  *dic_tmp;
    if (indexPath.row<[arr_tmp count]) {
        dic_tmp=[arr_tmp objectAtIndex:indexPath.row];
    }
    else {
        dic_tmp=[arr_tmp objectAtIndex:indexPath.row-i_row_expand];
    }
    
    NSString *str_type=[dic_tmp objectForKey:@"type"];
    if ([str_type isEqualToString:@"textarea"]) {
        return 180;
    }
    else {
        return 44;
    }
    
    
}

-(void)tableView:(UITableView *)tb didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[tb cellForRowAtIndexPath:indexPath];
    if ([cell isMemberOfClass:[PrintFileNavCell class]]) {
        PrintFileNavCell *cell_nav=(PrintFileNavCell*)cell;
        NSArray *tmp_Files=cell_nav.file_data;
        NSArray *tmp_Title=cell_nav.file_title;
        PrintFileDetail *viewController=[[PrintFileDetail alloc]init];
        viewController.arr_data=tmp_Files;
        viewController.arr_title=tmp_Title;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    if (![self isExtendedCellIndexPath:indexPath]) {
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        if ([cell.accessibilityHint isEqualToString:@"canExpandList"]) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            i_row_expand=cell.accessibilityElements.count;
            [self extendCellAtIndexPath:indexPath count:i_row_expand];
        }
    }
    if (self.selectedRowIndexPath) {
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        if ([cell.accessibilityHint isEqualToString:@"listdata"]) {
            str_selected=cell.textLabel.text;
            UITableViewCell *cell_ch=[tableView cellForRowAtIndexPath:self.selectedRowIndexPath];
            cell_ch.detailTextLabel.text=str_selected;
            cell_ch.detailTextLabel.textColor=[UIColor blueColor];
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:self.selectedRowIndexPath.row inSection:self.selectedRowIndexPath.section];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            
        }
    }

}


//去掉hidden属性的UI数据
-(NSMutableDictionary*)DispalyUIAdvance:(NSDictionary*)dic_control{
    NSMutableDictionary *dic_my_ctl=[dic_control mutableCopy];
    for (int i=0;i<[dic_my_ctl count];i++) {
        NSString *str_index=[NSString stringWithFormat:@"%d",i];
        NSMutableArray *arr_my_ctl=[dic_my_ctl objectForKey:str_index];
        for (int j=0;j<[arr_my_ctl count];j++) {
            NSDictionary *dic_sub_ctl=[arr_my_ctl objectAtIndex:j];
            NSString *str_sub_type=[dic_sub_ctl objectForKey:@"type"];
            if ([str_sub_type isEqualToString:@"hidden"]) {
                [arr_my_ctl removeObject:dic_sub_ctl];
            }
            else if ([str_sub_type isEqualToString:@"tableView"]) {
                NSArray *arr_tabledata=[dic_sub_ctl objectForKey:@"tableData"];
                NSUInteger i_count=[arr_tabledata count];
                [arr_my_ctl removeAllObjects];
                for (int l=0;l<i_count;l++) {
                    [arr_my_ctl addObject:dic_sub_ctl];
                }
                for (int l=0;l<i_count;l++) {
                    NSDictionary *dic_tmp_ctl=[arr_my_ctl objectAtIndex:l];
                    [dic_tmp_ctl setValue:[arr_tabledata objectAtIndex:l] forKey:@"tableDataCotent"];
                }
            }
            else if ([str_sub_type isEqualToString:@"list"]) {
                
                
            }

        
        }
    }
    return dic_my_ctl;
}



#pragma mark  点击时间后下拉扩展cell事件

-(void)extendCellAtIndexPath:(NSIndexPath *)indexPath count:(NSInteger)i_count
{
    [tableView beginUpdates];
    
    if (self.selectedRowIndexPath) {
        if ([self isSelectedRowIndexPath:indexPath]) {
            NSIndexPath *tempIndexPath=self.selectedRowIndexPath;
            self.selectedRowIndexPath=nil;
            [self removeCellBelowIndexPath:tempIndexPath count:i_count];
        }
        else if ([self isExtendedCellIndexPath:indexPath]);
        else {
            NSIndexPath *tempIndexPath=self.selectedRowIndexPath;
            if (indexPath.row>self.selectedRowIndexPath.row && indexPath.section==self.selectedRowIndexPath.section) {
                indexPath=[NSIndexPath indexPathForRow:(indexPath.row-1) inSection:indexPath.section];
            }
            self.selectedRowIndexPath=indexPath;
            [self removeCellBelowIndexPath:tempIndexPath count:i_count];
            [self insertCellBelowIndexPath:indexPath count:i_count];
            
        }
        
    }
    else {
        self.selectedRowIndexPath=indexPath;
        [self insertCellBelowIndexPath:indexPath count:i_count];
    }
    
    [tableView endUpdates];
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    
}

-(void)insertCellBelowIndexPath:(NSIndexPath *)indexPath count:(NSInteger)i_count
{
    NSMutableArray *pathsArray=[[NSMutableArray alloc]init];
    for (int i=1;i<=i_count;i++) {
        indexPath=[NSIndexPath indexPathForRow:(indexPath.row+1) inSection:indexPath.section];
        [pathsArray addObject:indexPath];
    }
    //NSArray *pathsArray=@[indexPath];
    [tableView insertRowsAtIndexPaths:pathsArray withRowAnimation:UITableViewRowAnimationTop];
}

-(void)removeCellBelowIndexPath:(NSIndexPath *)indexPath count:(NSInteger)i_count
{
    NSMutableArray *pathsArray=[[NSMutableArray alloc]init];
    for (int i=1;i<=i_count;i++) {
        indexPath=[NSIndexPath indexPathForRow:(indexPath.row+1) inSection:indexPath.section];
        [pathsArray addObject:indexPath];
    }
    [tableView deleteRowsAtIndexPaths:pathsArray withRowAnimation:UITableViewRowAnimationTop];
}

-(void)setSelectedRowIndexPath:(NSIndexPath *)selectedRowIndexPath {
    _selectedRowIndexPath=selectedRowIndexPath;
}

-(BOOL)isExtendedCellIndexPath:(NSIndexPath *)indexPath {
    if (indexPath && self.selectedRowIndexPath) {
        if (indexPath.row==self.selectedRowIndexPath.row+1 && indexPath.section==self.selectedRowIndexPath.section) {
            return YES;
        }
    }
    return NO;
}

-(BOOL)isSelectedRowIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath && self.selectedRowIndexPath) {
        if (indexPath.row==self.selectedRowIndexPath.row && indexPath.section ==self.selectedRowIndexPath.section) {
            return YES;
        }
    }
    return NO;
}


//判断同意或常用语
-(UIView*)viewForContainerAtIndexPath:(NSIndexPath *)indexPath dic:(NSDictionary*)dic_tmp cell:(TableViewCell*)cell {
    if ([self isExtendedCellIndexPath:indexPath]) {
        NSString *str_lable=[dic_tmp objectForKey:@"label"];
        UILabel *lbl_label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,cell.frame.size.height)];
        lbl_label.text=str_lable;
        lbl_label.textColor=[UIColor blueColor];
        return lbl_label;
    }
    else {
        return nil;
    }
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
