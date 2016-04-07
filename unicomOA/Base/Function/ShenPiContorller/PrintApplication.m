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
    
    self.view.backgroundColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1];
    
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
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)SubmitToPrint:(UIButton*)sender {
    
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
    return 50;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    view.backgroundColor=[UIColor clearColor];
    CGRect view_title;
    if (iPhone5_5s || iPhone4_4s) {
        view_title=CGRectMake(0, 20, self.view.frame.size.width*0.28, 30);
    }
    else {
        view_title=CGRectMake(0, 20, self.view.frame.size.width*0.2, 30);
    }
    UILabel *lbl_sectionTitle=[[UILabel alloc]initWithFrame:view_title];
    lbl_sectionTitle.textAlignment=NSTextAlignmentLeft;
    lbl_sectionTitle.backgroundColor=[UIColor whiteColor];
    if (section==0) {
        lbl_sectionTitle.text=@"基本信息";
    }
    else {
        lbl_sectionTitle.text=@"复印文件";
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
    static NSString *ID=@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:ID];
    }
    
    if (indexPath.section==0) {
        cell.backgroundColor=[UIColor whiteColor];
        cell.textLabel.textColor=[UIColor colorWithRed:112/255.0f green:112/255.0f blue:112/255.0f alpha:1];
        cell.textLabel.font=[UIFont systemFontOfSize:13];
        cell.textLabel.textAlignment=NSTextAlignmentLeft;
        cell.detailTextLabel.textColor=[UIColor colorWithRed:112/255.0f green:112/255.0f blue:112/255.0f alpha:1];
        cell.detailTextLabel.font=[UIFont systemFontOfSize:13];
        if (indexPath.row==0) {
            cell.textLabel.text=@"申请流程";
            cell.detailTextLabel.text=@"复印申请";
            cell.detailTextLabel.textColor=[UIColor blackColor];
        }
        else if (indexPath.row==1) {
            //textfield
            PrintApplicationTitleCell *cell=[PrintApplicationTitleCell cellWithTable:tableView withName:@"复印标题"];
            //cell.textLabel.text=@"复印标题";
            return cell;
        }
        else if (indexPath.row==2) {
            //textview
            PrintApplicationDetailCell *cell=[PrintApplicationDetailCell cellWithTable:tableView withName:@"备注信息"];
            //cell.textLabel.text=@"备注信息";
            return cell;
        }
        else if (indexPath.row==3) {
            cell.textLabel.text=@"发起人";
            //与"我"的设置一致，考虑获取数据
            cell.detailTextLabel.text=@"张三";
        }
        else if (indexPath.row==4) {
            cell.textLabel.text=@"所在部门";
             //与"我"的设置一致，考虑获取数据
            cell.detailTextLabel.text=@"综合部";
        }
        else if (indexPath.row==5) {
            cell.textLabel.text=@"联系电话";
             //与"我"的设置一致，考虑获取数据
            cell.detailTextLabel.text=@"13812345678";
        }
        else if (indexPath.row==6) {
            cell.textLabel.text=@"发起时间";
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy/MM/dd"];
            NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
            cell.detailTextLabel.text=strDate;
        }
    }
    else {
        //cell.backgroundColor=[UIColor clearColor];
        //cell.textLabel.text=@"无复印文件，请点击右上角『添加』按钮，进行文件添加";
        if (_b_hasFile==NO)
        {
            PrintApplicationNoFileCell *cell=[PrintApplicationNoFileCell cellWithTable:tableView withName:@""];
            return cell;
        }
        else {
            PrintFiles *tmp_File=[_arr_printFiles objectAtIndex:(_arr_printFiles.count-1-indexPath.row)];
            
           // PrintApplicationFileCell *cell=[PrintApplicationFileCell cellWithTable:tableView withTitle:@"周口太昊陵项目竣工验收图纸" withPages:24 withCopies:3 withCellHeight:100];
            PrintApplicationFileCell *cell=[PrintApplicationFileCell cellWithTable:tableView withTitle:tmp_File.str_filename withPages:tmp_File.i_pages withCopies:tmp_File.i_copies withCellHeight:100];
            cell.delegate=self;
            cell.myTag=indexPath.row;
            
            return cell;
        }
       
    }

    return cell;
    
}

-(void)sideslipCellRemoveCell:(PrintApplicationFileCell *)cell atIndex:(NSInteger)index {
    NSLog(@"删除第%ld个文件",(long)index);
}

-(void)tapCell:(PrintApplicationFileCell *)cell atIndex:(NSInteger)index {
    NSLog(@"选中第%ld个文件",(long)index);
}

-(void)passValue:(NSString *)str_FileName pages:(int)i_pages copies:(int)i_copies pic_pages:(int)i_pic_pages cover:(BOOL)b_hascover colorcopies:(int)i_colorcopies simplecopies:(int)i_simplecopies {
    PrintFiles *tmp_Files=[[PrintFiles alloc]init];
    tmp_Files.str_filename=str_FileName;
    tmp_Files.i_pages=i_pages;
    tmp_Files.i_copies=i_copies;
    tmp_Files.i_pic_pages=i_pic_pages;
    tmp_Files.b_hascover=b_hascover;
    tmp_Files.i_colorcopies=i_colorcopies;
    tmp_Files.i_simplecopies=i_simplecopies;
    [_arr_printFiles addObject:tmp_Files];
    [self.tableview reloadData];
}

@end
