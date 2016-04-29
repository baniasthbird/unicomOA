//
//  PrintApplication.m
//  unicomOA
//
//  Created by hnsi-03 on 16/4/6.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "PrintApplication.h"
#import "PrintApplicationTitleCell.h"
#import "PrintApplicationDetailCell.h"
#import "PrintApplicationNoFileCell.h"
#import "PrintApplicationFileCell.h"
#import "AddPrintFile.h"
#import "PrintFiles.h"

@interface PrintApplication()<UITableViewDelegate,UITableViewDataSource,PrintApplicationFileCellDelegate,PrintFilePassValueDelegate>

@property (strong,nonatomic) UITableView *tableview;

//需复印的文件
@property (strong,nonatomic) NSMutableArray *arr_printFiles;

@end

@implementation PrintApplication

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"新建申请";
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    [barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = barButtonItem;

    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(AddFile:)];
    [barButtonItem2 setTitleTextAttributes:dict forState:UIControlStateNormal];
    UIBarButtonItem *barButtonItem3 = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(SubmitToPrint:)];
    [barButtonItem3 setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItems=[NSArray arrayWithObjects:barButtonItem3,barButtonItem2, nil];
    
    //self.view.backgroundColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1];
    self.view.backgroundColor=[UIColor colorWithRed:246/255.0f green:249/255.0f blue:254/255.0f alpha:1];
    
    _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _tableview.delegate=self;
    _tableview.dataSource=self;
    _tableview.backgroundColor=[UIColor clearColor];
    
    _b_hasFile=NO;
    _arr_printFiles=[[NSMutableArray alloc]initWithCapacity:0];
    
    [self.view addSubview:_tableview];
    
}

-(void)MovePreviousVc:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)AddFile:(UIButton*)sender {
    AddPrintFile *viewController=[[AddPrintFile alloc]init];
    viewController.delegate=self;
    viewController.b_isEdit=NO;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)SubmitToPrint:(UIButton*)sender {
    PrintApplicationTitleCell *cell=[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    PrintService *tmp_service=[self getPrintObject:self.tableview];
    if ([cell.textLabel.text isEqualToString:@"复印标题"]) {
        [_delegate PassPrintValue:cell.txt_title.text PrintObject:tmp_service];
    }
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3] animated:YES];
}

#pragma mark 复印内容
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 7;
    }
    else {
        if ([_arr_printFiles count]==0) {
            return 1;
        }
        else {
            return [_arr_printFiles count];
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
    if (iPhone5_5s || iPhone4_4s) {
        view_title=CGRectMake(0, 0, self.view.frame.size.width, 30);
    }
    else {
        view_title=CGRectMake(0, 0, self.view.frame.size.width, 30);
    }
    UILabel *lbl_sectionTitle=[[UILabel alloc]initWithFrame:view_title];
    lbl_sectionTitle.textAlignment=NSTextAlignmentLeft;
    lbl_sectionTitle.backgroundColor=[UIColor whiteColor];
    if (section==0) {
        lbl_sectionTitle.text=@"    基本信息";
    }
    else {
        lbl_sectionTitle.text=@"    复印文件";
    }
    [view addSubview:lbl_sectionTitle];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        if (indexPath.row!=2) {
            return 40;
        }
        else {
            return 100;
        }
    }
    else {
        return 100;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //static NSString *ID=@"cell";
    NSString *ID=[NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:ID];
    }
    
    if (indexPath.section==0) {
        cell.backgroundColor=[UIColor whiteColor];
        cell.textLabel.textColor=[UIColor blackColor];
        cell.textLabel.font=[UIFont systemFontOfSize:16];
        cell.textLabel.textAlignment=NSTextAlignmentLeft;
        cell.detailTextLabel.textColor=[UIColor colorWithRed:186/255.0f green:186/255.0f blue:186/255.0f alpha:1];
        cell.detailTextLabel.font=[UIFont systemFontOfSize:16];
        if (indexPath.row==0) {
            cell.textLabel.text=@"申请流程";
            cell.detailTextLabel.text=@"复印申请";
            cell.detailTextLabel.textColor=[UIColor colorWithRed:186/255.0f green:186/255.0f blue:186/255.0f alpha:1];
        }
        else if (indexPath.row==1) {
            
            //textfield
            PrintApplicationTitleCell *cell=[PrintApplicationTitleCell cellWithTable:tableView withName:@"复印标题" withPlaceHolder:@"请输入复印标题，最多50个字" atIndexPath:indexPath keyboardType:UIKeyboardTypeDefault];
            return cell;
            
        }
        else if (indexPath.row==2) {
            
            //textview
           // PrintApplicationDetailCell *cell=[PrintApplicationDetailCell cellWithTable:tableView withName:@"备注信息" atIndexPath:indexPath];
            PrintApplicationDetailCell *cell=[PrintApplicationDetailCell cellWithTable:tableView withName:@"备注信息" withPlaceHolder:@"请输入备注信息，最多500个字" atIndexPath:indexPath];
            
            //cell.textLabel.text=@"备注信息";
            return cell;
            
        }
        else if (indexPath.row==3) {
            cell.textLabel.text=@"发起人";
            //与"我"的设置一致，考虑获取数据
            cell.detailTextLabel.text=_userInfo.str_name;
        }
        else if (indexPath.row==4) {
            cell.textLabel.text=@"所在部门";
             //与"我"的设置一致，考虑获取数据
            cell.detailTextLabel.text=_userInfo.str_department;
        }
        else if (indexPath.row==5) {
            cell.textLabel.text=@"联系电话";
             //与"我"的设置一致，考虑获取数据
            cell.detailTextLabel.text=_userInfo.str_cellphone;
        }
        else if (indexPath.row==6) {
            cell.textLabel.text=@"发起时间";
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy/MM/dd"];
            NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
            cell.detailTextLabel.text=strDate;
        }
    }
    else if (indexPath.section==1) {
        //cell.backgroundColor=[UIColor clearColor];
        //cell.textLabel.text=@"无复印文件，请点击右上角『添加』按钮，进行文件添加";
        if (_b_hasFile==NO)
        {
            PrintApplicationNoFileCell* cell=[PrintApplicationNoFileCell cellWithTable:tableView withName:@""];
            return cell;
        }
        else {
           // PrintFiles *tmp_File=[_arr_printFiles objectAtIndex:(_arr_printFiles.count-1-indexPath.row)];
            PrintFiles *tmp_File=[_arr_printFiles objectAtIndex:(indexPath.row)];
           // PrintApplicationFileCell *cell=[PrintApplicationFileCell cellWithTable:tableView withTitle:@"周口太昊陵项目竣工验收图纸" withPages:24 withCopies:3 withCellHeight:100];
            PrintApplicationFileCell *cell=[PrintApplicationFileCell cellWithTable:tableView withTitle:tmp_File.str_filename withPages:tmp_File.i_pages withCopies:tmp_File.i_copies withCellHeight:100 withPrintFile:tmp_File];
            
            cell.file=tmp_File;
            cell.delegate=self;
            cell.myTag=indexPath.row;
            
            return cell;
        }
       
    }

    return cell;
    
}

-(void)sideslipCellRemoveCell:(PrintApplicationFileCell *)cell atIndex:(NSInteger)index {
   // [_arr_printFiles removeObjectAtIndex:_arr_printFiles.count-1-index];
    [_arr_printFiles removeObjectAtIndex:index];
    NSLog(@"删除第%ld个文件",(long)index);
    if ([_arr_printFiles count]==0) {
        _b_hasFile=NO;
    }
    else {
        _b_hasFile=YES;
    }
    NSIndexSet *nd=[[NSIndexSet alloc]initWithIndex:1];
    [self.tableview reloadSections:nd withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)tapCell:(PrintApplicationFileCell *)cell atIndex:(NSInteger)index {
    AddPrintFile *viewController=[[AddPrintFile alloc]init];
    viewController.printFiles=cell.file;
    viewController.b_isEdit=YES;
    viewController.delegate=self;
    [self.navigationController pushViewController:viewController animated:YES];
    NSLog(@"选中第%ld个文件",(long)index);
}

-(void)passValue:(PrintFiles *)new_file {
    [_arr_printFiles addObject:new_file];
    _b_hasFile=YES;
    NSIndexSet *nd=[[NSIndexSet alloc]initWithIndex:1];
    [self.tableview reloadSections:nd withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)editValue:(PrintFiles *)origin_file editFile:(PrintFiles *)edit_file {
    for (int i=0; i<_arr_printFiles.count;i++) {
        PrintFiles *tmpFile=[_arr_printFiles objectAtIndex:i];
        if (tmpFile==origin_file) {
            [_arr_printFiles setObject:edit_file atIndexedSubscript:i];
        }
    }
    NSIndexSet *nd=[[NSIndexSet alloc]initWithIndex:1];
    [self.tableview reloadSections:nd withRowAnimation:UITableViewRowAnimationAutomatic];

}


-(PrintService*)getPrintObject:(UITableView*)tableView {
    PrintService *tmp_printService=[[PrintService alloc]init];
    //复印标题
    PrintApplicationTitleCell *cell_title=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    tmp_printService.str_title=cell_title.txt_title.text;
    //备注信息
    PrintApplicationDetailCell *cell_detail=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    tmp_printService.str_remark=cell_detail.txt_detail.text;
    //发起人
    UITableViewCell *cell_name=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    tmp_printService.str_name=cell_name.detailTextLabel.text;
    //所在部门
    UITableViewCell *cell_department=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    tmp_printService.str_department=cell_department.detailTextLabel.text;
    //联系电话
    UITableViewCell *cell_phonenum=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    tmp_printService.str_phonenum=cell_phonenum.detailTextLabel.text;
    //发起时间
    UITableViewCell *cell_time=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
    tmp_printService.str_time=cell_time.detailTextLabel.text;
    
    //复印文件
    tmp_printService.arr_PrintFiles=_arr_printFiles;
    
    //申请时间
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MM-dd HH:mm"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    tmp_printService.str_applicationTime=locationString;


    return tmp_printService;
}

@end
