//
//  PrintShenPiDetail.m
//  unicomOA
//
//  Created by hnsi-03 on 16/4/13.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "PrintShenPiDetail.h"
#import "ShenPiAgree.h"
#import "ShenPiDisAgree.h"
#import "ShenPiResultCell.h"
#import "PrintFileNavCell.h"
#import "PrintFileDetail.h"

@interface PrintShenPiDetail()<ShenPiAgreeDelegate,ShenPiDisAgreeDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIButton *btn_agree;

@property (nonatomic,strong) UIButton *btn_disagree;

@end


@implementation PrintShenPiDetail

-(void)viewDidLoad {
    [super viewDidLoad];
    //[self.tableview setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-100)];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    barButtonItem.tintColor=[UIColor whiteColor];
    [barButtonItem setImage:[UIImage imageNamed:@"returnlogo.png"]];
    self.navigationItem.leftBarButtonItem=barButtonItem;
    
    _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-150) style:UITableViewStylePlain];
    _tableview.delegate=self;
    _tableview.dataSource=self;
    _tableview.backgroundColor=[UIColor clearColor];
    _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    

    self.view.backgroundColor=[UIColor whiteColor];
    
    _btn_agree=[self CreateButton:self.view.frame.size.width/6 y:self.view.frame.size.height-150 width:self.view.frame.size.width/3 height:50 text:@"同意"];
    
    _btn_disagree=[self CreateButton:self.view.frame.size.width/2 y:self.view.frame.size.height-150 width:self.view.frame.size.width/3 height:50 text:@"不同意"];
    
    
    
    [_btn_agree addTarget:self action:@selector(SignToAgree:) forControlEvents:UIControlEventTouchUpInside];
    
    [_btn_disagree addTarget:self action:@selector(SignToDissAgree:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if (_b_isEnabled==YES) {
        [_btn_agree setEnabled:YES];
        [_btn_disagree setEnabled:YES];
    }
    else {
        [_btn_disagree setEnabled:NO];
        [_btn_agree setEnabled:NO];
    }
    
    [self.view addSubview:_btn_agree];
    [self.view addSubview:_btn_disagree];
    [self.view addSubview:_tableview];
}

-(void)SignToAgree:(UIButton*)sender {
    ShenPiAgree *viewController=[[ShenPiAgree alloc]init];
    viewController.delegate=self;
    viewController.userInfo=_user_Info;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)SignToDissAgree:(UIButton*)sender {
    ShenPiDisAgree *viewController=[[ShenPiDisAgree alloc]init];
    viewController.delegate=self;
    viewController.userInfo=_user_Info;
    [self.navigationController pushViewController:viewController animated:YES];
}


-(UIButton*)CreateButton:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height text:(NSString*)str_text{
    UIButton *btn_tmp=[[UIButton alloc]initWithFrame:CGRectMake(x, y, width, height)];
    [btn_tmp setTitle:str_text forState:UIControlStateNormal];
    btn_tmp.backgroundColor=[UIColor whiteColor];
    [btn_tmp setTitleColor:[UIColor colorWithRed:30/255.0f green:155/255.0f blue:240/255.0f alpha:1] forState:UIControlStateNormal];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 204/255.0f, 204/255.0f, 204/255.0f, 1 });
    btn_tmp.layer.borderColor=colorref;
    btn_tmp.layer.borderWidth=1;
    btn_tmp.titleLabel.font=[UIFont systemFontOfSize:13];
    return btn_tmp;
    
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

-(void)MovePreviousVc:(UIButton*)sender {
    [_delegate PrintRefreshTableView];
    [self.navigationController popViewControllerAnimated:YES];
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


#pragma mark tableview方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 7;
    }
    else if (section==1) {
        return _service.arr_PrintFiles.count;
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

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    view.backgroundColor=[UIColor clearColor];
    CGRect view_title;
    view_title=CGRectMake(0, 0, self.view.frame.size.width, 30);
    UILabel *lbl_sectionTitle=[[UILabel alloc]initWithFrame:view_title];
    //lbl_sectionTitle.textAlignment=NSTextAlignmentLeft;
    if (section==0) {
        lbl_sectionTitle.textAlignment=NSTextAlignmentCenter;
        lbl_sectionTitle.text=@"基本信息";
        lbl_sectionTitle.backgroundColor=[UIColor whiteColor];
        lbl_sectionTitle.textColor=[UIColor colorWithRed:70/255.0f green:115/255.0f blue:230/255.0f alpha:1];
    }
    else if (section==1) {
        lbl_sectionTitle.text=@"    复印文件";
        lbl_sectionTitle.textColor=[UIColor blackColor];
        lbl_sectionTitle.backgroundColor=[UIColor clearColor];
        lbl_sectionTitle.textAlignment=NSTextAlignmentLeft;
    }
    else  {
        lbl_sectionTitle.backgroundColor=[UIColor whiteColor];
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

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ID=@"cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:ID];
    }
    cell.textLabel.textAlignment=NSTextAlignmentLeft;
    cell.textLabel.textColor=[UIColor colorWithRed:122/255.0f green:122/255.0f blue:122/255.0f alpha:1];
    cell.detailTextLabel.textColor=[UIColor colorWithRed:199/255.0f green:199/255.0f blue:199/255.0f alpha:1];
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    cell.detailTextLabel.font=[UIFont systemFontOfSize:16];
    
    
    if (indexPath.section==0) {
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
           // cell.textLabel.text=@"申请流程";
           // cell.detailTextLabel.text=@"复印申请";
           // cell.detailTextLabel.textColor=[UIColor blackColor];
            UILabel *leftLabel=[[UILabel alloc]init];
            UILabel *rightLabel=[[UILabel alloc]init];
            if (iPhone4_4s || iPhone5_5s) {
                [leftLabel setFrame:CGRectMake(70, 0, 90, 40)];
                [rightLabel setFrame:CGRectMake(160, 0,250, 40)];
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
            rightLabel.text=@"复印流程";
            leftLabel.font=[UIFont systemFontOfSize:16];
            rightLabel.font=[UIFont systemFontOfSize:16];
            leftLabel.textColor=[UIColor colorWithRed:192/255.0f green:192/255.0f blue:192/255.0f alpha:1];
            rightLabel.textColor=[UIColor colorWithRed:109/255.0f green:147/255.0f blue:240/255.0f alpha:1];
            [cell.contentView addSubview:leftLabel];
            [cell.contentView addSubview:rightLabel];
            
            return cell;
        }
        else if (indexPath.row==1) {
            cell.textLabel.text=@"复印标题";
            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@%@",_service.str_title,@"项目打印清单"];
         
        }
        else if (indexPath.row==2) {
            cell.textLabel.text=@"备注信息";
            cell.detailTextLabel.text=_service.str_remark;
        }
        else if (indexPath.row==3) {
            cell.textLabel.text=@"发起人";
            cell.detailTextLabel.text=_service.str_name;
        }
        else if (indexPath.row==4) {
            cell.textLabel.text=@"所在部门";
            cell.detailTextLabel.text=_service.str_department;
        }
        else if (indexPath.row==5) {
            cell.textLabel.text=@"联系电话";
            cell.detailTextLabel.text=_service.str_phonenum;
        }
        else if (indexPath.row==6) {
            cell.textLabel.text=@"发起时间";
            cell.detailTextLabel.text=_service.str_time;
        }
        
        [cell.contentView addSubview:leftView];
        [cell.contentView addSubview:rightView];
        [cell.contentView sendSubviewToBack:leftView];
        [cell.contentView sendSubviewToBack:rightView];
    }
    else if (indexPath.section==1) {
        PrintFiles *tmp_File=[_service.arr_PrintFiles objectAtIndex:(indexPath.row)];
        // PrintApplicationFileCell *cell=[PrintApplicationFileCell cellWithTable:tableView withTitle:@"周口太昊陵项目竣工验收图纸" withPages:24 withCopies:3 withCellHeight:100];
        PrintFileNavCell *cell=[PrintFileNavCell cellWithTable:tableView withTitle:tmp_File.str_filename withPages:tmp_File.i_pages withCopies:tmp_File.i_copies  atIndexPath:indexPath];
        cell.file=tmp_File;
        return cell;
    }
    else if (indexPath.section==2) {
        if (indexPath.row==0) {
            if (_service.shenpi_1!=nil) {
                ShenPiStatus *tmp_status=_service.shenpi_1;
                ShenPiResultCell *cell=[ShenPiResultCell cellWithTable:tableView withImage:tmp_status.str_Logo withName:tmp_status.str_name withStatus:tmp_status.str_status withTime:tmp_status.str_time atIndex:indexPath];
                return cell;
            }
            else {
                ShenPiResultCell *cell=[ShenPiResultCell cellWithTable:tableView withImage:@"headLogo.png" withName:@"李四" withStatus:@"审批中" withTime:@"04-04 16:16" atIndex:indexPath];
                return cell;
                
            }
            
        }
        else if (indexPath.row==1) {
            if (_service.shenpi_2!=nil) {
                ShenPiStatus *tmp_status=_service.shenpi_2;
                ShenPiResultCell *cell=[ShenPiResultCell cellWithTable:tableView withImage:tmp_status.str_Logo withName:tmp_status.str_name withStatus:tmp_status.str_status withTime:tmp_status.str_time atIndex:indexPath];
                return cell;
            }
            else {
                ShenPiResultCell *cell=[ShenPiResultCell cellWithTable:tableView withImage:@"headLogo.png" withName:@"李四" withStatus:@"审批中" withTime:@"04-04 16:16" atIndex:indexPath];
                return cell;
            }
            
        }
        else {
            ShenPiResultCell *cell=[ShenPiResultCell cellWithTable:tableView withImage:@"headLogo.png" withName:@"李四" withStatus:@"审批中" withTime:@"04-04 16:16" atIndex:indexPath];
            return cell;
        }
    }
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1) {
        PrintFileNavCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        PrintFiles *tmp_Files=cell.file;
        PrintFileDetail *viewController=[[PrintFileDetail alloc]init];
        viewController.file=tmp_Files;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}


@end
