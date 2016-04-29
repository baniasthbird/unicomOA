//
//  NewApplication.m
//  unicomOA
//
//  Created by hnsi-03 on 16/4/6.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "NewApplication.h"
#import "PrintApplication.h"
#import "CarApplication.h"

@interface NewApplication()<UITableViewDelegate,UITableViewDataSource,CarApplicationDelegate,PrintApplicationDelegate>

@property (strong,nonatomic) UITableView *tableView;

@end

@implementation NewApplication

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"选择申请流程";
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    barButtonItem.tintColor=[UIColor whiteColor];
    [barButtonItem setImage:[UIImage imageNamed:@"returnlogo.png"]];
    
    [barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = barButtonItem;

    self.view.backgroundColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height*0.05, self.view.frame.size.width, self.view.frame.size.height*0.3) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tableView];
    
}


-(void)MovePreviousVc:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark tableView 方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID=@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.backgroundColor=[UIColor whiteColor];
    cell.textLabel.textColor=[UIColor blackColor];
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    cell.textLabel.textAlignment=NSTextAlignmentLeft;
    
    UIImageView *img_icon=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
    
    UILabel *lbl_title=[[UILabel alloc]initWithFrame:CGRectMake(50, 10, 100, 30)];
    lbl_title.textColor=[UIColor blackColor];
    lbl_title.font=[UIFont systemFontOfSize:16];
    lbl_title.textAlignment=NSTextAlignmentLeft;
    
    
    if (indexPath.row==0) {
        //cell.imageView.image=[UIImage imageNamed:@"printmission.png"];
        img_icon.image=[UIImage imageNamed:@"printmission.png"];
        lbl_title.text=@"复印申请";
    }
    else if (indexPath.row==1) {
       // cell.imageView.image=[UIImage imageNamed:@"carmission.png"];
        img_icon.image=[UIImage imageNamed:@"carmission.png"];
        lbl_title.text=@"预约用车";
    }
    [cell.contentView addSubview:img_icon];
    [cell.contentView addSubview:lbl_title];
    //[cell.imageView setFrame:CGRectMake(10, 10, 10, 10)];
    //[cell.imageView setFrame:CGRectMake(0, 0, 50, 50)];

    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        PrintApplication *viewController=[[PrintApplication alloc]init];
        viewController.delegate=self;
        viewController.userInfo=_userInfo;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (indexPath.row==1) {
        CarApplication *viewController=[[CarApplication alloc]init];
        viewController.delegate=self;
        viewController.userInfo=_userInfo;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

-(void)PassCarValue:(NSString *)str_reason CarObject:(CarService *)carservice {
    [_delegate PassValueFromCarApplication:str_reason CarObject:carservice];
}

-(void)PassPrintValue:(NSString *)str_title PrintObject:(PrintService *)service{
    [_delegate PassValueFromPrintApplication:str_title PrintObject:service];
}




@end
