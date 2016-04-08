//
//  AddPrintFile.m
//  unicomOA
//
//  Created by hnsi-03 on 16/4/7.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "AddPrintFile.h"
#import "AddPrintFileCell.h"
#import "AddPrintRadioCell.h"
#import "PrintApplication.h"
#import "RadioBox.h"


@interface AddPrintFile()

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation AddPrintFile

-(void)viewDidLoad {
    [super viewDidLoad];
    if (_b_isEdit==NO) {
       self.title=@"添加文件";
    }
    else {
       self.title=@"编辑文件";
    }
    
    
   
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    barButtonItem.tintColor=[UIColor whiteColor];
    [barButtonItem setImage:[UIImage imageNamed:@"returnlogo.png"]];
    
    [barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(MoveNextVc:)];
    [barButtonItem2 setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = barButtonItem2;

    

    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height*0.05, self.view.frame.size.width, self.view.frame.size.height*0.7) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tableView];
    
    

    
    self.view.backgroundColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1];


}

-(void)MovePreviousVc:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)MoveNextVc:(UIButton*)sender {
    AddPrintFileCell *cell_name= [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *str_name=cell_name.txt_title.text;
    AddPrintFileCell *cell_pages= [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    int i_pages=[cell_pages.txt_title.text intValue];
    AddPrintFileCell *cell_copies= [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    int i_copies=[cell_copies.txt_title.text intValue];
    AddPrintFileCell *cell_pic_pages= [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    int i_pic_pages=[cell_pic_pages.txt_title.text intValue];
    AddPrintRadioCell *cell_has_cover=[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    BOOL b_hascover=NO;
    for (UIView *subview in cell_has_cover.radioGroup1.subviews)
    {
        if ([subview isMemberOfClass:[RadioBox class]]) {
            RadioBox *tmp_box=(RadioBox*)subview;
            if (tmp_box.on==YES)
            {
                if ([tmp_box.text isEqualToString:@"是"]) {
                    b_hascover=YES;
                }
                else if ([tmp_box.text isEqualToString:@"否"]) {
                    b_hascover=NO;
                }
            }
        }
    }
    //int i_has_cover=(int)cell_has_cover.radioGroup1.selectValue;
    AddPrintFileCell *cell_color_copies= [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    int i_color_copies=[cell_color_copies.txt_title.text intValue];
    AddPrintFileCell *cell_simple_copies= [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
    int i_simple_copies=[cell_simple_copies.txt_title.text intValue];
    PrintFiles *tmp_file=[[PrintFiles alloc]init];
    tmp_file.str_filename=str_name;
    tmp_file.i_pages=i_pages;
    tmp_file.i_copies=i_copies;
    tmp_file.i_pic_pages=i_pic_pages;
    tmp_file.b_hascover=b_hascover;
    tmp_file.i_colorcopies=i_color_copies;
    tmp_file.i_simplecopies=i_simple_copies;
    
    if (_b_isEdit==NO) {
        [_delegate passValue:tmp_file];
    }
    else {
        [_delegate editValue:_printFiles editFile:tmp_file];
    }
    
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark tableView 方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddPrintFileCell *cell;
    if (_b_isEdit==NO) {
        if (indexPath.row==0) {
            cell=[AddPrintFileCell cellWithTable:tableView withName:@"文件名称" withPlaceHolder:@"填写文件名称"];
        }
        else if (indexPath.row==1) {
            cell=[AddPrintFileCell cellWithTable:tableView withName:@"复印页数" withPlaceHolder:@"填写复印页数"];
        }
        else if (indexPath.row==2) {
            cell=[AddPrintFileCell cellWithTable:tableView withName:@"份数" withPlaceHolder:@"填写份数"];
        }
        else if (indexPath.row==3) {
            cell=[AddPrintFileCell cellWithTable:tableView withName:@"晒图张数" withPlaceHolder:@"填写晒图张数"];
        }
        else if (indexPath.row==4) {
            AddPrintRadioCell  *cell=[AddPrintRadioCell cellWithTable:tableView withName:@"正式封皮" withSelectedValue:0];
           
            return cell;
        }
        else if (indexPath.row==5) {
            cell=[AddPrintFileCell cellWithTable:tableView withName:@"精装册数" withPlaceHolder:@"填写精装册数"];
        }
        else if (indexPath.row==6) {
            cell=[AddPrintFileCell cellWithTable:tableView withName:@"简装册数" withPlaceHolder:@"填写简装册数"];
        }
    }
    else {
        if (indexPath.row==0) {
            NSString *str_name=_printFiles.str_filename;
            cell=[AddPrintFileCell cellWithTable:tableView withName:@"文件名称" withText:str_name];
        }
        else if (indexPath.row==1) {
            NSString *str_page=[NSString stringWithFormat:@"%d",_printFiles.i_pages];
            cell=[AddPrintFileCell cellWithTable:tableView withName:@"复印页数" withText:str_page];
        }
        else if (indexPath.row==2) {
            NSString *str_copies=[NSString stringWithFormat:@"%d",_printFiles.i_copies];
            cell=[AddPrintFileCell cellWithTable:tableView withName:@"份数" withText:str_copies];
        }
        else if (indexPath.row==3) {
            NSString *str_pic_pages=[NSString stringWithFormat:@"%d",_printFiles.i_pic_pages];
            cell=[AddPrintFileCell cellWithTable:tableView withName:@"晒图张数" withText:str_pic_pages];
        }
        else if (indexPath.row==4) {
            //封皮赋值待定 zr 0408
            //AddPrintRadioCell  *cell=[AddPrintRadioCell cellWithTable:tableView withName:@"正式封皮"];
            AddPrintRadioCell *cell;
            if (_printFiles.b_hascover==YES) {
                cell=[AddPrintRadioCell cellWithTable:tableView withName:@"正式封皮" withSelectedValue:0];
            }
            else if (_printFiles.b_hascover==NO) {
                cell=[AddPrintRadioCell cellWithTable:tableView withName:@"正式封皮" withSelectedValue:1];
            }
            return cell;
        }
        else if (indexPath.row==5) {
            NSString *str_color_pages=[NSString stringWithFormat:@"%d",_printFiles.i_colorcopies];
            cell=[AddPrintFileCell cellWithTable:tableView withName:@"精装册数" withText:str_color_pages];
        }
        else if (indexPath.row==6) {
            NSString *str_simple_pages=[NSString stringWithFormat:@"%d",_printFiles.i_simplecopies];
            cell=[AddPrintFileCell cellWithTable:tableView withName:@"简装册数" withText:str_simple_pages];
        }
    }
    
    
    return cell;
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


@end
