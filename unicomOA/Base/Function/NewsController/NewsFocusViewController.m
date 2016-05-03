//
//  NewsFocusViewController.m
//  unicomOA
//
//  Created by zr-mac on 16/3/9.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "NewsFocusViewController.h"
#import "NewsManagementTableViewCell.h"
#import "NewsDisplayViewController.h"

@interface NewsFocusViewController ()<UITableViewDelegate,UITableViewDataSource,NewsTapDelegate>

 @property (nonatomic,strong) UITableView* tableview;

 @property (nonatomic,strong) NSMutableArray *arr_focus;

@end

@implementation NewsFocusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"关注列表";
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    barButtonItem.tintColor=[UIColor whiteColor];
    [barButtonItem setImage:[UIImage imageNamed:@"returnlogo.png"]];
    
    [barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = barButtonItem;

    
    self.view.backgroundColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:242/255.0f alpha:1];
    
    _arr_focus=[[NSMutableArray alloc]initWithCapacity:1];
    
    //_tableview.frame=CGRectMake(self.view.frame.size.width*0.08, self.view.frame.size.height*0.05, self.view.frame.size.width*0.85, self.view.frame.size.height*0.8);
    _tableview=[[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.008, self.view.frame.size.height*0.05, self.view.frame.size.width*0.984, self.view.frame.size.height) style:UITableViewStylePlain];
    
    _tableview.dataSource=self;
    
    _tableview.delegate=self;
    
    [self.view addSubview:_tableview];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [_arr_focus count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //添加关注列表
    NewsManagementTableViewCell *cell=[NewsManagementTableViewCell cellWithTable:tableView withCellHeight:110 titleX:self.view.frame.size.width/32 titleY:0.0f titleW:15*self.view.frame.size.width/16 titleH:50.0f DepartX:self.view.frame.size.width/32 DepartY:60.0f DepartW:3*self.view.frame.size.width/8 DepartH:40.0f TimeX:self.view.frame.size.width/2 TimeY:60.0f TimeW:self.view.frame.size.width/3 TimeH:40.0f];
    cell.delegate=self;
    cell.myTag=indexPath.row;
    cell.lbl_Title.text=@"国家发展改革委关于放开部分建设项目服务收费标准有关问题的通知";
    cell.lbl_department.text=@"综合管理部 张三";
    cell.lbl_time.text=@"2016-01-26 16:45";
    
    
    return cell;

    
    // Configure the cell...
    
}

-(void)sideslipCellRemoveCell:(NewsManagementTableViewCell *)cell atIndex:(NSInteger)index {
    
}

-(void)tapCell:(NewsManagementTableViewCell *)cell atIndex:(NSInteger)index {
    NewsDisplayViewController *news_controller=[[NewsDisplayViewController alloc]init];
    
    [self.navigationController pushViewController:news_controller animated:YES];
    
}

-(void)MovePreviousVc:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
