//
//  MessageViewController.m
//  unicomOA
//
//  Created by zr-mac on 16/2/15.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "MessageViewController.h"
#import "RemindViewController.h"



@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property  NSUInteger count;

@property (nonatomic,strong) AFHTTPSessionManager *session;

@end

@implementation MessageViewController {
    DataBase *db;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"消息";
        NSDictionary * dict=@{
                              NSForegroundColorAttributeName:   [UIColor whiteColor]};
        
        self.navigationController.navigationBar.titleTextAttributes=dict;
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.title = @"消息";

    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor clearColor];
    
    
    [self.view addSubview:_tableView];
    
    db=[DataBase sharedinstanceDB];
    
    _session=[AFHTTPSessionManager manager];
    _session.responseSerializer= [AFHTTPResponseSerializer serializer];
    [_session.requestSerializer setHTTPShouldHandleCookies:YES];
    
    
    
    _count=5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }
    else {
        return 3;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return 50;
    }
    else {
        return 100;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==1) {
        return 30;
    }
    else {
        return 0;
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==0) {
        return 30;
    }
    else {
        return 0;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        if (indexPath.section==0) {
            cell.textLabel.text=@"工作提醒";
            cell.imageView.image=[UIImage imageNamed:@"remind.png"];
            cell.textLabel.textColor=[UIColor blackColor];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            [self updateTableViewCell:cell forCount:_count];
        }
        else {
            cell.textLabel.text=@"aaa";
        }
    }
    
    
    
    return cell;
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGRect frameRect = CGRectMake(0, 0, self.view.frame.size.width, 40);
    
    UILabel *label = [[UILabel alloc] initWithFrame:frameRect];
    
    label.textAlignment=NSTextAlignmentLeft;
    
    CGFloat i_Float=0;
    if (iPhone4_4s || iPhone5_5s) {
        i_Float=16;
    }
    else {
        i_Float=20;
    }
    
    label.font=[UIFont systemFontOfSize:i_Float];
    
   // label.backgroundColor=[UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1];
    
    if (section==1) {
        label.text=@"    新闻公告";
    }
   
    return label;
}


-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view_end=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    view_end.backgroundColor=[UIColor whiteColor];
    if (section==0) {
        return view_end;
    }
    else {
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            RemindViewController *viewController=[[RemindViewController alloc]init];
            viewController.userInfo=_userInfo;
            //传入各个新闻的数量 zr 0504
            viewController.i_index1=2;
            viewController.i_index2=1;
            viewController.i_index3=2;
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

- (void)updateTableViewCell:(UITableViewCell *)cell forCount:(NSUInteger)count {
    UILabel *lbl_count=[[UILabel alloc]init];
    
    [lbl_count setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-80, 10, 30, 30)];
    
    lbl_count.backgroundColor=[UIColor redColor];
    lbl_count.textColor=[UIColor whiteColor];
    lbl_count.text=[NSString stringWithFormat:@"%lu",(unsigned long)count];
    lbl_count.textAlignment=NSTextAlignmentCenter;
    
    lbl_count.layer.cornerRadius=15.0f;
    [lbl_count.layer setMasksToBounds:YES];
    
    [cell.contentView addSubview:lbl_count];
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
   // [_tableView reloadData];
    
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
