//
//  PrintApplicationDetail.m
//  unicomOA
//
//  Created by hnsi-03 on 16/4/12.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "PrintApplicationDetail.h"
#import "ShenPiResultCell.h"
#import "PrintFileNavCell.h"
#import "PrintFileDetail.h"

@interface PrintApplicationDetail()<UITableViewDelegate,UITableViewDataSource>



@end

@implementation PrintApplicationDetail

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"申请详情";
    
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
    
    [self.view addSubview:_tableview];

}

-(void)MovePreviousVc:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
    lbl_sectionTitle.textAlignment=NSTextAlignmentLeft;
    if (section==0) {
        lbl_sectionTitle.text=@"    基本信息";
        lbl_sectionTitle.textColor=[UIColor colorWithRed:70/255.0f green:115/255.0f blue:230/255.0f alpha:1];
        lbl_sectionTitle.backgroundColor=[UIColor whiteColor];
    }
    else if (section==1) {
        lbl_sectionTitle.text=@"    复印文件";
        lbl_sectionTitle.textColor=[UIColor blackColor];
        lbl_sectionTitle.backgroundColor=[UIColor clearColor];
    }
    else {
        //lbl_sectionTitle.text=@"    审批结果";
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:ID];
    }
    cell.textLabel.textAlignment=NSTextAlignmentLeft;
    cell.textLabel.textColor=[UIColor blackColor];
    cell.detailTextLabel.textColor=[UIColor colorWithRed:152/255.0f green:152/255.0f blue:152/255.0f alpha:1];
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    cell.detailTextLabel.font=[UIFont systemFontOfSize:16];
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            cell.textLabel.text=@"申请流程";
            cell.detailTextLabel.text=@"复印申请";
            cell.detailTextLabel.textColor=[UIColor blackColor];
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
    }
    /*
    else if (indexPath.section==1) {
        PrintFiles *tmp_File=[_service.arr_PrintFiles objectAtIndex:(indexPath.row)];
        // PrintApplicationFileCell *cell=[PrintApplicationFileCell cellWithTable:tableView withTitle:@"周口太昊陵项目竣工验收图纸" withPages:24 withCopies:3 withCellHeight:100];
        PrintFileNavCell *cell=[PrintFileNavCell cellWithTable:tableView withTitle:tmp_File.str_filename withPages:tmp_File.i_pages withCopies:tmp_File.i_copies  atIndexPath:indexPath];
        cell.file=tmp_File;
        
        return cell;

    }
    */
    else {
        if (indexPath.row==0) {
            if (_service.shenpi_1!=nil) {
                ShenPiStatus *tmp_status=_service.shenpi_1;
                
               // ShenPiResultCell *cell=[ShenPiResultCell cellWithTable:tableView withImage:tmp_status.str_Logo withName:tmp_status.str_name withStatus:tmp_status.str_status  withTime:tmp_status.str_time ActivityName:@"" atIndex:indexPath];
                return cell;
            }
            else {
               // ShenPiResultCell *cell=[ShenPiResultCell cellWithTable:tableView withImage:@"headLogo.png" withName:@"李四" withStatus:@"审批中" withTime:@"04-04 16:16" ActivityName:@"" atIndex:indexPath];
                return cell;
                
            }
            
        }
        else if (indexPath.row==1) {
            if (_service.shenpi_2!=nil) {
                ShenPiStatus *tmp_status=_service.shenpi_2;
           //     ShenPiResultCell *cell=[ShenPiResultCell cellWithTable:tableView withImage:tmp_status.str_Logo withName:tmp_status.str_name withStatus:tmp_status.str_status withTime:tmp_status.str_time ActivityName:@"" atIndex:indexPath];
                return cell;
            }
            else {
             //   ShenPiResultCell *cell=[ShenPiResultCell cellWithTable:tableView withImage:@"headLogo.png" withName:@"李四" withStatus:@"审批中"   withTime:@"04-04 16:16" ActivityName:@"" atIndex:indexPath];
                return cell;
            }
            
        }
        else {
          //  ShenPiResultCell *cell=[ShenPiResultCell cellWithTable:tableView withImage:@"headLogo.png" withName:@"李四" withStatus:@"审批中" withTime:@"04-04 16:16" ActivityName:@"" atIndex:indexPath];
            return cell;
        }        
    }
    
    return cell;

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
    if (indexPath.section==1) {
        PrintFileNavCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        PrintFiles *tmp_Files=cell.file;
        PrintFileDetail *viewController=[[PrintFileDetail alloc]init];
        viewController.file=tmp_Files;
        [self.navigationController pushViewController:viewController animated:YES];
    }
     */
    
}





@end
