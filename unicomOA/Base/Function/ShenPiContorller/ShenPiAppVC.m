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
#import "DYCAddress.h"
#import "DYCAddressPickerView.h"
#import "Address.h"
#import "TableViewCell.h"
#import "LXAlertView.h"

@interface ShenPiAppVC()<UITableViewDelegate,UITableViewDataSource,DYCAddressDelegate,DYCAddressPickerViewDelegate>

@property (nonatomic,strong) AFHTTPSessionManager *session;

//控件组
@property (nonatomic,strong) NSArray *arr_groupList;
//初始控件列表
@property (nonatomic,strong) NSArray *arr_ctlList;

//控件列表组织后的
@property (nonatomic,strong) NSDictionary *dic_clt;

@property (nonatomic,strong) UITableView *tableview;

@property (strong,nonatomic) NSIndexPath *selectedRowIndexPath;

//提交数据的url
@property (strong,nonatomic) NSString *str_url_postdata;

@property NSInteger i_rowCount;

@end


@implementation ShenPiAppVC {
    DataBase *db;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    if (_str_title!=nil) {
        self.title=[NSString stringWithFormat:@"%@%@%@",@"新建",_str_title,@"申请"];
    }
    else {
        self.title=@"新建申请";
    }
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    [barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(Submit:)];
    [barButtonItem2 setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=barButtonItem2;
    
    self.view.backgroundColor=[UIColor colorWithRed:246/255.0f green:249/255.0f blue:254/255.0f alpha:1];
    
    _i_rowCount=0;
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
                _str_url_postdata=[JSON objectForKey:@"url"];
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


//根据js ajax规范，修改key值，调整.为/
-(NSString*)modifykey:(NSString*)str_key {
    NSString *str_return=[str_key stringByReplacingOccurrencesOfString:@"." withString:@"/"];
    return str_return;
}


-(void)Submit:(UIButton*)sender {
    //提交申请
   // NSMutableDictionary *dic_submit=[[NSMutableDictionary alloc]init];
    NSMutableArray *arr_m_ctlList=(NSMutableArray*)_arr_ctlList;
    NSMutableDictionary *dic_sub=[NSMutableDictionary dictionary];
    for (int i=0;i<[arr_m_ctlList count];i++) {
        NSDictionary *dic_ctl= [arr_m_ctlList objectAtIndex:i];
        NSString *str_key=[dic_ctl objectForKey:@"key"];
        str_key=[self modifykey:str_key];
        NSObject *obj_value=[dic_ctl objectForKey:@"value"];
        if (obj_value!=nil && obj_value!=[NSNull null]) {
            NSString *str_value=(NSString*)obj_value;
            if (![str_value isEqualToString:@""]) {
                dic_sub[str_key]=str_value;
            }
          //  [arr_submit addObject:dic_sub];
        }
        
    }
    
    if (_i_rowCount!=0) {
        for (int i=0;i<_i_rowCount;i++) {
            UITableViewCell *cell=[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if (![cell isMemberOfClass:[UITableViewCell class]]) {
                NSString *str_key=cell.accessibilityHint;
                str_key=[self modifykey:str_key];
                NSString *str_value=@"";
                if ([cell isMemberOfClass:[PrintApplicationTitleCell class]]) {
                    PrintApplicationTitleCell *print_cell=(PrintApplicationTitleCell*)cell;
                    str_value=print_cell.txt_title.text;
                     dic_sub[str_key]=str_value;
                                   }
                else if ([cell isMemberOfClass:[PrintApplicationDetailCell class]]) {
                    PrintApplicationDetailCell *detail_cell=(PrintApplicationDetailCell*)cell;
                    str_value=detail_cell.txt_detail.text;
                    dic_sub[str_key]=str_value;
                }
            }
            else {
                if (cell.accessibilityValue!=nil && ![cell.accessibilityValue isEqual:@""]) {
                    NSString *str_key=cell.accessibilityValue;
                    str_key=[self modifykey:str_key];
                    NSString *str_value=cell.detailTextLabel.text;
                     dic_sub[str_key]=str_value;
                    
                }
            }
            
        }
    }
    
    [self SubmitUrl:dic_sub];

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
        BOOL b_isExpanded=NO;
        for (int i=0;i<[arr_ctl count];i++) {
            NSDictionary *dic_tmp=[arr_ctl objectAtIndex:i];
            NSString *str_type= [dic_tmp objectForKey:@"type"];
            if (![str_type isEqualToString:@"hidden"]) {
                i_count=i_count+1;
                if ([str_type isEqualToString:@"date"] || [str_type isEqualToString:@"picker"]) {
                    b_isExpanded=YES;
                }
            }
        }
        if (b_isExpanded==NO) {
            _i_rowCount=i_count;
            return i_count;
        }
        else {
            if (self.selectedRowIndexPath) {
                _i_rowCount=i_count+1;
                return  i_count+1;
            }
            else {
                _i_rowCount=i_count;
                return i_count;
            }
        }
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
        NSIndexPath *index_selected=self.selectedRowIndexPath;
        NSString *str_index=[NSString stringWithFormat:@"%ld",(long)indexPath.section];
        NSArray *arr_ctl= [_dic_clt objectForKey:str_index];
        NSDictionary *dic_tmp;
        if (index_selected!=nil) {
            if (indexPath.section==index_selected.section) {
                if (indexPath.row<=index_selected.row) {
                    dic_tmp=[arr_ctl objectAtIndex:indexPath.row];
                }
                else if (indexPath.row>index_selected.row){
                    if (indexPath.row==index_selected.row+1) {
                        return 180;
                    }
                    else {
                        dic_tmp=[arr_ctl objectAtIndex:indexPath.row-1];
                    }
                   
                }
            }
            else {
                dic_tmp=[arr_ctl objectAtIndex:indexPath.row];
            }
            
        }
        else {
            dic_tmp = [arr_ctl objectAtIndex:indexPath.row];
        }
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
        cell.textLabel.text=@"";
        return cell;
    }
    else {
        NSString *str_index=[NSString stringWithFormat:@"%ld",(long)indexPath.section];
        NSArray *arr_ctl= [_dic_clt objectForKey:str_index];
        NSMutableArray *arr_m_ctl=[self DispalyUIWithoutHidden:arr_ctl];
        //if (indexPath.row<[arr_m_ctl count]) {
        NSDictionary *dic_tmp;
        if (self.selectedRowIndexPath!=nil) {
            if (indexPath.section==self.selectedRowIndexPath.section) {
                if (indexPath.row<=self.selectedRowIndexPath.row) {
                    dic_tmp= [arr_m_ctl objectAtIndex:indexPath.row];
                }
                else if (indexPath.row>self.selectedRowIndexPath.row) {
                    if (indexPath.row==self.selectedRowIndexPath.row+1) {
                        NSDictionary *dic_previous=[arr_m_ctl objectAtIndex:indexPath.row-1];
                        NSString *str_type=[dic_previous objectForKey:@"type"];
                        NSString *identifier = [TableViewCell reusableIdentifier];
                        TableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:identifier owner:self options:nil]objectAtIndex:0];
                        if ([str_type isEqualToString:@"date"]) {
                            [cell addcontentView:[self viewForContainerAtIndexPath:indexPath isDate:YES]];
                        }
                        else if ([str_type isEqualToString:@"picker"]) {
                            [cell addcontentView:[self viewForContainerAtIndexPath:indexPath isDate:NO]];
                        }
                        return cell;
                    }
                    else {
                        dic_tmp=[arr_m_ctl objectAtIndex:indexPath.row-1];
                    }
                    
                }
            }
            else {
                dic_tmp= [arr_m_ctl objectAtIndex:indexPath.row];
            }
            
        }
        else {
            dic_tmp=[arr_m_ctl objectAtIndex:indexPath.row];
        }
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
                        cell.accessibilityHint=@"NotExpanded";
                    }
                    else {
                        NSString *str_label=[dic_tmp objectForKey:@"label"];
                        NSString *str_require=[dic_tmp objectForKey:@"require"];
                        BOOL b_require=[str_require boolValue];
                        if (b_require==YES) {
                            str_label=[NSString stringWithFormat:@"%@%@",str_label,@"（必填）"];
                        }
                        NSObject *obj_prompt=[dic_tmp objectForKey:@"prompt"];
                        NSString *str_key=[dic_tmp objectForKey:@"key"];
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
                            PrintApplicationTitleCell *cell=[PrintApplicationTitleCell cellWithTable:tableView withName:str_label withPlaceHolder:str_prompt withText:str_value atIndexPath:indexPath keyboardType:UIKeyboardTypeDefault];
                            cell.accessibilityHint=str_key;
                            return cell;
                        }
                        else if ([str_type isEqualToString:@"int"]) {
                            PrintApplicationTitleCell *cell=[PrintApplicationTitleCell cellWithTable:tableView withName:str_label withPlaceHolder:str_prompt withText:str_value atIndexPath:indexPath keyboardType:UIKeyboardTypeNumberPad];
                            cell.accessibilityHint=str_key;
                            return cell;
                        }
                        
                        
                    }
                }
                else if ([str_type isEqualToString:@"textarea"]) {
                    NSString *str_readonly=[dic_tmp objectForKey:@"readonly"];
                    BOOL b_readonly=[str_readonly boolValue];
                    if (b_readonly==YES) {
                        
                    }
                    else {
                        NSString *str_label=[dic_tmp objectForKey:@"label"];
                        NSString *str_require=[dic_tmp objectForKey:@"require"];
                        BOOL b_require=[str_require boolValue];
                        if (b_require==YES) {
                            str_label=[NSString stringWithFormat:@"%@%@",str_label,@"（必填）"];
                        }
                        NSString *str_key=[dic_tmp objectForKey:@"key"];
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
                        PrintApplicationDetailCell *cell=[PrintApplicationDetailCell cellWithTable:tableView withName:str_label withPlaceHolder:str_prompt withText:str_value atIndexPath:indexPath atHeight:180];
                        cell.accessibilityHint=str_key;
                        return cell;
                    }
                }
                else if ([str_type isEqualToString:@"date"]) {
                    NSString *str_label=[dic_tmp objectForKey:@"label"];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
                    NSString *str_key=[dic_tmp objectForKey:@"key"];
                    cell.textLabel.text=str_label;
                    cell.detailTextLabel.text=strDate;
                    cell.accessibilityHint=@"canExpandDate";
                    cell.accessibilityValue=str_key;
                }
                else if ([str_type isEqualToString:@"picker"]) {
                    NSString *str_label=[dic_tmp objectForKey:@"label"];
                    NSString *str_key=[dic_tmp objectForKey:@"key"];
                    cell.textLabel.text=str_label;
                    cell.detailTextLabel.text=@"郑州";
                    cell.accessibilityHint=@"canExpandPicker";
                    cell.accessibilityValue=str_key;
                }
            }
      //  }
        
        
            
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
    if (![self isExtendedCellIndexPath:indexPath]) {
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        if ([cell.accessibilityHint isEqualToString:@"canExpandDate"] || [cell.accessibilityHint isEqualToString:@"canExpandPicker"]) {
            [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
            [self extendCellAtIndexPath:indexPath];
         }
    }
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


#pragma mark  点击时间后下拉扩展cell事件

-(void)extendCellAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableview beginUpdates];
    
    if (self.selectedRowIndexPath) {
        if ([self isSelectedRowIndexPath:indexPath]) {
            NSIndexPath *tempIndexPath=self.selectedRowIndexPath;
            self.selectedRowIndexPath=nil;
            [self removeCellBelowIndexPath:tempIndexPath];
        }
        else if ([self isExtendedCellIndexPath:indexPath]);
        else {
            NSIndexPath *tempIndexPath=self.selectedRowIndexPath;
            if (indexPath.row>self.selectedRowIndexPath.row && indexPath.section==self.selectedRowIndexPath.section) {
                indexPath=[NSIndexPath indexPathForRow:(indexPath.row-1) inSection:indexPath.section];
            }
            self.selectedRowIndexPath=indexPath;
            [self removeCellBelowIndexPath:tempIndexPath];
            [self insertCellBelowIndexPath:indexPath];
            
        }
        
    }
    else {
        self.selectedRowIndexPath=indexPath;
        [self insertCellBelowIndexPath:indexPath];
    }
    
    [self.tableview endUpdates];
    [self.tableview scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    
}

-(void)insertCellBelowIndexPath:(NSIndexPath *)indexPath
{
    indexPath=[NSIndexPath indexPathForRow:(indexPath.row+1) inSection:indexPath.section];
    NSArray *pathsArray=@[indexPath];
    [self.tableview insertRowsAtIndexPaths:pathsArray withRowAnimation:UITableViewRowAnimationTop];
}

-(void)removeCellBelowIndexPath:(NSIndexPath *)indexPath
{
    indexPath =[NSIndexPath indexPathForRow:(indexPath.row+1) inSection:indexPath.section];
    NSArray *pathsArray=@[indexPath];
    [self.tableview deleteRowsAtIndexPaths:pathsArray withRowAnimation:UITableViewRowAnimationTop];
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

//判断是添加日期PickerView还是地市PickerView
-(UIView*)viewForContainerAtIndexPath:(NSIndexPath *)indexPath isDate:(BOOL)b_IsDate{
    if ([self isExtendedCellIndexPath:indexPath]) {
        if (b_IsDate==YES) {
            UIDatePicker *datePicker=[[UIDatePicker alloc]init];
            [datePicker setDatePickerMode:UIDatePickerModeDate];
            // [datePicker setLocale:[NSLocale alloc]:@"zh_Hans_CN"];
            [datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
            [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
            [datePicker setTag:indexPath.row];
            UIView *dropDownView=datePicker;
            
            return dropDownView;
        }
        else {
            DYCAddress *address = [[DYCAddress alloc] init];
            address.dataDelegate = self;
            [address handlerAddress];
            DYCAddressPickerView *pickerView = [[DYCAddressPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180) withAddressArray:address.array];
            pickerView.DYCDelegate = self;
            pickerView.backgroundColor = [UIColor clearColor];
            UIView *dropDownView=pickerView;
            return dropDownView;
        }
        
    }
    else {
        return nil;
    }
}

-(void)dateChanged:(UIDatePicker*)sender  {
    NSDate *date=sender.date;
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString=[dateFormatter stringFromDate:date];
    if (self.selectedRowIndexPath!=nil) {
        UITableViewCell *cell=[self.tableview cellForRowAtIndexPath:self.selectedRowIndexPath];
        UILabel *lbl_date=cell.detailTextLabel;
        lbl_date.text=dateString;
        lbl_date.textColor=[UIColor blackColor];
    }
    
}

-(void)selectAddressProvince:(Address *)province andCity:(Address *)city andCounty:(Address *)county {
    //UITableViewCell *cell=[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0]];
    if (self.selectedRowIndexPath!=nil) {
        UITableViewCell *cell=[_tableview cellForRowAtIndexPath:self.selectedRowIndexPath];
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ %@ %@",province.name,city.name,county.name];
        cell.detailTextLabel.textColor=[UIColor blackColor];
    }
    /*
    for (NSString *key in _dic_clt) {
        NSArray *arr_sub_ctl=_dic_clt[key];
        for (int i=0;i<[arr_sub_ctl count];i++) {
            NSDictionary *dic_sub=[arr_sub_ctl objectAtIndex:i];
            NSString *str_type=[dic_sub objectForKey:@"type"];
            if ([str_type isEqualToString:@"picker"]) {
                NSIndexPath *index=[NSIndexPath indexPathForRow:i inSection:[key integerValue]];
                UITableViewCell *cell=[_tableview cellForRowAtIndexPath:index];
                cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ %@ %@",province.name,city.name,county.name];
                cell.detailTextLabel.textColor=[UIColor blackColor];
            }
        }
    }
     */
}

-(void)addressList:(NSArray *)array {
    
}




-(void)SubmitUrl:(NSMutableDictionary*)dic_param{
    if (_str_url_postdata!=nil) {
        
        NSString *str_ip=@"";
        NSString *str_port=@"";
        NSMutableArray *t_array=[db fetchIPAddress];
        if (t_array.count==1) {
            NSArray *arr_ip=[t_array objectAtIndex:0];
            str_ip=[arr_ip objectAtIndex:0];
            str_port=[arr_ip objectAtIndex:1];
        }
        
        
        NSString *str_url=[NSString stringWithFormat:@"%@%@:%@%@",@"http://",str_ip,str_port,_str_url_postdata];
        [_session POST:str_url parameters:dic_param progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *JSON=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSString *str_success= [JSON objectForKey:@"success"];
            BOOL b_success=[str_success boolValue];
            if (b_success==YES) {
                LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:@"提交申请成功" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
                    
                }];
                [alert showLXAlertView];

            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"申请失败：%@",error);
        }];
    }

}


@end
