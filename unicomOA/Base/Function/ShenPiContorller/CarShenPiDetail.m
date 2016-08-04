//
//  CarShenPiDetail.m
//  unicomOA
//
//  Created by hnsi-03 on 16/4/13.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "CarShenPiDetail.h"
#import "ShenPiAgree.h"
#import "ShenPiDisAgree.h"
#import "ShenPiCopy.h"
#import "ShenPiResultCell.h"
#import "ShenPiAgreeWithCarDeploy.h"

@interface CarShenPiDetail()<ShenPiAgreeDelegate,ShenPiDisAgreeDelegate,ShenPiAgreeWithCarDeployDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIButton *btn_agree;

@property (nonatomic,strong) UIButton *btn_disagree;

@end

@implementation CarShenPiDetail

-(void)viewDidLoad {
    [super viewDidLoad];
    [self.tableview setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-100)];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    barButtonItem.tintColor=[UIColor whiteColor];
    [barButtonItem setImage:[UIImage imageNamed:@"returnlogo.png"]];
    self.navigationItem.leftBarButtonItem=barButtonItem;
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-150) style:UITableViewStyleGrouped];
    _tableview.delegate=self;
    _tableview.dataSource=self;
    _tableview.backgroundColor=[UIColor clearColor];
    _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    _btn_agree=[self CreateButton:self.view.frame.size.width/6 y:self.view.frame.size.height-150 width:self.view.frame.size.width/3 height:50 text:@"同意"];
    
    _btn_disagree=[self CreateButton:self.view.frame.size.width/2 y:self.view.frame.size.height-150 width:self.view.frame.size.width/3 height:50 text:@"不同意"];
    
    UIButton *btn_copy=[self CreateButton:2*self.view.frame.size.width/3 y:self.view.frame.size.height-100 width:self.view.frame.size.width/3 height:50 text:@"抄送"];
    
    
    [_btn_agree addTarget:self action:@selector(SignToAgree:) forControlEvents:UIControlEventTouchUpInside];
    
    [_btn_disagree addTarget:self action:@selector(SignToDissAgree:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn_copy addTarget:self action:@selector(SignToCopy:) forControlEvents:UIControlEventTouchUpInside];
    
    if (_b_IsEnabled==NO) {
        [_btn_agree setEnabled:NO];
        [_btn_disagree setEnabled:NO];
    }
    else if (_b_IsEnabled==YES) {
        [_btn_disagree setEnabled:YES];
        [_btn_agree setEnabled:YES];
    }
    
    
    [self.view addSubview:_btn_agree];
    [self.view addSubview:_btn_disagree];
    [self.view addSubview:_tableview];
}

-(void)SignToAgree:(UIButton*)sender {
    if (self.service.shenpi_1!=nil && self.service.shenpi_2==nil) {
        ShenPiAgreeWithCarDeploy *viewController=[[ShenPiAgreeWithCarDeploy alloc]init];
        viewController.delegate=self;
        viewController.user_info=_user_Info;
        [self.navigationController pushViewController:viewController animated:NO];
        
    }
    else if (self.service.shenpi_1==nil && self.service.shenpi_2==nil) {
        ShenPiAgree *viewController=[[ShenPiAgree alloc]init];
        viewController.delegate=self;
        viewController.userInfo=_user_Info;
        [self.navigationController pushViewController:viewController animated:NO];
    }
    
}

-(void)SignToDissAgree:(UIButton*)sender {
    ShenPiDisAgree *viewController=[[ShenPiDisAgree alloc]init];
    viewController.delegate=self;
    viewController.userInfo=_user_Info;
    [self.navigationController pushViewController:viewController animated:NO];
}

-(void)SignToCopy:(UIButton*)sender {
    /*
    ShenPiCopy *viewController=[[ShenPiCopy alloc]init];
    viewController.delegate=self;
    viewController.userInfo=_user_Info;
    [self.navigationController pushViewController:viewController animated:YES];
     */
}

-(UIButton*)CreateButton:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height text:(NSString*)str_text{
    UIButton *btn_tmp=[[UIButton alloc]initWithFrame:CGRectMake(x, y, width, height)];
    [btn_tmp setTitle:str_text forState:UIControlStateNormal];
    btn_tmp.backgroundColor=[UIColor whiteColor];
    [btn_tmp setTitleColor:[UIColor colorWithRed:30/255.0f green:155/255.0f blue:240/255.0f alpha:1] forState:UIControlStateNormal];
    btn_tmp.layer.borderWidth=1;
    btn_tmp.titleLabel.font=[UIFont systemFontOfSize:13];
    return btn_tmp;
    
}

-(void)MovePreviousVc:(UIButton*)sender {
    [_delegate CarRefreshTableView];
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)SendAgreeStatus:(ShenPiStatus *)tmp_status {
    if (self.service.shenpi_1==nil) {
        self.service.shenpi_1=tmp_status;
    }
    else if (self.service.shenpi_2==nil) {
        self.service.shenpi_2=tmp_status;
        [_btn_agree setEnabled:NO];
        [_btn_disagree setEnabled:NO];
    }
    [self.tableview reloadData];
    
}

-(void)SendDisAgreeStatus:(ShenPiStatus *)tmp_Status {
    if (self.service.shenpi_1==nil) {
        self.service.shenpi_1=tmp_Status;
        [_btn_agree setEnabled:NO];
        [_btn_disagree setEnabled:NO];
    }
    else if (self.service.shenpi_2==nil) {
        self.service.shenpi_2=tmp_Status;
        [_btn_agree setEnabled:NO];
        [_btn_disagree setEnabled:NO];
    }
    [self.tableview reloadData];
}

-(void)SendAgreeStatus:(ShenPiStatus *)tmp_status CarModel:(CarModel *)model {
    if (self.service.shenpi_2==nil) {
        self.service.shenpi_2=tmp_status;
        //self.service.car_model=model;
    }
    [self.tableview reloadData];
}

-(void)SendShenPiCopyUser:(NSMutableArray *)usr_copy {
    
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

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return 40;
    }
    else {
        return 100;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    view.backgroundColor=[UIColor clearColor];
    CGRect view_title;
    view_title=CGRectMake(0, 0, self.view.frame.size.width, 30);
    UILabel *lbl_sectionTitle=[[UILabel alloc]initWithFrame:view_title];
    lbl_sectionTitle.textAlignment=NSTextAlignmentCenter;
    lbl_sectionTitle.backgroundColor=[UIColor whiteColor];
    if (section==0) {
        lbl_sectionTitle.text=@"基本信息";
        lbl_sectionTitle.textColor=[UIColor colorWithRed:70/255.0f green:115/255.0f blue:230/255.0f alpha:1];
    }
    [view addSubview:lbl_sectionTitle];
    return view;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ID=@"cell";
    
    
    if (indexPath.section==0) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:ID];
        }
        cell.textLabel.textAlignment=NSTextAlignmentLeft;
        cell.textLabel.textColor=[UIColor colorWithRed:122/255.0f green:122/255.0f blue:122/255.0f alpha:1];
        cell.detailTextLabel.textColor=[UIColor colorWithRed:199/255.0f green:199/255.0f blue:199/255.0f alpha:1];
        cell.textLabel.font=[UIFont systemFontOfSize:16];
        cell.detailTextLabel.font=[UIFont systemFontOfSize:16];
        
        UIView *leftView=[[UIView alloc]init];
        UIView *rightView=[[UIView alloc]init];
        if (iPhone5_5s || iPhone4_4s) {
            [leftView setFrame:CGRectMake(0, 0, 100, 40)];
            [rightView setFrame:CGRectMake(100, 0, 220, 40)];
        }
        else if (iPhone6) {
            [leftView setFrame:CGRectMake(0, 0, 105, 40)];
            [rightView setFrame:CGRectMake(105, 0, 270, 40)];
        }
        else {
            [leftView setFrame:CGRectMake(0, 0, 113, 40)];
            [rightView setFrame:CGRectMake(113, 0, 301, 40)];
        }
        if (indexPath.row%2==0) {
            if (indexPath.row!=0) {
                leftView.backgroundColor=[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
                rightView.backgroundColor=[UIColor whiteColor];
            }
        }
        else {
            leftView.backgroundColor=[UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1];
            rightView.backgroundColor=[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
        }
        
        if (indexPath.row==0) {
            UILabel *leftLabel=[[UILabel alloc]init];
            UILabel *rightLabel=[[UILabel alloc]init];
            if (iPhone4_4s || iPhone5_5s) {
                [leftLabel setFrame:CGRectMake(70, 0, 90, 40)];
                [rightLabel setFrame:CGRectMake(160, 0,90, 40)];
            }
            else if (iPhone6) {
                [leftLabel setFrame:CGRectMake(97.5, 0, 90, 40)];
                [rightLabel setFrame:CGRectMake(187.5, 0, 90, 40)];
            }
            else {
                [leftLabel setFrame:CGRectMake(122, 0, 90, 40)];
                [rightLabel setFrame:CGRectMake(212, 0, 90, 40)];
            }
            leftLabel.backgroundColor=[UIColor whiteColor];
            rightLabel.backgroundColor=[UIColor whiteColor];
            leftLabel.textAlignment=NSTextAlignmentCenter;
            rightLabel.textAlignment=NSTextAlignmentCenter;
            leftLabel.text=@"申请流程";
            rightLabel.text=@"预约用车";
            leftLabel.font=[UIFont systemFontOfSize:16];
            rightLabel.font=[UIFont systemFontOfSize:16];
            leftLabel.textColor=[UIColor colorWithRed:192/255.0f green:192/255.0f blue:192/255.0f alpha:1];
            rightLabel.textColor=[UIColor colorWithRed:109/255.0f green:147/255.0f blue:240/255.0f alpha:1];
            [cell.contentView addSubview:leftLabel];
            [cell.contentView addSubview:rightLabel];
            
            return cell;
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
        [cell.contentView addSubview:leftView];
        [cell.contentView addSubview:rightView];
        [cell.contentView sendSubviewToBack:leftView];
        [cell.contentView sendSubviewToBack:rightView];
        
        return cell;
    }
    else {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cellid"];
        return cell;
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
