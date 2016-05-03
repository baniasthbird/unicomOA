//
//  PrintFileDetail.m
//  unicomOA
//
//  Created by hnsi-03 on 16/4/12.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "PrintFileDetail.h"
#import "AddPrintRadioCell.h"
#import "RadioBox.h"

@interface PrintFileDetail()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableview;

@end

@implementation PrintFileDetail

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title=@"文件详情";
    
    self.view.backgroundColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1];
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    barButtonItem.tintColor=[UIColor whiteColor];
    [barButtonItem setImage:[UIImage imageNamed:@"returnlogo.png"]];
    
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
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row!=4) {
        return 40;
    }
    else {
        return 50;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    NSString *ID=@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:ID];
    }
    cell.textLabel.textAlignment=NSTextAlignmentLeft;
    cell.textLabel.textColor=[UIColor blackColor];
    cell.detailTextLabel.textColor=[UIColor colorWithRed:110/255.0f green:112/255.0f blue:112/255.0f alpha:1];
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    cell.detailTextLabel.font=[UIFont systemFontOfSize:16];
    
    if (indexPath.row==0) {
        cell.textLabel.text=@"文件名称";
        cell.detailTextLabel.text=_file.str_filename;
    }
    else if (indexPath.row==1) {
        cell.textLabel.text=@"复印页数";
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%d",_file.i_pages];
    }
    else if (indexPath.row==2) {
        cell.textLabel.text=@"份数";
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%d",_file.i_copies];
    }
    else if (indexPath.row==3) {
        cell.textLabel.text=@"晒图张数";
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%d",_file.i_pic_pages];
    }
    else if (indexPath.row==4) {
        AddPrintRadioCell *cell=[AddPrintRadioCell cellWithTable:tableView withName:@"正式封皮" withSelectedValue:0];
        for (UIView *subview in cell.radioGroup1.subviews)
        {
            if ([subview isMemberOfClass:[RadioBox class]]) {
                RadioBox *tmp_box=(RadioBox*)subview;
                if (_file.b_hascover==YES) {
                    if ([tmp_box.text isEqualToString:@"是"]) {
                        [tmp_box setOn:YES];
                    }
                }
                else {
                    if ([tmp_box.text isEqualToString:@"否"]) {
                        [tmp_box setOn:YES];
                    }
                }
            }
        }
        return cell;

    }
    else if (indexPath.row==5) {
        cell.textLabel.text=@"精装册数";
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%d",_file.i_colorcopies];
    }
    else if (indexPath.row==6) {
        cell.textLabel.text=@"简装册数";
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%d",_file.i_simplecopies];
    }
    return cell;
}




@end
