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


@interface AddPrintFile()

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation AddPrintFile

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"添加文件";
    
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
  
}

#pragma mark tableView 方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
    static NSString *ID=@"cell";
    UITableViewCell *cell_d = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell_d==nil) {
        cell_d=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell_d.backgroundColor=[UIColor whiteColor];
    cell_d.textLabel.textColor=[UIColor blackColor];
    cell_d.textLabel.font=[UIFont systemFontOfSize:16];
    cell_d.textLabel.textAlignment=NSTextAlignmentLeft;
    */
    AddPrintFileCell *cell;
    
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
        AddPrintRadioCell  *cell=[AddPrintRadioCell cellWithTable:tableView withName:@"正式封皮"];
        return cell;
    }
    else if (indexPath.row==5) {
        cell=[AddPrintFileCell cellWithTable:tableView withName:@"精装册数" withPlaceHolder:@"填写精装册数"];
    }
    else if (indexPath.row==6) {
        cell=[AddPrintFileCell cellWithTable:tableView withName:@"简装册数" withPlaceHolder:@"填写简装册数"];
    }
    else {
        /*
        cell_d.textLabel.text=@"正式封皮";
        return cell_d;
         */
    }
    
    
    return cell;
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


@end
