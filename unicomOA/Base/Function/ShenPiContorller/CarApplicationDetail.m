//
//  CarApplicationDetail.m
//  unicomOA
//
//  Created by hnsi-03 on 16/4/12.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "CarApplicationDetail.h"


@interface CarApplicationDetail()<UITableViewDelegate,UITableViewDataSource>



@end

@implementation CarApplicationDetail

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"申请详情";
    
    //self.view.backgroundColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1];
    self.view.backgroundColor=[UIColor colorWithRed:246/255.0f green:249/255.0f blue:254/255.0f alpha:1];
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    barButtonItem.tintColor=[UIColor whiteColor];
    [barButtonItem setImage:[UIImage imageNamed:@"returnlogo.png"]];
    self.navigationItem.leftBarButtonItem=barButtonItem;
    
    _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _tableview.delegate=self;
    _tableview.dataSource=self;
    _tableview.backgroundColor=[UIColor clearColor];
    
 
  //  _arr_ShenPiStatus=[[NSMutableArray alloc]initWithCapacity:2];
        
    
    
    [self.view addSubview:_tableview];
    
}


-(void)MovePreviousVc:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark tableview方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 13;
    }
    else {
        return 2;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ID=@"cell";
    
    
    if (indexPath.section==0) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:ID];
        }
        cell.textLabel.textAlignment=NSTextAlignmentLeft;
        cell.textLabel.textColor=[UIColor blackColor];
        cell.detailTextLabel.textColor=[UIColor colorWithRed:152/255.0f green:152/255.0f blue:152/255.0f alpha:1];
        cell.textLabel.font=[UIFont systemFontOfSize:16];
        cell.detailTextLabel.font=[UIFont systemFontOfSize:16];
        if (indexPath.row==0) {
            cell.textLabel.text=@"申请流程";
            cell.detailTextLabel.text=@"预约用车";
            cell.detailTextLabel.textColor=[UIColor blackColor];
        }
        else if (indexPath.row==1) {
            cell.textLabel.text=@"申请人";
            cell.detailTextLabel.text=_service.str_name;
        }
        else if (indexPath.row==2) {
            cell.textLabel.text=@"所在部门";
            cell.detailTextLabel.text=_service.str_department;
        }
        else if (indexPath.row==3) {
            cell.textLabel.text=@"联系电话";
            cell.detailTextLabel.text=_service.str_phonenum;
        }
        else if (indexPath.row==4) {
            cell.textLabel.text=@"用车类别";
            cell.detailTextLabel.text=_service.str_categroy;
        }
        else if (indexPath.row==5) {
            cell.textLabel.text=@"用车人数";
            cell.detailTextLabel.text=[NSString stringWithFormat:@"%d", _service.i_usernum];
        }
        else if (indexPath.row==6) {
            cell.textLabel.text=@"使用人";
            cell.detailTextLabel.text=_service.str_usrname;
        }
        else if (indexPath.row==7) {
            cell.textLabel.text=@"用车时间";
            cell.detailTextLabel.text=_service.str_usingtime;
            cell.detailTextLabel.textColor=[UIColor colorWithRed:125/255.0f green:204/255.0f blue:255/255.0f alpha:1];
        }
        else if (indexPath.row==8) {
            cell.textLabel.text=@"返程时间";
            cell.detailTextLabel.text=_service.str_returntime;
            cell.detailTextLabel.textColor=[UIColor colorWithRed:125/255.0f green:204/255.0f blue:255/255.0f alpha:1];
        }
        else if (indexPath.row==9) {
            cell.textLabel.text=@"用车天数";
            //系统计算
            cell.detailTextLabel.text=[NSString stringWithFormat:@"%ld",(long)[self dateCalc:_service.str_usingtime returnDate:_service.str_returntime]];
        }
        else if (indexPath.row==10) {
            cell.textLabel.text=@"目的地";
            cell.detailTextLabel.text=_service.str_destination;
        }
        else if (indexPath.row==11) {
            cell.textLabel.text=@"出差事由";
            cell.detailTextLabel.text=_service.str_reason;
        }
        else if (indexPath.row==12) {
            cell.textLabel.text=@"备注信息";
            cell.detailTextLabel.text=_service.str_remark;
        }
        return cell;
    }
    
    else {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cellID"];
        return cell;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    view.backgroundColor=[UIColor clearColor];
    CGRect view_title;
    if (iPhone5_5s || iPhone4_4s) {
        view_title=CGRectMake(0, 0, self.view.frame.size.width*0.28, 30);
    }
    else {
        view_title=CGRectMake(0, 0, self.view.frame.size.width*0.2, 30);
    }
    UILabel *lbl_sectionTitle=[[UILabel alloc]initWithFrame:view_title];
    lbl_sectionTitle.textAlignment=NSTextAlignmentLeft;
    lbl_sectionTitle.backgroundColor=[UIColor whiteColor];
    if (section==0) {
        lbl_sectionTitle.text=@"基本信息";
    }
    else {
        lbl_sectionTitle.text=@"审批结果";
    }
    [view addSubview:lbl_sectionTitle];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return 40;
    }
    else {
        return 100;
    }
}

//使用日期与返程日期间的计算
-(NSInteger)dateCalc:(NSString*)str_usingdate returnDate:(NSString*)str_returndate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSDate *d_using=[formatter dateFromString:str_usingdate];
    NSDate *d_return=[formatter dateFromString:str_returndate];
    
    NSCalendar *userCalendar = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitDay;
    
    NSDateComponents *components=[userCalendar components:unitFlags fromDate:d_using toDate:d_return options:0];
    
    NSInteger days=[components day];
    
    days=days+1;
    return days;
}





@end
