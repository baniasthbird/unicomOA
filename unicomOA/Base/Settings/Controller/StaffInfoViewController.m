//
//  StaffInfoViewController.m
//  unicomOA
//
//  Created by hnsi-03 on 16/3/16.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "StaffInfoViewController.h"
#import "HeadViewCell.h"

@interface StaffInfoViewController ()

@end

@implementation StaffInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"我的资料";
    
    self.view.backgroundColor=[UIColor colorWithRed:236.0/255.0f green:236.0/255.0f blue:236.0/255.0f alpha:1];
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
#warning Incomplete implementation, return the number of sections
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    if (section==0) {
        return 4;
    }
    else {
        return 5;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.textLabel.textColor=[UIColor blackColor];
    cell.textLabel.textAlignment=NSTextAlignmentLeft;
    cell.detailTextLabel.textColor=[UIColor colorWithRed:236.0/255.0f green:236.0/255.0f  blue:236.0/255.0f  alpha:1];
    
    
    if (indexPath.section==0 && indexPath.row==0) {
       // cell=[[HeadViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        HeadViewCell *cell=[[HeadViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        return cell;
        
    }
    else if (indexPath.section==0 && indexPath.row==1) {
        cell.textLabel.text=@"姓名";
        cell.detailTextLabel.text=@"张三";
    }
    else if (indexPath.section==0 && indexPath.row==2) {
        cell.textLabel.text=@"帐号";
        cell.detailTextLabel.text=@"张三";
    }
    else if (indexPath.section==0 && indexPath.row==3) {
        cell.textLabel.text=@"性别";
        cell.detailTextLabel.text=@"男";
    }
    else if (indexPath.section==1 && indexPath.row==0) {
        cell.textLabel.text=@"部门";
        cell.detailTextLabel.text=@"综合部";
    }
    else if (indexPath.section==1 && indexPath.row==1) {
        cell.textLabel.text=@"职务";
        cell.detailTextLabel.text=@"部门经理";
    }
    else if (indexPath.section==1 && indexPath.row==2) {
        cell.textLabel.text=@"手机";
        
    }
    else if (indexPath.section==1 && indexPath.row==3) {
        cell.textLabel.text=@"Email";
        cell.detailTextLabel.text=@"未绑定";
    }
    else if (indexPath.section==1 && indexPath.row==4) {
        cell.textLabel.text=@"固定电话";
        cell.detailTextLabel.text=@"未填写";
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0 && indexPath.row==0) {
        return 100;
    }
    else {
        return 45;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    view.backgroundColor=[UIColor colorWithRed:236.0/255.0f green:236/255.0f blue:236/255.0f alpha:1];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    view.backgroundColor=[UIColor colorWithRed:236.0/255.0f green:236/255.0f blue:236/255.0f alpha:1];
    return view;
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
