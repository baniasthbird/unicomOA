//
//  IVotingManamentController.m
//  unicomOA
//
//  Created by hnsi-03 on 16/3/30.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "IVotingManamentController.h"
#import "IVotingDisplayController.h"
#import "IVotingResultViewController.h"

@interface IVotingManamentController()

@property (strong,nonatomic) NSMutableArray *arr_vote;

@end


@implementation IVotingManamentController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"在线投票";
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    barButtonItem.tintColor=[UIColor whiteColor];
    [barButtonItem setImage:[UIImage imageNamed:@"returnlogo.png"]];
   
    [barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    [self buildView];
}

-(void)didReceiveMemoryWarning {
    
}

-(void)buildDataSource {
    
}

-(void)buildView {
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.005, self.view.frame.size.height/5, self.view.frame.size.width*0.99, self.view.frame.size.height) style:UITableViewStylePlain];
    
    _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    
    _tableView.backgroundColor=[UIColor whiteColor];
    
    _tableView.dataSource=self;
    
    _tableView.delegate=self;

    
    if (iPhone4_4s || iPhone5_5s) {
        _btn_Select=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/32, self.view.frame.size.height*0.123, self.view.frame.size.width/4, self.view.frame.size.height/16)];
    }
    else if (iPhone6) {
        _btn_Select=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/32, self.view.frame.size.height*0.115, self.view.frame.size.width/4, self.view.frame.size.height/16)];
    }
    else if (iPhone6_plus) {
        _btn_Select=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/32, self.view.frame.size.height*0.113, self.view.frame.size.width/4, self.view.frame.size.height/16)];
    }
    [_btn_Select setTitle:@"状态" forState:UIControlStateNormal];
    [_btn_Select setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_btn_Select setBackgroundColor:[UIColor colorWithRed:243.0/255.0f green:243.0f/255.0f blue:243.0f/255.0f alpha:1]];
    _btn_Select.layer.borderWidth=1;
    _btn_Select.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    _btn_Select.layer.cornerRadius=5;
    [_btn_Select addTarget:self action:@selector(selectClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if (iPhone4_4s || iPhone5_5s) {
        _txt_Search=[[UITextField alloc]initWithFrame:CGRectMake(5*self.view.frame.size.width/16.0, self.view.frame.size.height*0.123, 2*self.view.frame.size.width/3, self.view.frame.size.height/16)];
    }
    else if (iPhone6) {
        _txt_Search=[[UITextField alloc]initWithFrame:CGRectMake(5*self.view.frame.size.width/16.0, self.view.frame.size.height*0.115, 2*self.view.frame.size.width/3, self.view.frame.size.height/16)];
    }
    else if (iPhone6_plus) {
        _txt_Search=[[UITextField alloc]initWithFrame:CGRectMake(5*self.view.frame.size.width/16.0, self.view.frame.size.height*0.113, 2*self.view.frame.size.width/3, self.view.frame.size.height/16)];
    }
    _txt_Search.layer.borderWidth=1;
    _txt_Search.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    _txt_Search.layer.cornerRadius=5;
    _txt_Search.placeholder=@"请输入搜索关键字";
    [_txt_Search setTextColor:[UIColor blackColor]];
    
    
    [self.view addSubview:_btn_Select];
    [self.view addSubview:_tableView];
    [self.view addSubview:_txt_Search];
    
    self.view.backgroundColor=[UIColor colorWithRed:243.0/255.0f green:243.0/255.0f blue:243.0/255.0 alpha:1];
    
    _arr_vote=[NSMutableArray arrayWithCapacity:2];
    

}

#pragma mark tableView方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VotingCell *cell;
    if (iPhone6 || iPhone6_plus) {
        cell=[VotingCell cellWithTable:tableView withCellHeight:110 titleX:self.view.frame.size.width*0.05 titleY:0.0f titleW:self.view.frame.size.width*0.68 titleH:50.0f ConditionX:self.view.frame.size.width*0.75 CondiditonY:0.0f ConditionW:self.view.frame.size.width*0.35 ConditionH:50.0f DepartX:self.view.frame.size.width*0.05 DepartY:60.0f DepartW:3*self.view.frame.size.width/8 DepartH:40.0f TimeX:self.view.frame.size.width/2 TimeY:60.0f TimeW:self.view.frame.size.width/3 TimeH:40.0f];
    }
    else if (iPhone5_5s || iPhone4_4s) {
        cell=[VotingCell cellWithTable:tableView withCellHeight:110 titleX:self.view.frame.size.width*0.05 titleY:0.0f titleW:self.view.frame.size.width*0.68 titleH:50.0f ConditionX:self.view.frame.size.width*0.75 CondiditonY:0.0f ConditionW:self.view.frame.size.width*0.35 ConditionH:50.0f DepartX:self.view.frame.size.width*0.05 DepartY:60.0f DepartW:3*self.view.frame.size.width/8 DepartH:40.0f TimeX:self.view.frame.size.width/2 TimeY:60.0f TimeW:self.view.frame.size.width*0.4 TimeH:40.0f];
    }
    
    cell.delegate=self;
    cell.myTag=indexPath.row;
    if (indexPath.section==0 && indexPath.row==0) {
        cell.lbl_Titile.text=@"你最喜欢的与院领导的交流方式";
        cell.lbl_condition.text=@"正在投票";
        cell.lbl_Department.text=@"综合管理部 张三";
        cell.lbl_time.text=@"2016-01-26 16:45";
    }
    else if (indexPath.section==0 && indexPath.row==1) {
        cell.lbl_Titile.text=@"优秀员工评选（综合管理部）";
        cell.lbl_condition.text=@"已经结束";
        cell.lbl_Department.text=@"综合管理部 张三";
        cell.lbl_time.text=@"2016-01-26 16:45";
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation==UIInterfaceOrientationPortrait);
}

-(void)selectClicked:(UIButton*)sender {
    NSArray *arr=[[NSArray alloc]init];
    arr=[NSArray arrayWithObjects:@"全部",@"正在投票",@"已经结束",nil];
    NSArray *arrImage=[[NSArray alloc]init];
    arrImage=[NSArray arrayWithObjects:[UIImage imageNamed:@"apple.png"],[UIImage imageNamed:@"apple.png"],[UIImage imageNamed:@"apple.png"],nil];
    if (dropDown==nil) {
        CGFloat f=120;
        dropDown =[[NIDropDown alloc] showDropDown:sender :&f :arr :arrImage :@"down"];
        dropDown.delegate=self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }

}

-(void)rel {
    dropDown=nil;
}

-(void)niDropDownDelegateMethod:(NIDropDown *)sender {
    [self rel];
    NSLog(@"%@",_btn_Select.titleLabel.text);
}

-(void)tapCell:(VotingCell *)cell atIndex:(NSInteger)index {
    NSString *str_condition=cell.lbl_condition.text;
    if ([str_condition isEqualToString:@"正在投票"]) {
        IVotingDisplayController *viewController=[[IVotingDisplayController alloc]init];
        viewController.str_title=cell.lbl_Titile.text;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if ([str_condition isEqualToString:@"已经结束"]) {
        IVotingResultViewController *viewController=[[IVotingResultViewController alloc]init];
        viewController.str_title=cell.lbl_Titile.text;
        viewController.str_condition=@"已经结束";
        [self.navigationController pushViewController:viewController animated:YES];
    }
    NSLog(@"进入投票页");
}

-(void)sideslipCellRemoveCell:(VotingCell *)cell atIndex:(NSInteger)index {
    
}

-(void)MovePreviousVc:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end