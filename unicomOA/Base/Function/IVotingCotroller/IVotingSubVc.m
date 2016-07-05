//
//  IVotingSubVc.m
//  unicomOA
//
//  Created by hnsi-03 on 16/7/4.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "IVotingSubVc.h"
#import "IVotingDisplayController.h"
#import "IVotingResultViewController.h"
#import "VotingCell.h"

@interface IVotingSubVc () <UITableViewDelegate, UITableViewDataSource,VotingTapDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation IVotingSubVc

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64- 44) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithRed:random()%255/255.0 green:random()%255/255.0 blue:random()%255/255.0 alpha:1];
    
    
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_str_condition isEqualToString:@"全部"]) {
        return 2;
    }
    else {
       return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        VotingCell *cell;
        if (iPhone6 || iPhone6_plus) {
            cell=[VotingCell cellWithTable:tableView withCellHeight:110 titleX:self.view.frame.size.width*0.15 titleY:0.0f titleW:self.view.frame.size.width*0.68 titleH:50.0f DepartX:self.view.frame.size.width*0.05 DepartY:60.0f DepartW:3*self.view.frame.size.width/8 DepartH:40.0f TimeX:self.view.frame.size.width/2 TimeY:60.0f TimeW:self.view.frame.size.width/3 TimeH:40.0f atIndexPath:indexPath];
        }
        else if (iPhone5_5s || iPhone4_4s) {
            cell=[VotingCell cellWithTable:tableView withCellHeight:110 titleX:self.view.frame.size.width*0.15 titleY:0.0f titleW:self.view.frame.size.width*0.68 titleH:50.0f DepartX:self.view.frame.size.width*0.15 DepartY:60.0f DepartW:3*self.view.frame.size.width/8 DepartH:40.0f TimeX:self.view.frame.size.width*0.6 TimeY:60.0f TimeW:self.view.frame.size.width*0.4 TimeH:40.0f atIndexPath:indexPath];
        }
        
        cell.delegate=self;
        cell.myTag=indexPath.row;
    if ([_str_condition isEqualToString:@"全部"]) {
        if (indexPath.section==0 && indexPath.row==0) {
            cell.backgroundColor=[UIColor clearColor];
            cell.lbl_Titile.text=@"你最喜欢的与院领导的交流方式";
            [cell.img_condition setFrame:CGRectMake(cell.contentView.frame.origin.x, cell.contentView.frame.origin.y, 47, 40.5)];
            cell.img_condition.image=[UIImage imageNamed:@"voting"];
            cell.lbl_Department.text=@"综合管理部 张三";
            cell.lbl_time.text=@"2016-01-26 16:45";
            cell.isVoting=YES;
        }
        else if (indexPath.section==0 && indexPath.row==1) {
            cell.backgroundColor=[UIColor clearColor];
            cell.lbl_Titile.text=@"优秀员工评选（综合管理部）";
            cell.lbl_Department.text=@"综合管理部 张三";
            cell.lbl_time.text=@"2016-01-26 16:45";
            [cell.img_condition setFrame:CGRectMake(cell.contentView.frame.origin.x, cell.contentView.frame.origin.y, 47, 40.5)];
            cell.img_condition.image=[UIImage imageNamed:@"voteend"];
            cell.isVoting=NO;
        }
        return cell;
    }
    else if ([_str_condition isEqualToString:@"正在投票"]) {
        if (indexPath.section==0 && indexPath.row==0) {
            cell.backgroundColor=[UIColor clearColor];
            cell.lbl_Titile.text=@"你最喜欢的与院领导的交流方式";
            [cell.img_condition setFrame:CGRectMake(cell.contentView.frame.origin.x, cell.contentView.frame.origin.y, 47, 40.5)];
            cell.img_condition.image=[UIImage imageNamed:@"voting"];
            cell.lbl_Department.text=@"综合管理部 张三";
            cell.lbl_time.text=@"2016-01-26 16:45";
            cell.isVoting=YES;
        }
        return cell;
    }
    else if ([_str_condition isEqualToString:@"已经结束"]) {
        if (indexPath.section==0 && indexPath.row==0) {
            cell.backgroundColor=[UIColor clearColor];
            cell.lbl_Titile.text=@"优秀员工评选（综合管理部）";
            cell.lbl_Department.text=@"综合管理部 张三";
            cell.lbl_time.text=@"2016-01-26 16:45";
            [cell.img_condition setFrame:CGRectMake(cell.contentView.frame.origin.x, cell.contentView.frame.origin.y, 47, 40.5)];
            cell.img_condition.image=[UIImage imageNamed:@"voteend"];
            cell.isVoting=NO;
        }
        return cell;
    }
    else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.text = @"";
        return cell;
    }

   
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)sideslipCellRemoveCell:(VotingCell *)cell atIndex:(NSInteger)index {
    
}

-(void)tapCell:(VotingCell *)cell atIndex:(NSInteger)index {
    BOOL b_isVoting=cell.isVoting;
    if (b_isVoting==YES) {
        IVotingDisplayController *viewController=[[IVotingDisplayController alloc]init];
        viewController.str_title=cell.lbl_Titile.text;
        viewController.user_Info=_user_Info;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else  {
        IVotingResultViewController *viewController=[[IVotingResultViewController alloc]init];
        viewController.str_title=cell.lbl_Titile.text;
        viewController.str_condition=@"已经结束";
        viewController.user_Info=_user_Info;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    NSLog(@"进入投票页");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
